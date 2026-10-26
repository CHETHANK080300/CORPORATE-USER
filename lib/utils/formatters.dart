import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _currencyFormatVnd = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  static final NumberFormat _currencyFormatUsd = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');

  static String formatCurrency(double amount, String currency, {bool compact = false}) {
    if (currency == 'USD') {
      return _currencyFormatUsd.format(amount);
    }

    if (compact) {
      final absAmount = amount.abs();
      if (absAmount >= 1000000000000) {
        final trillion = amount / 1000000000000;
        return '${trillion.toStringAsFixed(trillion.truncateToDouble() == trillion ? 0 : 2).replaceAll('.', ',')} nghìn tỷ ₫';
      } else if (absAmount >= 1000000000) {
        final billion = amount / 1000000000;
        return '${billion.toStringAsFixed(billion.truncateToDouble() == billion ? 0 : 2).replaceAll('.', ',')} tỷ ₫';
      } else if (absAmount >= 1000000) {
        final million = amount / 1000000;
        return '${million.toStringAsFixed(million.truncateToDouble() == million ? 0 : 2).replaceAll('.', ',')} triệu ₫';
      }
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
