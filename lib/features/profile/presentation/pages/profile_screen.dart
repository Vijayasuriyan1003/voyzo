import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../bookings/presentation/widgets/detail_widgets.dart';
import '../providers/profile_provider.dart';

/// Driver Profile screen — reads from [profileProvider] for extended details
/// and [authControllerProvider] for name/initials.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: const VoyzoAppBar(title: 'Profile', showProfile: false),
      body: profileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                            auth.initials,
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
                              border:
                                  Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(Icons.edit,
                                size: 13.sp, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    auth.fullName ?? profileState.profile?.name ?? '—',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    profileState.profile?.phone ?? auth.user ?? '—',
                    style:
                        TextStyle(fontSize: 14.sp, color: AppColors.labelGrey),
                  ),
                  SizedBox(height: 28.h),

                  // Support contact card.
                  if (profileState.profile?.supportPhone != null)
                    _SupportCard(
                        phone: profileState.profile!.supportPhone!),

                  SizedBox(height: 14.h),

                  // Logout.
                  WhiteCard(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      onTap: () async {
                        await ref
                            .read(authControllerProvider.notifier)
                            .logout();
                        // Router redirect handles navigation.
                      },
                      leading: Icon(Icons.logout_rounded,
                          color: AppColors.textPrimary, size: 22.sp),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right_rounded,
                          color: AppColors.labelGrey, size: 22.sp),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  final String phone;
  const _SupportCard({required this.phone});

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
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
                  phone,
                  style: TextStyle(
                      fontSize: 13.sp, color: AppColors.labelGrey),
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
    );
  }
}
