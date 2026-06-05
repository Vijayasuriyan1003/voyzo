import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/core/constants/app_colors.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _mobileController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),

                child: Padding(
                  padding: EdgeInsets.all(18.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              context.push('/customer_login');
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 18.sp,
                              color: AppColors.textPrimary,
                            ),
                            label: Text(
                              "Back",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        Image.asset('assets/images/VOYZO_logo.png', width: 250),

                        SizedBox(height: 80.h),

                        Text(
                          "Forgot Password",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 25.h),

                        TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: inputDecoration('Mobile Number'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter mobile number';
                            }

                            if (!RegExp(
                              r'^[0-9]{10}$',
                            ).hasMatch(value.trim())) {
                              return 'Enter valid 10 digit mobile number';
                            }

                            return null;
                          },
                        ),

                        SizedBox(height: 30.h),

                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: () {
                              final isValid =
                                  _formKey.currentState?.validate() ?? false;

                              if (!isValid) {
                                return;
                              }
                              context.push('/forgot_otp');
                            },
                            child: Text("Submit"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
