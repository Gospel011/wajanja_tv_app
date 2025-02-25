

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/presentation/widgets/buttons/my_elevated_button.dart';
import 'package:wajanja/presentation/widgets/my_textformfield.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';
import 'package:wajanja/utils/validators/validators.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage>
    with UiInfoMixin {
  final confirmPassword = TextEditingController();
  final password = TextEditingController();

  bool obscureText = true;

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    confirmPassword.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wajanja Tv")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80.h),

            Text(
              "Create new password",
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
                        sectionText: "Confirm password",
                        controller: confirmPassword,
                        hintText: "Confirm new password",
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
                        validator:
                            (value) => signupConfirmPasswordValidator(
                              value,
                              password.text,
                            ),
                      ),
                    ],
                  ).pSymmetric(),
            ),

            SizedBox(height: 75.h),

            MyElevatedButton(
              text: "Change password",
              onPressed: () async {
                //TODO: IMPLEMENT FIREBASE LOGIN

                final isValid = formKey.currentState?.validate() ?? false;

                if (!isValid) return;

                await showMessage(
                  context,
                  "Success",
                  "Password changed successfully, please login with your new details.",
                );

                if (!context.mounted) return;

                context.goNamed(AppRoutes.login.name);

                log.i("IMPLEMNENT FIREBASE CHANGE PASSWORD");
              },
            ).pSymmetric(),

            // Spacer(),
          ],
        ),
      ),
    );
  }
}
