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

  const BookingSuccessPage({super.key, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Page'),
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

                final fullName = user?.fullName ?? '';

                final nameParts = fullName.trim().split(' ');

                String initials = '';

                if (nameParts.length >= 2) {
                  initials = '${nameParts[0][0]}${nameParts[1][0]}'
                      .toUpperCase();
                } else if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
                  initials = nameParts[0][0].toUpperCase();
                }

                return CircleAvatar(
                  radius: 14.r,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
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
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(22.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your trip request has been\nreceived for $dateTime.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 18.h),
              Text(
                'You will receive the driver\ndetails shortly.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 22.h),
              Text(
                'For further enquiry\ncontact on below number.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.sp),
              ),
              SizedBox(height: 6.h),
              Text(
                '+91 234567890',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 28.h),
              AppButton(
                label: 'View Trip Details',
                onTap: () {
                  context.go(
                    '/customer_booking_details',
                    extra: {'status': 'pending'},
                  );
                },
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                  ),
                  onPressed: () {
                    context.push('/cancel_booking');
                  },
                  child: const Text('Cancel Booking'),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const CustomerBottomNavBar(currentIndex: 1),
    );
  }
}
