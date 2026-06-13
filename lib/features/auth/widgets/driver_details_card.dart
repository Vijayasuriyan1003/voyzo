import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class DriverDetailsCard extends StatelessWidget {
  final String driverName;
  final String phoneNumber;
  final String vehicleNumber;
  final String dutyType;
  final VoidCallback onViewProfile;

  const DriverDetailsCard({
    super.key,
    required this.driverName,
    required this.phoneNumber,
    required this.vehicleNumber,
    required this.dutyType,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Column(
        children: [
          Row(
            children: [
              _infoItem('Driver Name', driverName),
              GestureDetector(
                onTap: () {
                  _showDriverProfileDialog(context);
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
              _infoItem('Phone Number', phoneNumber, alignRight: true),
            ],
          ),

          SizedBox(height: 18.h),

          Row(
            children: [
              _infoItem('Vehicle Number', vehicleNumber),
              _infoItem('Duty Type', dutyType, alignRight: true),
            ],
          ),
        ],
      ),
    );
  }

  void _showDriverProfileDialog(BuildContext context) {
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
                  phoneNumber,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: 20.h),

                _driverInfoRow(
                  icon: Icons.directions_car,
                  title: 'Driving Experience',
                  value: '5 Years',
                ),

                _driverInfoRow(
                  icon: Icons.star,
                  title: 'Driver Rating',
                  value: '4.8 / 5',
                ),

                _driverInfoRow(
                  icon: Icons.route,
                  title: 'Trips Completed',
                  value: '250 Trips',
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
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
