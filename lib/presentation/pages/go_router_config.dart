import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/presentation/pages/auth_pages/email_verification_page.dart';
import 'package:wajanja/presentation/pages/auth_pages/forgot_password_page%20copy.dart';
import 'package:wajanja/presentation/pages/auth_pages/login_page.dart';
import 'package:wajanja/presentation/pages/auth_pages/reset_password_page.dart';
import 'package:wajanja/presentation/pages/auth_pages/signup_page.dart';
import 'package:wajanja/presentation/pages/auth_pages/signup_success_page.dart';
import 'package:wajanja/presentation/pages/onboarding_pages/onboarding.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/helpers/logger.dart';


class AppRouterConfig {
  // final AuthState authState;
  AppRouterConfig();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  final goRouter = GoRouter(
    navigatorKey: _rootNavigatorKey,
    // initialLocation: '/home/profile/668aaa78ffccf5a5a61e854c',
    initialLocation: '/${AppRoutes.onboarding.path}',
    // initialLocation: '/login',
    routes: [
      // StatefulShellRoute.indexedStack(
      //   builder: (context, state, navigationShell) {
      //     return HomePage(shell: navigationShell);
      //   },
      //   branches: [
      //     // lodges

      //     // roommates

      //     // services

      //     // requests
      //   ],
      // ),

      //? E M A I L   V E R I F I C  A T I O N
      GoRoute(
        name: AppRoutes.emailVerification.name,
        path: "/${AppRoutes.emailVerification.path}",
        builder: (context, state) {
          final Map<String, dynamic>? extra =
              (state.extra as Map<String, dynamic>?);

          log.i("Extras: $extra");

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

          log.i("Extras: $extra");

          return Onboarding();
        },
      ),

      //? A U T H E N T I C A T I O N   R O U T E S
      GoRoute(
        name: AppRoutes.login.name,
        path: "/${AppRoutes.login.path}",
        builder: (context, state) {
          // log.i("Login from goroute");
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

                  // log.i("Email from go_router: $email");

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
      bool isLoggedIn = false;
      String currentLocation = state.matchedLocation;

      // log.i("CHECKING AUTH CUBIT: ${authCubit.state}");

      log.i("Current location $currentLocation is logged in $isLoggedIn");

      if (currentLocation == '/login' && isLoggedIn == true) {
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

  GoRouter get router {
    return goRouter;
  }
}
