import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/presentation/widgets/buttons/my_elevated_button.dart';
import 'package:wajanja/presentation/widgets/buttons/my_google_sign_in_button.dart';
import 'package:wajanja/utils/constants/app_svgs.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';

class Onboarding extends ConsumerStatefulWidget {
  const Onboarding({super.key});

  @override
  ConsumerState<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends ConsumerState<Onboarding>
    with AuthMixin, UiInfoMixin {
  Brightness get brightness => Theme.of(context).brightness;
  List<OnboardingIllustrations> get illustrations =>
      OnboardingIllustrations.themeIllustrations(brightness);

  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  bool get isLastPage => currentPage == illustrations.length - 1;

  @override
  Widget build(BuildContext context) {
    ref.listen(
      authNotifierProvider,
      (previous, next) {

        log.f("AUTH STATE:  $next");
        switch (next.states) {
          case AuthStates.signingInWithGoogleSuccessful:
            context.goNamed(AppRoutes.home.name);
            break;
          case AuthStates.signingInWithGoogleFailed:
            showErrorDialog(context, error: next.error!);
            break;
          default:
        }
      },
    );
    return Scaffold(
      // appBar: AppBar(title: const Text('Wajanja Tv')),
      bottomNavigationBar: Column(
        spacing: 10.h,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLastPage)
            MyElevatedButton(
              onPressed: () {
                log.d("continue with email");

                context.goNamed(AppRoutes.login.name);
              },
              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
              backgroundColor: Theme.of(context).colorScheme.surfaceTint,
              // leadingIcon: Icon(Icons.email_outlined, size: 24.r,),
              text: "Continue with email",
            ).pSymmetric(),
          isLastPage
              ? MyGoogleSignInButton().pAll(16.r)
              : MyElevatedButton(
                  onPressed: isLastPage
                      ? () {
                          // googleSignIn();

                          // showSnackMessage(
                          //   context,
                          //   "Implement google signin",
                          //   flushbarPosition: FlushbarPosition.TOP,
                          // );
                        }
                      : next,
                  text: "Next",
                  leadingIcon: isLastPage ? AppSvgs.googleLogo : null,
                ).pAll(16.r),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 408 / 508.24,
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemCount: illustrations.length,
              itemBuilder: (context, index) {
                final illustration = illustrations.elementAt(index);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 65.h,
                  children: [
                    SvgPicture.asset(illustration.path),
                    Text(
                      illustration.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(illustration.subtitle, textAlign: TextAlign.center),
                  ],
                ).pSymmetric();
              },
            ),
          ),
          SizedBox(height: 65.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10.w,
            children: List<Widget>.generate(illustrations.length, (index) {
              final bool onIndex = currentPage == index;

              return Container(
                width: 16.r,
                height: 16.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: onIndex
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void next() {
    pageController.animateToPage(
      !isLastPage ? ++currentPage : currentPage,
      duration: Durations.medium2,
      curve: Curves.fastEaseInToSlowEaseOut,
    );
  }
}
