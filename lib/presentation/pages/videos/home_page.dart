import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/data_layer/models/search/search.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/data_layer/providers/user_provider/user_provider.dart';
import 'package:wajanja/data_layer/providers/videos_provider/videos_provider.dart';
import 'package:wajanja/my_tests/sample_models.dart';
import 'package:wajanja/presentation/components/video_row.dart';
import 'package:wajanja/presentation/widgets/my_loading_widget.dart';
import 'package:wajanja/presentation/widgets/my_search_bar.dart';
// import 'package:wajanja/my_tests/sample_video_model.dart';
import 'package:wajanja/presentation/widgets/video_widget.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with AppBarMixin, UiInfoMixin, PaginationMixin {
  // models.User? user;
  late final StreamSubscription<User?> subscription;
  // String countryCode = 'NG';

  final Search search = Search();
  final TextEditingController searchController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  int get page =>
      calculatePage(itemCount: ref.read(videosNotifierProvider).videos.length);

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      paginationScrollControllerListener(scrollController, onBottomReached: () {
        log.i("At bottom");

        log.f("REQUESTING LODGES FOR PAGE: $page");

        searchVideos(searchController.text.trim(), search);
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchVideos('', search);
    });
    subscription = FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        if (user == null) {
          log.d("AUTH STATE CHANGES: $user");

          // if (!mounted) return;

          ref.read(authNotifierProvider.notifier).logout();
        }
      },
    );
  }

  void searchVideos(String text, Search searchObj, {bool newSearch = false}) {
    ref.read(videosNotifierProvider.notifier).fetchVideos(
          query: text,
          countryCode: searchObj.country.code,
          newSearch: newSearch,
          page: page,
        );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log.i("STATES IN BUILD ${ref.read(userNotifierProvider)}");

    ref.watch(authNotifierProvider);
    final videosState = ref.watch(videosNotifierProvider);

    ref.listen(authNotifierProvider, (prev, next) {
      log.i("STATE: $next");
      switch (next.states) {
        case AuthStates.initial:
          if (next.user != null) return;
          context.goNamed(AppRoutes.login.name);
          break;
        default:
      }
    });

    ref.listen(
      videosNotifierProvider,
      (previous, next) {
        // log.f("STATE: $next");
        switch (next.states) {
          case VideosStates.fetchingVideosFailed:
            showSnackMessage(
              context,
              next.error!.content,
              error: true,
              flushbarPosition: FlushbarPosition.TOP,
            );

            break;
          default:
        }
      },
    );

    return Scaffold(
      appBar: buildAppBar(context, ref: ref, title: "Videos"),
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
            onSearch: searchVideos,
          ).pSymmetric()),
          SliverToBoxAdapter(
              child: SizedBox(
            height: 24.h,
          )),
          videosState.states == VideosStates.fetchingVideos &&
                  videosState.videos.isEmpty
              ? SliverFillRemaining(
                  child: Center(child: MyLoadingWidget()),
                )
              : videosState.videos.isEmpty
                  // body: videosState.videos.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Text("No videos found"),
                      ),
                    )
                  : SliverToBoxAdapter(child: SizedBox.shrink()),
          if (videosState.videos.isNotEmpty)
            SliverToBoxAdapter(
                child: VideoRow(
                    title: "New", videos: videosState.videos, maxLength: 4)),
          if (videosState.videos.isNotEmpty)
            SliverToBoxAdapter(
                child: SizedBox(
              height: 32.h,
            )),
          if (videosState.videos.isNotEmpty)
            SliverGrid.builder(
              itemCount: videosState.videos.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 9 / 16,
                  mainAxisSpacing: 10.r,
                  crossAxisSpacing: 10.r),
              itemBuilder: (context, index) {
                final video = videosState.videos.elementAt(index);
                return VideoWidget(
                    video: video,
                    onTap: () {
                      log.i("GO TO DESCRIPTION FOR VIDEO: $video");

                      context.pushNamed(
                        AppRoutes.videoDescription.name,
                        extra: video,
                      );
                    });
              },
            ).spSymmetric(horizontal: 16.w),
          SliverToBoxAdapter(
              child: SizedBox(
            height: 16.h,
          )),
          if (videosState.states == VideosStates.fetchingVideos &&
              videosState.videos.isNotEmpty)
            SliverToBoxAdapter(child: MyLoadingWidget()),
          SliverToBoxAdapter(
              child: SizedBox(
            height: 24.h,
          ))
        ],
      ),
    );
  }
}
