import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/data_layer/models/search/search.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/data_layer/providers/news_provider/news_provider.dart';
import 'package:wajanja/presentation/widgets/loading_states_widget.dart';
import 'package:wajanja/presentation/widgets/my_search_bar.dart';
import 'package:wajanja/presentation/widgets/news_widget.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';

class NewsPage extends ConsumerStatefulWidget {
  const NewsPage({super.key});

  @override
  ConsumerState<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends ConsumerState<NewsPage>
    with AppBarMixin, ThemesMixin, PaginationMixin {
  late final User user;

  Search search = Search();

  ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = ref.read(authNotifierProvider).user!;

    scrollController.addListener(() {
      paginationScrollControllerListener(scrollController, onBottomReached: () {
        log.i("At bottom");

        log.f("REQUESTING LODGES FOR PAGE: $page");

        searchNews(searchController.text.trim(), search);
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(newsNotifierProvider.notifier)
          .fetchNews(countryCode: search.country.code);
    });
  }

  int get page =>
      calculatePage(itemCount: ref.read(newsNotifierProvider).news.length);

  void searchNews(String text, Search searchObj, {bool newSearch = false}) {
    ref.read(newsNotifierProvider.notifier).fetchNews(
          query: text,
          countryCode: searchObj.country.code,
          newSearch: newSearch,
          page: page,
        );
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsNotifierProvider);

    return Scaffold(
      appBar: buildAppBar(context, ref: ref, title: "News"),
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 30.h,
            ),
          ),
          SliverToBoxAdapter(
              child: MySearchBar(
            search: search,
            searchController: searchController,
            onSearch: searchNews,
          ).pSymmetric()),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 32.h,
            ),
          ),
          SliverList.builder(
            itemBuilder: (context, index) {
              final news = newsState.news.elementAt(index);

              return NewsWidget(
                news: news,
                onTap: () {
                  context.pushNamed(
                    AppRoutes.newsDetails.name,
                    extra: news,
                  );
                },
              ).pOnly(bottom: 20.h);
            },
            itemCount: newsState.news.length,
          ).spSymmetric(),
          LoadingStatesWidget(
            isLoading: newsState.states == NewsStates.fetchingNews,
            isEmpty: newsState.news.isEmpty,
            emptyText: "No news found in ${search.country.name}",
          ),
        ],
      ),
    );
  }
}
