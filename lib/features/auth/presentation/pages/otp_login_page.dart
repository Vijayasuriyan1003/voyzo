import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/core/constants/app_colors.dart';
import 'package:voyzo/theme/app_theme.dart';

class OtpLoginPage extends StatelessWidget {
  const OtpLoginPage({super.key});

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      prefixIcon: const Icon(Icons.mail_outline),
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
                  padding: const EdgeInsets.all(18),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 80.h),

                        Image.asset('assets/images/VOYZO_logo.png', width: 250),
                        SizedBox(height: 50.h),

                        Text(
                          'Login with OTP',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 35.h),

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

                        SizedBox(height: 20.h),

                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.push('/login_otp_verification');
                              }
                            },
                            child: Text('Send OTP'),
                          ),
                        ),

                        SizedBox(height: 35.h),

                        GestureDetector(
                          onTap: () {
                            context.go('/customer_login');
                          },
                          child: Text(
                            'Login with Email/Mobile',
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        SizedBox(height: 18.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don’t have an account ? ',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.go('/register');
                              },
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
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
            );
          },
        ),
      ),
    );
  }
}
