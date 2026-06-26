import 'package:go_router/go_router.dart';
import 'package:voyzo/features/auth/presentation/pages/booking_success_page.dart';
import 'package:voyzo/features/auth/presentation/pages/cancel_booking_page.dart';
import 'package:voyzo/features/auth/presentation/pages/customer_booking_details_page.dart';
import 'package:voyzo/features/auth/presentation/pages/customer_booking_history_page.dart';
import 'package:voyzo/features/auth/presentation/pages/customer_login_page.dart';
import 'package:voyzo/features/auth/presentation/pages/customer_profile_page.dart';
import 'package:voyzo/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:voyzo/features/auth/presentation/pages/info_page.dart';
import 'package:voyzo/features/auth/presentation/pages/login_otp_verification.dart';
import 'package:voyzo/features/auth/presentation/pages/otp_login_page.dart';
import 'package:voyzo/features/auth/presentation/pages/payment_options_page.dart';
import 'package:voyzo/features/auth/presentation/pages/payment_page.dart';
import 'package:voyzo/features/auth/presentation/pages/register_otp_page.dart';
import 'package:voyzo/features/auth/presentation/pages/register_screen.dart';
import 'package:voyzo/features/auth/presentation/pages/review_page.dart';
import 'package:voyzo/features/auth/presentation/pages/set_new_password_page.dart';
import 'package:voyzo/features/auth/presentation/pages/splash_screen.dart';
import 'package:voyzo/features/auth/presentation/pages/forgot_otp_page.dart';
import 'package:voyzo/features/home/presentation/pages/home_page.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/bookings/presentation/pages/booking_history_screen.dart';
import '../features/bookings/presentation/pages/booking_list_screen.dart';
import '../features/bookings/presentation/pages/booking_request_screen.dart';
import '../features/bookings/presentation/pages/add_booking_request_screen.dart';
import '../features/bookings/presentation/pages/add_driver_trip_screen.dart';
import '../features/bookings/presentation/pages/add_expense_screen.dart';
import '../features/bookings/presentation/pages/booking_details_screen.dart';
import '../features/bookings/presentation/pages/payment_screen.dart';
import '../features/bookings/presentation/pages/payment_received_screen.dart';
import '../features/bookings/presentation/pages/trip_completed_summary_screen.dart';
import '../features/bookings/presentation/pages/trip_details_screen.dart';
import '../features/bookings/presentation/pages/active_trip_screen.dart';
import '../features/profile/presentation/pages/profile_screen.dart';
import '../features/profile/presentation/pages/setting_screen.dart';
import '../features/profile/presentation/pages/edit_profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/info_page', builder: (context, state) => const InfoPage()),
    GoRoute(
      path: '/customer_login',
      builder: (context, state) => const CustomerLoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/register_otp',
      builder: (context, state) => RegisterOtpPage(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/forgot_otp',
      builder: (context, state) => const ForgotOtpPage(),
    ),
    GoRoute(
      path: '/set_new_password',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        return SetNewPasswordPage(
          isChangePassword: extra?['isChangePassword'] ?? false,
        );
      },
    ),
    GoRoute(
      path: '/otp_login',
      builder: (context, state) => const OtpLoginPage(),
    ),
    GoRoute(
      path: '/login_otp_verification',
      builder: (context, state) => const LoginOtpVerification(),
    ),
    GoRoute(path: '/home_page', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/customer_profile',
      builder: (context, state) => const CustomerProfilePage(),
    ),
    GoRoute(
      path: '/booking_success',
      builder: (context, state) {
        final data = state.extra as Map<String, String>;

        return BookingSuccessPage(dateTime: data['dateTime'] ?? '');
      },
    ),
    GoRoute(
      path: '/customer_booking_history',
      builder: (context, state) => const CustomerBookingHistoryPage(),
    ),
    GoRoute(
      path: '/customer_booking_details',
      builder: (context, state) => const CustomerBookingDetailsPage(),
    ),
    GoRoute(
      path: '/cancel_booking',
      builder: (context, state) => const CancelBookingPage(),
    ),
    GoRoute(
      path: '/payment_details',
      builder: (context, state) => const PaymentPage(),
    ),
    GoRoute(
      path: '/payment-options',
      builder: (context, state) => const PaymentOptionsPage(),
    ),
    GoRoute(
      path: '/review_page',
      builder: (context, state) => const ReviewPage(),
    ),

    // ── Driver flow ──────────────────────────────────────────────────────────
    // Login → Booking History → Trip Details (Trip Start); Profile via avatar.
    GoRoute(
      path: '/booking-history',
      builder: (context, state) => const BookingHistoryScreen(),
    ),
    // Aliases (back-compat).
    GoRoute(
      path: '/trip-list',
      builder: (context, state) => const BookingHistoryScreen(),
    ),
    GoRoute(
      path: '/bookings',
      builder: (context, state) => const BookingHistoryScreen(),
    ),
    GoRoute(
      path: '/booking-list',
      builder: (context, state) => const BookingListScreen(),
    ),
    GoRoute(
      path: '/booking-request',
      builder: (context, state) => const BookingRequestScreen(),
    ),
    GoRoute(
      path: '/add-booking-request',
      builder: (context, state) => const AddBookingRequestScreen(),
    ),
    GoRoute(
      path: '/add-driver-trip',
      builder: (context, state) => const AddDriverTripScreen(),
    ),
    GoRoute(
      path: '/booking-details',
      builder: (context, state) =>
          BookingDetailsScreen(bookingId: state.extra as String),
    ),
    GoRoute(
      path: '/trip-details',
      builder: (context, state) {
        return const TripDetailsScreen();
      },
    ),
    GoRoute(
      path: '/add-expense',
      builder: (context, state) {
        final extra = state.extra;

        if (extra is Map) {
          return AddExpenseScreen(
            bookingId: extra['bookingId']?.toString() ?? '',
            expenseId: extra['expenseId']?.toString(),
          );
        }

        return AddExpenseScreen(bookingId: extra?.toString() ?? '');
      },
    ),
    GoRoute(
      path: '/active-trip',
      builder: (context, state) =>
          ActiveTripScreen(bookingId: state.extra as String),
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) =>
          PaymentScreen(bookingId: state.extra as String),
    ),
    GoRoute(
      path: '/payment-received',
      builder: (context, state) =>
          PaymentReceivedScreen(bookingId: state.extra as String),
    ),
    GoRoute(
      path: '/trip-completed',
      builder: (context, state) =>
          TripCompletedSummaryScreen(bookingId: state.extra as String),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/setting',
      builder: (context, state) => const SettingScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
  ],
);
