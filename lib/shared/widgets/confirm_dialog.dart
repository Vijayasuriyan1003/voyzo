import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import 'app_button.dart';

/// Figma "Are you sure?" delete confirmation (node 464:1330) — a white rounded
/// card over a scrim with a title, message and two buttons. Resolves to `true`
/// when the destructive action is confirmed.
Future<bool> showConfirmDialog(
  BuildContext context, {
  String title = 'Are you sure?',
  String message = 'Do you want to delete this expense?',
  String confirmLabel = 'Yes',
  String cancelLabel = 'No',
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: const Color(0x99000000),
    builder: (ctx) => Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: AppColors.labelGrey),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: cancelLabel,
                    height: 46,
                    variant: AppButtonVariant.outline,
                    onTap: () => Navigator.of(ctx).pop(false),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AppButton(
                    label: confirmLabel,
                    height: 46,
                    onTap: () => Navigator.of(ctx).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  return result ?? false;
}
