import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand — Figma uses an amber accent (#F5B220) across buttons, amounts and
  // the active bottom-nav icon.
  static const Color primary = Color(0xFFF5B220);
  static const Color primaryDark = Color(0xFFC98A00);
  static const Color primaryLight = Color(0xFFFFD27A);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  // Figma list/detail screens sit on a light grey canvas (#EEEEEE).
  static const Color greyBackground = Color(0xFFEEEEEE);
  static const Color surfaceContainer = Color(0xFFFDEBDD);
  static const Color surfaceContainerHigh = Color(0xFFF7E5D7);

  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF9FA5C0);
  // Figma label grey for field/section labels.
  static const Color labelGrey = Color(0xFF9FA5C0);
  static const Color textHint = Color(0xFF9FA5C0);

  static const Color outline = Color(0xFF9FA5C0);
  static const Color outlineVariant = Color(0xFFCBD0E0);
  static const Color divider = Color(0xFFE6E6E6);

  static const Color error = Color(0xFFE53935);
  static const Color errorContainer = Color(0xFFFFDAD6);

  // Status palette — Figma driver Booking History uses blue "Upcoming" and
  // green "Completed"; chips toggle amber (active) / grey (inactive).
  static const Color statusUpcoming = Color(0xFF2742A6); // Upcoming (blue)
  static const Color statusCompleted = Color(0xFF01982A); // Completed (green)
  static const Color statusOngoing = Color(0xFF01982A); // On Going (green)
  static const Color statusOpen = Color(0xFF01982A);
  static const Color statusCancelled = Color(0xFFE53935); // red
  static const Color statusDraft = Color(0xFF9FA5C0); // grey
  static const Color statusBooked = Color(0xFFF5B220); // amber
  static const Color statusPending = Color(0xFF2742A6); // blue
  static const Color chipInactive = Color(0xFFC4C4C4); // inactive filter chip
  static const Color avatarGrey = Color(0xFFD9D9D9); // avatar circle

  static const Color success = Color(0xFF2E7D32);
  static const Color successContainer = Color(0xFFE8F5E9);
  static const Color onSuccess = Color(0xFFFFFFFF);

  static const Color upcoming = Color(0xFF1565C0);
  static const Color upcomingContainer = Color(0xFFE3F2FD);

  static const Color active = Color(0xFF2E7D32);
  static const Color activeContainer = Color(0xFFE8F5E9);

  static const Color cardShadow = Color(
    0x26000000,
  ); // 0.15 black, Figma card shadow
}
