import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/presentation/widgets/buttons/my_elevated_button.dart';
import 'package:wajanja/presentation/widgets/buttons/my_text_button.dart';
import 'package:wajanja/presentation/widgets/my_dialog.dart';
import 'package:wajanja/presentation/widgets/my_textformfield.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';
import 'package:wajanja/utils/validators/validators.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage>
    with UiInfoMixin, UrlMixin {
  final email = TextEditingController(text: 'dipogoh387@bankrau.com');

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (prev, next) async {
      switch (next.states) {
        case AuthStates.sendingPasswordResetEmailFailed:
          showErrorDialog(context, error: next.error!);
          break;
        case AuthStates.passwordResetEmailSent:
          await showAdaptiveDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return MyDialog(
                  title: "Email Sent",
                  content:
                      "A password reset email has been sent to you. Please check your mail and follow the prompts to reset your email.",
                  actions: [
                    MyTextButton(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        log.f("Open email app");

                        openMailingApp(context);
                      },
                      text: "Open mailing app",
                    )
                  ],
                );
              });

          if (!context.mounted) return;

          context.goNamed(AppRoutes.login.name);
        // showMessage(
        //   context,
        //   "Email Sent",
        //   "A password reset email has been sent to you. Please check your mail and follow the prompts to reset your email.",
        //   actions: [
        //     MyElevatedButton(text: text)
        //   ],
        // );
        default:
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text("Wajanja Tv")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80.h),

            Text(
              "Enter your email",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 36.h),

            Form(
              key: formKey,
              child: Column(
                spacing: 20.h,
                children: [
                  MyTextFormField(
                    sectionText: "Email",
                    controller: email,
                    hintText: "example@gmail.com",
                    validator: emailValidator,
                  ),
                  SizedBox(height: 104.h),
                ],
              ).pSymmetric(),
            ),

            SizedBox(height: 104.h),

            Builder(builder: (context) {
              final authState = ref.watch(authNotifierProvider);

              return MyElevatedButton(
                text: "Send email",
                loading:
                    authState.states == AuthStates.sendingPasswordResetEmail,
                onPressed: () {
                  final isValid = formKey.currentState?.validate() ?? false;

                  if (!isValid) return;

                  ref
                      .read(authNotifierProvider.notifier)
                      .sendPasswordResetEmail(email.text.trim());

                  // context.pushNamed(AppRoutes.resetPassword.name);
                },
              ).pSymmetric();
            }),

            // Spacer(),
          ],
        ),
      ),
    );
  }
}
