import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date, {String pattern = 'MMM dd, yyyy'}) {
    return DateFormat(pattern).format(date);
  }

  static String formatTime(DateTime time, {String pattern = 'HH:mm'}) {
    return DateFormat(pattern).format(time);
  }

  static String formatDateTime(DateTime dateTime, {String pattern = 'MMM dd, yyyy HH:mm'}) {
    return DateFormat(pattern).format(dateTime);
  }

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return formatDate(dateTime);
      }
    } else if (difference.inHours > 0) {
      if (difference.inHours == 1) {
        return '1 hour ago';
      } else {
        return '${difference.inHours} hours ago';
      }
    } else if (difference.inMinutes > 0) {
      if (difference.inMinutes == 1) {
        return '1 minute ago';
      } else {
        return '${difference.inMinutes} minutes ago';
      }
    } else {
      return 'Just now';
    }
  }

  static String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      if (minutes > 0) {
        return '${hours}h ${minutes}m';
      } else {
        return '${hours}h';
      }
    } else {
      return '${duration.inMinutes}m';
    }
  }

  static String formatTimeRange(String startTime, String endTime) {
    return '$startTime - $endTime';
  }

  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  static String formatPricePerHour(double price) {
    return '\$${price.toStringAsFixed(2)}/hour';
  }

  static DateTime parseDate(String dateString) {
    return DateFormat('yyyy-MM-dd').parse(dateString);
  }

  static DateTime parseTime(String timeString) {
    final now = DateTime.now();
    final timeParts = timeString.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && 
           date.month == tomorrow.month && 
           date.day == tomorrow.day;
  }

  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) && 
           date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  static String getDayName(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  static String getShortDayName(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  static String getMonthName(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  static String getShortMonthName(DateTime date) {
    return DateFormat('MMM').format(date);
  }

  static List<String> getTimeSlots({
    required String startTime,
    required String endTime,
    required int slotDurationMinutes,
  }) {
    final slots = <String>[];
    final start = parseTime(startTime);
    final end = parseTime(endTime);
    
    var current = start;
    while (current.isBefore(end)) {
      slots.add(formatTime(current));
      current = current.add(Duration(minutes: slotDurationMinutes));
    }
    
    return slots;
  }

  static bool isTimeSlotAvailable(
    String timeSlot,
    List<String> bookedSlots,
  ) {
    return !bookedSlots.contains(timeSlot);
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}
