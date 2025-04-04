import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wajanja/data_layer/models/audiobook/audiobook.dart';
import 'package:wajanja/data_layer/models/helper_models/error_model.dart';
import 'package:wajanja/data_layer/models/videos/video.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_state.dart';
import 'package:wajanja/utils/constants/app_constants.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';

part 'audiobooks_state.dart';

class AudioboooksNotifier extends Notifier<AudiobooksState> with FirebaseQueryMixin {
  late final AuthState _authState;
  @override
  build() {
    _authState = ref.read(authNotifierProvider);
    return AudiobooksState(states: AudiobooksStates.initial);
  }

  static final _db = FirebaseFirestore.instance;
  final _audiobooksRef = _db.collection(CollectionPaths.audiobooks.path);

  Future<void> fetchAudiobooks({
    String? query,
    required String countryCode,
    bool newSearch = false,
    int page = 1,
  }) async {
    log.f("A QUERY: $query, COUNTRY CODE: $countryCode");
    state = state.copyWith(
      states: AudiobooksStates.fetchingAudiobooks,
      audiobooks: newSearch ? [] : state.audiobooks,
    );

    final first = await _audiobooksRef
        .where("title", isGreaterThanOrEqualTo: query)
        .where("country", isEqualTo: countryCode)
        .orderBy('title')
        .limit(AppConstants.pageLimit * page)
        .get();

    final last = first.size > 0 ? first.docs[first.size - 1] : null;

    QuerySnapshot<Map<String, dynamic>>? next;

    if (page != 1 && last != null) {
      next = await _audiobooksRef
          .where('title', isGreaterThan: query)
          .where('country', isEqualTo: countryCode)
          .orderBy('title')
          .startAfterDocument(last)
          .limit(AppConstants.pageLimit)
          .get();
    }

    final results = List<Audiobook>.from(await populateDocsField(
      'postedBy',
      page != 1 && last != null ? next!.docs : first.docs,
      toObject: (e) => Audiobook.fromMap(e),
    ));

    state = state.copyWith(
      states: AudiobooksStates.audiobooksFetched,
      audiobooks: {...state.audiobooks, ...results}.toList(),
    );
  }

  Future<Audiobook?> like(Audiobook audiobook) async {
    final loggedInUser = _authState.user;

    log.f("liking...: ${loggedInUser?.email}");

    if (loggedInUser == null) return null;

    late Audiobook newAudiobook;

    if (audiobook.likes.contains(loggedInUser.email)) {
      // remove email
      audiobook.docRef.update({
        'likes': FieldValue.arrayRemove([loggedInUser.email!])
      });
      newAudiobook = audiobook.copyWith(
          likes: audiobook.likes
              .where((el) => el != loggedInUser.email!)
              .toList());
    } else {
      // add email
      audiobook.docRef.update({
        'likes': FieldValue.arrayUnion([loggedInUser.email!]),
        'dislikes': FieldValue.arrayRemove([loggedInUser.email!])
      });
      newAudiobook = audiobook.copyWith(
          likes: [...audiobook.likes, loggedInUser.email!],
          dislikes: audiobook.dislikes
              .where((el) => el != loggedInUser.email!)
              .toList());
    }

    updateAudiobookLocally(newAudiobook);

    return newAudiobook;
  }

  Future<Audiobook?> dislike(Audiobook audiobook) async {
    final loggedInUser = _authState.user;

    log.f("disliking...: ${loggedInUser?.email}");

    if (loggedInUser == null) return null;

    late Audiobook newAudiobook;

    if (audiobook.dislikes.contains(loggedInUser.email)) {
      // remove email
      audiobook.docRef.update({
        'dislikes': FieldValue.arrayRemove([loggedInUser.email!])
      });
      newAudiobook = audiobook.copyWith(
          dislikes: audiobook.dislikes
              .where((el) => el != loggedInUser.email!)
              .toList());
    } else {
      // add email
      audiobook.docRef.update({
        'dislikes': FieldValue.arrayUnion([loggedInUser.email!]),
        'likes': FieldValue.arrayRemove([loggedInUser.email!])
      });

      newAudiobook = audiobook.copyWith(
          dislikes: [...audiobook.dislikes, loggedInUser.email!],
          likes: audiobook.likes
              .where((el) => el != loggedInUser.email!)
              .toList());
    }

    updateAudiobookLocally(newAudiobook);

    return newAudiobook;
  }

  void updateAudiobookLocally(Audiobook audiobook) {
    state = state.copyWith(
        audiobooks: state.audiobooks
            .map((el) => el == audiobook ? audiobook : el)
            .toList());

    log.f("NEWS AFTER UPDATE: ${state.audiobooks}");
  }
}

final audiobooksNotifierProvider =
    NotifierProvider<AudioboooksNotifier, AudiobooksState>(() => AudioboooksNotifier());
