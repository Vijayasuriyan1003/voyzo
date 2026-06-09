import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
        automaticallyImplyLeading: false,
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
                  context.push(
                    '/booking_details',
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
                    context.go('/home_page');
                  },
                  child: const Text('Cancel Booking'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) context.go('/home_page');
          if (index == 1) context.go('/customer_booking_history');
          if (index == 2) context.go('/profile');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
