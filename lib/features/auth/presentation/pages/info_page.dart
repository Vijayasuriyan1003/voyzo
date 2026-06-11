import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'title': 'Book Fast,\nTravel Smart',
      'description':
          'Choose your car, select your time\nand enjoy a smooth booking\nexperience with trusted service\nanytime you need.',
    },
    {
      'title': 'Safe Ride,\nEasy Travel',
      'description':
          'Track your booking, view driver\ndetails and enjoy a comfortable journey with Voyzo.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (currentPage == pages.length - 1) {
      context.go('/customer_login');
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          itemCount: pages.length,
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(18.w),
              child: Column(
                children: [
                  SizedBox(height: 25.h),

                  Container(
                    height: 250.h,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                  ),

                  SizedBox(height: 25.h),

                  Text(
                    pages[index]['title']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Text(
                    pages[index]['description']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: 25.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (dotIndex) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        height: 8.h,
                        width: 8.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPage == dotIndex
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: AppColors.background,
                    child: IconButton(
                      icon: Icon(
                        currentPage == pages.length - 1
                            ? Icons.check
                            : Icons.arrow_forward,
                        color: Colors.black,
                      ),
                      onPressed: _nextPage,
                    ),
                  ),

                  SizedBox(height: 25.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
