import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/driver_bottom_nav.dart';
import '../providers/booking_provider.dart';
import '../widgets/trip_list_card.dart';

/// Booking List — Open / Completed / Cancelled / Draft, fetched from the API.
class BookingListScreen extends ConsumerWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingListProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: _ListAppBar(
        title: 'Booking Lists',
        onAdd: () => context.push('/add-booking-request'),
        onRequests: () => context.push('/booking-request'),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded,
                    color: AppColors.error, size: 48.sp),
                SizedBox(height: 12.h),
                Text(e.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.sp, color: AppColors.textSecondary)),
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () =>
                      ref.read(bookingListProvider.notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (items) => items.isEmpty
            ? Center(
                child: Text('No bookings found',
                    style: TextStyle(
                        fontSize: 15.sp, color: AppColors.labelGrey)),
              )
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(bookingListProvider.notifier).refresh(),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final b = items[i];
                    return TripListCard(
                      code: b.bookingCode,
                      date: DateFormat('dd-MM-yyyy')
                          .format(b.scheduledDateTime),
                      time: DateFormat('HH:mm:ss')
                          .format(b.scheduledDateTime),
                      status: b.status,
                      onTap: () =>
                          context.push('/booking-details', extra: b.id),
                    );
                  },
                ),
              ),
      ),
      bottomNavigationBar: const DriverBottomNav(currentIndex: 1),
    );
  }
}

class _ListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onAdd;
  final VoidCallback? onRequests;
  const _ListAppBar(
      {required this.title, required this.onAdd, this.onRequests});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0.5,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        if (onRequests != null)
          IconButton(
            onPressed: onRequests,
            icon: Icon(Icons.fact_check_outlined,
                color: AppColors.textPrimary, size: 22.sp),
          ),
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add_rounded, color: Colors.white, size: 24.sp),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
