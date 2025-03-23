// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:wajanja/utils/extensions/string_extension.dart';

enum AuthStates {
  initial,

  signingUp,
  signedUp,
  signingUpFailed,

  loggingIn,
  loggedIn,
  loggingInFailed,
  checkingEmailVerificationStatus,
  checkingEmailVerificationStatusFailed,
  checkingEmailVerificationStatusSuccessful,
  sendingEmailVerificationFailed,
  sendingEmailVerification,
  emailVerificationSent,
  signingOut,
  signingOutFailed,
  signingInWithGoogle,
  signingInWithGoogleFailed,
  signingInWithGoogleSuccessful,
  sendingPasswordResetEmailFailed,
  sendingPasswordResetEmail,
  passwordResetEmailSent,
  loggedInUserFetched,
}

enum OnboardingIllustrations {
  video_light(
    path: 'assets/illustrations/video_light.svg',
    title: "Videos and Documentaries",
    subtitle:
        "Explore a vast collection of movies and documentaries, from thrilling blockbusters to insightful stories.",
  ),
  news_light(
    path: "assets/illustrations/news_light.svg",
    title: "News",
    subtitle:
        "Stay updated with the latest headlines, in-depth reports, and breaking news from around the world.",
  ),
  podcast_light(
    path: "assets/illustrations/podcast_light.svg",
    title: "Podcasts",
    subtitle:
        "Tune in to thought-provoking conversations, inspiring stories, and expert discussions.",
  ),
  audio_book_light(
    path: "assets/illustrations/audio_book_light.svg",
    title: "Audio Books",
    subtitle:
        "Enjoy a rich library of audiobooks, from bestsellers to timeless classics, anytime, anywhere.",
  ),
  video_dark(
    path: "assets/illustrations/video_dark.svg",
    title: "Videos and Documentaries",
    subtitle:
        "Explore a vast collection of movies and documentaries, from thrilling blockbusters to insightful stories.",
  ),
  news_dark(
    path: "assets/illustrations/news_dark.svg",
    title: "News",
    subtitle:
        "Stay updated with the latest headlines, in-depth reports, and breaking news from around the world.",
  ),
  podcast_dark(
    path: "assets/illustrations/podcast_dark.svg",
    title: "Podcasts",
    subtitle:
        "Tune in to thought-provoking conversations, inspiring stories, and expert discussions.",
  ),
  audio_book_dark(
    path: "assets/illustrations/audio_book_dark.svg",
    title: "Audio Books",
    subtitle:
        "Enjoy a rich library of audiobooks, from bestsellers to timeless classics, anytime, anywhere.",
  );

  final String path;
  final String title;
  final String subtitle;

  const OnboardingIllustrations({
    required this.path,
    required this.title,
    required this.subtitle,
  });

  static List<OnboardingIllustrations> themeIllustrations(
    Brightness brightness,
  ) {
    switch (brightness) {
      case Brightness.light:
        return [
          OnboardingIllustrations.video_light,
          OnboardingIllustrations.news_light,
          OnboardingIllustrations.podcast_light,
          OnboardingIllustrations.audio_book_light,
        ];

      default:
        return [
          OnboardingIllustrations.video_dark,
          OnboardingIllustrations.news_dark,
          OnboardingIllustrations.podcast_dark,
          OnboardingIllustrations.audio_book_dark,
        ];
    }
  }
}

enum AppRoutes {
  onboarding,
  login,
  signup,
  emailVerification,
  home,
  forgotPassword,
  resetPassword,
  signupSuccess,
  videoDescription,
  news,
  audiobooks,
  podcasts, newsDetails, imageView;

  String get path => name.kebabCase;
}

enum TextFieldType { otp, normal }

enum TutorialSections { home }

