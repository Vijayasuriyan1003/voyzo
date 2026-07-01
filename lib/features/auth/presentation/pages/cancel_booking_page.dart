import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/core/constants/app_colors.dart';
import 'package:voyzo/features/auth/presentation/provider/user_provider.dart';
import 'package:voyzo/features/auth/widgets/customer_bottom_navbar.dart';

class CancelBookingPage extends StatefulWidget {
  const CancelBookingPage({super.key});

  @override
  State<CancelBookingPage> createState() => _CancelBookingPageState();
}

class _CancelBookingPageState extends State<CancelBookingPage> {
  String? selectedReason;
  String? reasonError;

  final TextEditingController otherReasonController = TextEditingController();

  final reasons = [
    'Plan cancelled',
    'Waiting long time',
    'Driver not reachable',
  ];

  @override
  void dispose() {
    otherReasonController.dispose();
    super.dispose();
  }

  String _getInitials(String fullName) {
    final nameParts = fullName.trim().split(' ');

    if (nameParts.length >= 2 &&
        nameParts[0].isNotEmpty &&
        nameParts[1].isNotEmpty) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }

    return '';
  }

  void _showCancelSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(22.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 36.r,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  child: Icon(
                    Icons.close,
                    color: AppColors.primary,
                    size: 36.sp,
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  'Booking Cancelled Successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Your booking with CRN : #854HG23\nhas been cancelled successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    height: 1.5,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  height: 46.h,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/customer_booking_history');

                      setState(() {
                        selectedReason = null;
                        otherReasonController.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: Text(
                      'Got it',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _reasonTile(String reason) {
    final isSelected = selectedReason == reason;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () {
          setState(() {
            if (selectedReason == reason) {
              // Unselect if the same reason is tapped again
              selectedReason = null;
            } else {
              // Select the new reason
              selectedReason = reason;
            }

            reasonError = null;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
              width: isSelected ? 1.4 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  reason,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
        ),
        title: Text(
          'Cancel Booking',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: () {
              context.go('/customer_profile');
            },
            child: Consumer(
              builder: (context, ref, child) {
                final user = ref.watch(userProvider);
                final initials = _getInitials(user?.fullName ?? '');

                return CircleAvatar(
                  radius: 16.r,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
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
          ),
          SizedBox(width: 15.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 22.h),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 58.w,
                            height: 58.w,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Icon(
                              Icons.event_busy_outlined,
                              color: AppColors.primary,
                              size: 32.sp,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cancel Booking',
                                  style: TextStyle(
                                    fontSize: 19.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  'Please select a reason for cancelling your booking.',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    height: 1.35,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    Text(
                      'Select the reason for cancellation',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 14.h),

                    ...reasons.map((reason) => _reasonTile(reason)),

                    SizedBox(height: 8.h),

                    Text(
                      'Other',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    TextField(
                      controller: otherReasonController,
                      minLines: 5,
                      maxLines: 5,
                      maxLength: 200,
                      onChanged: (value) {
                        if (value.trim().isNotEmpty) {
                          setState(() {
                            reasonError = null;
                          });
                        }
                      },
                      cursorColor: AppColors.primary,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Other reason',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(16.w),
                        counterStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12.sp,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.3,
                          ),
                        ),
                      ),
                    ),

                    if (reasonError != null) ...[
                      SizedBox(height: 6.h),
                      Text(
                        reasonError!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],

                    SizedBox(height: 16.h),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.25),
                        ),
                      ),
                      child: Text(
                        'Note: Cancel Before 4 hours Cancellation charges INR. 500.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            Container(
              color: const Color(0xFFF8F8F8),
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 18.h),
              child: SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: () {
                    final otherReason = otherReasonController.text.trim();

                    if (selectedReason == null && otherReason.isEmpty) {
                      setState(() {
                        reasonError =
                            'Please select a reason or enter another reason.';
                      });
                      return;
                    }

                    _showCancelSuccessDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    'Cancel Ride',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomerBottomNavBar(currentIndex: 1),
    );
  }
}
