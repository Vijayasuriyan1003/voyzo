import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:voyzo/features/auth/data/auth_api.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../../data/models/expense_model.dart';
import '../providers/booking_provider.dart';
import '../widgets/detail_widgets.dart';

/// Figma "Add Expense" (node 463:1244) — Charges Type, Amount and an upload
/// field, with a Save button. Adds (or, when [expenseId] is given, edits) an
/// extra charge on the active trip.
class AddExpenseScreen extends ConsumerStatefulWidget {
  final String bookingId;
  final String? expenseId;
  const AddExpenseScreen({super.key, required this.bookingId, this.expenseId});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  String? _type;
  final _amount = TextEditingController();
  String? _fileName;

  bool get _isEdit => widget.expenseId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final booking = ref
          .read(bookingProvider.notifier)
          .getBookingById(widget.bookingId);
      for (final e in booking?.expenses ?? const <ExpenseModel>[]) {
        if (e.id == widget.expenseId) {
          _type = e.type;
          _amount.text = e.amount.toStringAsFixed(0);
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amt = double.tryParse(_amount.text.trim());

    if (_type == null || amt == null || amt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Select a charge type and enter an amount'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
      return;
    }

    final expense = ExpenseModel(
      id: widget.expenseId ?? 'EX${DateTime.now().millisecondsSinceEpoch}',
      type: _type!,
      amount: amt,
      addedAt: DateTime.now(),
    );

    if (_isEdit) {
      ref
          .read(bookingProvider.notifier)
          .updateExpense(widget.bookingId, expense);
      ref.read(selectedBookingProvider.notifier).update((booking) {
        if (booking == null) return null;
        return booking.copyWith(
          expenses: booking.expenses
              .map((e) => e.id == expense.id ? expense : e)
              .toList(),
        );
      });

      context.pop();
      return;
    }

    final success = await AuthApi.addExpense(
      bookingId: widget.bookingId,
      expenseType: _type!,
      price: amt,
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to add expense in ERP'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
      return;
    }

    ref.read(bookingProvider.notifier).addExpense(widget.bookingId, expense);

    ref.read(selectedBookingProvider.notifier).update((booking) {
      if (booking == null) return null;
      return booking.copyWith(expenses: [...booking.expenses, expense]);
    });

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: VoyzoAppBar(title: _isEdit ? 'Edit Expense' : 'Add Expense'),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Charges Type',
              style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
            ),
            SizedBox(height: 8.h),
            DropdownButtonFormField2<String>(
              valueListenable: ValueNotifier(_type),
              isExpanded: true,
              hint: Text(
                'Select charge type',
                style: TextStyle(fontSize: 14.sp, color: AppColors.labelGrey),
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
                border: _border(AppColors.outlineVariant),
                enabledBorder: _border(AppColors.outlineVariant),
                focusedBorder: _border(AppColors.primary),
              ),
              items: ExpenseModel.expenseTypes
                  .map((t) => DropdownItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => _type = v),
            ),
            SizedBox(height: 20.h),
            PillInput(
              label: 'Amount',
              hint: 'INR.',
              controller: _amount,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.h),
            Text(
              'Upload multiple files',
              style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () => setState(() => _fileName = 'receipt_01.jpg'),
              child: Container(
                width: double.infinity,
                height: 96.h,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      color: AppColors.labelGrey,
                      size: 26.sp,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _fileName ?? 'Tap to upload files',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.labelGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32.h),
            AppButton(label: 'Save', onTap: _save),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.r),
    borderSide: BorderSide(color: c),
  );
}
