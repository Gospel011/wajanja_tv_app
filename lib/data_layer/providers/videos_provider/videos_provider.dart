import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wajanja/data_layer/models/helper_models/error_model.dart';
import 'package:wajanja/data_layer/models/videos/video.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_state.dart';
import 'package:wajanja/utils/constants/app_constants.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';

part 'videos_state.dart';

class VideosNotifier extends Notifier<VideosState> with FirebaseQueryMixin {
  late final AuthState _authState;
  @override
  build() {
    _authState = ref.read(authNotifierProvider);
    return VideosState(states: VideosStates.initial);
  }

  static final _db = FirebaseFirestore.instance;
  final _videosRef = _db.collection(CollectionPaths.videos.path);

  Future<void> fetchVideos(
      {String? query,
      required String countryCode,
      bool newSearch = false,
      int page = 1}) async {
    log.f("A QUERY: $query, COUNTRY CODE: $countryCode");
    state = state.copyWith(
      states: VideosStates.fetchingVideos,
      videos: newSearch ? [] : state.videos,
    );

    final first = await _videosRef
        .where("title", isGreaterThanOrEqualTo: query)
        .where("country", isEqualTo: countryCode)
        .orderBy('title')
        .limit(AppConstants.pageLimit * page)
        .get();

    final last = first.docs[first.size - 1];

    QuerySnapshot<Map<String, dynamic>>? next;

    if (page != 1) {
      next = await _videosRef
          .where('title', isGreaterThan: query)
          .where('country', isEqualTo: countryCode)
          .orderBy('title')
          .startAfterDocument(last)
          .limit(AppConstants.pageLimit)
          .get();
    }

    final results = List<Video>.from(await populateDocsField(
      'postedBy',
      page != 1 ? next!.docs : first.docs,
      toObject: (e) => Video.fromMap(e),
    ));

    state = state.copyWith(
      states: VideosStates.videosFetched,
      videos: {...state.videos, ...results}.toList(),
    );
  }

  Future<Video?> likeVideo(Video video) async {
    final loggedInUser = _authState.user;

    log.f("liking...: ${loggedInUser?.email}");

    if (loggedInUser == null) return null;

    if (video.likes.contains(loggedInUser.email)) {
      // remove email
      video.docRef.update({
        'likes': FieldValue.arrayRemove([loggedInUser.email!])
      });
      return video.copyWith(
          likes: video.likes.where((el) => el != loggedInUser.email!).toList());
    } else {
      // add email
      video.docRef.update({
        'likes': FieldValue.arrayUnion([loggedInUser.email!]),
        'dislikes': FieldValue.arrayRemove([loggedInUser.email!])
      });
      return video.copyWith(
          likes: [...video.likes, loggedInUser.email!],
          dislikes:
              video.dislikes.where((el) => el != loggedInUser.email!).toList());
    }
  }

  Future<Video?> dislikeVideo(Video video) async {
    final loggedInUser = _authState.user;

    log.f("disliking...: ${loggedInUser?.email}");

    if (loggedInUser == null) return null;

    if (video.dislikes.contains(loggedInUser.email)) {
      // remove email
      video.docRef.update({
        'dislikes': FieldValue.arrayRemove([loggedInUser.email!])
      });
      return video.copyWith(
          dislikes:
              video.dislikes.where((el) => el != loggedInUser.email!).toList());
    } else {
      // add email
      video.docRef.update({
        'dislikes': FieldValue.arrayUnion([loggedInUser.email!]),
        'likes': FieldValue.arrayRemove([loggedInUser.email!])
      });

      return video.copyWith(
          dislikes: [...video.dislikes, loggedInUser.email!],
          likes: video.likes.where((el) => el != loggedInUser.email!).toList());
    }
  }
}

final videosNotifierProvider =
    NotifierProvider<VideosNotifier, VideosState>(() => VideosNotifier());
