import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../providers/booking_provider.dart';
import '../widgets/detail_widgets.dart';

/// Figma "Payment Received" — trip charges breakdown + QR with a success
/// confirmation card.
class PaymentReceivedScreen extends ConsumerWidget {
  final String bookingId;
  const PaymentReceivedScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking =
        ref.watch(bookingProvider.notifier).getBookingById(bookingId);
    final total = booking?.totalAmount ?? 0;

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: const VoyzoAppBar(title: 'Payment', showBack: false),
      body: Stack(
        children: [
          // Behind: trip charges breakdown + QR
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
            child: Column(
              children: [
                Text(
                  'Trip Charges breakdown',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                WhiteCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ride charges',
                          style: TextStyle(
                              fontSize: 15.sp, color: AppColors.labelGrey)),
                      Text('₹ ${(booking?.tripAmount ?? 0).toStringAsFixed(0)}',
                          style: TextStyle(
                              fontSize: 15.sp, color: AppColors.textPrimary)),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Icon(Icons.qr_code_2_rounded,
                    size: 160.sp, color: AppColors.textPrimary),
              ],
            ),
          ),
          // Scrim
          Container(color: Colors.black.withOpacity(0.45)),
          // Success card
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 32.w),
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => context.go('/trip-list'),
                      child: Icon(Icons.close_rounded,
                          size: 22.sp, color: AppColors.textSecondary),
                    ),
                  ),
                  Container(
                    width: 96.w,
                    height: 96.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFCDEBD0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_rounded,
                        size: 56.sp, color: const Color(0xFF2E7D32)),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Payment Received',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '₹ ${total.toStringAsFixed(0)} collected',
                    style: TextStyle(
                        fontSize: 14.sp, color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 28.h),
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () => context.go('/trip-list'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
