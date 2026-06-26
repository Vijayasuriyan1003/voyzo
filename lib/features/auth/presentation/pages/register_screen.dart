import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/core/constants/app_colors.dart';
import 'package:voyzo/features/auth/data/auth_api.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/app_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isChecked = false;
  bool isPasswordVisible = false;
  bool showTermsError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget termsItem({required String title, required String description}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void openTerms() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 350.h,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      termsItem(
                        title: '1. Acceptance of Terms',
                        description:
                            'By using this application, you agree to be bound by these Terms & Conditions. If you do not agree, please do not use the app.',
                      ),
                      termsItem(
                        title: '2. Use of Service',
                        description:
                            'You agree to use this service only for lawful purposes and in a way that does not infringe the rights of others or restrict their use of the service.',
                      ),
                      termsItem(
                        title: '3. Privacy Policy',
                        description:
                            'Your personal data is collected and processed in accordance with our Privacy Policy. By using this app, you consent to such processing.',
                      ),
                      termsItem(
                        title: '4. Booking & Cancellation',
                        description:
                            'All bookings are subject to availability. Cancellations must be made within the specified time frame to avoid charges.',
                      ),
                      termsItem(
                        title: '5. Liability',
                        description:
                            'We are not liable for any indirect or consequential loss arising from the use of this application or its services.',
                      ),
                      termsItem(
                        title: '6. Changes to Terms',
                        description:
                            'We reserve the right to modify these terms at any time. Continued use of the app after changes constitutes acceptance of the new terms.',
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                child: AppButton(
                  label: 'Accept & Continue',
                  onTap: () {
                    setState(() {
                      isChecked = true;
                      showTermsError = false;
                    });

                    context.pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  final authApi = AuthApi();

  Future<void> submitRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final success = await authApi.registerCustomer(
        full_name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        mobileno: _mobileController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (success && mounted) {
        context.push('/register_otp');
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
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
                  padding: const EdgeInsets.all(18),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 80.h),

                        Image.asset('assets/images/VOYZO_logo.png', width: 250),

                        SizedBox(height: 25.h),

                        Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 25.h),

                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'Full Name',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter full name';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 12.h),

                        TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: 'Mobile No.',
                          ),
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

                        SizedBox(height: 12.h),

                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Email ID',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter email';
                            }

                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value.trim())) {
                              return 'Enter valid email';
                            }

                            return null;
                          },
                        ),

                        SizedBox(height: 12.h),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }

                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }

                            return null;
                          },
                        ),

                        SizedBox(height: 8.h),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isChecked = value ?? false;

                                      if (isChecked) {
                                        showTermsError = false;
                                      }
                                    });
                                  },
                                ),

                                const Text("I agree "),

                                GestureDetector(
                                  onTap: openTerms,
                                  child: const Text(
                                    "terms & condition.",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            if (showTermsError)
                              const Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: Text(
                                  'Please accept Terms & Conditions',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed: submitRegister,
                            child: const Text('Register'),
                          ),
                        ),

                        SizedBox(height: 25.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Do have a account? ',
                              style: TextStyle(color: AppColors.textHint),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.go('/customer_login');
                              },
                              child: const Text(
                                'Login',
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
