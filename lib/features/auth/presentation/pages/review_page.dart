import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/core/constants/app_colors.dart';
import 'package:voyzo/features/auth/presentation/provider/user_provider.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double driverRating = 0.0;
  double carRating = 0.0;
  double serviceRating = 0.0;

  final feedbackController = TextEditingController();

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  void _updateRating(
    DragUpdateDetails details,
    double width,
    Function(double) onChanged,
  ) {
    double value = (details.localPosition.dx / width) * 5;
    value = value.clamp(0.0, 5.0);
    value = (value * 2).round() / 2;
    onChanged(value);
  }

  Widget halfStarRating(double rating, Function(double) onChanged) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (details) {
            _updateRating(details, width, onChanged);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final star = index + 1;

              IconData icon;

              if (rating >= star) {
                icon = Icons.star;
              } else if (rating >= star - 0.5 && rating != 0) {
                icon = Icons.star_half;
              } else {
                icon = Icons.star_border;
              }

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    onChanged(star - 0.5);
                  },
                  onDoubleTap: () {
                    onChanged(star.toDouble());
                  },
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Icon(icon, color: AppColors.primary, size: 30.sp),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget ratingItem({
    required IconData icon,
    required String title,
    required double rating,
    required Function(double) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: AppColors.primary.withOpacity(.12),
            child: Icon(icon, color: AppColors.primary, size: 22.sp),
          ),

          SizedBox(width: 12.w),

          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
            ),
          ),

          Expanded(flex: 4, child: halfStarRating(rating, onChanged)),
        ],
      ),
    );
  }

  String getInitials(String fullName) {
    final nameParts = fullName.trim().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(10.w),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: () => context.pop(),
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        title: Text(
          'Review',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: () => context.go('/customer_profile'),
            child: Consumer(
              builder: (context, ref, child) {
                final user = ref.watch(userProvider);
                final initials = getInitials(user?.fullName ?? '');

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
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 42.r,
                            backgroundColor: AppColors.primary,
                            child: CircleAvatar(
                              radius: 40.r,
                              backgroundColor: const Color(0xFFD8A5E8),
                              child: Icon(
                                Icons.person,
                                size: 45.sp,
                                color: Colors.purple.shade300,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rakesh Kumar',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.directions_car,
                                    size: 16.sp,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'Hyundai Verna',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.confirmation_number,
                                    size: 16.sp,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'RJ 02 BL 2354',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 28.h),

                    CircleAvatar(
                      radius: 38.r,
                      backgroundColor: AppColors.primary.withOpacity(0.12),
                      child: Icon(
                        Icons.favorite,
                        color: AppColors.primary,
                        size: 34.sp,
                      ),
                    ),

                    SizedBox(height: 14.h),

                    Text(
                      'Thank You!',
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 6.h),

                    Text(
                      'Please rate your trip and help us improve',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 26.h),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Column(
                        children: [
                          ratingItem(
                            icon: Icons.person,
                            title: 'Driver Rating',
                            rating: driverRating,
                            onChanged: (value) {
                              setState(() => driverRating = value);
                            },
                          ),
                          ratingItem(
                            icon: Icons.directions_car,
                            title: 'Car Rating',
                            rating: carRating,
                            onChanged: (value) {
                              setState(() => carRating = value);
                            },
                          ),
                          ratingItem(
                            icon: Icons.support_agent,
                            title: 'Voyzo Service',
                            rating: serviceRating,
                            onChanged: (value) {
                              setState(() => serviceRating = value);
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 22.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Feedback',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    TextFormField(
                      controller: feedbackController,
                      minLines: 5,
                      maxLines: 5,
                      maxLength: 300,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: 'Share your experience with us...',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(16.w),

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
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25.h),
                  ],
                ),
              ),
            ),

            Container(
              color: const Color(0xFFF8F8F8),
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 18.h),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.go('/customer_booking_history');
                  },
                  icon: Icon(Icons.check_circle_outline, size: 22.sp),
                  label: Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
