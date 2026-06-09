import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/mock_data/mock_data.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';
import '../widgets/trip_list_card.dart';

/// Figma "Booking Request" — Booked / Cancelled / Draft, with a + to add one.
class BookingRequestScreen extends StatelessWidget {
  const BookingRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = MockData.bookingRequests;
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: VoyzoAppBar(
        title: 'Booking Request',
        showProfile: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () => context.push('/add-booking-request'),
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
    );
  }
}
