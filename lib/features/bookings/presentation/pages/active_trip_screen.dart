import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../../data/models/booking_model.dart';
import '../providers/booking_provider.dart';
import '../widgets/add_expense_modal.dart';
import '../widgets/trip_widgets.dart';

class ActiveTripScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const ActiveTripScreen({super.key, required this.bookingId});

  @override
  ConsumerState<ActiveTripScreen> createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends ConsumerState<ActiveTripScreen> {
  late Timer _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _timerText {
    final h = _elapsed.inHours.toString().padLeft(2, '0');
    final m = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  void _showAddExpense(String bookingId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddExpenseModal(bookingId: bookingId),
    );
  }

  void _showEndTripDialog(BookingModel booking) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _EndTripDialog(
        booking: booking,
        onConfirm: (endKm) {
          ref.read(bookingProvider.notifier).endTrip(booking.id, endKm);
          context.pushReplacement('/payment', extra: booking.id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final booking = ref.watch(bookingProvider.select((s) =>
        s.bookings.firstWhere((b) => b.id == widget.bookingId,
            orElse: () => s.bookings.first)));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VoyzoAppBar(title: 'Active Trip'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active status + timer banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A1B9A), Color(0xFF4A148C)],
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 7.w,
                          height: 7.h,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.greenAccent.withOpacity(0.6),
                                blurRadius: 4,
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          'ACTIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Trip Duration',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 10.sp,
                        ),
                      ),
                      Text(
                        _timerText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),

            // Guest card
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                      icon: Icons.person_rounded, label: 'Guest Details'),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24.r,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          booking.passengerName
                              .substring(0, 2)
                              .toUpperCase(),
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
                            Text(
                              '${booking.bookingCode}  •  ${booking.bookingType}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.call_rounded,
                          color: AppColors.primary, size: 22.sp),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Route
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                      icon: Icons.route_rounded, label: 'Trip Route'),
                  SizedBox(height: 14.h),
                  RouteTimeline(
                    pickup: booking.pickupLocation,
                    drop: booking.dropLocation,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Trip info
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                      icon: Icons.info_outline_rounded, label: 'Trip Info'),
                  SizedBox(height: 12.h),
                  InfoRow(
                    label: 'Start KM',
                    value: '${booking.startKm?.toStringAsFixed(0) ?? '--'} km',
                  ),
                  InfoRow(
                    label: 'Started At',
                    value: booking.startTime != null
                        ? DateFormat('hh:mm a').format(booking.startTime!)
                        : '--',
                  ),
                  InfoRow(
                    label: 'Base Fare',
                    value: '₹ ${booking.tripAmount.toStringAsFixed(0)}',
                  ),
                  if (booking.expenses.isNotEmpty)
                    InfoRow(
                      label: 'Extra Expenses',
                      value:
                          '₹ ${booking.totalExpenses.toStringAsFixed(0)}',
                      highlight: true,
                    ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Expenses
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SectionTitle(
                          icon: Icons.receipt_long_rounded,
                          label: 'Extra Expenses'),
                      GestureDetector(
                        onTap: () => _showAddExpense(booking.id),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                                color: AppColors.outlineVariant),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.add_rounded,
                                  size: 14.sp, color: AppColors.primary),
                              SizedBox(width: 4.w),
                              Text(
                                'Add',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  if (booking.expenses.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'No expenses added yet',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    )
                  else
                    ...booking.expenses.map((e) => _ExpenseRow(expense: e)),
                  if (booking.expenses.isNotEmpty) ...[
                    Divider(color: AppColors.divider),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Expenses',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '₹ ${booking.totalExpenses.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Add Expenses',
                    onTap: () => _showAddExpense(booking.id),
                    variant: AppButtonVariant.outline,
                    icon: Icons.add_rounded,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AppButton(
                    label: 'End Trip',
                    onTap: () => _showEndTripDialog(booking),
                    variant: AppButtonVariant.danger,
                    icon: Icons.stop_circle_outlined,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  final dynamic expense;
  const _ExpenseRow({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              _iconForType(expense.type),
              size: 16.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.type,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (expense.notes != null)
                  Text(
                    expense.notes!,
                    style: TextStyle(
                        fontSize: 11.sp, color: AppColors.textHint),
                  ),
              ],
            ),
          ),
          Text(
            '₹ ${expense.amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'Toll':
        return Icons.toll_rounded;
      case 'Fuel':
        return Icons.local_gas_station_rounded;
      case 'Parking':
        return Icons.local_parking_rounded;
      case 'Food':
        return Icons.fastfood_rounded;
      case 'Maintenance':
        return Icons.build_rounded;
      default:
        return Icons.receipt_rounded;
    }
  }
}

class _EndTripDialog extends StatefulWidget {
  final BookingModel booking;
  final void Function(double endKm) onConfirm;

  const _EndTripDialog({required this.booking, required this.onConfirm});

  @override
  State<_EndTripDialog> createState() => _EndTripDialogState();
}

class _EndTripDialogState extends State<_EndTripDialog> {
  final _endKmController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _endKmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalExp = widget.booking.totalExpenses;
    final fare = widget.booking.tripAmount;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.stop_circle_rounded,
                      color: AppColors.error, size: 24.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'End Trip?',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close_rounded,
                      color: AppColors.textSecondary, size: 20.sp),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              'Are you sure you want to end this trip?',
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 20.h),

            // Summary
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  _SummaryRow(
                      label: 'Passenger', value: widget.booking.passengerName),
                  _SummaryRow(
                      label: 'Base Fare',
                      value: '₹ ${fare.toStringAsFixed(0)}'),
                  if (totalExp > 0)
                    _SummaryRow(
                        label: 'Extra Expenses',
                        value: '₹ ${totalExp.toStringAsFixed(0)}'),
                  Divider(color: AppColors.outlineVariant),
                  _SummaryRow(
                    label: 'Total Amount',
                    value: '₹ ${(fare + totalExp).toStringAsFixed(0)}',
                    bold: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            Text(
              'End KM Reading',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _endKmController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
              ],
              decoration: InputDecoration(
                hintText: 'e.g. 12720',
                prefixIcon: const Icon(Icons.speed_outlined,
                    color: AppColors.textHint),
              ),
            ),
            SizedBox(height: 20.h),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                      side: const BorderSide(color: AppColors.outlineVariant),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() => _isLoading = true);
                            await Future.delayed(
                                const Duration(milliseconds: 600));
                            final km = double.tryParse(
                                    _endKmController.text.trim()) ??
                                0;
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              widget.onConfirm(km);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 18.w,
                            height: 18.h,
                            child: const CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            'Confirm',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
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
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _SummaryRow(
      {required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              color: bold ? AppColors.primary : AppColors.textPrimary,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
