import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../features/bookings/data/models/booking_model.dart';

class StatusBadge extends StatelessWidget {
  final BookingStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: _textColor,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  String get _label {
    switch (status) {
      case BookingStatus.upcoming:
        return 'Upcoming';
      case BookingStatus.active:
        return 'Active';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get _bgColor {
    switch (status) {
      case BookingStatus.upcoming:
        return AppColors.upcomingContainer;
      case BookingStatus.active:
        return AppColors.activeContainer;
      case BookingStatus.completed:
        return AppColors.successContainer;
      case BookingStatus.cancelled:
        return const Color(0xFFF5F5F5);
    }
  }

  Color get _textColor {
    switch (status) {
      case BookingStatus.upcoming:
        return AppColors.upcoming;
      case BookingStatus.active:
        return AppColors.active;
      case BookingStatus.completed:
        return AppColors.success;
      case BookingStatus.cancelled:
        return const Color(0xFF424242);
    }
  }
}