enum FirebaseAuthExceptions {
  emailAlreadyInUse(
    "This email is already associated with an account, please login instead.",
  ),
  invalidEmail(
    "This email is invalid, please provide another email",
  ),
  operationNotAllowed(
    "Auth provider not enabled, please try again later or contact support.",
  ),
  weakPassword(
    "Your password is too weak, please provide a more secure one",
  ),
  tooManyRequests(
    "You have made too many requests within a short time, please try again after some minutes.",
  ),
  userTokenExpired(
    "Please re-login to continue",
  ),
  networkRequestFailed(
    "Please check your internet connection",
  ),
  userDisabled(
    "Your account has been disabled, please contact support.",
  ),
  userNotFound(
    "This user does not exist, please create an account instead.",
  ),
  wrongPassword(
    "Your password is incorrect.",
  ),
  invalidLoginCredential(
    "Your email or password is incorrect",
  ),
  accountExistsWithDifferentCredential(
      "Please use the appropriate signin method for this account."),
  invalidCredential("Please try again"),
  invalidVerificationCode("Please provide a valid verification code"),
  invalidVerificationId("Please try again"),

  authInvalidEmail(
      "This email is invalid, please provide a valid email and try again."),
  authMissingAndroidPkgName("Please contact support"),
  authMissingContinueUri("Please contact support"),
  authMissingIosBundleId("Please contact support"),
  authInvalidContinueUri("Please contact support"),
  authUnauthorizedContinueUri("Please contact support"),
  authUserNotFound(
      "No user corresponding to the provided email was found, please provide a valid email and try again."),

  unknownError(
    "We could not complete your request at the moment, please try again later",
  );

  /**
invalid-verification-code:
Thrown if the credential is a [PhoneAuthProvider.credential] and the verification code of the credential is not valid.
invalid-verification-id:
Thrown if the credential is a [PhoneAuthProvider.credential] and the verification ID of the credential is not valid.id.








   */

  String get describe => name.kebabCase.capitalize.replaceAll('-', ' ');

  final String message;

  const FirebaseAuthExceptions(this.message);

  factory FirebaseAuthExceptions.fromCode(String value) {
    switch (value) {
      case 'email-already-in-use':
        return FirebaseAuthExceptions.emailAlreadyInUse;
      case 'invalid-email':
        return FirebaseAuthExceptions.invalidEmail;
      case 'operation-not-allowed':
        return FirebaseAuthExceptions.operationNotAllowed;
      case 'weak-password':
        return FirebaseAuthExceptions.weakPassword;
      case 'too-many-requests':
        return FirebaseAuthExceptions.tooManyRequests;
      case 'user-token-expired':
        return FirebaseAuthExceptions.userTokenExpired;
      case 'network-request-failed':
        return FirebaseAuthExceptions.networkRequestFailed;
      case 'user-disabled':
        return FirebaseAuthExceptions.userDisabled;
      case 'user-not-found':
        return FirebaseAuthExceptions.userNotFound;
      case 'wrong-password':
        return FirebaseAuthExceptions.wrongPassword;
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS':
        return FirebaseAuthExceptions.invalidLoginCredential;
      case 'account-exists-with-different-credential':
        return FirebaseAuthExceptions.accountExistsWithDifferentCredential;
      case 'auth/invalid-email':
        return FirebaseAuthExceptions.authInvalidEmail;
      case 'auth/missing-android-pkg-name':
        return FirebaseAuthExceptions.authMissingAndroidPkgName;
      case 'auth/missing-continue-uri':
        return FirebaseAuthExceptions.authMissingContinueUri;
      case 'auth/missing-ios-bundle-id':
        return FirebaseAuthExceptions.authMissingIosBundleId;
      case 'auth/invalid-continue-uri':
        return FirebaseAuthExceptions.authInvalidContinueUri;
      case 'auth/unauthorized-continue-uri':
        return FirebaseAuthExceptions.authUnauthorizedContinueUri;
      case 'auth/user-not-found':
        return FirebaseAuthExceptions.authUserNotFound;
      default:
        return FirebaseAuthExceptions.unknownError;
    }
  }

/**
 *
user-disabled: *
Thrown if the user corresponding to the given email has been disabled.
user-not-found:
Thrown if there is no user corresponding to the given email.
wrong-password:
Thrown if the password is invalid for the given email, or the account corresponding to the email does not have a password set.
too-many-requests:
Thrown if the user sent too many requests at the same time, for security the api will not allow too many attemps at the same time, user will have to wait for some time
user-token-expired:
Thrown if the user is no longer authenticated since his refresh token has been expired
network-request-failed:
Thrown if there was a network request error, for example the user don't don't have internet connection
INVALID_LOGIN_CREDENTIALS or invalid-credential:
Thrown if the password is invalid for the given email, or the account corresponding to the email does not have a password set. depending on if you are using firebase emulator or not the code is different
operation-not-allowed:
Thrown if email/password accounts are not enabled. Enable email/password accounts in the Firebase Console, under the Auth tab.
 */
}

