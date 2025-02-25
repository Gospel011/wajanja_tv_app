import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/presentation/widgets/buttons/my_elevated_button.dart';
import 'package:wajanja/presentation/widgets/buttons/my_text_button.dart';
import 'package:wajanja/presentation/widgets/my_pin_input.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage>
    with UiInfoMixin {
  final otp = TextEditingController();

  @override
  void dispose() {
    otp.dispose();
    super.dispose();
  }

  void verifyOtp(code) async {
    log.f("Completed otp: $code");

    if (otp.text.length < 4) {
      showSnackMessage(
        context,
        "Invalid otp",
        flushbarPosition: FlushbarPosition.TOP,
      );

      return;
    }

    await showMessage(
      context,
      'Success',
      "Verification successful, please login with your details",
    );

    if (!mounted) return;

    context.goNamed(AppRoutes.login.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wajanja Tv")),
      bottomNavigationBar:
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyElevatedButton(
                text: "Verify",
                onPressed: () {
                  verifyOtp(otp.text);
                  log.i("IMPLEMENT OTP VERIFICATION");
                },
              ),

              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  Text("Didn't recieve otp?"),
                  MyTextButton(
                    onPressed: () {
                      log.i("IMPLEMENT OTP RESEND");
                    },
                    text: "Resend",
                  ),
                ],
              ),

              SizedBox(height: 16.h),
            ],
          ).pSymmetric(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 80.h),

              Text(
                "Enter the otp we sent to example@gmail.com",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 36.h),

              MyPinInput(
                controller: otp,
                hintText: '-',
                onCompleted: verifyOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
