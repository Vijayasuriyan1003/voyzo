import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/features/auth/presentation/pages/customer_login_page.dart';
import 'package:voyzo/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:voyzo/features/auth/presentation/pages/info_page1.dart';
import 'package:voyzo/features/auth/presentation/pages/info_page2.dart';
import 'package:voyzo/features/auth/presentation/pages/login_otp_verification.dart';
import 'package:voyzo/features/auth/presentation/pages/otp_login_page.dart';
import 'package:voyzo/features/auth/presentation/pages/register_otp_page.dart';
import 'package:voyzo/features/auth/presentation/pages/register_screen.dart';
import 'package:voyzo/features/auth/presentation/pages/set_new_password_page.dart';
import 'package:voyzo/features/auth/presentation/pages/splash_screen.dart';
import 'package:voyzo/features/auth/presentation/pages/forgot_otp_page.dart';
import 'package:voyzo/features/home/presentation/pages/home_page.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/bookings/presentation/pages/booking_history_screen.dart';
import '../features/bookings/presentation/pages/trip_completed_summary_screen.dart';
import '../features/bookings/presentation/pages/trip_details_screen.dart';
import '../features/bookings/presentation/pages/active_trip_screen.dart';
import '../features/profile/presentation/pages/edit_profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/info_page1',
      builder: (context, state) => const InfoPage1(),
    ),
    GoRoute(
      path: '/info_page2',
      builder: (context, state) => const InfoPage2(),
    ),
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
      builder: (context, state) => const SetNewPasswordPage(),
    ),
    GoRoute(
      path: '/otp_login',
      builder: ((context, state) => const OtpLoginPage()),
    ),
    GoRoute(
      path: '/login_otp_verification',
      builder: ((context, state) => const LoginOtpVerification()),
    ),
    GoRoute(path: '/home_page', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/bookings',
      builder: (context, state) => const BookingHistoryScreen(),
    ),
    GoRoute(
      path: '/trip-completed',
      builder: (context, state) {
        final bookingId = state.extra as String;
        return TripCompletedSummaryScreen(bookingId: bookingId);
      },
    ),
    GoRoute(
      path: '/trip-details',
      builder: (context, state) {
        final bookingId = state.extra as String;
        return TripDetailsScreen(bookingId: bookingId);
      },
    ),
    GoRoute(
      path: '/active-trip',
      builder: (context, state) {
        final bookingId = state.extra as String;
        return ActiveTripScreen(bookingId: bookingId);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
  ],
);
