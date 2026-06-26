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
  int driverRating = 3;
  int carRating = 3;
  int serviceRating = 3;

  final feedbackController = TextEditingController();

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  Widget ratingStars(int rating, Function(int) onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;

        return GestureDetector(
          onTap: () {
            onTap(starIndex);
          },
          child: Icon(
            Icons.star,
            size: 30.sp,
            color: starIndex <= rating ? Colors.orange : Colors.grey,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
        leading: Padding(
          padding: EdgeInsets.all(10.w),
          child: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 16,
            ),
          ),
        ),
        title: Text(
          'Review',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
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

                final fullName = user?.fullName ?? '';

                final nameParts = fullName.trim().split(' ');

                String initials = '';

                if (nameParts.length >= 2) {
                  initials = '${nameParts[0][0]}${nameParts[1][0]}'
                      .toUpperCase();
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
          ),
          SizedBox(width: 15.w),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 35.w),
                child: Column(
                  children: [
                    SizedBox(height: 25.h),

                    Row(
                      children: [
                        CircleAvatar(
                          radius: 38.r,
                          backgroundColor: Colors.orange,
                          child: CircleAvatar(
                            radius: 37.r,
                            backgroundColor: const Color(0xFFD8A5E8),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rakesh Kumar',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.orange,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Hyundai Verna',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'RJ 02 BL 2354',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 25.h),

                    Text(
                      'Thank You!',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      'Please rate your trip',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Text(
                      'Driver Rating',
                      style: TextStyle(
                        fontSize: 16.sp,

                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ratingStars(driverRating, (value) {
                      setState(() => driverRating = value);
                    }),

                    SizedBox(height: 15.h),

                    Text(
                      'Car Rating',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ratingStars(carRating, (value) {
                      setState(() => carRating = value);
                    }),

                    SizedBox(height: 15.h),

                    Text(
                      'Voyzo Service',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ratingStars(serviceRating, (value) {
                      setState(() => serviceRating = value);
                    }),

                    SizedBox(height: 20.h),

                    Text(
                      'Feedback',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Container(
                      height: 80.h,
                      width: double.infinity,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: TextField(
                        controller: feedbackController,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          hintText: 'type your feedback',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isCollapsed: true,
                          filled: false,
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),

            Container(
              color: const Color(0xFFEFEFEF),
              padding: EdgeInsets.fromLTRB(35.w, 10.h, 35.w, 20.h),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/customer_booking_history');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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
