import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wajanja/data_layer/db/user_db.dart';
import 'package:wajanja/data_layer/models/helper_models/error_model.dart';
import 'package:wajanja/data_layer/providers/auth_provider/auth_state.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/data_layer/models/user_model/user.dart' as models;
import 'package:wajanja/utils/helpers/logger.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    final user = UserDb.instance.retrieveUser();

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
        final newUser = models.User.fromCredential(credential);

        if (user != null) {
          UserDb.instance.save(newUser);
        }

        _setState(
          state.copyWith(
            states: AuthStates.loggedIn,
            user: newUser,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e, errorState: AuthStates.loggingInFailed);
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

      final newUser = models.User.fromCredential(credential);

      _setState(
        state.copyWith(
          states: AuthStates.signingInWithGoogleSuccessful,
          user: newUser,
        ),
      );
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e,
          errorState: AuthStates.signingInWithGoogleFailed);
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
      {required String email, required String password}) async {
    _setState(state.copyWith(states: AuthStates.signingUp));
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      sendEmailVerification();

      _setState(
        state.copyWith(
          states: AuthStates.signedUp,
          user: models.User.fromCredential(credential),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e, errorState: AuthStates.signingUpFailed);
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
