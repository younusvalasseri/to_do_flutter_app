import 'package:intl/intl.dart';

class DateFormatter {
  // Format to a readable full date (e.g., Jan 1, 2025)
  static String formatFullDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  // Format to a full date with time (e.g., Jan 1, 2025 - 10:30 AM)
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM d, yyyy – h:mm a').format(date);
  }

  // Format to only time (e.g., 10:30 AM)
  static String formatTime(DateTime date) {
    return DateFormat.jm().format(date);
  }

  // Format to ISO 8601 string (e.g., 2025-01-01T10:30:00)
  static String formatIso(DateTime date) {
    return date.toIso8601String();
  }

  // Parse string to DateTime from yMMMd format
  static DateTime? parseFullDate(String dateString) {
    try {
      return DateFormat.yMMMd().parse(dateString);
    } catch (_) {
      return null;
    }
  }

  // Parse from ISO string
  static DateTime? parseIso(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      return null;
    }
  }
}
