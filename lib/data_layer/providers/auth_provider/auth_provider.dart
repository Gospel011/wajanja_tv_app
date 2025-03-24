import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wajanja/data_layer/db/user_db.dart';
import 'package:wajanja/data_layer/models/helper_models/error_model.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_state.dart';
import 'package:wajanja/data_layer/providers/user_provider/user_provider.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart' as models;
import 'package:wajanja/utils/helpers/logger.dart';

class AuthNotifier extends Notifier<AuthState> {
  UserState? userState;
  UserNotifier? userNotifier;

  @override
  AuthState build() {
    models.User? user = UserDb.instance.retrieveUser();

    userState = ref.watch(userNotifierProvider);
    userNotifier = ref.read(userNotifierProvider.notifier);

    log.i("NEW USER STATE: $userState");

    if (userState?.state == UserStates.userFetched ||
        userState?.state == UserStates.userUpserted) {
      user = userState!.user!;
      UserDb.instance.save(user);
    }

    return AuthState(states: AuthStates.initial, user: user);
  }

  void _setState(AuthState newState) {
    state = newState;
  }

  Future<void> checkUserVerificationStatus() async {
    _setState(
        state.copyWith(states: AuthStates.checkingEmailVerificationStatus));

    // FirebaseAuth.instance.applyActionCode(code);

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _setState(state.copyWith(
        states: AuthStates.checkingEmailVerificationStatusFailed,
        error: AppError(
          title: "Error",
          content: "Please login to verify your email",
        ),
      ));

      return;
    }

    try {
      await user.reload();
    } on FirebaseAuthException catch (e) {
      log.e("FIREBASE EXCEPTION ERROR CODE: ${e.code}");
      final exception = FirebaseAuthExceptions.fromCode(e.code);

      _setState(state.copyWith(
          states: AuthStates.checkingEmailVerificationStatusFailed,
          error:
              AppError(title: exception.describe, content: exception.message)));
    }

    final emailVerified = user.emailVerified;

    log.d("USER: $user");

    if (!emailVerified) {
      _setState(state.copyWith(
        states: AuthStates.checkingEmailVerificationStatusFailed,
        error: AppError(
          title: "Error",
          content: "Your email has not been verified.",
        ),
      ));
    } else {
      userNotifier!.upsertUser(
          models.User(email: user.email, emailVerified: user.emailVerified));

      _setState(
        state.copyWith(
          states: AuthStates.checkingEmailVerificationStatusSuccessful,
        ),
      );
    }
  }

  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    _setState(state.copyWith(states: AuthStates.sendingEmailVerification));

    if (user == null) {
      _setState(state.copyWith(
        states: AuthStates.sendingEmailVerificationFailed,
        error: AppError(
          title: "Error",
          content: "Please login to verify your email",
        ),
      ));

      return;
    }

    try {
      await user.sendEmailVerification();

      _setState(
        state.copyWith(
          states: AuthStates.emailVerificationSent,
          user: models.User(email: user.email),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(
        e,
        errorState: AuthStates.sendingEmailVerificationFailed,
      );
    }
  }

  Future<void> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    // FirebaseAuth.instance.signOut();

    _setState(state.copyWith(states: AuthStates.loggingIn));

    try {
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final user = credential.user;

      final emailVerified = user?.emailVerified ?? false;

      if (!emailVerified) {
        _setState(state.copyWith(
          states: AuthStates.checkingEmailVerificationStatusFailed,
          error: AppError(
            title: "Error",
            content: "Your email has not been verified.",
          ),
        ));
      } else {
        // models.User newUser = models.User.fromCredential(credential);

        // log.i("FETCHING USER: $userState");

        await userNotifier!.fetchUser(email);

        // log.i("User state after request: $userState");

        // }

        _setState(
          state.copyWith(
            states: AuthStates.loggedIn,
            // user: newUser,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e, errorState: AuthStates.loggingInFailed);
    } catch (e) {
      _handleGenericError(
        e,
        states: AuthStates.loggingInFailed,
        // message: "We could not log you in at the moment, please try again.",
      );
    }
  }

  void _handleGenericError(e, {String? message, required AuthStates states}) {
    _setState(
      state.copyWith(
        states: states,
        error: AppError(
          title: "Error",
          content: message ?? e.toString(),
        ),
      ),
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    _setState(state.copyWith(states: AuthStates.sendingPasswordResetEmail));
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      _setState(state.copyWith(states: AuthStates.passwordResetEmailSent));
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e,
          errorState: AuthStates.sendingPasswordResetEmailFailed);
    }
  }

  Future<void> signInWithGoogle() async {
    _setState(state.copyWith(states: AuthStates.signingInWithGoogle));

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      _setState(state.copyWith(
          states: AuthStates.signingInWithGoogleFailed,
          error: AppError(
              title: "Error",
              content: "We couldn't sign you in with google at the moment")));

      return;
    }
    // if

    try {
      final GoogleSignInAuthentication auth = await googleUser.authentication;

      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      final UserCredential credential = await FirebaseAuth.instance
          .signInWithCredential(googleAuthCredential);

      models.User newUser = models.User.fromCredential(credential);

      await userNotifier!.upsertUser(newUser);
      await userNotifier!.fetchUser(newUser.email!);

      // if (userState?.state == UserStates.userFetched) {
      //   newUser = userState!.user!;
      // }

      // UserDb.instance.save(newUser);

      _setState(
        state.copyWith(
          states: AuthStates.signingInWithGoogleSuccessful,
          // user: newUser,
        ),
      );
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e,
          errorState: AuthStates.signingInWithGoogleFailed);
    } catch (e) {
      log.i("ERROR IS: $e");
      _handleGenericError(
        e,
        states: AuthStates.signingInWithGoogleFailed,
        // message: "We could not sign you in with google at the moment",
      );
    }
  }

  Future<void> logout() async {
    _setState(state.copyWith(states: AuthStates.signingOut));

    try {
      await Future.wait([
        GoogleSignIn().signOut(),
        FirebaseAuth.instance.signOut(),
      ]);
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e, errorState: AuthStates.signingOutFailed);
      return;
    }

    UserDb.instance.clearUser();

    _setState(AuthState.initial());
  }

  Future<void> createUserWithEmailAndPassword(
      {required String email,
      required String fullName,
      required String phone,
      required String password}) async {
    _setState(state.copyWith(states: AuthStates.signingUp));
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      sendEmailVerification();

      final userToUpsert =
          models.User(email: email, fullName: fullName, phone: phone);

      await userNotifier!.upsertUser(userToUpsert);

      _setState(
        state.copyWith(
          states: AuthStates.signedUp,
          user: models.User.fromCredential(credential),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e, errorState: AuthStates.signingUpFailed);
    } catch (e) {
      _handleGenericError(e, states: AuthStates.signingUpFailed);
    }
  }

  void _handleFirebaseAuthException(FirebaseAuthException e,
      {required AuthStates errorState}) {
    final authException = FirebaseAuthExceptions.fromCode(e.code);

    log.e("FIREBASE AUTH EXCEPTION CODE: ${e.code}");

    _setState(state.copyWith(
      states: errorState,
      error: AppError(
        title: authException.describe,
        content: authException.message,
      ),
    ));
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
