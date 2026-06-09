import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../widgets/detail_widgets.dart';

/// Figma "Add New Booking Request" — booking creation form.
class AddBookingRequestScreen extends StatefulWidget {
  const AddBookingRequestScreen({super.key});

  @override
  State<AddBookingRequestScreen> createState() =>
      _AddBookingRequestScreenState();
}

class _AddBookingRequestScreenState extends State<AddBookingRequestScreen> {
  final _customer = TextEditingController();
  final _postingDate = TextEditingController();
  final _guestName = TextEditingController();
  final _phone = TextEditingController();
  final _fromDate = TextEditingController();
  final _toDate = TextEditingController();
  final _pickup = TextEditingController();
  final _drop = TextEditingController();
  String? _vehicleType;
  String? _tripType;
  String? _subTripType;

  @override
  void dispose() {
    for (final c in [
      _customer,
      _postingDate,
      _guestName,
      _phone,
      _fromDate,
      _toDate,
      _pickup,
      _drop,
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
    c.text =
        '${date.day}/${date.month}/${date.year}  ${time.format(context)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: const VoyzoAppBar(title: 'Add New Booking Request'),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        child: Column(
          children: [
            WhiteCard(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  PillInput(label: 'Customer', controller: _customer),
                  SizedBox(height: 18.h),
                  PillInput(
                    label: 'Posting Date',
                    controller: _postingDate,
                    suffix: Icon(Icons.calendar_month_rounded,
                        color: AppColors.primary, size: 20.sp),
                  ),
                  SizedBox(height: 18.h),
                  PillInput(label: 'Guest Name', controller: _guestName),
                  SizedBox(height: 18.h),
                  PillInput(
                    label: 'Phone Number',
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 18.h),
                  GestureDetector(
                    onTap: () => _pickDateTime(_fromDate),
                    child: AbsorbPointer(
                      child: PillInput(
                        label: 'From Date & Time',
                        controller: _fromDate,
                        suffix: Icon(Icons.calendar_month_rounded,
                            color: AppColors.primary, size: 20.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  GestureDetector(
                    onTap: () => _pickDateTime(_toDate),
                    child: AbsorbPointer(
                      child: PillInput(
                        label: 'To Date & Time',
                        controller: _toDate,
                        suffix: Icon(Icons.calendar_month_rounded,
                            color: AppColors.primary, size: 20.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  _Dropdown(
                    label: 'Vehicle Type',
                    value: _vehicleType,
                    items: const ['Sedan', 'SUV', 'KUV', 'Hatchback'],
                    onChanged: (v) => setState(() => _vehicleType = v),
                  ),
                  SizedBox(height: 18.h),
                  PillInput(label: 'Pick Up Location', controller: _pickup),
                  SizedBox(height: 18.h),
                  PillInput(label: 'Drop off Location', controller: _drop),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      Expanded(
                        child: _Dropdown(
                          label: 'Trip Type',
                          value: _tripType,
                          items: const ['Transfer', 'Round Trip', 'Multi city'],
                          onChanged: (v) => setState(() => _tripType = v),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: _Dropdown(
                          label: 'Sub Trip Type',
                          value: _subTripType,
                          items: const ['One way', 'Two way'],
                          onChanged: (v) => setState(() => _subTripType = v),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            AppButton(
              label: 'Save',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Booking request saved'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r)),
                  ),
                );
                context.pop();
              },
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _Dropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary)),
        SizedBox(height: 8.h),
        DropdownButtonFormField2<String>(
          valueListenable: ValueNotifier(value),
          isExpanded: true,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
          ),
          items: items
              .map((e) => DropdownItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
