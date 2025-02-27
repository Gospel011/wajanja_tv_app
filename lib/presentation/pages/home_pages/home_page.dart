import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/presentation/widgets/buttons/my_elevated_button.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/extensions/widget_extensions.dart';
import 'package:wajanja/utils/helpers/logger.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        if (user == null) {
          log.d("AUTH STATE CHANGES: $user");

          ref.read(authNotifierProvider.notifier).logout();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(ref.read(authNotifierProvider).states);

    ref.listen(authNotifierProvider, (prev, next) {
      switch (next.states) {
        case AuthStates.initial:
          context.goNamed(AppRoutes.login.name);
          break;
        default:
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20.h,
          children: [
            Text("Home page"),
            Builder(builder: (context) {
              final authState = ref.watch(authNotifierProvider);

              return MyElevatedButton(
                text: "Logout",
                loading: authState.states == AuthStates.signingOut,
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).logout();
                },
              ).pSymmetric();
            }),
          ],
        ),
      ),
    );
  }
}
