import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/features/auth/widgets/customer_bottom_navbar.dart';
import 'package:voyzo/features/auth/widgets/driver_details_card.dart';

import '../../../../core/constants/app_colors.dart';

class CustomerBookingDetailsPage extends StatefulWidget {
  final String status;

  const CustomerBookingDetailsPage({super.key, required this.status});

  @override
  State<CustomerBookingDetailsPage> createState() =>
      _CustomerBookingDetailsPageState();
}

class _CustomerBookingDetailsPageState
    extends State<CustomerBookingDetailsPage> {
  bool isLoading = true;
  var startOtp;
  var endOtp;

  String driverName = '';
  String phoneNumber = '';
  String vehicleNumber = '';
  String dutyType = '';

  @override
  void initState() {
    super.initState();
    fetchBookingDetails();
  }

  Future<void> fetchBookingDetails() async {
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      startOtp = '1234';
      endOtp = '6789';
      driverName = 'Ramesh Jain';
      phoneNumber = '+91 8928262841';
      vehicleNumber = 'RJ19CH7897';
      dutyType = '300 KM Per Day';
      isLoading = false;
    });
  }

  Color get statusColor {
    if (widget.status == 'completed') return AppColors.statusCompleted;
    if (widget.status == 'cancelled') return AppColors.statusCancelled;
    if (widget.status == 'upcoming') return AppColors.statusUpcoming;
    return AppColors.statusPending;
  }

  String get statusText {
    if (widget.status == 'upcoming') return 'Booking Upcoming';
    if (widget.status == 'completed') return 'Booking Completed';
    if (widget.status == 'cancelled') return 'Booking Cancelled';
    return 'Booking Pending';
  }

  @override
  Widget build(BuildContext context) {
    final isPending = widget.status == 'pending';
    final isUpcoming = widget.status == 'upcoming';
    final isCompleted = widget.status == 'completed';

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Booking Details',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
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

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(18.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Guest Details',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 14.h),

                        _card(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  _infoItem('Guest Name', 'Raj Pandey'),
                                  _infoItem(
                                    'Booking ID',
                                    '#456789',
                                    alignRight: true,
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.h),
                              Row(
                                children: [
                                  _infoItem('Vehicle Type', 'SUV'),
                                  _infoItem(
                                    'Est. Amount',
                                    'INR. 12,600',
                                    alignRight: true,
                                    valueColor: AppColors.primary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        if (isUpcoming) ...[
                          SizedBox(height: 14.h),

                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Start OTP',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        '1234',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'End OTP',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        '5678',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        SizedBox(height: 14.h),

                        _card(
                          child: Row(
                            children: [
                              _infoItem('Start', '28-10-2025\n09:11:37'),
                              Expanded(
                                child: Center(
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: AppColors.primary,
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                              _infoItem(
                                'End',
                                '28-10-2025\n19:11:37',
                                alignRight: true,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 14.h),

                        _card(
                          child: Column(
                            children: [
                              _locationItem(
                                iconColor: AppColors.primary,
                                title: 'Pick up Location',
                                address:
                                    'Jaipur International Airport Terminal,\nSanganer Airport Area, Jaipur, Rajasthan,\n302041',
                              ),
                              SizedBox(height: 16.h),
                              _locationItem(
                                iconColor: Colors.grey,
                                title: 'Drop Off Location',
                                address:
                                    'Jaipur International Airport Terminal,\nSanganer Airport Area, Jaipur, Rajasthan,\n302041',
                              ),
                            ],
                          ),
                        ),

                        if (isUpcoming || isCompleted) ...[
                          SizedBox(height: 14.h),

                          _card(
                            child: Row(
                              children: [
                                _infoItem('Trip Type', 'Transfer'),
                                _infoItem(
                                  'Sub Trip Type',
                                  'One Way',
                                  alignRight: true,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h),

                          Text(
                            'Driver Details',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 12.h),

                          DriverDetailsCard(
                            driverName: driverName,
                            phoneNumber: phoneNumber,
                            vehicleNumber: vehicleNumber,
                            dutyType: dutyType,
                            onViewProfile: () {},
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                if (isPending || isUpcoming)
                  Container(
                    color: AppColors.background,
                    padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 18.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: () {
                              context.push('/payment_details');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            child: Text(
                              'Pay Now',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: () {
                              context.push('/cancel_booking');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade400,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            child: Text(
                              'Cancel Booking',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

      bottomNavigationBar: const CustomerBottomNavBar(currentIndex: 1),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: child,
    );
  }

  Widget _infoItem(
    String title,
    String value, {
    bool alignRight = false,
    Color? valueColor,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: alignRight
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppColors.textPrimary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationItem({
    required Color iconColor,
    required String title,
    required String address,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on_outlined, color: iconColor, size: 22.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                address,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
