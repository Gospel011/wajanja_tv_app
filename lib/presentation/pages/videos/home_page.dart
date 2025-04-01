import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/data_layer/providers/user_provider/user_provider.dart';
import 'package:wajanja/my_tests/sample_models.dart';
import 'package:wajanja/presentation/components/video_row.dart';
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

class _HomePageState extends ConsumerState<HomePage> with AppBarMixin {
  // models.User? user;
  late final StreamSubscription<User?> subscription;
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   user = ref.read(authNotifierProvider).user!;
    // });
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

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log.i("STATES IN BUILD ${ref.read(userNotifierProvider)}");

    ref.watch(authNotifierProvider);


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

    return Scaffold(
      appBar: buildAppBar(context, ref: ref, title: "Videos"),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 30.h,
            ),
          ),
          SliverToBoxAdapter(
              child: VideoRow(title: "New", videos: videos, maxLength: 4)),
          SliverToBoxAdapter(
              child: SizedBox(
            height: 32.h,
          )),
          SliverGrid.builder(
            itemCount: videos.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 9 / 16,
                mainAxisSpacing: 10.r,
                crossAxisSpacing: 10.r),
            itemBuilder: (context, index) {
              final video = videos.elementAt(index);
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
            height: 24.h,
          ))
        ],
      ),
    );
  }
}
