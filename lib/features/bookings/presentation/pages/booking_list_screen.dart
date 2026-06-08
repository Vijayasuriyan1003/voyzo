import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/mock_data/mock_data.dart';
import '../../../../shared/widgets/driver_bottom_nav.dart';
import '../widgets/trip_list_card.dart';

/// Figma "Booking Lists" — Open / Completed / Cancelled / Draft, with a + to
/// add a new booking request.
class BookingListScreen extends StatelessWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = MockData.bookingList;
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: _ListAppBar(
        title: 'Booking Lists',
        onAdd: () => context.push('/add-booking-request'),
        onRequests: () => context.push('/booking-request'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final b = items[i];
          return TripListCard(
            code: b.bookingCode,
            date: DateFormat('dd-MM-yyyy').format(b.scheduledDateTime),
            time: DateFormat('HH:mm:ss').format(b.scheduledDateTime),
            status: b.status,
            onTap: () => context.push('/booking-details', extra: b.id),
          );
        },
      ),
      bottomNavigationBar: const DriverBottomNav(currentIndex: 1),
    );
  }
}

/// White app bar with a centered title and a trailing amber "+" button.
class _ListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onAdd;
  final VoidCallback? onRequests;
  const _ListAppBar({required this.title, required this.onAdd, this.onRequests});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0.5,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        if (onRequests != null)
          IconButton(
            onPressed: onRequests,
            icon: Icon(Icons.fact_check_outlined,
                color: AppColors.textPrimary, size: 22.sp),
          ),
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add_rounded, color: Colors.white, size: 24.sp),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
