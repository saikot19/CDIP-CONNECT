import 'package:intl/intl.dart';

class AppFormatters {
  const AppFormatters._();

  static String _locale = 'en';

  static void setLocale(String locale) {
    _locale = locale == 'bn' ? 'bn' : 'en';
  }

  static String get locale => _locale;
  static bool get isBangla => _locale == 'bn';
  static String get appFontFamily => isBangla ? 'Anek Bangla' : 'Proxima Nova';

  static const Map<int, String> _banglaMonths = {
    1: 'জানুয়ারি',
    2: 'ফেব্রুয়ারি',
    3: 'মার্চ',
    4: 'এপ্রিল',
    5: 'মে',
    6: 'জুন',
    7: 'জুলাই',
    8: 'আগস্ট',
    9: 'সেপ্টেম্বর',
    10: 'অক্টোবর',
    11: 'নভেম্বর',
    12: 'ডিসেম্বর',
  };

  static const Map<String, String> _banglaDigits = {
    '0': '০',
    '1': '১',
    '2': '২',
    '3': '৩',
    '4': '৪',
    '5': '৫',
    '6': '৬',
    '7': '৭',
    '8': '৮',
    '9': '৯',
  };

  static String digits(dynamic value) {
    final text = (value ?? '').toString();
    if (!isBangla || text.isEmpty) return text;
    return text.split('').map((char) => _banglaDigits[char] ?? char).join();
  }

  static String fullName(String? name) {
    final cleaned = (name ?? '').trim().replaceAll(RegExp(r'\s+'), ' ');
    return cleaned.isEmpty ? 'Member' : cleaned;
  }

  static String amount(dynamic value, {String suffix = 'BDT'}) {
    final number = _toDouble(value);
    final formatted = NumberFormat.decimalPattern('en_IN').format(number.round());
    final text = suffix.isEmpty ? formatted : '$formatted $suffix';
    return digits(text);
  }

  static String rawNumber(dynamic value) {
    final number = _toDouble(value);
    final formatted = NumberFormat.decimalPattern('en_IN').format(number.round());
    return digits(formatted);
  }

  static String date(dynamic value) {
    final dt = _parseDate(value);
    if (dt == null) return digits((value ?? 'N/A').toString());
    return digits(DateFormat('dd - MM - yyyy').format(dt));
  }

  static String dateTime(dynamic value) {
    final dt = _parseDate(value);
    if (dt == null) return digits((value ?? '').toString());
    if (isBangla) {
      final hour12 = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final marker = dt.hour < 12 ? 'পূর্বাহ্ণ' : 'অপরাহ্ণ';
      final month = _banglaMonths[dt.month] ?? '';
      return digits('${dt.day} $month ${dt.year}, $hour12:$minute $marker');
    }
    return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
  }

  static String compactDate(dynamic value) {
    final dt = _parseDate(value);
    if (dt == null) return digits((value ?? 'N/A').toString());
    if (isBangla) {
      final month = _banglaMonths[dt.month] ?? '';
      return digits('${dt.day} $month ${dt.year}');
    }
    return DateFormat('dd MMM yyyy').format(dt);
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    final raw = value.toString().trim();
    if (raw.isEmpty || raw == '0000-00-00') return null;
    return DateTime.tryParse(raw) ?? DateTime.tryParse(raw.replaceFirst(' ', 'T'));
  }
}
