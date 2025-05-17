import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wajanja/data_layer/models/helper_models/error_model.dart';
import 'package:wajanja/data_layer/models/podcast/podcast.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_state.dart';
import 'package:wajanja/utils/constants/app_constants.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';

part 'podcast_state.dart';

class PodcastNotifier extends Notifier<PodcastState> with FirebaseQueryMixin {
  late final AuthState _authState;
  @override
  build() {
    _authState = ref.read(authNotifierProvider);
    return PodcastState(states: PodcastStates.initial);
  }

  static final _db = FirebaseFirestore.instance;
  final _newsRef = _db.collection(CollectionPaths.podcasts.path);

  Future<void> fetchPodcasts(
      {String? query,
      required String countryCode,
      bool newSearch = false,
      int page = 1}) async {
    log.f("A QUERY: $query, COUNTRY CODE: $countryCode");
    state = state.copyWith(
      states: PodcastStates.fetchingPodcasts,
      podcasts: newSearch ? [] : state.podcasts,
    );

    final first = await _newsRef
        .where("title", isGreaterThanOrEqualTo: query)
        .where("country", isEqualTo: countryCode)
        .orderBy('title')
        .limit(AppConstants.pageLimit * page)
        .get();

    final last = first.size > 0 ? first.docs[first.size - 1] : null;

    QuerySnapshot<Map<String, dynamic>>? next;

    if (page != 1 && last != null) {
      next = await _newsRef
          .where('title', isGreaterThan: query)
          .where('country', isEqualTo: countryCode)
          .orderBy('title')
          .startAfterDocument(last)
          .limit(AppConstants.pageLimit)
          .get();
    }

    final results = List<Podcast>.from(await populateDocsField(
      'postedBy',
      page != 1 && last != null ? next!.docs : first.docs,
      toObject: (e) => Podcast.fromMap(e),
    ));

    state = state.copyWith(
      states: PodcastStates.podcastsFetched,
      podcasts: {...state.podcasts, ...results}.toList(),
    );
  }

  Future<Podcast?> like(Podcast podcast) async {
    final loggedInUser = _authState.user;

    log.f("liking...: ${loggedInUser?.email}");

    if (loggedInUser == null) return null;

    late Podcast newPodcast;

    if (podcast.likes.contains(loggedInUser.email)) {
      // remove email
      podcast.docRef.update({
        'likes': FieldValue.arrayRemove([loggedInUser.email!])
      });
      newPodcast = podcast.copyWith(
          likes:
              podcast.likes.where((el) => el != loggedInUser.email!).toList());
    } else {
      // add email
      podcast.docRef.update({
        'likes': FieldValue.arrayUnion([loggedInUser.email!]),
        'dislikes': FieldValue.arrayRemove([loggedInUser.email!])
      });

      newPodcast = podcast.copyWith(
          likes: [...podcast.likes, loggedInUser.email!],
          dislikes: podcast.dislikes
              .where((el) => el != loggedInUser.email!)
              .toList());
    }

    updatePodcastLocally(newPodcast);

    return newPodcast;
  }

  Future<Podcast?> dislike(Podcast podcast) async {
    final loggedInUser = _authState.user;

    log.f("disliking...: ${loggedInUser?.email}");

    if (loggedInUser == null) return null;

    late Podcast newPodcast;

    if (podcast.dislikes.contains(loggedInUser.email)) {
      // remove email
      podcast.docRef.update({
        'dislikes': FieldValue.arrayRemove([loggedInUser.email!])
      });
      newPodcast = podcast.copyWith(
          dislikes: podcast.dislikes
              .where((el) => el != loggedInUser.email!)
              .toList());
    } else {
      // add email
      podcast.docRef.update({
        'dislikes': FieldValue.arrayUnion([loggedInUser.email!]),
        'likes': FieldValue.arrayRemove([loggedInUser.email!])
      });

      newPodcast = podcast.copyWith(
          dislikes: [...podcast.dislikes, loggedInUser.email!],
          likes:
              podcast.likes.where((el) => el != loggedInUser.email!).toList());
    }

    updatePodcastLocally(newPodcast);

    return newPodcast;
  }

  void updatePodcastLocally(Podcast podcast) {
    state = state.copyWith(
        podcasts:
            state.podcasts.map((el) => el == podcast ? podcast : el).toList());

    log.f("NEWS AFTER UPDATE: ${state.podcasts}");
  }
}

final podcastNotifierProvider =
    NotifierProvider<PodcastNotifier, PodcastState>(() => PodcastNotifier());
