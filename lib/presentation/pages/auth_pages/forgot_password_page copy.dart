import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/presentation/widgets/buttons/my_elevated_button.dart';
import 'package:wajanja/presentation/widgets/my_textformfield.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/validators/validators.dart';


class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final email = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
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
              "Enter your email",
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
                        hintText: "example@gmail.com",
                        validator: emailValidator,
                      ),

                      SizedBox(height: 104.h),
                    ],
                  ).pSymmetric(),
            ),

            SizedBox(height: 104.h),

            MyElevatedButton(
              text: "Confirm",
              onPressed: () {
                final isValid = formKey.currentState?.validate() ?? false;

                if(!isValid) return;

                context.pushNamed(AppRoutes.resetPassword.name);
              },
            ).pSymmetric(),

            // Spacer(),
          ],
        ),
      ),
    );
  }
}
