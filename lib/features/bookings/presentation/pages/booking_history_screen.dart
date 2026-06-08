import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/mock_data/mock_data.dart';
import '../../data/models/booking_model.dart';
import '../providers/booking_provider.dart';
import '../widgets/trip_route_card.dart';

/// Figma driver "Booking History" (node 350:1212) — top bar with avatar,
/// All / Upcoming / Completed filter chips and route cards.
class BookingHistoryScreen extends ConsumerWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingProvider);
    final bookings = state.filteredBookings;

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: Column(
        children: [
          _TopBar(),
          SizedBox(height: 14.h),
          _Filters(
            active: state.activeFilter,
            onChanged: (f) =>
                ref.read(bookingProvider.notifier).setFilter(f),
          ),
          SizedBox(height: 6.h),
          Expanded(
            child: bookings.isEmpty
                ? Center(
                    child: Text(
                      'No trips',
                      style: TextStyle(
                          fontSize: 15.sp, color: AppColors.labelGrey),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final b = bookings[index];
                      return TripRouteCard(
                        pickup: b.pickupLocation,
                        drop: b.dropLocation,
                        dateTime: DateFormat('dd-MM-yyyy  HH:mm:ss')
                            .format(b.scheduledDateTime),
                        status: b.status,
                        onTap: () => _onTap(context, ref, b),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, WidgetRef ref, BookingModel booking) {
    ref.read(selectedBookingIdProvider.notifier).state = booking.id;
    context.push('/trip-details', extra: booking.id);
  }
}

/// White header bar: centred "Booking History" title + circular "AD" avatar
/// that opens the driver Profile.
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: const Color(0x33000000),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Booking History',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Positioned(
            right: 16.w,
            child: GestureDetector(
              onTap: () => context.push('/profile'),
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: AppColors.avatarGrey,
                child: Text(
                  MockData.driver['initials'] as String,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// All / Upcoming / Completed pill filters (amber active, grey inactive).
class _Filters extends StatelessWidget {
  final String active;
  final ValueChanged<String> onChanged;
  const _Filters({required this.active, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        children: [
          _chip('All', 'all'),
          SizedBox(width: 10.w),
          _chip('Upcoming', 'upcoming'),
          SizedBox(width: 10.w),
          _chip('Completed', 'completed'),
        ],
      ),
    );
  }

  Widget _chip(String label, String value) {
    final selected = active == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.chipInactive,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFF2F2F2),
          ),
        ),
      ),
    );
  }
}
