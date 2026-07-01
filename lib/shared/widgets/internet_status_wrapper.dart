import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../core/constants/app_colors.dart';

class InternetStatusWrapper extends StatefulWidget {
  final Widget child;

  const InternetStatusWrapper({super.key, required this.child});

  @override
  State<InternetStatusWrapper> createState() => _InternetStatusWrapperState();
}

class _InternetStatusWrapperState extends State<InternetStatusWrapper> {
  bool hasInternet = true;
  bool isChecking = false;
  StreamSubscription<InternetStatus>? _subscription;

  @override
  void initState() {
    super.initState();
    _checkInternet();

    _subscription = InternetConnection().onStatusChange.listen((status) {
      if (!mounted) return;
      setState(() {
        hasInternet = status == InternetStatus.connected;
      });
    });
  }

  Future<void> _checkInternet() async {
    setState(() => isChecking = true);

    final connected = await InternetConnection().hasInternetAccess;

    if (!mounted) return;

    setState(() {
      hasInternet = connected;
      isChecking = false;
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!hasInternet) {
      return NoInternetPage(isChecking: isChecking, onRetry: _checkInternet);
    }

    return widget.child;
  }
}

class NoInternetPage extends StatelessWidget {
  final bool isChecking;
  final VoidCallback onRetry;

  const NoInternetPage({
    super.key,
    required this.isChecking,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _NoInternetIllustration(),

              SizedBox(height: 35.h),

              Text(
                'No Internet Connection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: 12.h),

              Text(
                'Please check your Wi-Fi or mobile data\nconnection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  height: 1.5,
                  color: AppColors.labelGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 36.h),

              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton.icon(
                  onPressed: isChecking ? null : onRetry,
                  icon: isChecking
                      ? SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          Icons.refresh_rounded,
                          size: 24.sp,
                          color: Colors.white,
                        ),
                  label: Text(
                    isChecking ? 'Checking...' : 'Retry',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoInternetIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260.w,
      height: 230.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 20.h,
            child: Container(
              width: 190.w,
              height: 190.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            top: 20.h,
            child: Icon(
              Icons.wifi_off_rounded,
              size: 92.sp,
              color: AppColors.primary,
            ),
          ),

          Positioned(
            bottom: 30.h,
            child: Icon(
              Icons.local_taxi_rounded,
              size: 105.sp,
              color: AppColors.primary,
            ),
          ),

          Positioned(
            right: 25.w,
            bottom: 78.h,
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                color: Colors.white,
                size: 25.sp,
              ),
            ),
          ),

          Positioned(
            bottom: 18.h,
            child: Container(
              width: 180.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
