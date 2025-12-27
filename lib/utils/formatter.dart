import 'package:intl/intl.dart';

class Formatter {
  static String currency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String compactCurrency(double amount) {
    if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(1)}K';
    }
    return currency(amount);
  }

  static String date(DateTime date) {
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }

  static String dateShort(DateTime date) {
    return DateFormat('dd/MM/yy').format(date);
  }

  static String dateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return 'Hari Ini';
    } else if (targetDate == yesterday) {
      return 'Kemarin';
    }
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }
}