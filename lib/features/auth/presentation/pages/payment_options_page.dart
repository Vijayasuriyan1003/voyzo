import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/core/constants/app_colors.dart';
import 'package:voyzo/features/auth/presentation/provider/user_provider.dart';
import 'package:voyzo/features/auth/widgets/customer_bottom_navbar.dart';

class PaymentOptionsPage extends StatelessWidget {
  const PaymentOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
        title: Text(
          'Payment',
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Options',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: 28.h),

                      Text(
                        'All Payment Options',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),

                      SizedBox(height: 10.h),

                      _paymentOption(
                        icon: Icons.credit_card,
                        title: 'Cards',
                        subtitle: 'VISA   MasterCard   RuPay',
                      ),

                      _paymentOption(
                        icon: Icons.account_balance,
                        title: 'Netbanking',
                        subtitle: 'SBI   HDFC   ICICI',
                      ),

                      _paymentOption(
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'Wallet',
                        subtitle: 'Paytm   PhonePe   GPay',
                      ),

                      _paymentOption(
                        icon: Icons.access_time,
                        title: 'Pay Later',
                        subtitle: 'LazyPay   Simpl',
                      ),

                      const Spacer(),

                      Text(
                        'Extra Fees Added',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: 6.h),

                      Text(
                        'A convenience fee will be charged by Acme Corp depending\non your choice of payment method',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 18.h),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '₹10,000 + Fee\nView Details',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 160.w,
                            height: 45.h,
                            child: ElevatedButton(
                              onPressed: () {
                                _showPaymentReceivedDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF07051A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                              ),
                              child: Text(
                                'Continue',
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
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const CustomerBottomNavBar(currentIndex: 1),
    );
  }

  Widget _paymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: Colors.indigo),

          SizedBox(width: 10.w),

          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Icon(Icons.keyboard_arrow_down, size: 20.sp, color: Colors.black),
        ],
      ),
    );
  }
}

void _showPaymentReceivedDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 26.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 42.r,
                    backgroundColor: Colors.green.withOpacity(0.18),
                    child: Icon(Icons.check, size: 55.sp, color: Colors.green),
                  ),

                  SizedBox(height: 22.h),

                  Text(
                    'Payment Received',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 80.h),

                  SizedBox(
                    width: double.infinity,
                    height: 45.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        context.push('/review_page');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              right: 8.w,
              top: 8.h,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(dialogContext);
                },
                child: Icon(Icons.close, size: 24.sp, color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    },
  );
}
