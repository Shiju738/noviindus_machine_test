import 'package:intl/intl.dart';

class Format {
  static String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);

      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  static String formatFirstName(String name) {
    if (name.isEmpty) return '';

    List<String> words = name.trim().split(' ');

    if (words.isNotEmpty && words.first.isNotEmpty) {
      return words.first;
    }

    return '';
  }

  static String formatNameInitials(String name) {
    if (name.isEmpty) return '';

    List<String> words = name.trim().split(' ');

    if (words.isNotEmpty && words.first.isNotEmpty) {
      return words.first[0].toUpperCase();
    }

    return '';
  }

  static String formatNameAllInitials(String name) {
    if (name.isEmpty) return '';

    List<String> words = name.trim().split(' ');

    String initials = '';
    for (String word in words) {
      if (word.isNotEmpty) {
        initials += word[0].toUpperCase();
      }
    }

    return initials;
  }
}
