import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../../data/models/booking_model.dart';
import '../providers/booking_provider.dart';

class TripDetailsScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const TripDetailsScreen({super.key, required this.bookingId});

  @override
  ConsumerState<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends ConsumerState<TripDetailsScreen> {
  final _otpController = TextEditingController();
  final _startKmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    _startKmController.dispose();
    super.dispose();
  }

  Future<void> _startTrip(BookingModel booking) async {
    if (!_formKey.currentState!.validate()) return;

    if (_otpController.text.trim() != (booking.otp ?? '')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid OTP. Please try again.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final km = double.tryParse(_startKmController.text.trim()) ?? 0;
    ref.read(bookingProvider.notifier).startTrip(booking.id, km);

    if (mounted) {
      context.pushReplacement('/active-trip', extra: booking.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = ref.watch(bookingProvider.notifier).getBookingById(widget.bookingId);

    if (booking == null) {
      return const Scaffold(body: Center(child: Text('Booking not found')));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VoyzoAppBar(title: 'Trip Details'),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.upcomingContainer,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.upcoming.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.schedule_rounded,
                        color: AppColors.upcoming, size: 18.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Upcoming Trip  •  ${DateFormat('dd MMM yyyy, hh:mm a').format(booking.scheduledDateTime)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.upcoming,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Guest card
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(icon: Icons.person_rounded, label: 'Guest Details'),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24.r,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            booking.passengerName.substring(0, 2).toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.passengerName,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                booking.passengerPhone,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _InfoChip(
                          label: booking.bookingType,
                          icon: Icons.flight_rounded,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    _InfoRow(
                      label: 'Booking Ref',
                      value: booking.bookingCode,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              // Route card
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(
                        icon: Icons.route_rounded, label: 'Trip Route'),
                    SizedBox(height: 16.h),
                    _RouteTimeline(
                      pickup: booking.pickupLocation,
                      drop: booking.dropLocation,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              // Vehicle card
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(
                        icon: Icons.directions_car_rounded,
                        label: 'Vehicle Details'),
                    SizedBox(height: 12.h),
                    _InfoRow(label: 'Vehicle', value: booking.vehicleInfo),
                    _InfoRow(label: 'Number', value: booking.vehicleNumber),
                    _InfoRow(
                        label: 'Trip Amount',
                        value: '₹ ${booking.tripAmount.toStringAsFixed(0)}',
                        highlight: true),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // OTP + Start KM inputs
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(
                        icon: Icons.play_circle_outline_rounded,
                        label: 'Start Trip'),
                    SizedBox(height: 16.h),
                    AppTextField(
                      label: 'OTP Verification',
                      hint: 'Enter passenger OTP',
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      prefixIcon: const Icon(Icons.pin_outlined,
                          color: AppColors.textHint),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'OTP required' : null,
                    ),
                    SizedBox(height: 14.h),
                    AppTextField(
                      label: 'Start Kilometre (KM)',
                      hint: 'Enter current odometer reading',
                      controller: _startKmController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d*')),
                      ],
                      prefixIcon: const Icon(Icons.speed_outlined,
                          color: AppColors.textHint),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Start KM required' : null,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              AppButton(
                label: 'Start Trip',
                onTap: _isLoading ? null : () => _startTrip(booking),
                isLoading: _isLoading,
                icon: Icons.play_arrow_rounded,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable sub-widgets ──────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.outlineVariant, width: 0.5),
        boxShadow: [
          BoxShadow(
              color: AppColors.cardShadow, blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionTitle({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.primary),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  const _InfoRow(
      {required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textHint,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                color: highlight ? AppColors.primary : AppColors.textPrimary,
                fontWeight:
                    highlight ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: AppColors.primaryDark),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteTimeline extends StatelessWidget {
  final String pickup;
  final String drop;
  const _RouteTimeline({required this.pickup, required this.drop});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 10.w,
              height: 10.h,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2.w,
              height: 36.h,
              color: AppColors.outlineVariant,
            ),
            Icon(Icons.location_on, size: 16.sp, color: AppColors.error),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pickup',
                style: TextStyle(
                    fontSize: 11.sp, color: AppColors.textHint),
              ),
              SizedBox(height: 2.h),
              Text(
                pickup,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 22.h),
              Text(
                'Drop-off',
                style: TextStyle(
                    fontSize: 11.sp, color: AppColors.textHint),
              ),
              SizedBox(height: 2.h),
              Text(
                drop,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
