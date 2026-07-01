import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:voyzo/features/bookings/presentation/providers/driver_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/mock_data/mock_data.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _licenseController = TextEditingController();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    final driver = ref.read(driverProvider);

    if (driver != null) {
      _nameController.text = driver.fullName;
      _phoneController.text = driver.mobileNo;
      _emailController.text = driver.email;
      _licenseController.text = driver.license_number;
    }
  }

  Future<void> _pickAndCropImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Profile Image',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
          cropStyle: CropStyle.circle,
        ),
      ],
    );

    if (croppedFile == null) return;

    setState(() {
      _profileImage = File(croppedFile.path);
    });
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndCropImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndCropImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isSaving = false;
  int _selectedPhotoIndex = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    // _vehicleController.dispose();
    // _vehicleNoController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final driver = ref.watch(driverProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VoyzoAppBar(title: 'Edit Profile'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 28.h),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5), // Light grey (#F5F5F5)
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 44.r,
                        backgroundColor: AppColors.avatarGrey,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Text(
                                (ref.watch(driverProvider)?.fullName ?? 'DR')
                                    .split(' ')
                                    .where((e) => e.isNotEmpty)
                                    .map((e) => e[0])
                                    .take(2)
                                    .join(),
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : null,
                      ),
                      GestureDetector(
                        onTap: _showImagePickerOptions,
                        child: Container(
                          width: 28.w,
                          height: 28.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    driver?.fullName ?? '',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatChip(
                        icon: Icons.star_rounded,
                        label:
                            '${(driver?.rating ?? 0).toStringAsFixed(1)} Rating',
                        color: Colors.amber,
                      ),
                      SizedBox(width: 12.w),
                      _StatChip(
                        icon: Icons.directions_car_rounded,
                        label: '${driver?.customNoOfTrips ?? 0} Trips',
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
                  // Gallery / photo selection
                  // _SectionHeader('Select Profile Photo'),
                  // SizedBox(height: 12.h),
                  // GridView.builder(
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 4,
                  //     crossAxisSpacing: 8.w,
                  //     mainAxisSpacing: 8.h,
                  //   ),
                  //   itemCount: 8,
                  //   itemBuilder: (context, index) {
                  //     final isSelected = _selectedPhotoIndex == index;
                  //     return GestureDetector(
                  //       onTap: () =>
                  //           setState(() => _selectedPhotoIndex = index),
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //           color: isSelected
                  //               ? AppColors.primary
                  //               : AppColors.surfaceContainer,
                  //           borderRadius: BorderRadius.circular(10.r),
                  //           border: Border.all(
                  //             color: isSelected
                  //                 ? AppColors.primary
                  //                 : AppColors.outlineVariant,
                  //             width: isSelected ? 2 : 0.5,
                  //           ),
                  //         ),
                  //         child: index == 7
                  //             ? Icon(
                  //                 Icons.add_photo_alternate_rounded,
                  //                 color: isSelected
                  //                     ? Colors.white
                  //                     : AppColors.textHint,
                  //                 size: 22.sp,
                  //               )
                  //             : Column(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Icon(
                  //                     Icons.person_rounded,
                  //                     color: isSelected
                  //                         ? Colors.white
                  //                         : AppColors.textHint,
                  //                     size: 24.sp,
                  //                   ),
                  //                   if (isSelected)
                  //                     Icon(
                  //                       Icons.check_circle,
                  //                       color: Colors.white,
                  //                       size: 12.sp,
                  //                     ),
                  //                 ],
                  //               ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  // SizedBox(height: 24.h),

                  // Personal info
                  _SectionHeader('Personal Information'),
                  SizedBox(height: 12.h),
                  AppTextField(
                    label: 'Full Name',
                    controller: _nameController,
                    readOnly: true,
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.textHint,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  AppTextField(
                    label: 'Mobile Number',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    readOnly: true,
                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                      color: AppColors.textHint,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  AppTextField(
                    label: 'Email Address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.textHint,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Vehicle details
                  // _SectionHeader('Vehicle Details'),
                  // SizedBox(height: 12.h),
                  // AppTextField(
                  //   label: 'Vehicle Model',
                  //   controller: _vehicleController,
                  //   prefixIcon: const Icon(
                  //     Icons.directions_car_outlined,
                  //     color: AppColors.textHint,
                  //   ),
                  // ),
                  // SizedBox(height: 14.h),
                  // AppTextField(
                  //   label: 'Vehicle Number',
                  //   controller: _vehicleNoController,
                  //   prefixIcon: const Icon(
                  //     Icons.badge_outlined,
                  //     color: AppColors.textHint,
                  //   ),
                  // ),
                  // SizedBox(height: 24.h),

                  // License
                  _SectionHeader('License Details'),
                  SizedBox(height: 12.h),
                  AppTextField(
                    label: 'License Number',
                    controller: _licenseController,
                    readOnly: true,
                    prefixIcon: const Icon(
                      Icons.article_outlined,
                      color: AppColors.textHint,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Upload docs placeholder
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Container(
                  //     width: double.infinity,
                  //     padding: EdgeInsets.symmetric(vertical: 14.h),
                  //     decoration: BoxDecoration(
                  //       color: AppColors.surfaceContainer,
                  //       borderRadius: BorderRadius.circular(12.r),
                  //       border: Border.all(
                  //         color: AppColors.outlineVariant,
                  //         style: BorderStyle.solid,
                  //       ),
                  //     ),
                  //     child: Column(
                  //       children: [
                  //         Icon(
                  //           Icons.upload_file_rounded,
                  //           color: AppColors.textHint,
                  //           size: 24.sp,
                  //         ),
                  //         SizedBox(height: 6.h),
                  //         Text(
                  //           'Upload License / Documents',
                  //           style: TextStyle(
                  //             fontSize: 13.sp,
                  //             color: AppColors.textHint,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 32.h),

                  // Save
                  AppButton(
                    label: 'Save Profile',
                    onTap: _isSaving
                        ? null
                        : () async {
                            setState(() => _isSaving = true);
                            await Future.delayed(
                              const Duration(milliseconds: 1000),
                            );
                            if (mounted) {
                              setState(() => _isSaving = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Profile saved successfully!',
                                    style: TextStyle(
                                      color: AppColors.onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  backgroundColor: AppColors.success,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                              );
                            }
                          },
                    isLoading: _isSaving,
                    icon: Icons.save_rounded,
                  ),
                  SizedBox(height: 12.h),
                  AppButton(
                    label: 'Logout',
                    onTap: () {
                      ref.read(isLoggedInProvider.notifier).state = false;
                      context.go('/login');
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
  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        // color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16.sp),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
