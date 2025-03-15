import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/presentation/widgets/buttons/my_elevated_button.dart';
import 'package:wajanja/presentation/widgets/buttons/my_google_sign_in_button.dart';
import 'package:wajanja/presentation/widgets/my_textformfield.dart';
import 'package:wajanja/utils/constants/app_svgs.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';
import 'package:wajanja/utils/validators/validators.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> with UiInfoMixin {
  final fullName = TextEditingController(text: 'Faro Dojeh');
  final email = TextEditingController(text: 'dipogoh387@bankrau.com');
  final phone = TextEditingController(text: '09090899878');
  final password = TextEditingController(text: 'testUser1@');
  final confirmPassword = TextEditingController(text: 'testUser1@');

  bool obscureText = true;

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    fullName.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (prev, next) {
      switch (next.states) {
        case AuthStates.signingUpFailed:
          showErrorDialog(context, error: next.error!);
          break;
        case AuthStates.signedUp:
          context.pushNamed(AppRoutes.emailVerification.name);
          break;
        default:
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Wajanja Tv"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.close),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      bottomNavigationBar: Builder(builder: (context) {
        final authState = ref.watch(authNotifierProvider);

        return Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20.h,
          children: [
            MyElevatedButton(
              text: "Signup",
              loading: authState.states == AuthStates.signingUp,
              onPressed: () {
                //TODO: IMPLEMENT FIREBASE LOGIN

                final isValid = formKey.currentState?.validate() ?? false;

                if (!isValid) return;

                final emailStr = email.text.trim();
                final passwordStr = password.text;

                log.d("Email: $emailStr");
                log.d("Password: $passwordStr");

                ref
                    .read(authNotifierProvider.notifier)
                    .createUserWithEmailAndPassword(
                        email: emailStr, password: passwordStr);

                // context.pushNamed(AppRoutes.emailVerification.name);

                // log.d("IMPLEMNENT FIREBASE SIGNUP");
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
        );
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80.h),
            Text(
              "Create your account",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 36.h),
            Form(
              key: formKey,
              child: Column(
                spacing: 20.h,
                children: [
                  MyTextFormField(
                    sectionText: "Full name",
                    controller: fullName,
                    hintText: "Joseph Christopher",
                    validator: (value) => nonNullValidator(
                      value,
                      message: "Please provide your name",
                    ),
                  ),
                  MyTextFormField(
                    sectionText: "Email",
                    controller: email,
                    hintText: "example@gmail.com",
                    validator: emailValidator,
                  ),
                  MyTextFormField(
                    sectionText: "Phone",
                    controller: phone,
                    hintText: "+234-123-456-7890",
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    validator: (value) => nonNullValidator(value,
                        message: "Please provide your phone number"),
                  ),
                  MyTextFormField(
                    controller: password,
                    sectionText: "Password",
                    validator: passwordValidator,
                    hintText: 'Password',
                    obscureText: obscureText,
                    suffixIcon: Icon(
                      obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                    suffixOnpressed: () => setState(() {
                      obscureText = !obscureText;
                    }),
                  ),
                  MyTextFormField(
                    controller: confirmPassword,
                    sectionText: "Confirm password",
                    validator: (value) => signupConfirmPasswordValidator(
                      value,
                      password.text,
                    ),
                    hintText: 'Confirm your password',
                    obscureText: obscureText,
                    suffixIcon: Icon(
                      obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                    suffixOnpressed: () => setState(() {
                      obscureText = !obscureText;
                    }),
                  ),
                ],
              ).pSymmetric(),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
