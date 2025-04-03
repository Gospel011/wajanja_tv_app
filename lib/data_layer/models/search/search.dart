import 'package:intl_phone_field/countries.dart';

class Search {
  String _text = '';
  Country country = countries.elementAt(158);

  String get text => _text;

  set text(String value) => _text = value.trim();
}
