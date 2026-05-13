import 'package:intl/intl.dart';

class DisplayFormatters {
  const DisplayFormatters._();

  static String firstName(String? value, {String fallback = ''}) {
    final clean = (value ?? '').trim().replaceAll(RegExp(r'\\s+'), ' ');
    if (clean.isEmpty) return fallback;
    return clean.split(' ').first;
  }

  static String formatLastUpdated(String? value, {String fallback = 'Sync pending'}) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) return fallback;

    final normalized = raw.contains('T') ? raw : raw.replaceFirst(' ', 'T');
    final dateTime = DateTime.tryParse(normalized);
    if (dateTime == null) return raw;

    return DateFormat('d MMM y, h:mm a').format(dateTime);
  }
}
