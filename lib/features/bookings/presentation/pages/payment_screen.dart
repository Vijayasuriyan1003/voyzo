import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../providers/booking_provider.dart';
import '../widgets/detail_widgets.dart';

/// Figma "Payment" — amount payable and the fare break-up with Pay Now.
class PaymentScreen extends ConsumerWidget {
  final String bookingId;
  const PaymentScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking =
        ref.watch(bookingProvider.notifier).getBookingById(bookingId);
    if (booking == null) {
      return const Scaffold(body: Center(child: Text('Booking not found')));
    }

    final rows = <MapEntry<String, double>>[
      MapEntry('Ride', booking.tripAmount),
      for (final e in booking.expenses)
        MapEntry(e.notes?.isNotEmpty == true ? e.notes! : e.type, e.amount),
      if (booking.gst > 0) MapEntry('GST', booking.gst),
    ];

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: const VoyzoAppBar(title: 'Payment'),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WhiteCard(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount Payable: ${booking.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Payment Details',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Here is the amount breakup of your ride.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ...rows.map((r) => _row(r.key, r.value)),
                  Divider(color: AppColors.textPrimary, height: 24.h),
                  _row('Total', booking.totalAmount, bold: true),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            AppButton(
              label: 'Pay Now',
              onTap: () => context.pushReplacement(
                '/payment-received',
                extra: booking.id,
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, double amount, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.textPrimary,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            'INR. ${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.textPrimary,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
