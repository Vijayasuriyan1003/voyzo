import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/core/constants/app_colors.dart';
import 'package:voyzo/features/auth/data/auth_api.dart';

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

  void openTerms() async {
    // final Uri url = Uri.parse("https://your-website.com/terms");
    // await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  // final authApi = AuthApi();

  // Future<void> submitRegister() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   if (!isChecked) {
  //     setState(() {
  //       showTermsError = true;
  //     });
  //     return;
  //   }
  //   try {
  //     final response = await authApi.register(
  //       name: _nameController.text.trim(),
  //       number: _mobileController.text.trim(),
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text.trim(),
  //     );

  //     print(response.data);
  //     if (!mounted) return;
  //     context.push('/register_otp');
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('Register failed')));
  //   }
  // }

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
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.push('/register_otp');
                              }
                            },
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
