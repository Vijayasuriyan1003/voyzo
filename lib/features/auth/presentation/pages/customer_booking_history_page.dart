import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/features/auth/widgets/customer_bottom_navbar.dart';

import '../../../../core/constants/app_colors.dart';

class CustomerBookingHistoryPage extends StatefulWidget {
  const CustomerBookingHistoryPage({super.key});

  @override
  State<CustomerBookingHistoryPage> createState() =>
      _CustomerBookingHistoryPageState();
}

class _CustomerBookingHistoryPageState
    extends State<CustomerBookingHistoryPage> {
  String selectedFilter = 'All';

  final List<Map<String, String>> bookings = [
    {
      'from': 'Jaipur station.....',
      'to': 'Delhi airport',
      'status': 'pending',
      'date': '27-10-2025',
      'time': '09:05:51',
    },
    {
      'from': 'Jaipur station.....',
      'to': 'Delhi airport',
      'status': 'upcoming',
      'date': '27-10-2025',
      'time': '09:05:51',
    },
    {
      'from': 'Jaipur station.....',
      'to': 'Delhi airport',
      'status': 'cancelled',
      'date': '27-10-2025',
      'time': '09:05:51',
    },
    {
      'from': 'Jaipur station.....',
      'to': 'Delhi airport',
      'status': 'completed',
      'date': '27-10-2025',
      'time': '09:05:51',
    },
  ];

  List<Map<String, String>> get filteredBookings {
    if (selectedFilter == 'All') return bookings;

    if (selectedFilter == 'Upcoming') {
      return bookings
          .where((booking) => booking['status'] == 'upcoming')
          .toList();
    }

    return bookings
        .where((booking) => booking['status'] == 'completed')
        .toList();
  }

  Color statusColor(String status) {
    if (status == 'completed') return AppColors.statusCompleted;
    if (status == 'cancelled') return AppColors.statusCancelled;
    if (status == 'upcoming') return AppColors.statusUpcoming;
    return AppColors.statusPending;
  }

  String statusText(String status) {
    if (status == 'completed') return 'Completed';
    if (status == 'cancelled') return 'Cancelled';
    if (status == 'upcoming') return 'Upcoming';
    return 'Pending';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text('Booking History'),
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
            child: CircleAvatar(
              radius: 14.r,
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: Text(
                'RK',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(width: 15.w),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            Container(
              height: 44.h,
              // padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Row(
                children: [
                  filterButton('All'),
                  filterButton('Upcoming'),
                  filterButton('Completed'),
                ],
              ),
            ),

            SizedBox(height: 22.h),

            Expanded(
              child: ListView.builder(
                itemCount: filteredBookings.length,
                itemBuilder: (context, index) {
                  final booking = filteredBookings[index];

                  return bookingCard(context: context, booking: booking);
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const CustomerBottomNavBar(currentIndex: 1),
    );
  }

  Widget filterButton(String title) {
    final bool selected = selectedFilter == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = title;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget bookingCard({
    required BuildContext context,
    required Map<String, String> booking,
  }) {
    final status = booking['status'] ?? 'pending';

    return GestureDetector(
      onTap: () {
        context.push('/customer_booking_details', extra: {'status': status});
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking['from'] ?? '',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    'to',
                    style: TextStyle(fontSize: 11.sp, color: AppColors.primary),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    booking['to'] ?? '',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  statusText(status),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: statusColor(status),
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  booking['date'] ?? '',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),

                Text(
                  booking['time'] ?? '',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
