import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../../../auth/application/auth_controller.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _vehicleController;
  late final TextEditingController _vehicleNoController;
  late final TextEditingController _licenseController;

  bool _initialised = false;
  int _selectedPhotoIndex = 0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _vehicleController = TextEditingController();
    _vehicleNoController = TextEditingController();
    _licenseController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _vehicleController.dispose();
    _vehicleNoController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  /// Populate controllers once the profile has loaded.
  void _populate(DriverProfile p) {
    if (_initialised) return;
    _initialised = true;
    _nameController.text = p.name;
    _phoneController.text = p.phone ?? '';
    _emailController.text = p.email ?? '';
    _vehicleController.text = p.vehicleModel ?? '';
    _vehicleNoController.text = p.vehicleNumber ?? '';
    _licenseController.text = p.licenseNumber ?? '';
  }

  Future<void> _save() async {
    try {
      await ref.read(profileProvider.notifier).save(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            email: _emailController.text.trim(),
            vehicleNumber: _vehicleNoController.text.trim(),
            vehicleModel: _vehicleController.text.trim(),
            licenseNumber: _licenseController.text.trim(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            'Profile saved successfully!',
            style: TextStyle(
                color: AppColors.onPrimary, fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r)),
        ));
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r)),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final profileState = ref.watch(profileProvider);

    // Populate controllers once profile data arrives.
    if (profileState.profile != null) _populate(profileState.profile!);

    final isSaving = profileState.isLoading && _initialised;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VoyzoAppBar(title: 'Edit Profile'),
      body: profileState.isLoading && !_initialised
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 28.h),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFFF8F5), Color(0xFFFDE8CC)],
                      ),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 44.r,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                auth.initials,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              width: 28.w,
                              height: 28.h,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 2),
                              ),
                              child: Icon(Icons.camera_alt_rounded,
                                  color: Colors.white, size: 14.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          auth.fullName ??
                              profileState.profile?.name ??
                              '—',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        if (profileState.profile?.driverCode != null)
                          Text(
                            profileState.profile!.driverCode!,
                            style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary),
                          ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (profileState.profile?.rating != null)
                              _StatChip(
                                icon: Icons.star_rounded,
                                label:
                                    '${profileState.profile!.rating!.toStringAsFixed(1)} Rating',
                                color: Colors.amber,
                              ),
                            if (profileState.profile?.rating != null)
                              SizedBox(width: 12.w),
                            if (profileState.profile?.totalTrips != null)
                              _StatChip(
                                icon: Icons.directions_car_rounded,
                                label:
                                    '${profileState.profile!.totalTrips} Trips',
                                color: AppColors.primary,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Photo selection placeholder.
                        _SectionHeader('Select Profile Photo'),
                        SizedBox(height: 12.h),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8.w,
                            mainAxisSpacing: 8.h,
                          ),
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            final isSelected = _selectedPhotoIndex == index;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedPhotoIndex = index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.surfaceContainer,
                                  borderRadius:
                                      BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.outlineVariant,
                                    width: isSelected ? 2 : 0.5,
                                  ),
                                ),
                                child: index == 7
                                    ? Icon(
                                        Icons.add_photo_alternate_rounded,
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.textHint,
                                        size: 22.sp,
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.person_rounded,
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.textHint,
                                            size: 24.sp,
                                          ),
                                          if (isSelected)
                                            Icon(Icons.check_circle,
                                                color: Colors.white,
                                                size: 12.sp),
                                        ],
                                      ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 24.h),

                        // Personal info.
                        _SectionHeader('Personal Information'),
                        SizedBox(height: 12.h),
                        AppTextField(
                          label: 'Full Name',
                          controller: _nameController,
                          prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                              color: AppColors.textHint),
                        ),
                        SizedBox(height: 14.h),
                        AppTextField(
                          label: 'Mobile Number',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: const Icon(Icons.phone_outlined,
                              color: AppColors.textHint),
                        ),
                        SizedBox(height: 14.h),
                        AppTextField(
                          label: 'Email Address',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: AppColors.textHint),
                        ),
                        SizedBox(height: 24.h),

                        // Vehicle details.
                        _SectionHeader('Vehicle Details'),
                        SizedBox(height: 12.h),
                        AppTextField(
                          label: 'Vehicle Model',
                          controller: _vehicleController,
                          prefixIcon: const Icon(
                              Icons.directions_car_outlined,
                              color: AppColors.textHint),
                        ),
                        SizedBox(height: 14.h),
                        AppTextField(
                          label: 'Vehicle Number',
                          controller: _vehicleNoController,
                          prefixIcon: const Icon(Icons.badge_outlined,
                              color: AppColors.textHint),
                        ),
                        SizedBox(height: 24.h),

                        // License.
                        _SectionHeader('License Details'),
                        SizedBox(height: 12.h),
                        AppTextField(
                          label: 'License Number',
                          controller: _licenseController,
                          prefixIcon: const Icon(Icons.article_outlined,
                              color: AppColors.textHint),
                        ),
                        SizedBox(height: 12.h),

                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                  color: AppColors.outlineVariant),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.upload_file_rounded,
                                    color: AppColors.textHint, size: 24.sp),
                                SizedBox(height: 6.h),
                                Text(
                                  'Upload License / Documents',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.textHint,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),

                        AppButton(
                          label: 'Save Profile',
                          onTap: isSaving ? null : _save,
                          isLoading: isSaving,
                          icon: Icons.save_rounded,
                        ),
                        SizedBox(height: 12.h),
                        AppButton(
                          label: 'Logout',
                          onTap: () async {
                            await ref
                                .read(authControllerProvider.notifier)
                                .logout();
                          },
                          variant: AppButtonVariant.outline,
                          icon: Icons.logout_rounded,
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _StatChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14.sp),
          SizedBox(width: 4.w),
          Text(label,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: color,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
