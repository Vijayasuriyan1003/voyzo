import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/core/constants/app_colors.dart';
import 'package:voyzo/features/auth/data/auth_api.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final authApi = AuthApi();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r)),
    );
  }

  Future<void> submitForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final input = _controller.text.trim();

    final isEmail = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(input);

    final success = await authApi.forgotPassword(input);

    if (!mounted) return;

    if (success) {
      if (isEmail) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset link sent to your email'),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('OTP sent successfully')));

        context.push('/forgot_otp');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to process request')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                            onPressed: () => context.push('/customer_login'),
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
                          controller: _controller,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration('Email or Mobile Number'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email or Mobile Number is required';
                            }

                            final input = value.trim();

                            if (RegExp(r'^\d+$').hasMatch(input)) {
                              if (input.length != 10) {
                                return 'Mobile number must be 10 digits';
                              }
                              return null;
                            }

                            final isEmail = RegExp(
                              r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(input);

                            if (!isEmail) {
                              return 'Enter a valid email address';
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 30.h),
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: submitForgotPassword,
                            child: const Text("Submit"),
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
