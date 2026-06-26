import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/expense_model.dart';
import '../providers/booking_provider.dart';
import '../widgets/detail_widgets.dart';

/// Figma driver "Trip Details" (node 350:1255 + states). Three states keyed off
/// the booking status:
///  • upcoming  → Trip Start  (OTP + Start KM, "Trip Start").
///  • active    → Trip End    (Start OTP/KM read-only, Extra Expenses + Add
///    Expense, End OTP + End KM, "Trip End").
///  • completed → read-only "Trip Completed" summary (node 374:906).
class TripDetailsScreen extends ConsumerStatefulWidget {
  const TripDetailsScreen({super.key});

  @override
  ConsumerState<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends ConsumerState<TripDetailsScreen> {
  final _otpController = TextEditingController();
  final _startKmController = TextEditingController();
  final _endOtpController = TextEditingController();
  final _endKmController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    _startKmController.dispose();
    _endOtpController.dispose();
    _endKmController.dispose();
    super.dispose();
  }

  void _toast(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Future<void> _tripStart(BookingModel booking) async {
    if (_otpController.text.trim().isEmpty ||
        _startKmController.text.trim().isEmpty) {
      _toast('Enter OTP and Start KM', AppColors.error);
      return;
    }
    if (_otpController.text.trim() != '1234') {
      _toast('Invalid OTP. Please try again.', AppColors.error);
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    final km = double.tryParse(_startKmController.text.trim()) ?? 0;
    ref
        .read(bookingProvider.notifier)
        .startTrip(booking.id, km, _otpController.text.trim());

    final updatedBooking = booking.copyWith(
      status: BookingStatus.active,
      startKm: km,
      startTime: DateTime.now(),
      otp: _otpController.text.trim(),
    );

    ref.read(selectedBookingProvider.notifier).state = updatedBooking;
    if (!mounted) return;
    setState(() => _isLoading = false);
    _toast('Trip started', AppColors.success);
  }

  Future<void> _tripEnd(BookingModel booking) async {
    if (_endOtpController.text.trim().isEmpty ||
        _endKmController.text.trim().isEmpty) {
      _toast('Enter End OTP and End KM', AppColors.error);
      return;
    }
    if (_endOtpController.text.trim() != (booking.otp ?? '')) {
      _toast('Invalid End OTP. Please try again.', AppColors.error);
      return;
    }
    final endKm = double.tryParse(_endKmController.text.trim()) ?? 0;
    if (booking.startKm != null && endKm <= booking.startKm!) {
      _toast('End KM must be greater than Start KM', AppColors.error);
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    ref.read(bookingProvider.notifier).endTrip(booking.id, endKm);
    if (!mounted) return;
    setState(() => _isLoading = false);
    _toast('Trip completed', AppColors.success);
    context.pop();
  }

  Widget _expenseRow(BookingModel booking, ExpenseModel e) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              e.notes ?? e.type,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
            ),
          ),
          Text(
            'INR. ${e.amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () => context.push('/add-expense', extra: booking.id),
            child: Icon(
              Icons.edit_outlined,
              size: 18.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () => _deleteExpense(booking, e),
            child: Icon(
              Icons.delete_outline_rounded,
              size: 19.sp,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteExpense(BookingModel booking, ExpenseModel e) async {
    final ok = await showConfirmDialog(
      context,
      message: 'Do you want to delete the ${e.notes ?? e.type} charge?',
    );
    if (!ok) return;
    ref.read(bookingProvider.notifier).removeExpense(booking.id, e.id);
  }

  @override
  Widget build(BuildContext context) {
    // Watch the STATE (not the notifier) so the screen rebuilds when expenses
    // are added/edited/deleted in place.
    final booking = ref.watch(selectedBookingProvider);
    if (booking == null) {
      return const Scaffold(body: Center(child: Text('Booking not found')));
    }
    final completed = booking.status == BookingStatus.completed;
    final started = booking.status == BookingStatus.active;

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: const VoyzoAppBar(title: 'Trip Details'),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (completed) ...[
              Text(
                'Trip Completed',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.statusCompleted,
                ),
              ),
              SizedBox(height: 12.h),
            ] else ...[
              const DetailHeading('Guest Details'),
              SizedBox(height: 10.h),
            ],
            _guestCard(booking, completed: completed),
            SizedBox(height: 12.h),
            WhiteCard(
              child: LocationTimeline(
                pickup: booking.pickupLocation,
                drop: booking.dropLocation,
              ),
            ),
            SizedBox(height: 12.h),
            _dutyCard(booking),
            SizedBox(height: 12.h),
            if (completed)
              _completedTrips(booking)
            else if (started)
              ..._endStep(booking)
            else
              ..._startStep(booking),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  // ── Step 1: Trip Start ──────────────────────────────────────────────────
  List<Widget> _startStep(BookingModel booking) => [
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
    SizedBox(height: 20.h),
    AppButton(
      label: 'Trip Start',
      onTap: () => _tripStart(booking),
      isLoading: _isLoading,
    ),
  ];

  // ── Step 2: Trip End ────────────────────────────────────────────────────
  List<Widget> _endStep(BookingModel booking) => [
    WhiteCard(
      child: TwoColRow(
        left: LabelledValue(label: 'Start OTP', value: booking.otp ?? '-'),
        right: LabelledValue(
          label: 'Start KM',
          value: booking.startKm?.toStringAsFixed(0) ?? '-',
          align: CrossAxisAlignment.end,
        ),
      ),
    ),
    SizedBox(height: 16.h),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const DetailHeading('Extra Expenses'),
        GestureDetector(
          onTap: () => context.push('/add-expense', extra: booking.id),
          child: Row(
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                color: AppColors.primary,
                size: 20.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                'Add Expense',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    SizedBox(height: 10.h),
    WhiteCard(
      child: booking.expenses.isEmpty
          ? Text(
              'No extra expenses added',
              style: TextStyle(fontSize: 13.sp, color: AppColors.labelGrey),
            )
          : Column(
              children: [
                for (final e in booking.expenses) _expenseRow(booking, e),
              ],
            ),
    ),
    SizedBox(height: 16.h),
    WhiteCard(
      child: Row(
        children: [
          Expanded(
            child: PillInput(
              label: 'End OTP',
              controller: _endOtpController,
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: PillInput(
              label: 'End KM',
              controller: _endKmController,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    ),
    SizedBox(height: 20.h),
    AppButton(
      label: 'Trip End',
      onTap: () => _tripEnd(booking),
      isLoading: _isLoading,
    ),
  ];

  // ── Completed: read-only summary (node 374:906) ───────────────────────────
  Widget _completedTrips(BookingModel booking) => WhiteCard(
    child: Column(
      children: [
        TwoColRow(
          left: LabelledValue(label: 'OTP', value: booking.otp ?? '-'),
          right: LabelledValue(
            label: 'Start KM',
            value: booking.startKm?.toStringAsFixed(0) ?? '-',
            align: CrossAxisAlignment.end,
          ),
        ),
        SizedBox(height: 14.h),
        TwoColRow(
          left: LabelledValue(label: 'OTP', value: booking.otp ?? '-'),
          right: LabelledValue(
            label: 'End KM',
            value: booking.endKm?.toStringAsFixed(0) ?? '-',
            align: CrossAxisAlignment.end,
          ),
        ),
      ],
    ),
  );

  Widget _guestCard(BookingModel booking, {required bool completed}) =>
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
                      label: completed ? 'Picked-up on' : 'Pickup date',
                      value: DateFormat(
                        'dd-MM-yyyy',
                      ).format(booking.scheduledDateTime),
                    ),
                    right: LabelledValue(
                      label: 'Pickup Time',
                      value: DateFormat(
                        'HH:mm:ss',
                      ).format(booking.scheduledDateTime),
                    ),
                  ),
                ],
              ),
            ),
            if (!completed) ...[
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
          ],
        ),
      );

  Widget _dutyCard(BookingModel booking) => WhiteCard(
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: LabelledValue(label: 'Duty Type', value: booking.dutyType),
        ),
        SizedBox(height: 14.h),
        TwoColRow(
          left: LabelledValue(label: 'Trip Type', value: booking.tripType),
          right: LabelledValue(
            label: 'Sub Trip Type',
            value: booking.subTripType,
            align: CrossAxisAlignment.end,
          ),
        ),
      ],
    ),
  );
}
