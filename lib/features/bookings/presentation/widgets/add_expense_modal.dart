import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voyzo/features/auth/data/auth_api.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../data/models/expense_model.dart';
import '../providers/booking_provider.dart';

class AddExpenseModal extends ConsumerStatefulWidget {
  final String bookingId;
  const AddExpenseModal({super.key, required this.bookingId});

  @override
  ConsumerState<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends ConsumerState<AddExpenseModal> {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedType = ExpenseModel.expenseTypes.first;
  bool _billUploaded = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addExpense() async {
    print('ADD EXPENSE FUNCTION STARTED');
    final amount = double.tryParse(_amountController.text.trim());

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid amount'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await AuthApi.addExpense(
      bookingId: widget.bookingId,
      expenseType: _selectedType,
      price: amount,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to add expense'),
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
      id: 'EX${DateTime.now().millisecondsSinceEpoch}',
      type: _selectedType,
      amount: amount,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      addedAt: DateTime.now(),
    );

    ref.read(bookingProvider.notifier).addExpense(widget.bookingId, expense);

    final selectedBooking = ref.read(selectedBookingProvider);
    if (selectedBooking != null) {
      ref.read(selectedBookingProvider.notifier).state = selectedBooking
          .copyWith(expenses: [...selectedBooking.expenses, expense]);
    }

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$_selectedType expense of ₹${amount.toStringAsFixed(0)} added',
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12.h),
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Expense',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Expense type
            Text(
              'Expense Type',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: ExpenseModel.expenseTypes.map((type) {
                final isSelected = type == _selectedType;
                return GestureDetector(
                  onTap: () => setState(() => _selectedType = type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.outlineVariant,
                      ),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20.h),

            // Amount
            Text(
              'Amount (₹)',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
              ],
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: '0.00',
                prefixText: '₹  ',
                prefixStyle: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
                hintStyle: TextStyle(
                  color: AppColors.outlineVariant,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Notes
            Text(
              'Notes (Optional)',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _notesController,
              maxLines: 2,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'e.g. Toll at NH48 expressway',
              ),
            ),
            SizedBox(height: 16.h),

            // Upload bill
            GestureDetector(
              onTap: () => setState(() => _billUploaded = !_billUploaded),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: _billUploaded
                      ? AppColors.successContainer
                      : AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: _billUploaded
                        ? AppColors.success
                        : AppColors.outlineVariant,
                    style: BorderStyle.solid,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _billUploaded
                          ? Icons.check_circle_rounded
                          : Icons.upload_file_rounded,
                      color: _billUploaded
                          ? AppColors.success
                          : AppColors.textHint,
                      size: 28.sp,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _billUploaded ? 'Bill uploaded' : 'Upload Bill / Photo',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: _billUploaded
                            ? AppColors.success
                            : AppColors.textHint,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            AppButton(
              label: 'Add Expense',
              onTap: _isLoading
                  ? null
                  : () {
                      print('APP BUTTON CLICKED');
                      _addExpense();
                    },
              isLoading: _isLoading,
              icon: Icons.add_circle_outline_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
