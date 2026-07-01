import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/features/auth/presentation/provider/user_provider.dart';
import 'package:voyzo/features/auth/widgets/customer_bottom_navbar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';

class BookingSuccessPage extends StatelessWidget {
  final String dateTime;
  final String bookingRequestId;

  const BookingSuccessPage({
    super.key,
    required this.dateTime,
    required this.bookingRequestId,
  });

  String _getInitials(String fullName) {
    final nameParts = fullName.trim().split(' ');

    if (nameParts.length >= 2 &&
        nameParts[0].isNotEmpty &&
        nameParts[1].isNotEmpty) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Booking Page',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: () {
              context.go('/customer_profile');
            },
            child: Consumer(
              builder: (context, ref, child) {
                final user = ref.watch(userProvider);
                final initials = _getInitials(user?.fullName ?? '');

                return CircleAvatar(
                  radius: 16.r,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 15.w),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 34.h),

                      Container(
                        width: 96.w,
                        height: 96.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.12),
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                          size: 58.sp,
                        ),
                      ),

                      SizedBox(height: 28.h),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 28.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Your trip request has been',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 21.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),

                            SizedBox(height: 6.h),

                            Text(
                              'received for $dateTime.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 21.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),

                            SizedBox(height: 20.h),

                            Container(
                              width: 80.w,
                              height: 1,
                              color: Colors.grey.shade300,
                            ),

                            SizedBox(height: 20.h),

                            Text(
                              'You will receive the driver\ndetails shortly.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.sp,
                                height: 1.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),

                            SizedBox(height: 24.h),

                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(18.r),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'For further enquiry',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'contact on below number.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    '+91 234567890',
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 28.h),
                    ],
                  ),
                ),
              ),

              AppButton(
                label: 'View Trip Details',
                onTap: () {
                  context.go(
                    '/customer_booking_details',
                    extra: {
                      'doctype': 'Booking Request',
                      'id': bookingRequestId,
                      'status': 'pending',
                    },
                  );
                },
              ),

              SizedBox(height: 12.h),

              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.grey.shade700,
                    elevation: 0,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  onPressed: () {
                    context.push('/cancel_booking');
                  },
                  child: Text(
                    'Cancel Booking',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomerBottomNavBar(currentIndex: 1),
    );
  }
}
