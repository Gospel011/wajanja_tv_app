import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/presentation/widgets/buttons/my_elevated_button.dart';
import 'package:wajanja/presentation/widgets/buttons/my_google_sign_in_button.dart';
import 'package:wajanja/presentation/widgets/buttons/my_text_button.dart';
import 'package:wajanja/presentation/widgets/my_dialog.dart';
import 'package:wajanja/presentation/widgets/my_textformfield.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';
import 'package:wajanja/utils/validators/validators.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with UiInfoMixin {
  final email = TextEditingController(text: 'dipogoh387@bankrau.com');
  final password = TextEditingController(text: 'testUser1@');

  bool obscureText = true;

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  bool get isAtLogin =>
      GoRouter.of(context).state.matchedLocation == '/${AppRoutes.login.path}';

  @override
  Widget build(BuildContext context) {
    log.f("IS AT LOGIN: $isAtLogin");

    ref.listen(authNotifierProvider, (prev, next) {
      log.i("MOUNTED: $mounted, CONTEXT.MOUNTED: ${context.mounted}");

      switch (next.states) {
        case AuthStates.loggedIn:
        case AuthStates.signingInWithGoogleSuccessful:
          context.goNamed(AppRoutes.home.name);
          break;
        case AuthStates.loggingInFailed:
          showErrorDialog(context, error: next.error!);
          break;
        case AuthStates.sendingEmailVerification:
          if (!isAtLogin) return;
          showDialog(
              context: context,
              builder: (context) {
                return CircularProgressIndicator.adaptive();
              });
          break;
        case AuthStates.emailVerificationSent:
          if (!isAtLogin) return;
          context.pop();
          context.pushNamed(AppRoutes.emailVerification.name);
          break;
        case AuthStates.sendingEmailVerificationFailed:
          if (!isAtLogin) return;
          context.pop();
          showErrorDialog(context, error: next.error!, actions: [
            MyTextButton(
                onPressed: () {
                  context.pop();
                  sendEmailVerification();
                },
                text: "Retry")
          ]);
          break;
        case AuthStates.checkingEmailVerificationStatusFailed:
          if (!isAtLogin) return;
          showDialog(
              context: context,
              builder: (context) {
                return MyDialog(
                  title: next.error!.title,
                  content: next.error!.content,
                  actions: [
                    MyTextButton(
                        onPressed: () {
                          context.pop();
                          sendEmailVerification();
                        },
                        text: "Verify email")
                  ],
                );
              });
          break;
        default:
      }
    });
    return Scaffold(
      appBar: AppBar(title: Text("Wajanja Tv")),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20.h,
        children: [
          MyElevatedButton(
            text: "Signup",
            onPressed: () {
              context.goNamed(AppRoutes.signup.name);
            },
          ).pSymmetric(),
          Row(
            spacing: 4.w,
            children: [
              Expanded(
                child: Divider(color: Theme.of(context).colorScheme.tertiary),
              ),
              Text(
                "or continue with",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
              ),
              Expanded(
                child: Divider(color: Theme.of(context).colorScheme.tertiary),
              ),
            ],
          ).pSymmetric(),
          MyGoogleSignInButton().pSymmetric(),
          SizedBox(height: 16.h),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80.h),

            Text(
              "Welcome back!",
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
                    hintText: "Email",
                    validator: emailValidator,
                  ),
                  MyTextFormField(
                    controller: password,
                    sectionText: "Password",
                    validator: passwordValidator,
                    obscureText: obscureText,
                    suffixIcon: Icon(
                      obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                    suffixOnpressed: () => setState(() {
                      obscureText = !obscureText;
                    }),
                    hintText: 'Password',
                  ),
                ],
              ).pSymmetric(),
            ),

            SizedBox(height: 8.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyTextButton(
                  text: "forgot password?",
                  onPressed: () {
                    context.pushNamed(AppRoutes.forgotPassword.name);
                  },
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ).pSymmetric(),

            SizedBox(height: 36.h),

            Builder(builder: (context) {
              final authState = ref.watch(authNotifierProvider);

              return MyElevatedButton(
                text: "Login",
                loading: authState.states == AuthStates.loggingIn,
                onPressed: () {
                  //TODO: IMPLEMENT FIREBASE LOGIN

                  final isValid = formKey.currentState?.validate() ?? false;

                  if (!isValid) return;

                  // showSnackMessage(
                  //   context,
                  //   "Log user in",
                  //   flushbarPosition: FlushbarPosition.TOP,
                  // );

                  ref
                      .read(authNotifierProvider.notifier)
                      .loginWithEmailAndPassword(
                          email: email.text.trim(), password: password.text);

                  // log.d("IMPLEMNENT FIREBASE LOGIN");
                },
              ).pSymmetric();
            }),

            // Spacer(),
          ],
        ),
      ),
    );
  }

  void sendEmailVerification() {
    ref.read(authNotifierProvider.notifier).sendEmailVerification();
  }
}
