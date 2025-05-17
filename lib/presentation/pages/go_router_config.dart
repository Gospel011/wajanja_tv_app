import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/data_layer/models/extras/audiobook_extra.dart';
import 'package:wajanja/data_layer/models/extras/image_extra.dart';
import 'package:wajanja/data_layer/models/news/news.dart';
import 'package:wajanja/data_layer/models/videos/video.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/presentation/pages/audiobooks/audiobook_detail.dart';
import 'package:wajanja/presentation/pages/auth_pages/email_verification_page.dart';
import 'package:wajanja/presentation/pages/auth_pages/forgot_password_page%20copy.dart';
import 'package:wajanja/presentation/pages/auth_pages/login_page.dart';
import 'package:wajanja/presentation/pages/auth_pages/reset_password_page.dart';
import 'package:wajanja/presentation/pages/auth_pages/signup_page.dart';
import 'package:wajanja/presentation/pages/auth_pages/signup_success_page.dart';
import 'package:wajanja/presentation/pages/audiobooks/audiobooks.dart';
import 'package:wajanja/presentation/pages/news/news_details.dart';
import 'package:wajanja/presentation/pages/profile/profile.dart';
import 'package:wajanja/presentation/pages/settings/settings_page.dart';
import 'package:wajanja/presentation/pages/utility_pages/image_view_page.dart';
import 'package:wajanja/presentation/pages/videos/home.dart';
import 'package:wajanja/presentation/pages/videos/home_page.dart';
import 'package:wajanja/presentation/pages/news/news.dart';
import 'package:wajanja/presentation/pages/podcasts/podcasts.dart';
import 'package:wajanja/presentation/pages/videos/video_description.dart';
import 'package:wajanja/presentation/pages/onboarding_pages/onboarding.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/helpers/logger.dart';

