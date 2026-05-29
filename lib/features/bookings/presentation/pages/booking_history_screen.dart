import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../../data/models/booking_model.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_card.dart';

class BookingHistoryScreen extends ConsumerWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookings = bookingState.filteredBookings;
    final activeFilter = bookingState.activeFilter;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VoyzoAppBar(
        title: 'Booking History',
        showBack: false,
        showProfile: true,
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            color: AppColors.surface,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isActive: activeFilter == 'all',
                  onTap: () =>
                      ref.read(bookingProvider.notifier).setFilter('all'),
                ),
                SizedBox(width: 8.w),
                _FilterChip(
                  label: 'Upcoming',
                  isActive: activeFilter == 'upcoming',
                  onTap: () =>
                      ref.read(bookingProvider.notifier).setFilter('upcoming'),
                ),
                SizedBox(width: 8.w),
                _FilterChip(
                  label: 'Completed',
                  isActive: activeFilter == 'completed',
                  onTap: () =>
                      ref.read(bookingProvider.notifier).setFilter('completed'),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.divider),

          // Summary counts
          Container(
            color: AppColors.surface,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              children: [
                Text(
                  '${bookings.length} trip${bookings.length != 1 ? 's' : ''} found',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: bookings.isEmpty
                ? _EmptyState(filter: activeFilter)
                : ListView.builder(
                    padding:
                        EdgeInsets.only(top: 8.h, bottom: 24.h),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return BookingCard(
                        booking: booking,
                        onTap: () => _onBookingTap(context, ref, booking),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _onBookingTap(
      BuildContext context, WidgetRef ref, BookingModel booking) {
    ref.read(selectedBookingIdProvider.notifier).state = booking.id;
    if (booking.status == BookingStatus.completed) {
      context.push('/trip-completed', extra: booking.id);
    } else if (booking.status == BookingStatus.active) {
      context.push('/active-trip', extra: booking.id);
    } else {
      context.push('/trip-details', extra: booking.id);
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String filter;
  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car_outlined,
              size: 64.sp, color: AppColors.outlineVariant),
          SizedBox(height: 16.h),
          Text(
            filter == 'completed'
                ? 'No completed trips yet'
                : filter == 'upcoming'
                    ? 'No upcoming trips'
                    : 'No bookings found',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your trips will appear here',
            style: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