enum UserStates {
  initial,

  fetchingUser,
  userFetched,
  fetchingUserFailed,
  upsertingUser,
  userUpserted,
  upsertingUserFailed,
}

enum CollectionPaths {
  users('users');

  final String path;

  const CollectionPaths(this.path);
}

enum VideoCategories {
  entertainment,
  education,
  gaming,
  lifestyle,
  techAndReviews,
  music,
  newsAndPolitics,
  businessAndFinance,
  scienceAndDocumentary,
  diyAndCrafts,
  sports,
  healthAndWellness,
  comedy,
  travel,
  foodAndCooking,
  beautyAndFashion,
  podcastsAndTalkShows,
  animation,
  motivation,
  vlogs;

  String get describe => name.kebabCase.replaceAll('-', ' ');

  factory VideoCategories.fromString(String value) {
    switch (value.toLowerCase()) {
      case 'entertainment':
        return VideoCategories.entertainment;
      case 'education':
        return VideoCategories.education;
      case 'gaming':
        return VideoCategories.gaming;
      case 'lifestyle':
        return VideoCategories.lifestyle;
      case 'tech and reviews':
        return VideoCategories.techAndReviews;
      case 'music':
        return VideoCategories.music;
      case 'news and politics':
        return VideoCategories.newsAndPolitics;
      case 'business and finance':
        return VideoCategories.businessAndFinance;
      case 'science and documentary':
        return VideoCategories.scienceAndDocumentary;
      case 'diy and crafts':
        return VideoCategories.diyAndCrafts;
      case 'sports':
        return VideoCategories.sports;
      case 'health and wellness':
        return VideoCategories.healthAndWellness;
      case 'comedy':
        return VideoCategories.comedy;
      case 'travel':
        return VideoCategories.travel;
      case 'food and cooking':
        return VideoCategories.foodAndCooking;
      case 'beauty and fashion':
        return VideoCategories.beautyAndFashion;
      case 'podcasts and talk shows':
        return VideoCategories.podcastsAndTalkShows;
      case 'animation':
        return VideoCategories.animation;
      case 'motivation':
        return VideoCategories.motivation;
      case 'vlogs':
        return VideoCategories.vlogs;
      default:
        throw ArgumentError('Invalid video category: $value');
    }
  }
}

enum NewsCategory {
  world,
  politics,
  business,
  technology,
  science,
  health,
  sports,
  entertainment,
  environment,
  education,
  crime,
  law,
  finance,
  economy,
  travel,
  food,
  culture,
  fashion,
  real_estate,
  gaming,
  automotive,
  startup,
  social_media,
  weather,
  energy,
  space,
  history,
  religion,
  opinion,
  breaking_news;

  String get describe => name.split('_').join(' ');

  factory NewsCategory.fromString(String value) {
    return NewsCategory.values.firstWhere(
      (category) => category.describe == value,
      orElse: () => throw ArgumentError("Invalid category: $value"),
    );
  }
}

enum NewsSectionType {
  text,
  pictures;

  String get describe => name;

  factory NewsSectionType.fromString(String value) {
    return NewsSectionType.values.firstWhere(
      (type) => type.describe == value,
      orElse: () => throw ArgumentError("Invalid NewsSectionType: $value"),
    );
  }
}
