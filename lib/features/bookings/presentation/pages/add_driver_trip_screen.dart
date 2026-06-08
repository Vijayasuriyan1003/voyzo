import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../widgets/detail_widgets.dart';

/// Figma "Add New Driver Trip" (Frame 7) — the driver manually logs a trip:
/// Booking ID, Driver Name/ID, Trip Start/End, OTP, Start/End KM, Trip Type,
/// Sub Trip Type, Fuel and Status.
class AddDriverTripScreen extends StatefulWidget {
  const AddDriverTripScreen({super.key});

  @override
  State<AddDriverTripScreen> createState() => _AddDriverTripScreenState();
}

class _AddDriverTripScreenState extends State<AddDriverTripScreen> {
  final _bookingId = TextEditingController();
  final _driverName = TextEditingController();
  final _driverId = TextEditingController();
  final _tripStart = TextEditingController();
  final _tripEnd = TextEditingController();
  final _otp = TextEditingController();
  final _startKm = TextEditingController();
  final _endKm = TextEditingController();
  final _fuel = TextEditingController();
  String? _tripType;
  String? _subTripType;
  String? _status;
  bool _isLoading = false;

  @override
  void dispose() {
    for (final c in [
      _bookingId,
      _driverName,
      _driverId,
      _tripStart,
      _tripEnd,
      _otp,
      _startKm,
      _endKm,
      _fuel,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDateTime(TextEditingController c) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null || !mounted) return;
    setState(() {
      c.text = '${date.day.toString().padLeft(2, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-${date.year}  '
          '${time.format(context)}';
    });
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

  Future<void> _save() async {
    if (_bookingId.text.trim().isEmpty ||
        _driverName.text.trim().isEmpty ||
        _tripStart.text.trim().isEmpty) {
      _toast('Enter Booking ID, Driver Name and Trip Start', AppColors.error);
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _toast('Driver trip saved', AppColors.success);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: const VoyzoAppBar(title: 'Add New Driver Trip'),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DetailHeading('Driver Details'),
            SizedBox(height: 10.h),
            WhiteCard(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  PillInput(label: 'Booking ID', controller: _bookingId),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      Expanded(
                        child: PillInput(
                            label: 'Driver Name', controller: _driverName),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child:
                            PillInput(label: 'Driver ID', controller: _driverId),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  GestureDetector(
                    onTap: () => _pickDateTime(_tripStart),
                    child: AbsorbPointer(
                      child: PillInput(
                        label: 'Trip Start',
                        controller: _tripStart,
                        suffix: Icon(Icons.calendar_month_rounded,
                            color: AppColors.primary, size: 20.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  GestureDetector(
                    onTap: () => _pickDateTime(_tripEnd),
                    child: AbsorbPointer(
                      child: PillInput(
                        label: 'Trip End',
                        controller: _tripEnd,
                        suffix: Icon(Icons.calendar_month_rounded,
                            color: AppColors.primary, size: 20.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      Expanded(
                        child: PillInput(
                          label: 'OTP',
                          controller: _otp,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: PillInput(
                          label: 'Fuel',
                          controller: _fuel,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      Expanded(
                        child: PillInput(
                          label: 'Start KM',
                          controller: _startKm,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: PillInput(
                          label: 'End KM',
                          controller: _endKm,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      Expanded(
                        child: PillDropdown(
                          label: 'Trip Type',
                          value: _tripType,
                          items: const ['Transfer', 'Round Trip', 'Multi city'],
                          onChanged: (v) => setState(() => _tripType = v),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: PillDropdown(
                          label: 'Sub Trip Type',
                          value: _subTripType,
                          items: const ['One way', 'Two way'],
                          onChanged: (v) => setState(() => _subTripType = v),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  PillDropdown(
                    label: 'Status',
                    value: _status,
                    items: const [
                      'Open',
                      'On Going',
                      'Completed',
                      'Cancelled',
                      'Draft',
                    ],
                    onChanged: (v) => setState(() => _status = v),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            AppButton(label: 'Save', onTap: _save, isLoading: _isLoading),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
