import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_provider.dart';
import 'package:wajanja/data_layer/providers/user_provider/user_provider.dart';
import 'package:wajanja/presentation/widgets/buttons/my_elevated_button.dart';
import 'package:wajanja/utils/constants/app_svgs.dart';
import 'package:wajanja/utils/constants/enums.dart';

class MyGoogleSignInButton extends ConsumerWidget {
  const MyGoogleSignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider).states;
    final userStates = ref.watch(userNotifierProvider).state;
    return MyElevatedButton(
      text: "Continue with google",
      leadingIcon: AppSvgs.googleLogo,
      loading: authState == AuthStates.signingInWithGoogle || userStates == UserStates.fetchingUser,
      onPressed: () async {
        // context.goNamed(AppRoutes.signup.name);

        await ref.read(authNotifierProvider.notifier).signInWithGoogle();

        // showSnackMessage(
        //   context,
        //   "Implement google signin",
        //   flushbarPosition: FlushbarPosition.TOP,
        // );
      },
    );
  }
}
