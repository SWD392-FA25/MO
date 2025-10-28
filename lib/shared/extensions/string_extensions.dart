extension StringExtensions on String {
  // Validation
  bool get isEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }
  
  bool get isUrl {
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(this);
  }
  
  bool get isPhoneNumber {
    final phoneRegex = RegExp(r'^\+?[1-9]\d{9,14}$');
    return phoneRegex.hasMatch(replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }
  
  bool get isNumeric {
    return double.tryParse(this) != null;
  }
  
  bool get isAlpha {
    final alphaRegex = RegExp(r'^[a-zA-Z]+$');
    return alphaRegex.hasMatch(this);
  }
  
  bool get isAlphanumeric {
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return alphanumericRegex.hasMatch(this);
  }
  
  // String manipulation
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
  
  String get capitalizeWords {
    return split(' ').map((word) => word.capitalize).join(' ');
  }
  
  String get reversed {
    return split('').reversed.join('');
  }
  
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }
  
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }
  
  String removeDuplicateWhitespace() {
    return replaceAll(RegExp(r'\s+'), ' ').trim();
  }
  
  // Conversion
  int? toIntOrNull() {
    return int.tryParse(this);
  }
  
  double? toDoubleOrNull() {
    return double.tryParse(this);
  }
  
  bool? toBoolOrNull() {
    if (toLowerCase() == 'true') return true;
    if (toLowerCase() == 'false') return false;
    return null;
  }
  
  // Utility
  bool containsIgnoreCase(String other) {
    return toLowerCase().contains(other.toLowerCase());
  }
  
  String replaceIgnoreCase(String from, String replace) {
    return replaceAllMapped(
      RegExp(from, caseSensitive: false),
      (match) => replace,
    );
  }
  
  String get initials {
    if (isEmpty) return '';
    final words = split(' ').where((word) => word.isNotEmpty).toList();
    if (words.isEmpty) return '';
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    }
    return words.take(2).map((word) => word[0].toUpperCase()).join();
  }
  
  String toSnakeCase() {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }
  
  String toCamelCase() {
    final words = split(RegExp(r'[_\s]'));
    if (words.isEmpty) return this;
    return words[0].toLowerCase() + 
           words.skip(1).map((word) => word.capitalize).join();
  }
  
  String toPascalCase() {
    return split(RegExp(r'[_\s]'))
        .map((word) => word.capitalize)
        .join();
  }
}

extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
  
  String orEmpty() => this ?? '';
  String or(String defaultValue) => this ?? defaultValue;
}
