import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/presentation/widgets/buttons/my_elevated_button.dart';
import 'package:wajanja/presentation/widgets/buttons/my_text_button.dart';
import 'package:wajanja/presentation/widgets/my_textformfield.dart';
import 'package:wajanja/utils/constants/app_svgs.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';
import 'package:wajanja/utils/validators/validators.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with UiInfoMixin {
  final email = TextEditingController();
  final password = TextEditingController();

  bool obscureText = true;

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

          MyElevatedButton(
            text: "Continue with google",
            leadingIcon: AppSvgs.googleLogo,
            onPressed: () {
              // context.goNamed(AppRoutes.signup.name);

              showSnackMessage(
                context,
                "Implement google signin",
                flushbarPosition: FlushbarPosition.TOP,
              );
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
              "Welcome back!",
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
                        suffixOnpressed:
                            () => setState(() {
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

            MyElevatedButton(
              text: "Login",
              onPressed: () {
                //TODO: IMPLEMENT FIREBASE LOGIN

                final isValid = formKey.currentState?.validate() ?? false;

                if (!isValid) return;

                showSnackMessage(
                  context,
                  "Log user in",
                  flushbarPosition: FlushbarPosition.TOP,
                );

                log.i("IMPLEMNENT FIREBASE LOGIN");
              },
            ).pSymmetric(),

            // Spacer(),
          ],
        ),
      ),
    );
  }
}
