import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../core/constants/app_colors.dart';

/// White rounded card on the grey detail canvas (Figma).
class WhiteCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const WhiteCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 14,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Black section heading, e.g. "Guest Details".
class DetailHeading extends StatelessWidget {
  final String text;
  const DetailHeading(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }
}

/// A grey label with its value below — building block for the two-column rows.
class LabelledValue extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final CrossAxisAlignment align;
  final Widget? labelTrailing;
  const LabelledValue({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.align = CrossAxisAlignment.start,
    this.labelTrailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.labelGrey,
              ),
            ),
            if (labelTrailing != null) ...[SizedBox(width: 8.w), labelTrailing!],
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Two label/value pairs across a row (left-aligned and right-aligned).
class TwoColRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  const TwoColRow({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        Expanded(
          child: Align(alignment: Alignment.topRight, child: right),
        ),
      ],
    );
  }
}

/// Pick Up / Drop Off addresses with the amber→grey location pins (Figma).
class LocationTimeline extends StatelessWidget {
  final String pickup;
  final String drop;
  const LocationTimeline({super.key, required this.pickup, required this.drop});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _pin(AppColors.primary),
            Container(width: 1.5.w, height: 44.h, color: AppColors.outlineVariant),
            _pin(const Color(0xFF9FA5C0)),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _addr('Pick Up Location', pickup),
              SizedBox(height: 14.h),
              _addr('Drop Off Location', drop),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pin(Color color) => Container(
        width: 20.w,
        height: 20.w,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(Icons.location_on, size: 12.sp, color: Colors.white),
      );

  Widget _addr(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.labelGrey,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
        ],
      );
}

/// Outlined pill input used on the detail forms (Figma rounded fields).
class PillInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Widget? suffix;
  const PillInput({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            suffixIcon: suffix,
            border: _border(AppColors.outlineVariant),
            enabledBorder: _border(AppColors.outlineVariant),
            focusedBorder: _border(AppColors.primary),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: BorderSide(color: c),
      );
}

/// Outlined pill dropdown matching [PillInput] — a labelled rounded select used
/// on the driver detail forms (Figma).
class PillDropdown extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const PillDropdown({
    super.key,
    this.label,
    this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        DropdownButtonFormField2<String>(
          valueListenable: ValueNotifier(value),
          isExpanded: true,
          hint: hint == null
              ? null
              : Text(hint!,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.labelGrey)),
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            border: _border(AppColors.outlineVariant),
            enabledBorder: _border(AppColors.outlineVariant),
            focusedBorder: _border(AppColors.primary),
          ),
          items: items
              .map((e) => DropdownItem(
                    value: e,
                    child: Text(e,
                        style: TextStyle(
                            fontSize: 14.sp, color: AppColors.textPrimary)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: BorderSide(color: c),
      );
}
