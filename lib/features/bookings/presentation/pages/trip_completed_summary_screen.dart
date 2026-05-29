import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../providers/booking_provider.dart';
import '../widgets/trip_widgets.dart';

class TripCompletedSummaryScreen extends ConsumerWidget {
  final String bookingId;
  const TripCompletedSummaryScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider.notifier).getBookingById(bookingId);

    if (booking == null) {
      return const Scaffold(body: Center(child: Text('Booking not found')));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VoyzoAppBar(title: 'Trip Summary'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
                ),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_circle_rounded,
                        color: Colors.white, size: 36.sp),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Trip Completed!',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    booking.bookingCode,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          label: 'Distance',
                          value:
                              '${booking.distanceTravelled?.toStringAsFixed(0) ?? '--'} km',
                        ),
                        _VerticalDivider(),
                        _StatItem(
                          label: 'Duration',
                          value: _duration(booking.startTime, booking.endTime),
                        ),
                        _VerticalDivider(),
                        _StatItem(
                          label: 'Amount',
                          value:
                              '₹ ${booking.totalAmount.toStringAsFixed(0)}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Passenger info
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                      icon: Icons.person_rounded, label: 'Passenger Details'),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22.r,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          booking.passengerName.substring(0, 2).toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.passengerName,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            booking.passengerPhone,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      _PaymentBadge(
                          isPaid: booking.paymentStatus.name == 'paid'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Route
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                      icon: Icons.route_rounded, label: 'Trip Route'),
                  SizedBox(height: 14.h),
                  RouteTimeline(
                      pickup: booking.pickupLocation,
                      drop: booking.dropLocation),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Trip details
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                      icon: Icons.info_outline_rounded, label: 'Trip Details'),
                  SizedBox(height: 12.h),
                  InfoRow(
                    label: 'Start KM',
                    value: '${booking.startKm?.toStringAsFixed(0) ?? '--'} km',
                  ),
                  InfoRow(
                    label: 'End KM',
                    value: '${booking.endKm?.toStringAsFixed(0) ?? '--'} km',
                  ),
                  InfoRow(
                    label: 'Distance',
                    value:
                        '${booking.distanceTravelled?.toStringAsFixed(0) ?? '--'} km',
                  ),
                  if (booking.startTime != null)
                    InfoRow(
                      label: 'Start Time',
                      value: DateFormat('dd MMM, hh:mm a')
                          .format(booking.startTime!),
                    ),
                  if (booking.endTime != null)
                    InfoRow(
                      label: 'End Time',
                      value: DateFormat('dd MMM, hh:mm a')
                          .format(booking.endTime!),
                    ),
                  InfoRow(label: 'Vehicle', value: booking.vehicleInfo),
                  InfoRow(
                      label: 'Vehicle No.', value: booking.vehicleNumber),
                  if (booking.driverNotes != null &&
                      booking.driverNotes!.isNotEmpty)
                    InfoRow(label: 'Notes', value: booking.driverNotes!),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Payment summary
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                      icon: Icons.receipt_long_rounded,
                      label: 'Payment Summary'),
                  SizedBox(height: 12.h),
                  _AmountRow(
                      label: 'Base Fare',
                      amount: booking.tripAmount,
                      bold: false),
                  ...booking.expenses.map((e) => _AmountRow(
                        label: e.type,
                        amount: e.amount,
                        bold: false,
                        isExpense: true,
                      )),
                  if (booking.expenses.isNotEmpty) ...[
                    Divider(color: AppColors.divider),
                    _AmountRow(
                        label: 'Total Extra',
                        amount: booking.totalExpenses,
                        bold: false,
                        isExpense: true),
                  ],
                  Divider(
                      color: AppColors.divider, thickness: 1.5),
                  _AmountRow(
                      label: 'Total Amount',
                      amount: booking.totalAmount,
                      bold: true),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Action buttons
            AppButton(
              label: 'Download Summary',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Summary downloaded!'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r)),
                ),
              ),
              icon: Icons.download_rounded,
            ),
            SizedBox(height: 10.h),
            AppButton(
              label: 'Share Summary',
              onTap: () {},
              variant: AppButtonVariant.outline,
              icon: Icons.share_rounded,
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  String _duration(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '--';
    final d = end.difference(start);
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes % 60}m';
    return '${d.inMinutes}m';
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 2.h),
        Text(label,
            style: TextStyle(fontSize: 11.sp, color: Colors.white60)),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1, height: 32.h, color: Colors.white.withOpacity(0.3));
  }
}

class _PaymentBadge extends StatelessWidget {
  final bool isPaid;
  const _PaymentBadge({required this.isPaid});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isPaid ? AppColors.successContainer : AppColors.errorContainer,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        isPaid ? 'Paid' : 'Pending',
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: isPaid ? AppColors.success : AppColors.error,
        ),
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool bold;
  final bool isExpense;
  const _AmountRow(
      {required this.label,
      required this.amount,
      required this.bold,
      this.isExpense = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isExpense)
                Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: Icon(Icons.add_circle_outline,
                      size: 12.sp, color: AppColors.textHint),
                ),
              Text(
                label,
                style: TextStyle(
                  fontSize: bold ? 14.sp : 13.sp,
                  color: AppColors.textSecondary,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
          Text(
            '₹ ${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: bold ? 16.sp : 13.sp,
              color: bold ? AppColors.primary : AppColors.textPrimary,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
