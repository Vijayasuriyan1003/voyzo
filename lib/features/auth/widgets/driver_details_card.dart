import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:voyzo/utils/call_helper.dart';

class DriverDetailsCard extends StatelessWidget {
  final String driver;
  final String phoneNumber;
  final String vehicleNumber;
  final String dutyType;
  final Map<String, dynamic>? driverProfile;

  const DriverDetailsCard({
    super.key,
    required this.driver,
    required this.phoneNumber,
    required this.vehicleNumber,
    required this.dutyType,
    required this.driverProfile,
  });

  // Future<void> makePhoneCall(String phoneNumber) async {
  //   final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

  //   if (await canLaunchUrl(phoneUri)) {
  //     await launchUrl(phoneUri);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _infoItem('Driver Name', driver)),

              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.h),
                    child: GestureDetector(
                      onTap: () {
                        if (driverProfile == null) return;
                        _showDriverProfileDialog(context, driverProfile!);
                      },
                      child: Text(
                        'View Profile',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            CallHelper.makePhoneCall(context, phoneNumber);
                          },
                          borderRadius: BorderRadius.circular(20.r),
                          child: Icon(
                            Icons.call,
                            size: 16.sp,
                            color: AppColors.primary,
                          ),
                        ),

                        SizedBox(width: 4.w),

                        GestureDetector(
                          onTap: () {
                            CallHelper.makePhoneCall(context, phoneNumber);
                          },
                          child: Text(
                            phoneNumber,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 18.h),

          Row(
            children: [
              Expanded(child: _infoItem('Vehicle Number', vehicleNumber)),

              Expanded(
                child: _infoItem('Duty Type', dutyType, alignRight: true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDriverProfileDialog(
    BuildContext context,
    Map<String, dynamic> driverData,
  ) {
    final driverName =
        driverData['driver_name']?.toString() ??
        driverData['full_name']?.toString() ??
        driver;

    final mobile = driverData['cell_number']?.toString() ?? phoneNumber;
    final trips = driverData['custom_no_of_trips']?.toString() ?? '-';
    final ratingValue =
        double.tryParse(driverData['custom_rating']?.toString() ?? '0') ?? 0.0;

    final rating = (ratingValue * 5).toStringAsFixed(1);
    final experience =
        driverData['custom_years_of_driving_experience']?.toString() ?? '-';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Driver Details',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 18.h),

                CircleAvatar(
                  radius: 45.r,
                  backgroundColor: const Color(0xFFD9D9D9),
                  child: Icon(Icons.person, size: 50.sp, color: Colors.white),
                ),

                SizedBox(height: 14.h),

                Text(
                  driverName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),

                SizedBox(height: 6.h),

                Text(
                  mobile,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: 16.h),

                _driverInfoRow(
                  icon: Icons.route,
                  title: 'No. of Trips',
                  value: trips,
                ),

                _driverInfoRow(
                  icon: Icons.star,
                  title: 'Rating',
                  value: '$rating / 5',
                ),

                _driverInfoRow(
                  icon: Icons.drive_eta,
                  title: 'Driving Experience',
                  value: '$experience Years',
                ),

                SizedBox(height: 18.h),

                SizedBox(
                  width: double.infinity,
                  height: 45.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _driverInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            height: 36.h,
            width: 36.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20.sp),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
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

  Widget _infoItem(String title, String value, {bool alignRight = false}) {
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
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
