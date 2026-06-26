import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/features/bookings/presentation/providers/driver_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/mock_data/mock_data.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../../../bookings/presentation/widgets/detail_widgets.dart';

/// Figma driver "Profile" (node 354:421) — avatar with edit, name (amber),
/// phone, a support-team contact card and Logout.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(driverProvider);
    final initials =
        driver?.fullName
            .split(' ')
            .where((e) => e.isNotEmpty)
            .map((e) => e[0])
            .take(2)
            .join() ??
        'DR';
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: const VoyzoAppBar(title: 'Profile', showProfile: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
        child: Column(
          children: [
            // Avatar with edit badge.
            GestureDetector(
              onTap: () => context.push('/edit-profile'),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 52.r,
                    backgroundColor: AppColors.avatarGrey,
                    child: Text(
                      initials,
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2.w,
                    bottom: 2.h,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(Icons.edit, size: 13.sp, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              driver?.fullName ?? '',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              driver?.mobileNo ?? '',
              style: TextStyle(fontSize: 14.sp, color: AppColors.labelGrey),
            ),
            SizedBox(height: 28.h),
            // Support-team contact card.
            WhiteCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Call for support team',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '+91 1234567890',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.labelGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.call, color: Colors.white, size: 20.sp),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            // Logout.
            WhiteCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                onTap: () {
                  ref.read(isLoggedInProvider.notifier).state = false;
                  context.go('/login');
                },
                leading: Icon(
                  Icons.logout_rounded,
                  color: AppColors.textPrimary,
                  size: 22.sp,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.labelGrey,
                  size: 22.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
