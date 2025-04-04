import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wajanja/data_layer/models/helper_models/error_model.dart';
import 'package:wajanja/data_layer/models/news/news.dart';
import 'package:wajanja/data_layer/models/videos/video.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_state.dart';
import 'package:wajanja/utils/constants/app_constants.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';

part 'news_state.dart';

class NewsNotifier extends Notifier<NewsState> with FirebaseQueryMixin {
  late final AuthState _authState;
  @override
  build() {
    _authState = ref.read(authNotifierProvider);
    return NewsState(states: NewsStates.initial);
  }

  static final _db = FirebaseFirestore.instance;
  final _newsRef = _db.collection(CollectionPaths.news.path);

  Future<void> fetchNews(
      {String? query,
      required String countryCode,
      bool newSearch = false,
      int page = 1}) async {
    log.f("A QUERY: $query, COUNTRY CODE: $countryCode");
    state = state.copyWith(
      states: NewsStates.fetchingNews,
      news: newSearch ? [] : state.news,
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

    final results = List<News>.from(await populateDocsField(
      'postedBy',
      page != 1 && last != null ? next!.docs : first.docs,
      toObject: (e) => News.fromMap(e),
    ));

    state = state.copyWith(
      states: NewsStates.newsFetched,
      news: {...state.news, ...results}.toList(),
    );
  }

  Future<News?> like(News news) async {
    final loggedInUser = _authState.user;

    log.f("liking...: ${loggedInUser?.email}");

    if (loggedInUser == null) return null;

    late News newNews;

    if (news.likes.contains(loggedInUser.email)) {
      // remove email
      news.docRef.update({
        'likes': FieldValue.arrayRemove([loggedInUser.email!])
      });
      newNews = news.copyWith(
          likes: news.likes.where((el) => el != loggedInUser.email!).toList());
    } else {
      // add email
      news.docRef.update({
        'likes': FieldValue.arrayUnion([loggedInUser.email!]),
        'dislikes': FieldValue.arrayRemove([loggedInUser.email!])
      });

      newNews = news.copyWith(
          likes: [...news.likes, loggedInUser.email!],
          dislikes:
              news.dislikes.where((el) => el != loggedInUser.email!).toList());
    }

    updateNewsLocally(newNews);

    return newNews;
  }

  Future<News?> dislike(News news) async {
    final loggedInUser = _authState.user;

    log.f("disliking...: ${loggedInUser?.email}");

    if (loggedInUser == null) return null;

    late News newNews;

    if (news.dislikes.contains(loggedInUser.email)) {
      // remove email
      news.docRef.update({
        'dislikes': FieldValue.arrayRemove([loggedInUser.email!])
      });
      newNews = news.copyWith(
          dislikes:
              news.dislikes.where((el) => el != loggedInUser.email!).toList());
    } else {
      // add email
      news.docRef.update({
        'dislikes': FieldValue.arrayUnion([loggedInUser.email!]),
        'likes': FieldValue.arrayRemove([loggedInUser.email!])
      });

      newNews = news.copyWith(
          dislikes: [...news.dislikes, loggedInUser.email!],
          likes: news.likes.where((el) => el != loggedInUser.email!).toList());
    }

    updateNewsLocally(newNews);

    return newNews;
  }

  void updateNewsLocally(News news) {
    state = state.copyWith(
        news: state.news.map((el) => el == news ? news : el).toList());

    log.f("NEWS AFTER UPDATE: ${state.news}");
  }
}

final newsNotifierProvider =
    NotifierProvider<NewsNotifier, NewsState>(() => NewsNotifier());
