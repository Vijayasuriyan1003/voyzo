import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class CustomerBookingHistoryPage extends StatelessWidget {
  const CustomerBookingHistoryPage({super.key});

  Color statusColor(String status) {
    if (status == 'completed') return Colors.green;
    if (status == 'cancelled') return Colors.red;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final bookings = [
      {'title': 'Jaipur station...', 'status': 'pending'},
      {'title': 'Jaipur station...', 'status': 'cancelled'},
      {'title': 'Jaipur station...', 'status': 'completed'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Booking History'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(18.w),
        child: Column(
          children: [
            Row(
              children: [
                chip('All', true),
                SizedBox(width: 8.w),
                chip('Upcoming', false),
                SizedBox(width: 8.w),
                chip('Completed', false),
              ],
            ),
            SizedBox(height: 18.h),
            Expanded(
              child: ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final status = booking['status']!;

                  return GestureDetector(
                    onTap: () {
                      context.push(
                        '/booking_details',
                        extra: {'status': status},
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 14.h),
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              booking['title']!,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            status,
                            style: TextStyle(
                              color: statusColor(status),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) context.go('/home_page');
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

  Widget chip(String text, bool selected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
