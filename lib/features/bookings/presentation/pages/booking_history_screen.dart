import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../../data/models/booking_model.dart';
import '../providers/booking_provider.dart';
import '../widgets/trip_route_card.dart';

/// Figma driver "Booking History" (node 350:1212) — top bar with avatar,
/// All / Upcoming / Completed filter chips and route cards.
class BookingHistoryScreen extends ConsumerStatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  ConsumerState<BookingHistoryScreen> createState() =>
      _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends ConsumerState<BookingHistoryScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(bookingProvider.notifier).fetchDriverBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingProvider);
    final bookings = state.filteredBookings;

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: const VoyzoAppBar(title: 'Booking History', showBack: false),
      body: Column(
        children: [
          SizedBox(height: 14.h),
          _Filters(
            active: state.activeFilter,
            onChanged: (f) => ref.read(bookingProvider.notifier).setFilter(f),
          ),
          SizedBox(height: 6.h),
          Expanded(
            child: bookings.isEmpty
                ? Center(
                    child: Text(
                      'No trips',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: AppColors.labelGrey,
                      ),
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
                        dateTime: DateFormat(
                          'dd-MM-yyyy  HH:mm:ss',
                        ).format(b.scheduledDateTime),
                        status: b.status,
                        onTap: () => _onTap(b),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _onTap(BookingModel booking) {
    ref.read(selectedBookingProvider.notifier).state = booking;
    // ref.read(selectedBookingIdProvider.notifier).state = booking.id;

    context.push('/trip-details');
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
