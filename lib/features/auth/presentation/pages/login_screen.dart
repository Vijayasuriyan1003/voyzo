import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/features/auth/data/auth_api.dart';
import 'package:voyzo/features/bookings/presentation/providers/driver_provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final driverData = await AuthApi.driverLogin(
      email: email,
      password: password,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (driverData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid login or driver profile not found'),
        ),
      );
      return;
    }

    ref.read(driverProvider.notifier).setDriver(driverData);
    ref.read(isLoggedInProvider.notifier).state = true;

    context.go('/booking-history');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 100.h),

              Image.asset('assets/images/VOYZO_logo.png', width: 250.w),

              SizedBox(height: 25.h),

              Text(
                'Driver Login',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: 45.h),

              _Field(
                controller: _emailController,
                hint: 'email id',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 20.h),

              _Field(
                controller: _passwordController,
                hint: 'Password',
                icon: Icons.lock_outline_rounded,
                obscure: _obscure,
                suffix: IconButton(
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.labelGrey,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                ),
              ),

              SizedBox(height: 35.h),

              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: const Color(0xFFF2F2F2),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 22.w,
                          height: 22.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFF2F2F2),
                          ),
                        ),
                ),
              ),

              SizedBox(height: 220.h),

              TextButton(
                onPressed: () {
                  context.push('/customer_login');
                },
                child: Text(
                  'Customer Login',
                  style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType keyboardType;

  const _Field({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 15.sp, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.labelGrey, fontSize: 15.sp),
        prefixIcon: Icon(icon, color: AppColors.labelGrey, size: 22.sp),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        border: _border(AppColors.outlineVariant),
        enabledBorder: _border(AppColors.outlineVariant),
        focusedBorder: _border(AppColors.primary),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(100.r),
      borderSide: BorderSide(color: color),
    );
  }
}
