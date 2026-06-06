import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/core/constants/app_colors.dart';
import 'package:voyzo/shared/widgets/app_button.dart';

class ForgotOtpPage extends StatelessWidget {
  const ForgotOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: EdgeInsets.all(18.w),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        context.pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 18.sp,
                        color: Colors.black,
                      ),
                      label: Text(
                        "Back",
                        style: TextStyle(color: Colors.black, fontSize: 18.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),

                  Image.asset('assets/images/VOYZO_logo.png', width: 250),

                  SizedBox(height: 25.h),

                  Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Text(
                    "Code has been send to\n Mobile Number ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textHint,
                      fontSize: 16.sp,
                    ),
                  ),

                  SizedBox(height: 35.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 42.w,
                        height: 42.h,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        child: TextField(
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.zero,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: 30.h),

                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/set_new_password');
                      },
                      child: Text("Submit"),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  Column(
                    children: [
                      Text(
                        "Didn't receive code?",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Resend again",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
