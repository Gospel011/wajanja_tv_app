import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wajanja/data_layer/models/helper_models/error_model.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/presentation/widgets/buttons/my_elevated_button.dart';
import 'package:wajanja/presentation/widgets/my_dialog.dart';
import 'package:wajanja/presentation/widgets/profile_picture.dart';
import 'package:wajanja/presentation/widgets/spaced_column.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/helpers/logger.dart';

mixin AuthMixin {
  void googleSignIn() {
    log.d("SIGN IN WITH GOOGLE");
  }
}

mixin AppBarMixin {
  PreferredSizeWidget buildAppBar(WidgetRef ref, {String? title}) {
    final user = ref.watch(authNotifierProvider).user!;
    return AppBar(
      title: Text(title ?? "Videos"),
      bottom: PreferredSize(preferredSize: Size(0, 10.h), child: Container()),
      actions: [
        ProfilePicture(user: user),
        SizedBox(
          width: 10.w,
        )
      ],
    );
  }
}

mixin ThemesMixin<T extends StatefulWidget> on State<T> {
  TextTheme get textTheme => Theme.of(context).textTheme;
  ColorScheme get colorScheme => Theme.of(context).colorScheme;

  bool get isDarkTheme => Theme.of(context).brightness == Brightness.dark;
}

mixin UrlMixin on UiInfoMixin {
  Future<void> openMailingApp(BuildContext context) async {
    final uri = Uri(scheme: 'mailto');

    if (await canLaunchUrl(uri)) {
      launchUrl(
        uri,
      );
    } else {
      if (!context.mounted) return;

      showSnackMessage(context, "Could not open mailing app");
    }

    // context,
    // errorMessage: "Could not open email app",
  }
}

mixin UiInfoMixin {
  void unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void launch(BuildContext context,
      {required Uri uri, String? errorMessage}) async {
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    } else {
      if (!context.mounted) return;
      showSnackMessage(
        context,
        "We could not open that url",
        error: true,
      );
    }
  }

  Future<void> showErrorDialog(BuildContext context,
      {required AppError error, List<Widget>? actions}) async {
    return showDialog(
      context: context,
      builder: (context) => MyDialog(
        title: error.title,
        content: error.content,
        actions: actions,
      ),
    );
  }

  void showTutorial(
    BuildContext context, {
    required List<TargetFocus> targets,
    required TutorialSections section,
    VoidCallback? onFinish,
  }) {
    // final canShowSection = TutorialsDb.instance.showSection(section);

    // log.d("SHOW CASE: $canShowSection");

    // if (!canShowSection) return;

    try {
      print("ABOUT TO SHOW");
      TutorialCoachMark(
        targets: targets, // List<TargetFocus>
        colorShadow:
            Theme.of(context).colorScheme.primary, // DEFAULT Colors.black
        // alignSkip: Alignment.bottomRight,
        textSkip: "skip",
        // paddingFocus: 10,
        opacityShadow: 0.8,
        textStyleSkip: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.w500,
        ),
        onClickTarget: (target) {
          print("CLICKED TARGET");
        },
        onClickTargetWithTapPosition: (target, tapDetails) {
          // print("target: $target");
          print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}",
          );
        },
        onClickOverlay: (target) {
          // print(target);

          print("OVERLAY CLICKED");
        },
        onSkip: () {
          // print("skip");
          return true;
        },
        onFinish: () {
          // TutorialsDb.instance.completeSection(section);

          if (onFinish == null) return;

          onFinish();
        },
      ).show(context: context);
    } catch (e) {
      log.d("ERROR SHOWING TUTORIAL IS: $e");
    }
  }

  /// Shows a message to the user in the form of a dialog with a [title] and
  /// [content]
  Future<dynamic> showMessage(context, String title, String content,
      {List<Widget>? actions}) {
    return showDialog(
      context: context,
      builder: (context) {
        return MyDialog(
          title: title,
          content: content,
          actions: actions,
        );
      },
    );
  }

  void deleteItem(BuildContext context, {required VoidCallback onDelete}) {
    showDialog(
      context: context,
      builder: (context) {
        return MyDialog(
          title: "Confirm Delete",
          content: RichText(
            text: TextSpan(
              text: "Are you sure you want to ",
              children: [
                TextSpan(
                  text: "delete ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "this item? This action "),
                TextSpan(
                  text: "cannot be undone!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          actions: [
            // Proceed
            SizedBox(
              width: 100.w,
              child: MyElevatedButton(
                text: "Proceed",
                borderRadius: Platform.isIOS ? BorderRadius.zero : null,
                onPressed: () {
                  context.pop();
                  onDelete();
                },
                backgroundColor: Theme.of(context).colorScheme.error,
                // fontWeight: FontWeight.bold,
              ),
            ),

            // Proceed
            TextButton(
              style: ButtonStyle(
                textStyle: WidgetStatePropertyAll(
                  TextStyle(decoration: TextDecoration.none, fontSize: 16.sp),
                ),
              ),
              onPressed: () {
                context.pop();
              },
              child: const Text("Cancel"),
            ),

            // Cancel
            // SizedBox(
            //     width: 100.w,
            //     child: MyElevatedButton(
            //       text: "Cancel",
            //       borderRadius: Platform.isIOS ? BorderRadius.zero : null,
            //       onPressed: () {
            //         context.pop();
            //       },
            //       backgroundColor: Theme.of(context).colorScheme.error,
            //       fontWeight: FontWeight.bold,
            //     )),
          ],
        );
      },
    );
  }

  // Future<dynamic> showUploadingDialog(
  //   BuildContext context, {
  //   barrierDismissible = false,
  // }) {
  //   return showDialog(
  //     barrierDismissible: barrierDismissible,
  //     context: context,
  //     builder: (context) => const UploadAnimation(),
  //   );
  //   // const MyLoadingWidget(color: Colors.white, size: 40));
  // }

  Future<dynamic> showLoadingDialog(
    BuildContext context, {
    barrierDismissible = false,
  }) {
    return showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator.adaptive(
          strokeCap: StrokeCap.round,
        ),
      ),
    );
    // const MyLoadingWidget(color: Colors.white, size: 40));
  }

  showMyBottomSheet(
    BuildContext context, {
    required List<Widget> children,
    bool showDragHandle = false,
    EdgeInsetsGeometry? padding,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    showModalBottomSheet(
      context: context,
      showDragHandle: showDragHandle,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: padding ?? EdgeInsets.all(16.r),
          child: SpacedColumn(
            gap: 4.h,
            crossAxisAlignment: crossAxisAlignment,
            children: children,
          ),
        );
      },
    );
  }

  Future<dynamic> showSnackMessage(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    FlushbarPosition flushbarPosition = FlushbarPosition.BOTTOM,
    bool error = false,
  }) {
    return Flushbar(
      messageText: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      duration: const Duration(milliseconds: 3000),
      flushbarPosition: flushbarPosition,
      animationDuration: const Duration(milliseconds: 800),
      borderRadius: BorderRadius.circular(16),
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 24),
      backgroundColor: Color.lerp(
        Colors.white,
        (error
            ? Theme.of(context).colorScheme.error
            : backgroundColor ?? Theme.of(context).colorScheme.primary),
        0.8,
      )!,
    ).show(context);
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     behavior: SnackBarBehavior.floating,
    //     backgroundColor:
    //         (backgroundColor ?? AppColors.maincolorBlue).withOpacity(0.7),
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    //     content: Text(
    //       message,
    //       style:
    //           const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    //     )));
  }
}
