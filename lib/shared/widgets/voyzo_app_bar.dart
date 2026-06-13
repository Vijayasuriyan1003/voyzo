import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../features/auth/application/auth_controller.dart';

/// Top app bar used across driver screens.  Reads the authenticated user's
/// initials from [authControllerProvider] instead of hard-coded mock data.
class VoyzoAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool showProfile;
  final bool showBack;
  final List<Widget>? actions;

  const VoyzoAppBar({
    super.key,
    required this.title,
    this.showProfile = true,
    this.showBack = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initials =
        ref.watch(authControllerProvider.select((s) => s.initials));

    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      shadowColor: const Color(0x33000000),
      centerTitle: true,
      toolbarHeight: 60.h,
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18.sp,
                color: AppColors.textPrimary,
              ),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        if (showProfile)
          GestureDetector(
            onTap: () => context.push('/profile'),
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: AppColors.avatarGrey,
                child: Text(
                  initials,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        if (actions != null) ...actions!,
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}
