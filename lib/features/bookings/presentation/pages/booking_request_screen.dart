import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../providers/booking_provider.dart';
import '../widgets/trip_list_card.dart';

/// Booking Requests — Booked / Cancelled / Draft, fetched from the API.
class BookingRequestScreen extends ConsumerWidget {
  const BookingRequestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingRequestProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: VoyzoAppBar(
        title: 'Booking Request',
        showProfile: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () => context.push('/add-booking-request'),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(Icons.add_rounded, color: Colors.white, size: 24.sp),
              ),
            ),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorBody(
          message: e.toString(),
          onRetry: () =>
              ref.read(bookingRequestProvider.notifier).refresh(),
        ),
        data: (items) => items.isEmpty
            ? Center(
                child: Text('No booking requests',
                    style: TextStyle(
                        fontSize: 15.sp, color: AppColors.labelGrey)),
              )
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(bookingRequestProvider.notifier).refresh(),
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
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                color: AppColors.error, size: 48.sp),
            SizedBox(height: 12.h),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14.sp, color: AppColors.textSecondary)),
            SizedBox(height: 16.h),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
