import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/core/constants/app_colors.dart';
import 'package:voyzo/core/network/dio_client.dart';
import 'package:voyzo/features/auth/data/auth_api.dart';
import 'package:voyzo/features/auth/presentation/provider/user_provider.dart';

class CustomerLoginPage extends ConsumerStatefulWidget {
  const CustomerLoginPage({super.key});

  @override
  ConsumerState<CustomerLoginPage> createState() => _CustomerLoginPageState();
}

class _CustomerLoginPageState extends ConsumerState<CustomerLoginPage> {
  bool isPasswordVisible = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final authApi = AuthApi();
  Future<void> submitLogin() async {
    if (!_formKey.currentState!.validate()) return;
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final userData = await authApi.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (userData != null) {
        ref.read(userProvider.notifier).state = UserState(
          email: userData['email'] ?? '',
          fullName: userData['full_name'] ?? '',
          mobileNo: userData['mobile_no'] ?? '',
          customerId: userData['customer_id'] ?? '',
          customerName: userData['customer_name'] ?? '',
        );

        final user = ref.read(userProvider);

        print('EMAIL: ${user?.email}');
        print('NAME: ${user?.fullName}');
        print('MOBILE: ${user?.mobileNo}');
        print('CUSTOMER ID: ${user?.customerId}');
        print('CUSTOMER NAME: ${user?.customerName}');

        context.go('/home_page');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    } catch (e) {
      print('LOGIN ERROR: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login failed')));
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

                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.all(18.h),

                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 80.h),

                          Image.asset(
                            'assets/images/VOYZO_logo.png',
                            width: 250,
                          ),

                          SizedBox(height: 25.h),

                          Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: 25.h),

                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.mail_outline),
                              hintText: "Email/Mobile Number",
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter email or mobile number';
                              }

                              final isEmail = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value);

                              final isMobile = RegExp(
                                r'^[0-9]{10}$',
                              ).hasMatch(value);

                              if (!isEmail && !isMobile) {
                                return 'Enter valid email or 10 digit mobile number';
                              }

                              return null;
                            },
                          ),

                          SizedBox(height: 20.h),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: !isPasswordVisible,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline),
                              hintText: "Password",
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
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 5.h),

                          Row(
                            children: [
                              Checkbox(value: false, onChanged: (value) {}),

                              const Text("Remember me"),

                              const Spacer(),

                              TextButton(
                                onPressed: () {
                                  context.push('/forgot_password');
                                },
                                child: const Text(
                                  "Forget Password?",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 5.h),

                          SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : submitLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      width: 22.w,
                                      height: 22.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      "Log In",
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),

                          SizedBox(height: 25.h),

                          GestureDetector(
                            onTap: () {
                              context.push('/otp_login');
                            },
                            child: Text(
                              'Login with OTP',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          SizedBox(height: 25.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don’t have an account ? ",
                                style: TextStyle(color: Colors.grey),
                              ),

                              GestureDetector(
                                onTap: () {
                                  context.push('/register');
                                },
                                child: const Text(
                                  "Sign up",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          TextButton(
                            onPressed: () {
                              context.push('/login');
                            },
                            child: Text(
                              "Driver Login",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),

                          SizedBox(height: 30.h),
                        ],
                      ),
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
