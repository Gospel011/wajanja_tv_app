// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:wajanja/utils/extensions/string_extension.dart';

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
  signupSuccess;

  String get path => name.kebabCase;
}

enum TextFieldType { otp, normal }

enum TutorialSections { home }
