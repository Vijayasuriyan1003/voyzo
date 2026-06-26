import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/core/constants/app_colors.dart';
import 'package:voyzo/features/auth/widgets/customer_bottom_navbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyzo/features/auth/presentation/provider/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerProfilePage extends StatelessWidget {
  const CustomerProfilePage({super.key});

  Future<void> _openWebsite() async {
    final Uri url = Uri.parse(
      'https://www.voyzotraveltech.com/about-voyzo-traveltech/',
    ); // Replace with actual URL

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final user = ref.watch(userProvider);

              final fullName = user?.fullName ?? '';

              final nameParts = fullName.trim().split(' ');

              String initials = '';

              if (nameParts.length >= 2) {
                initials = '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
              } else if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
                initials = nameParts[0][0].toUpperCase();
              }

              return CircleAvatar(
                radius: 14.r,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 14.w),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 35.h),

            Consumer(
              builder: (context, ref, child) {
                final user = ref.watch(userProvider);

                final fullName = user?.fullName ?? '';

                final nameParts = fullName.trim().split(' ');

                String initials = '';

                if (nameParts.length >= 2) {
                  initials = '${nameParts[0][0]}${nameParts[1][0]}'
                      .toUpperCase();
                } else if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
                  initials = nameParts[0][0].toUpperCase();
                }

                return Column(
                  children: [
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: const Color(0xFFBDBDBD),
                      child: Text(
                        initials,
                        style: TextStyle(
                          fontSize: 28.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    SizedBox(height: 15.h),

                    Text(
                      fullName,
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 3.h),

                    Text(
                      user?.mobileNo ?? '',
                      style: TextStyle(
                        color: const Color(0xFF9FA3B5),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 20.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _profileItem(context, 'About Voyzo'),

                    _divider(),

                    _profileItem(context, 'Support'),
                    _divider(),

                    _profileItem(context, 'Privacy Policy'),
                    _divider(),

                    _profileItem(context, 'Terms & Condition'),
                    _divider(),

                    _profileItem(context, 'Change Password', showArrow: false),
                    _divider(),

                    _profileItem(context, 'Logout', showArrow: false),
                  ],
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),

      bottomNavigationBar: const CustomerBottomNavBar(currentIndex: 2),
    );
  }

  Widget _profileItem(
    BuildContext context,
    String title, {
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: () {
        if (title == "About Voyzo") {
          _openWebsite();
        } else if (title == "Change Password") {
          context.push('/set_new_password', extra: {'isChangePassword': true});
        } else if (title == "Logout") {
          context.go('/customer_login');
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: const Color(0xFFA5A8B9),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            if (showArrow)
              Icon(
                Icons.chevron_right,
                size: 22.sp,
                color: const Color(0xFFA5A8B9),
              ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Divider(height: 1, color: Colors.grey.shade200),
    );
  }
}
