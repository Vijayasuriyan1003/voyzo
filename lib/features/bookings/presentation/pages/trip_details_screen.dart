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

/// Figma driver "Trip Details" (node 350:1255 + states). Two steps:
///  • Trip Start  — OTP + Start KM, "Trip Start" button.
///  • Trip End    — Start OTP/KM (read-only) + Extra Expenses + End OTP + End KM,
///    "Trip End" button.
/// The step shown depends on the booking status (upcoming → start, active → end).
class TripDetailsScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const TripDetailsScreen({super.key, required this.bookingId});

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  Future<void> _tripStart(BookingModel booking) async {
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
    await Future.delayed(const Duration(milliseconds: 600));
    final km = double.tryParse(_startKmController.text.trim()) ?? 0;
    ref.read(bookingProvider.notifier).startTrip(booking.id, km);
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

  void _addExpense(BookingModel booking, String type, double amount) {
    ref.read(bookingProvider.notifier).addExpense(
          booking.id,
          ExpenseModel(
            id: 'EX${DateTime.now().millisecondsSinceEpoch}',
            type: type,
            amount: amount,
            addedAt: DateTime.now(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final booking =
        ref.watch(bookingProvider.notifier).getBookingById(widget.bookingId);
    if (booking == null) {
      return const Scaffold(body: Center(child: Text('Booking not found')));
    }
    final started = booking.status == BookingStatus.active;

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: const VoyzoAppBar(title: 'Trip Details'),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DetailHeading('Guest Details'),
            SizedBox(height: 10.h),
            _guestCard(booking),
            SizedBox(height: 12.h),
            _dutyCard(booking),
            SizedBox(height: 12.h),
            WhiteCard(
              child: LocationTimeline(
                pickup: booking.pickupLocation,
                drop: booking.dropLocation,
              ),
            ),
            SizedBox(height: 12.h),
            if (!started) ..._startStep(booking) else ..._endStep(booking),
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
        // Start OTP / Start KM (entered values, read-only).
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
        const DetailHeading('Extra Expenses'),
        SizedBox(height: 10.h),
        _ExpensesCard(
          expenses: booking.expenses,
          onAdd: (type, amount) => _addExpense(booking, type, amount),
        ),
        SizedBox(height: 16.h),
        // End OTP / End KM.
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

  Widget _guestCard(BookingModel booking) => WhiteCard(
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

/// Extra Expenses card — lists existing Toll/Night/Parking charges and lets the
/// driver add another (Charges Type + Amount).
class _ExpensesCard extends StatefulWidget {
  final List<ExpenseModel> expenses;
  final void Function(String type, double amount) onAdd;
  const _ExpensesCard({required this.expenses, required this.onAdd});

  @override
  State<_ExpensesCard> createState() => _ExpensesCardState();
}

class _ExpensesCardState extends State<_ExpensesCard> {
  String? _type;
  final _amount = TextEditingController();
  bool _adding = false;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _submit() {
    final amt = double.tryParse(_amount.text.trim());
    if (_type == null || amt == null || amt <= 0) return;
    widget.onAdd(_type!, amt);
    setState(() {
      _type = null;
      _amount.clear();
      _adding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...widget.expenses.map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    e.notes ?? e.type,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
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
                ],
              ),
            ),
          ),
          if (_adding) ...[
            SizedBox(height: 4.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
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
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 12.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            borderSide: const BorderSide(
                                color: AppColors.outlineVariant),
                          ),
                        ),
                        items: ExpenseModel.expenseTypes
                            .map((t) =>
                                DropdownItem(value: t, child: Text(t)))
                            .toList(),
                        onChanged: (v) => setState(() => _type = v),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: PillInput(
                    label: 'Amount',
                    controller: _amount,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Add',
                    height: 44,
                    onTap: _submit,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AppButton(
                    label: 'Cancel',
                    height: 44,
                    variant: AppButtonVariant.outline,
                    onTap: () => setState(() => _adding = false),
                  ),
                ),
              ],
            ),
          ] else
            GestureDetector(
              onTap: () => setState(() => _adding = true),
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline_rounded,
                      color: AppColors.primary, size: 20.sp),
                  SizedBox(width: 6.w),
                  Text(
                    'Add Charges',
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
    );
  }
}