class AppRouterConfig {
  AppRouterConfig();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      // initialLocation: '/home/profile/668aaa78ffccf5a5a61e854c',
      initialLocation: '/${AppRoutes.onboarding.path}',
      // initialLocation: '/login',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return Home(shell: navigationShell);
          },
          branches: [
            //* VIDEOS
            StatefulShellBranch(routes: [
              GoRoute(
                  name: AppRoutes.home.name,
                  path: "/${AppRoutes.home.path}",
                  builder: (context, state) {
                    return HomePage();
                  },
                  routes: [
                    GoRoute(
                        name: AppRoutes.videoDescription.name,
                        path: "video-description",
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final video = state.extra as Video;
                          return VideoDescription(video: video);
                        }),
                  ]),
            ]),

            //* NEWS
            StatefulShellBranch(routes: [
              GoRoute(
                  name: AppRoutes.news.name,
                  path: "/${AppRoutes.news.path}",
                  builder: (context, state) {
                    return NewsPage();
                  },
                  routes: [
                    GoRoute(
                        name: AppRoutes.newsDetails.name,
                        path: AppRoutes.newsDetails.path,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          return NewsDetails(
                            news: (state.extra) as News,
                          );
                        }),
                  ]),
            ]),

            // * AUDIO BOOKS PAGE
            StatefulShellBranch(routes: [
              GoRoute(
                  name: AppRoutes.audiobooks.name,
                  path: "/${AppRoutes.audiobooks.path}",
                  builder: (context, state) {
                    return AudiobooksPage();
                  },
                  routes: [
                    GoRoute(
                        name: AppRoutes.audiobooksDetail.name,
                        path: AppRoutes.audiobooksDetail.path,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final extra = state.extra as AudiobookExtra;
                          return AudiobookDetail(
                            audiobook: extra.audiobook!,
                          );
                        }),
                  ]),
            ]),

            //* PODCASTS PAGE
            StatefulShellBranch(routes: [
              GoRoute(
                name: AppRoutes.podcasts.name,
                path: "/${AppRoutes.podcasts.path}",
                builder: (context, state) {
                  return PodcastsPage();
                },
              ),
            ]),
          ],
        ),

        GoRoute(
            name: AppRoutes.profile.name,
            path: "/${AppRoutes.profile.path}",
            builder: (context, state) {
              return const ProfilePage();
            }),

        GoRoute(
            name: AppRoutes.settings.name,
            path: "/${AppRoutes.settings.path}",
            builder: (context, state) {
              return const SettingsPage();
            }),

        //? IMAGE VIEW PAGE
        GoRoute(
            name: AppRoutes.imageView.name,
            path: "/${AppRoutes.imageView.path}",
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) {
              final extras = state.extra as ImageExtra;

              return ImageViewPage(
                image: extras.image,
                images: extras.images,
                currentIndex: extras.currentIndex,
                tag: extras.tag,
              );
            }),

        //? E M A I L   V E R I F I C  A T I O N
        GoRoute(
          name: AppRoutes.emailVerification.name,
          path: "/${AppRoutes.emailVerification.path}",
          builder: (context, state) {
            final Map<String, dynamic>? extra =
                (state.extra as Map<String, dynamic>?);

            log.d("Extras: $extra");

            return EmailVerificationPage();
          },
        ),

        // O N B O A R D I N G
        GoRoute(
          name: AppRoutes.onboarding.name,
          path: "/${AppRoutes.onboarding.path}",
          builder: (context, state) {
            final Map<String, dynamic>? extra =
                (state.extra as Map<String, dynamic>?);

            log.d("Extras: $extra");

            return Onboarding();
          },
        ),

        //? A U T H E N T I C A T I O N   R O U T E S
        GoRoute(
          name: AppRoutes.login.name,
          path: "/${AppRoutes.login.path}",
          builder: (context, state) {
            // log.d("Login from goroute");
            return const LoginPage();
          },
          routes: [
            // FORGOT PASSWORD
            GoRoute(
              name: AppRoutes.forgotPassword.name,
              path: AppRoutes.forgotPassword.path,
              builder: (context, state) {
                return const ForgotPasswordPage();
              },
              routes: [
                GoRoute(
                  name: AppRoutes.resetPassword.name,
                  path: AppRoutes.resetPassword.path,
                  builder: (context, state) {
                    // log.d("Email from go_router: $email");

                    return ResetPasswordPage();
                  },
                ),
              ],
            ),

            // SIGNUP
            GoRoute(
              name: AppRoutes.signup.name,
              path: AppRoutes.signup.path,
              builder: (context, state) {
                return const SignupPage();
              },
            ),
          ],
        ),

        // //? E M A I L   V E R I F I C  A T I O N
        // GoRoute(
        //   name: AppRoutes.emailVerification.name,
        //   path: "/${AppRoutes.emailVerification.path}",
        //   builder: (context, state) {
        //     return const EmailVerificationPage();
        //   },
        // ),

        //? S I G N U P   S U C C E S S
        GoRoute(
          name: AppRoutes.signupSuccess.name,
          path: "/${AppRoutes.signupSuccess.path}",
          builder: (context, state) {
            return const SignupSuccessPage();
          },
        ),
      ],
      redirect: (context, state) {
        final user = ref.read(authNotifierProvider).user;
        bool isLoggedIn = user != null && user.emailVerified;

        log.i("USER: $user");

        String currentLocation = state.matchedLocation;

        // log.d("CHECKING AUTH CUBIT: ${authCubit.state}");

        log.i("Current location $currentLocation is logged in $isLoggedIn");

        if ((currentLocation == '/login' || currentLocation == '/onboarding') &&
            isLoggedIn == true) {
          log.i("\n::: \nUser is logged in so redirecting to home\n::: ");
          return '/home'; //? original

          // return '/roommates-page/roommates-filter';
          // return '/home/request-roommate-intro/request-roommate';
        }

        if (currentLocation.startsWith('/home') && isLoggedIn == false) {
          return '/login';
        }

        // return '/login/signup';
        return null;
      },
    );
  }
}
