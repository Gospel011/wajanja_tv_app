extension MapToQueryString on Map<String, dynamic> {
  String toQueryString() {
    removeWhere((key, value) => value == null || value == '');
    var res = entries.map((entry) {
      final key = entry.key;
      final value = entry.value.toString();
      return '$key=$value';
    }).join('&');

    return res;
  }
}