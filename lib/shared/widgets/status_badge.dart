import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../features/bookings/data/models/booking_model.dart';

/// Figma renders trip/booking status as a bold colored text label
/// (e.g. "On Going" green, "Completed" amber) rather than a filled pill.
class StatusBadge extends StatelessWidget {
  final BookingStatus status;

  const StatusBadge({super.key, required this.status});

  static String labelOf(BookingStatus status) {
    switch (status) {
      case BookingStatus.active:
        return 'On Going';
      case BookingStatus.upcoming:
        return 'Upcoming';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.open:
        return 'Open';
      case BookingStatus.booked:
        return 'Booked';
      case BookingStatus.draft:
        return 'Draft';
      case BookingStatus.pending:
        return 'Pending';
    }
  }

  static Color colorOf(BookingStatus status) {
    switch (status) {
      case BookingStatus.active:
        return AppColors.statusOngoing;
      case BookingStatus.upcoming:
        return AppColors.upcoming;
      case BookingStatus.completed:
        return AppColors.statusCompleted;
      case BookingStatus.cancelled:
        return AppColors.statusCancelled;
      case BookingStatus.open:
        return AppColors.statusOpen;
      case BookingStatus.booked:
        return AppColors.statusBooked;
      case BookingStatus.draft:
        return AppColors.statusDraft;
      case BookingStatus.pending:
        return AppColors.statusPending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      labelOf(status),
      style: TextStyle(
        color: colorOf(status),
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
