import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/expense_model.dart';
import '../providers/booking_provider.dart';
import '../widgets/detail_widgets.dart';

/// Figma driver "List Details" (node 350:1255) — guest, duty/trip type, route,
/// OTP + Start KM, "Add extra Charges" and Save.
class TripDetailsScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const TripDetailsScreen({super.key, required this.bookingId});

  @override
  ConsumerState<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends ConsumerState<TripDetailsScreen> {
  final _otpController = TextEditingController();
  final _startKmController = TextEditingController();
  bool _isLoading = false;
  bool _showCharges = false;

  @override
  void dispose() {
    _otpController.dispose();
    _startKmController.dispose();
    super.dispose();
  }

  void _toast(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  Future<void> _save(BookingModel booking) async {
    if (_otpController.text.trim().isEmpty ||
        _startKmController.text.trim().isEmpty) {
      _toast('Enter OTP and Start KM', AppColors.error);
      return;
    }
    if (_otpController.text.trim() != (booking.otp ?? '')) {
      _toast('Invalid OTP. Please try again.', AppColors.error);
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    final km = double.tryParse(_startKmController.text.trim()) ?? 0;
    ref.read(bookingProvider.notifier).startTrip(booking.id, km);
    if (!mounted) return;
    setState(() => _isLoading = false);
    _toast('Trip started', AppColors.success);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final booking =
        ref.watch(bookingProvider.notifier).getBookingById(widget.bookingId);
    if (booking == null) {
      return const Scaffold(body: Center(child: Text('Booking not found')));
    }

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: const VoyzoAppBar(title: 'List Details'),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DetailHeading('Guest Details'),
            SizedBox(height: 10.h),
            // Guest card — name, pickup date/time and amber call button.
            WhiteCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.passengerName,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        TwoColRow(
                          left: LabelledValue(
                            label: 'Pickup date',
                            value: DateFormat('dd-MM-yyyy')
                                .format(booking.scheduledDateTime),
                          ),
                          right: LabelledValue(
                            label: 'Pickup Time',
                            value: DateFormat('HH:mm:ss')
                                .format(booking.scheduledDateTime),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.call, color: Colors.white, size: 20.sp),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            // Duty / Trip / Sub trip type.
            WhiteCard(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: LabelledValue(
                      label: 'Duty Type',
                      value: booking.dutyType,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  TwoColRow(
                    left: LabelledValue(
                      label: 'Trip Type',
                      value: booking.tripType,
                    ),
                    right: LabelledValue(
                      label: 'Sub Trip Type',
                      value: booking.subTripType,
                      align: CrossAxisAlignment.end,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            // Route.
            WhiteCard(
              child: LocationTimeline(
                pickup: booking.pickupLocation,
                drop: booking.dropLocation,
              ),
            ),
            SizedBox(height: 12.h),
            // OTP + Start KM.
            WhiteCard(
              child: Row(
                children: [
                  Expanded(
                    child: PillInput(
                      label: 'OTP',
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: PillInput(
                      label: 'Start KM',
                      controller: _startKmController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => setState(() => _showCharges = !_showCharges),
                child: Text(
                  'Add extra Charges',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            if (_showCharges) ...[
              SizedBox(height: 14.h),
              const _AdditionalChargesCard(),
            ],
            SizedBox(height: 18.h),
            AppButton(
                label: 'Save', onTap: () => _save(booking), isLoading: _isLoading),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

/// Figma "Add extra Charges" state — Charges Type, Amount and an upload row,
/// repeatable for Toll / Night / Parking.
class _AdditionalChargesCard extends StatefulWidget {
  const _AdditionalChargesCard();

  @override
  State<_AdditionalChargesCard> createState() => _AdditionalChargesCardState();
}

class _AdditionalChargesCardState extends State<_AdditionalChargesCard> {
  String? _type;
  final _amount = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Charges Type',
                  style: TextStyle(
                      fontSize: 13.sp, color: AppColors.textPrimary)),
              SizedBox(height: 8.h),
              DropdownButtonFormField2<String>(
                valueListenable: ValueNotifier(_type),
                isExpanded: true,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide:
                        const BorderSide(color: AppColors.outlineVariant),
                  ),
                ),
                items: ExpenseModel.expenseTypes
                    .map((t) => DropdownItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _type = v),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          PillInput(
            label: 'Amount',
            controller: _amount,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.h),
          Text('Upload multiple files',
              style:
                  TextStyle(fontSize: 13.sp, color: AppColors.textPrimary)),
          SizedBox(height: 8.h),
          DottedUpload(),
        ],
      ),
    );
  }
}

/// Dashed upload box for charge proof images.
class DottedUpload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64.h,
      decoration: BoxDecoration(
        color: AppColors.greyBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload_outlined,
              color: AppColors.labelGrey, size: 22.sp),
          SizedBox(height: 4.h),
          Text('Upload files',
              style: TextStyle(fontSize: 12.sp, color: AppColors.labelGrey)),
        ],
      ),
    );
  }
}
