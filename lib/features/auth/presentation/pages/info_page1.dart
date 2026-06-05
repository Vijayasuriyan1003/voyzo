import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/core/constants/app_colors.dart';

class InfoPage1 extends StatelessWidget {
  const InfoPage1({super.key});

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
                color: Colors.grey.shade300,
              ),

              SizedBox(height: 25.h),

              Text(
                'Book Fast,\nTravel Smart',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: 20.h),

              Text(
                'hoose your car, select your time\nand enjoy a smooth booking\nexperience with trusted service\nanytime you need.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: AppColors.textSecondary,
                  height: 1.4.h,
                ),
              ),

              SizedBox(height: 20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 4.r, backgroundColor: Colors.orange),
                  SizedBox(width: 8.w),
                  CircleAvatar(radius: 4.r, backgroundColor: Colors.grey),
                ],
              ),

              const Spacer(),

              CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.background,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.black),
                  onPressed: () {
                    context.go('/info_page2');
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
