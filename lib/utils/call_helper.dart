import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallHelper {
  static Future<void> makePhoneCall(
    BuildContext context,
    String phoneNumber,
  ) async {
    final cleanedNumber = phoneNumber.replaceAll(' ', '');

    final Uri uri = Uri(scheme: 'tel', path: cleanedNumber);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open dialer')));
    }
  }
}
