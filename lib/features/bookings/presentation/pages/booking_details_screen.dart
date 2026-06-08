import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../providers/booking_provider.dart';
import '../widgets/detail_widgets.dart';

/// Figma "Booking Details" — guest + schedule + route with Pay Now / Cancel.
class BookingDetailsScreen extends ConsumerWidget {
  final String bookingId;
  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking =
        ref.watch(bookingProvider.notifier).getBookingById(bookingId);
    if (booking == null) {
      return const Scaffold(body: Center(child: Text('Booking not found')));
    }

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: const VoyzoAppBar(title: 'Booking Details'),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DetailHeading('Guest Details'),
            SizedBox(height: 10.h),
            WhiteCard(
              child: Column(
                children: [
                  TwoColRow(
                    left: LabelledValue(
                      label: 'Guest Name',
                      value: booking.passengerName,
                    ),
                    right: LabelledValue(
                      label: 'Booking ID',
                      value: booking.bookingCode,
                      align: CrossAxisAlignment.end,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  TwoColRow(
                    left: LabelledValue(
                      label: 'Vehicle Type',
                      value: booking.vehicleInfo,
                    ),
                    right: LabelledValue(
                      label: 'Est. Amount',
                      value: 'INR. ${booking.tripAmount.toStringAsFixed(0)}',
                      valueColor: AppColors.primary,
                      align: CrossAxisAlignment.end,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            // Schedule
            WhiteCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: LabelledValue(
                      label: 'Start',
                      value: DateFormat('dd-MM-yyyy\nHH:mm:ss')
                          .format(booking.scheduledDateTime),
                    ),
                  ),
                  Icon(Icons.calendar_month_rounded,
                      color: AppColors.primary, size: 26.sp),
                  Expanded(
                    child: LabelledValue(
                      label: 'End',
                      value: DateFormat('dd-MM-yyyy\nHH:mm:ss').format(
                          booking.endDateTime ?? booking.scheduledDateTime),
                      align: CrossAxisAlignment.end,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            WhiteCard(
              child: LocationTimeline(
                pickup: booking.pickupLocation,
                drop: booking.dropLocation,
              ),
            ),
            SizedBox(height: 28.h),
            AppButton(
              label: 'Pay Now',
              onTap: () => context.push('/payment', extra: booking.id),
              icon: Icons.payment_rounded,
            ),
            SizedBox(height: 12.h),
            AppButton(
              label: 'Cancel Booking',
              onTap: () => context.pop(),
              variant: AppButtonVariant.secondary,
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
