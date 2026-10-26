import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _currencyFormatUsd = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  static final NumberFormat _currencyFormatVnd = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  static final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('MMM dd, yyyy HH:mm');

  static String formatCompactUsd(double amount) {
    final abs = amount.abs();
    if (abs >= 1000000000) {
      return '\$${(amount / 1000000000).toStringAsFixed(2)}B';
    } else if (abs >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(0)}M';
    } else if (abs >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(0)}K';
    }
    return '\$${amount.toStringAsFixed(0)}';
  }

  static String formatCurrency(double amount, String currency, {bool compact = false}) {
    if (compact && currency == 'USD') {
      return formatCompactUsd(amount);
    }
    if (currency == 'USD') {
      return _currencyFormatUsd.format(amount);
    }
    return _currencyFormatVnd.format(amount);
  }

  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }
}
