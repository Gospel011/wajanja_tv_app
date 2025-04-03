import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wajanja/data_layer/models/helper_models/error_model.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/data_layer/models/videos/video.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/helpers/logger.dart';

part 'videos_state.dart';

class VideosNotifier extends Notifier<VideosState> {
  @override
  build() {
    return VideosState(states: VideosStates.initial);
  }

  static final _db = FirebaseFirestore.instance;
  final _videosRef = _db.collection(CollectionPaths.videos.path);
  // .withConverter(
  //   fromFirestore: (snapshot, options) {
  //     return Video.fromFirestore(snapshot);
  //   },
  //   toFirestore: (model, _) {
  //     return model.toMap();
  //   },
  // );

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

    // String? endQuery = query == null
    //     ? null
    //     : query.substring(0, query.length - 1) +
    //         String.fromCharCode(query.codeUnitAt(query.length - 1) + 1);

    final first = await _videosRef
        .where("title", isGreaterThanOrEqualTo: query)
        // .where('title', isLessThan: endQuery)
        .where("country", isEqualTo: countryCode)
        .orderBy('title')
        // .startAfterDocument(DocumentSnapshot)
        .limit(2)
        // .startAfter(state.videos.map((el) => el.toMap()))
        .get();

    final last = first.docs[first.size - 1];

    QuerySnapshot<Map<String, dynamic>>? next;

    if (page != 1) {
      next = await _videosRef
          .where('title', isGreaterThan: query)
          .where('country', isEqualTo: countryCode)
          .orderBy('title')
          .startAfterDocument(last)
          .limit(2)
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

  Future<List<dynamic>> populateDocsField(
      String field, List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
      {required dynamic Function(Map<String, dynamic> object) toObject}) {
    final res = Future.wait(docs.map((el) async {
      final data = el.data();
      data[field] =
          (await (data[field] as DocumentReference<Map<String, dynamic>>)
              .get());

      return toObject(data);
    }));

    return res;
  }
}

final videosNotifierProvider =
    NotifierProvider<VideosNotifier, VideosState>(() => VideosNotifier());
