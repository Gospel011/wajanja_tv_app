extension MyStringExtension on String {
  String get capitalize {
    if (isEmpty) return this;

    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String get capitalizeAll {
    if (isEmpty) return this;

    return split(' ').map((el) => el.capitalize).join(' ');
  }

  bool get beginsWithVowel {
    if (trim().isEmpty) return false;
    return ['a', 'e', 'i', 'o', 'u'].contains(this[0].toLowerCase());
  }


  String get kebabCase {
    String parsedString = replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '-${match.group(0)!.toLowerCase()}',
    );

    if (parsedString[0] == '-') {
      parsedString = parsedString.replaceFirst('-', '');
    }
    return parsedString;
  }
}
