import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/features/auth/data/auth_api.dart';
import 'package:voyzo/features/auth/presentation/provider/user_provider.dart';
import 'package:voyzo/features/auth/widgets/customer_bottom_navbar.dart';

import '../../../../core/constants/app_colors.dart';

class CustomerBookingHistoryPage extends ConsumerStatefulWidget {
  const CustomerBookingHistoryPage({super.key});

  @override
  ConsumerState<CustomerBookingHistoryPage> createState() =>
      _CustomerBookingHistoryPageState();
}

class _CustomerBookingHistoryPageState
    extends ConsumerState<CustomerBookingHistoryPage> {
  String selectedFilter = 'All';
  bool isLoading = true;

  final authApi = AuthApi();
  List<Map<String, dynamic>> bookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final user = ref.read(userProvider);

    if (user == null || user.customerId.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final result = await authApi.getBookingHistory(customerId: user.customerId);

    if (!mounted) return;

    setState(() {
      bookings = result;
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> get filteredBookings {
    if (selectedFilter == 'All') return bookings;

    if (selectedFilter == 'Upcoming') {
      return bookings
          .where((booking) => booking['ui_status'] == 'upcoming')
          .toList();
    }
    if (selectedFilter == 'Cancelled') {
      return bookings
          .where((booking) => booking['ui_status'] == 'cancelled')
          .toList();
    }

    return bookings
        .where((booking) => booking['ui_status'] == 'completed')
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

  String getDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '';
    return dateTime.split(' ').first;
  }

  String getTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '';
    final parts = dateTime.split(' ');
    return parts.length > 1 ? parts[1] : '';
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
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Row(
                children: [
                  filterButton('All'),
                  filterButton('Upcoming'),
                  filterButton('Completed'),
                  filterButton('Cancelled'),
                ],
              ),
            ),
            SizedBox(height: 22.h),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredBookings.isEmpty
                  ? const Center(child: Text('No bookings found'))
                  : RefreshIndicator(
                      onRefresh: fetchBookings,
                      child: ListView.builder(
                        itemCount: filteredBookings.length,
                        itemBuilder: (context, index) {
                          final booking = filteredBookings[index];
                          return bookingCard(
                            context: context,
                            booking: booking,
                          );
                        },
                      ),
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
    required Map<String, dynamic> booking,
  }) {
    final status = booking['ui_status'] ?? 'pending';
    final from = booking['pick_up_location'] ?? '';
    final to = booking['drop_off_location'] ?? '';
    final fromDateTime = booking['from_date_time']?.toString() ?? '';
    print(
      'DOCTYPE: ${booking['doctype']} | ERP STATUS: ${booking['status']} | UI STATUS: ${booking['ui_status']}',
    );

    return GestureDetector(
      onTap: () {
        final doctype = booking['doctype']?.toString() ?? '';
        final id = booking['name']?.toString() ?? '';
        final status = booking['ui_status']?.toString() ?? 'pending';

        if (id.isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Booking ID not found')));
          return;
        }

        context.push(
          '/customer_booking_details',
          extra: {'doctype': doctype, 'id': id, 'status': status},
        );
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
                    from,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'to',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.labelGrey,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    to,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
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
                  getDate(fromDateTime),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  getTime(fromDateTime),
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
