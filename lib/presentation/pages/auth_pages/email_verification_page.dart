import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/presentation/widgets/buttons/my_elevated_button.dart';
import 'package:wajanja/presentation/widgets/buttons/my_text_button.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/logger.dart';
import 'package:wajanja/utils/mixins.dart';

class EmailVerificationPage extends ConsumerStatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  ConsumerState<EmailVerificationPage> createState() =>
      _EmailVerificationPageState();
}

class _EmailVerificationPageState extends ConsumerState<EmailVerificationPage>
    with UiInfoMixin, WidgetsBindingObserver {
  final otp = TextEditingController();
  late final String email;
  late StreamController<int> counterStream;

  Timer? _timer;
  Timer? _resendTimer;

  bool canResend = false;

  @override
  void initState() {
    super.initState();
    counterStream = StreamController();
    email = ref.read(authNotifierProvider).user!.email!;

    WidgetsBinding.instance.addObserver(this);

    initialiseTimer();

    initCanResend();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        log.f("paused or inactive: ${state.name}");
        counterStream.close();
        _timer?.cancel();
        break;
      case AppLifecycleState.resumed:
        log.f("Resumed: ${state.name}");
        counterStream = StreamController();
        initialiseTimer();

        setState(() {});
        break;
      default:
    }

    super.didChangeAppLifecycleState(state);
  }

  void initCanResend() {
    _resendTimer?.cancel();
    setState(() {
      canResend = false;
    });
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timer.tick >= 60) {
        setState(() {
          canResend = true;
        });
      }
    });
  }

  void initialiseTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print("TICK: ${timer.tick}");
      final counter = (timer.tick) % 6;

      log.f("COUNTER: $counter");

      counterStream.add(counter);

      if (counter == 0) {
        log.f("Verify otp");

        verifyOtp(null);
      }
    });
  }

  @override
  void dispose() {
    log.f("Dispose called");
    otp.dispose();
    _timer?.cancel();
    _resendTimer?.cancel();
    counterStream.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void verifyOtp(code) async {
    ref.read(authNotifierProvider.notifier).checkUserVerificationStatus();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (prev, next) async {
      switch (next.states) {
        case AuthStates.checkingEmailVerificationStatus:
          _timer?.cancel();
          break;
        case AuthStates.checkingEmailVerificationStatusFailed:
          showSnackMessage(context, next.error!.content,
              error: true, flushbarPosition: FlushbarPosition.TOP);

          initialiseTimer();
        case AuthStates.checkingEmailVerificationStatusSuccessful:
          _timer?.cancel();
          await showMessage(context, "Success",
              "Your email has been verified successfully, please login with your details to continue.");

          if (!context.mounted) return;

          context.goNamed(AppRoutes.login.name);
          break;
        default:
      }
    });
    return Scaffold(
      appBar: AppBar(title: Text("Wajanja Tv")),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Builder(builder: (context) {
            final authState = ref.watch(authNotifierProvider).states;

            final disabled = authState ==
                    AuthStates.checkingEmailVerificationStatusSuccessful ||
                authState == AuthStates.checkingEmailVerificationStatus;

            return MyElevatedButton(
              text: "Verify",
              onPressed: disabled
                  ? null
                  : () {
                      verifyOtp(otp.text);
                      log.d("IMPLEMENT OTP VERIFICATION");
                    },
            );
          }),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              Text("Didn't recieve otp?"),
              MyTextButton(
                onPressed: () {
                  log.d("IMPLEMENT OTP RESEND");

                  ref
                      .read(authNotifierProvider.notifier)
                      .sendEmailVerification();
                },
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: canResend ? 1 : 0.7)),
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
                "Please click the verification link we sent to $email",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 64.h),
              MyElevatedButton(
                onPressed: () async {
                  final uri = Uri(scheme: 'mailto');

                  launch(
                    context,
                    uri: uri,
                    errorMessage: "Could not open email app",
                  );
                },
                text: "Open email app",
                mainAxisSize: MainAxisSize.min,
                // child: Text("Open email app"),
              ).pSymmetric(),
              SizedBox(
                height: 64.h,
              ),
              StreamBuilder<int>(
                stream: counterStream.stream,
                initialData: 0,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) return SizedBox.shrink();
                  final authState = ref.watch(authNotifierProvider);
                  final isCheckingVerificationStatus = authState.states ==
                      AuthStates.checkingEmailVerificationStatus;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10.h,
                    children: [
                      isCheckingVerificationStatus
                          ? Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : Text(
                              "${6 - snapshot.data}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                      isCheckingVerificationStatus
                          ? Text("Checking verification status")
                          : SizedBox.shrink()
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
