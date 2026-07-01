import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/core/constants/app_colors.dart';

class SetNewPasswordPage extends StatefulWidget {
  final bool isChangePassword;

  const SetNewPasswordPage({super.key, this.isChangePassword = false});

  @override
  State<SetNewPasswordPage> createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends State<SetNewPasswordPage> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _oldPasswordController = TextEditingController();

  String? passwordError;
  String? confirmPasswordError;

  bool isStrongPassword(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  InputDecoration inputDecoration({
    required String hint,
    required bool visible,
    required VoidCallback onTap,
  }) {
    return InputDecoration(
      hintText: hint,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r)),
      suffixIcon: IconButton(
        icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
        onPressed: onTap,
      ),
    );
  }

  void submitPassword() {
    setState(() {
      passwordError = null;
      confirmPasswordError = null;
    });

    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password.isEmpty) {
      setState(() {
        passwordError = "Please enter new password";
      });
      return;
    }

    // if (password.length < 8) {
    //   setState(() {
    //     passwordError = "Password must be at least 8 characters long";
    //   });
    //   return;
    // }

    // if (!RegExp(r'[A-Z]').hasMatch(password)) {
    //   setState(() {
    //     passwordError = "Password must contain one uppercase letter";
    //   });
    //   return;
    // }

    // if (!RegExp(r'[a-z]').hasMatch(password)) {
    //   setState(() {
    //     passwordError = "Password must contain one lowercase letter";
    //   });
    //   return;
    // }

    // if (!RegExp(r'[0-9]').hasMatch(password)) {
    //   setState(() {
    //     passwordError = "Password must contain one number";
    //   });
    //   return;
    // }

    // if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
    //   setState(() {
    //     passwordError = "Password must contain one symbol";
    //   });
    //   return;
    // }

    if (confirmPassword.isEmpty) {
      setState(() {
        confirmPasswordError = "Please confirm password";
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        confirmPasswordError = "Password is not matching";
      });
      return;
    }

    context.go('/customer_login');
  }

  Widget errorText(String? error) {
    if (error == null) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          error,
          style: TextStyle(color: AppColors.error, fontSize: 13.sp),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
                  padding: EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () {
                            if (widget.isChangePassword) {
                              context.go('/customer_profile');
                            } else {
                              context.go('/forgot_password');
                            }
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 18.sp,
                            color: AppColors.textPrimary,
                          ),
                          label: Text(
                            'Back',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      Image.asset('assets/images/VOYZO_logo.png', width: 250.w),

                      SizedBox(height: 60.h),

                      Text(
                        'Set New password',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 30.h),

                      if (widget.isChangePassword) ...[
                        TextFormField(
                          controller: _oldPasswordController,
                          obscureText: !isPasswordVisible,
                          decoration: inputDecoration(
                            hint: 'Old Password',
                            visible: isPasswordVisible,
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter old password';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 16.h),
                      ],

                      TextField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: inputDecoration(
                          hint: 'Enter new password',
                          visible: isPasswordVisible,
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),

                      errorText(passwordError),

                      SizedBox(height: 18.h),

                      TextField(
                        controller: confirmPasswordController,
                        obscureText: !isConfirmPasswordVisible,
                        decoration: inputDecoration(
                          hint: 'Confirm Password',
                          visible: isConfirmPasswordVisible,
                          onTap: () {
                            setState(() {
                              isConfirmPasswordVisible =
                                  !isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),

                      errorText(confirmPasswordError),

                      SizedBox(height: 15.h),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Atleast 8 characters long, combination of uppercase letters, lowercase letters, numbers, and symbols.",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(height: 50.h),

                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: submitPassword,
                          child: Text('Submit'),
                        ),
                      ),
                    ],
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
