import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/features/auth/data/auth_api.dart';
import 'package:voyzo/features/auth/presentation/provider/user_provider.dart';
import 'package:voyzo/features/auth/widgets/customer_bottom_navbar.dart';
import 'package:voyzo/features/auth/widgets/driver_details_card.dart';

import '../../../../core/constants/app_colors.dart';

class CustomerBookingDetailsPage extends StatefulWidget {
  const CustomerBookingDetailsPage({super.key});

  @override
  State<CustomerBookingDetailsPage> createState() =>
      _CustomerBookingDetailsPageState();
}

class _CustomerBookingDetailsPageState
    extends State<CustomerBookingDetailsPage> {
  late Map<String, dynamic> booking;
  Map<String, dynamic>? driverProfile;
  bool driverProfileFetched = false;

  Future<void> fetchDriverProfile() async {
    if (driverProfileFetched) return;

    final driverId = value('driver');

    if (driverId.isEmpty) return;

    driverProfileFetched = true;

    final result = await AuthApi().getDriverProfile(driverId: driverId);

    if (!mounted) return;

    setState(() {
      driverProfile = result;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final extra = GoRouterState.of(context).extra;

    if (extra is Map<String, dynamic>) {
      booking = extra;
      fetchDriverProfile();
    } else {
      booking = {};
    }
  }

  String get status => booking['ui_status'] ?? 'pending';

  bool get isPending => status == 'pending';
  bool get isUpcoming => status == 'upcoming';
  bool get isCompleted => status == 'completed';

  Color get statusColor {
    if (status == 'completed') return AppColors.statusCompleted;
    if (status == 'cancelled') return AppColors.statusCancelled;
    if (status == 'upcoming') return AppColors.statusUpcoming;
    return AppColors.statusPending;
  }

  String get statusText {
    if (status == 'upcoming') return 'Trip Upcoming';
    if (status == 'completed') return 'Trip Completed';
    if (status == 'cancelled') return 'Trip Cancelled';
    return 'Booking Pending';
  }

  String value(String key) {
    final data = booking[key];
    if (data == null) return '';
    return data.toString();
  }

  String formatDateTime(String key) {
    final data = value(key);
    if (data.isEmpty) return '-';

    final parts = data.split(' ');
    if (parts.length >= 2) {
      return '${parts[0]}\n${parts[1]}';
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final guestName = value('guest_name');
    final bookingId = value('name');
    final vehicleType = value('vehicle_type');
    final estimatedAmount = booking['amount']?.toString() ?? '-';

    final pickupLocation = value('pick_up_location');
    final dropLocation = value('drop_off_location');
    final tripType = value('trip_type');
    final subTripType = value('sub_trip_type');

    final startOtp = value('start_otp').isNotEmpty ? value('start_otp') : '-';
    final endOtp = value('end_otp').isNotEmpty ? value('end_otp') : '-';

    final driver = value('driver').isNotEmpty ? value('driver') : '-';
    final phoneNumber = value('driver_phone_number').isNotEmpty
        ? value('driver_phone_number')
        : '-';
    final vehicleNumber = value('vehicle_number').isNotEmpty
        ? value('vehicle_number')
        : '-';
    final dutyType = value('duty_type').isNotEmpty ? value('duty_type') : '-';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
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
      body: Column(
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
                            _infoItem('Guest Name', guestName),
                            _infoItem(
                              'Booking ID',
                              bookingId,
                              alignRight: true,
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          children: [
                            _infoItem('Vehicle Type', vehicleType),

                            if (!isPending) ...[
                              _infoItem(
                                'Est. Amount',
                                '₹ $estimatedAmount',
                                alignRight: true,
                                // valueColor: AppColors.,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isUpcoming) ...[
                    SizedBox(height: 14.h),
                    _card(
                      child: Row(
                        children: [
                          _infoItem('Start OTP', startOtp),
                          _infoItem('End OTP', endOtp, alignRight: true),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 14.h),
                  _card(
                    child: Row(
                      children: [
                        _infoItem('Start', formatDateTime('from_date_time')),
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
                          formatDateTime('to_date_time'),
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
                          address: pickupLocation,
                        ),
                        SizedBox(height: 16.h),
                        _locationItem(
                          iconColor: Colors.grey,
                          title: 'Drop Off Location',
                          address: dropLocation,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  _card(
                    child: Row(
                      children: [
                        _infoItem('Trip Type', tripType),
                        _infoItem(
                          'Sub Trip Type',
                          subTripType,
                          alignRight: true,
                        ),
                      ],
                    ),
                  ),
                  if (isUpcoming || isCompleted) ...[
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
                      driver: driver,
                      phoneNumber: phoneNumber,
                      vehicleNumber: vehicleNumber,
                      dutyType: dutyType,
                      driverProfile: driverProfile,
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
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
            value.isEmpty ? '-' : value,
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
                address.isEmpty ? '-' : address,
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
