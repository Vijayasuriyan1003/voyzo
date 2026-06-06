import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../routes/app_router.dart';

class InfoPage2 extends StatelessWidget {
  const InfoPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Column(
            children: [
              SizedBox(height: 25.h),

              Container(
                height: 250.h,
                width: double.infinity,
                color: AppColors.textSecondary,
              ),

              SizedBox(height: 25.h),

              Text(
                "Book Fast,\nTravel Smart",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: 20.h),

              Text(
                "Choose your car, select your time\nand enjoy a smooth booking\nexperience with trusted service\nanytime you need.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),

              SizedBox(height: 20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 4.r,
                    backgroundColor: AppColors.textSecondary,
                  ),
                  SizedBox(width: 8.w),
                  CircleAvatar(radius: 4.r, backgroundColor: AppColors.primary),
                ],
              ),

              const Spacer(),

              CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.surface,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    context.go('/customer_login');
                  },
                ),
              ),

              SizedBox(height: 25.h),
            ],
          ),
        ),
      ),
    );
  }
}
