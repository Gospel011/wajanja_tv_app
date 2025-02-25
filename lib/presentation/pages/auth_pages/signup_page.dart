import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/presentation/widgets/buttons/my_elevated_button.dart';
import 'package:wajanja/presentation/widgets/my_textformfield.dart';
import 'package:wajanja/utils/constants/app_svgs.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/validators/validators.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20.h,
        children: [
          MyElevatedButton(
            text: "Signup",
            onPressed: () {
              //TODO: IMPLEMENT FIREBASE LOGIN

              final isValid = formKey.currentState?.validate() ?? false;

              if (!isValid) return; 


              context.pushNamed(AppRoutes.emailVerification.name);

              log.i("IMPLEMNENT FIREBASE SIGNUP");
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

          MyElevatedButton(
            text: "Continue with google",
            leadingIcon: AppSvgs.googleLogo,
            onPressed: () {
              context.goNamed(AppRoutes.signup.name);
            },
          ).pSymmetric(),

          SizedBox(height: 16.h),
        ],
      ),
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
              child:
                  Column(
                    spacing: 20.h,
                    children: [
                      MyTextFormField(
                        sectionText: "Full name",
                        controller: fullName,
                        hintText: "Joseph Christopher",
                        validator:
                            (value) => nonNullValidator(
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
                        suffixOnpressed:
                            () => setState(() {
                              obscureText = !obscureText;
                            }),
                      ),
                      MyTextFormField(
                        controller: confirmPassword,
                        sectionText: "Confirm password",
                        validator:
                            (value) => signupConfirmPasswordValidator(
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
                        suffixOnpressed:
                            () => setState(() {
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
