import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../providers/booking_provider.dart';
import '../widgets/trip_route_card.dart';

/// Driver "Booking History" — All / Upcoming / Completed filter chips and
/// trip route cards, fetched from the live API.
class BookingHistoryScreen extends ConsumerWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: const VoyzoAppBar(title: 'Booking History', showBack: false),
      body: Column(
        children: [
          SizedBox(height: 14.h),
          _Filters(
            active: state.activeFilter,
            onChanged: (f) =>
                ref.read(bookingProvider.notifier).setFilter(f),
          ),
          SizedBox(height: 6.h),
          Expanded(child: _Body(state: state)),
        ],
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  final BookingState state;
  const _Body({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded,
                  color: AppColors.error, size: 48.sp),
              SizedBox(height: 12.h),
              Text(
                state.error!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () =>
                    ref.read(bookingProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final bookings = state.filteredBookings;
    if (bookings.isEmpty) {
      return Center(
        child: Text(
          'No trips found',
          style: TextStyle(fontSize: 15.sp, color: AppColors.labelGrey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(bookingProvider.notifier).refresh(),
      child: ListView.builder(
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
            onTap: () {
              ref.read(selectedBookingIdProvider.notifier).state = b.id;
              context.push('/trip-details', extra: b.id);
            },
          );
        },
      ),
    );
  }
}

/// All / Upcoming / Completed pill filters.
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
          _chip('All', 'all', active, onChanged),
          SizedBox(width: 10.w),
          _chip('Upcoming', 'upcoming', active, onChanged),
          SizedBox(width: 10.w),
          _chip('Completed', 'completed', active, onChanged),
        ],
      ),
    );
  }

  Widget _chip(
      String label, String value, String active, ValueChanged<String> cb) {
    final selected = active == value;
    return GestureDetector(
      onTap: () => cb(value),
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
