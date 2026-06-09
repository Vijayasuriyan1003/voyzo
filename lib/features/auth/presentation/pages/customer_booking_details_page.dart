import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class CustomerBookingDetailsPage extends StatelessWidget {
  final String status;

  const CustomerBookingDetailsPage({super.key, required this.status});

  Color get statusColor {
    if (status == 'completed') return Colors.green;
    if (status == 'cancelled') return Colors.red;
    return AppColors.primary;
  }

  String get title {
    if (status == 'completed') return 'Booking Completed';
    if (status == 'cancelled') return 'Booking Cancelled';
    return 'Booking Pending';
  }

  @override
  Widget build(BuildContext context) {
    final showDriver = status == 'completed' || status == 'pending';

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: statusColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 14.h),
            card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  row('Guest Name', 'Raj Pandey'),
                  row('Booking ID', '#458216'),
                  row('Vehicle Type', 'SUV'),
                  row('Amount Paid', 'Rs. 5000'),
                  row('Start Date', '28-10-2025'),
                  row('End Date', '29-10-2025'),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            card(
              child: Column(
                children: [
                  locationRow(
                    'Pickup Location',
                    'Jaipur International Airport Terminal,\nAirport Road, Jaipur, Rajasthan',
                  ),
                  SizedBox(height: 12.h),
                  locationRow(
                    'Drop Location',
                    'Jaipur International Airport Terminal,\nAirport Road, Jaipur, Rajasthan',
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  row('Trip Type', 'Transfer'),
                  row('Sub Trip Type', 'One way'),
                ],
              ),
            ),
            if (showDriver) ...[
              SizedBox(height: 14.h),
              Text(
                'Driver Details',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    row('Driver Name', 'Suresh Jain'),
                    row('Mobile Number', '+91 9876543210'),
                    row('Vehicle Number', 'RJ 14 AB 1234'),
                    row('Car Type', 'SUV'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
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

  Widget card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }

  Widget row(String left, String right) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          Flexible(
            child: Text(
              right,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget locationRow(String title, String address) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on, color: AppColors.primary, size: 22.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(address, style: TextStyle(fontSize: 11.sp)),
            ],
          ),
        ),
      ],
    );
  }
}
