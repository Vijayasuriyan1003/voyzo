import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/application/auth_controller.dart';
import '../features/auth/presentation/pages/customer_login_page.dart';
import '../features/auth/presentation/pages/forgot_otp_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/info_page1.dart';
import '../features/auth/presentation/pages/info_page2.dart';
import '../features/auth/presentation/pages/login_otp_verification.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/otp_login_page.dart';
import '../features/auth/presentation/pages/register_otp_page.dart';
import '../features/auth/presentation/pages/register_screen.dart';
import '../features/auth/presentation/pages/set_new_password_page.dart';
import '../features/auth/presentation/pages/splash_screen.dart';
import '../features/bookings/presentation/pages/active_trip_screen.dart';
import '../features/bookings/presentation/pages/add_booking_request_screen.dart';
import '../features/bookings/presentation/pages/add_driver_trip_screen.dart';
import '../features/bookings/presentation/pages/add_expense_screen.dart';
import '../features/bookings/presentation/pages/booking_details_screen.dart';
import '../features/bookings/presentation/pages/booking_history_screen.dart';
import '../features/bookings/presentation/pages/booking_list_screen.dart';
import '../features/bookings/presentation/pages/booking_request_screen.dart';
import '../features/bookings/presentation/pages/payment_received_screen.dart';
import '../features/bookings/presentation/pages/payment_screen.dart';
import '../features/bookings/presentation/pages/trip_completed_summary_screen.dart';
import '../features/bookings/presentation/pages/trip_details_screen.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/profile/presentation/pages/edit_profile_screen.dart';
import '../features/profile/presentation/pages/profile_screen.dart';
import '../features/profile/presentation/pages/setting_screen.dart';

/// Bridges the Riverpod auth state to GoRouter's refreshListenable mechanism.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref.listen(authControllerProvider, (_, __) => notifyListeners());
  }
}

/// Set of path prefixes that belong to the unauthenticated flow.
bool _isAuthPath(String loc) =>
    loc == '/splash' ||
    loc == '/info_page1' ||
    loc == '/info_page2' ||
    loc.startsWith('/login') ||
    loc == '/customer_login' ||
    loc == '/register' ||
    loc == '/register_otp' ||
    loc == '/forgot_password' ||
    loc == '/forgot_otp' ||
    loc == '/set_new_password' ||
    loc == '/otp_login' ||
    loc == '/login_otp_verification';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final loc = state.matchedLocation;

      switch (auth.status) {
        case AuthStatus.unknown:
          // Session restore in progress — stay on splash.
          return loc == '/splash' ? null : '/splash';

        case AuthStatus.unauthenticated:
          // Allow all auth/onboarding paths; redirect anything else to login.
          if (_isAuthPath(loc)) return null;
          return '/customer_login';

        case AuthStatus.authenticated:
          // Redirect away from auth screens to the role-appropriate home.
          if (_isAuthPath(loc)) {
            return auth.isDriver ? '/booking-history' : '/home_page';
          }
          return null;
      }
    },
    routes: [
      // ── Unauthenticated / onboarding ──────────────────────────────────────
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/info_page1', builder: (_, __) => const InfoPage1()),
      GoRoute(path: '/info_page2', builder: (_, __) => const InfoPage2()),
      GoRoute(
          path: '/customer_login',
          builder: (_, __) => const CustomerLoginPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(path: '/register_otp', builder: (_, __) => RegisterOtpPage()),
      GoRoute(
          path: '/forgot_password',
          builder: (_, __) => const ForgotPasswordPage()),
      GoRoute(path: '/forgot_otp', builder: (_, __) => const ForgotOtpPage()),
      GoRoute(
          path: '/set_new_password',
          builder: (_, __) => const SetNewPasswordPage()),
      GoRoute(path: '/otp_login', builder: (_, __) => const OtpLoginPage()),
      GoRoute(
          path: '/login_otp_verification',
          builder: (_, __) => const LoginOtpVerification()),

      // ── Customer home ──────────────────────────────────────────────────────
      GoRoute(path: '/home_page', builder: (_, __) => const HomePage()),

      // ── Driver – booking history (primary home for drivers) ───────────────
      GoRoute(
          path: '/booking-history',
          builder: (_, __) => const BookingHistoryScreen()),
      GoRoute(
          path: '/booking-list',
          builder: (_, __) => const BookingListScreen()),
      GoRoute(
          path: '/booking-request',
          builder: (_, __) => const BookingRequestScreen()),
      GoRoute(
          path: '/add-booking-request',
          builder: (_, __) => const AddBookingRequestScreen()),
      GoRoute(
          path: '/add-driver-trip',
          builder: (_, __) => const AddDriverTripScreen()),
      GoRoute(
        path: '/booking-details',
        builder: (_, s) =>
            BookingDetailsScreen(bookingId: s.extra as String),
      ),
      GoRoute(
        path: '/trip-details',
        builder: (_, s) =>
            TripDetailsScreen(bookingId: s.extra as String),
      ),
      GoRoute(
        path: '/add-expense',
        builder: (_, s) {
          final extra = s.extra;
          if (extra is Map) {
            return AddExpenseScreen(
              bookingId: extra['bookingId'] as String,
              expenseId: extra['expenseId'] as String?,
            );
          }
          return AddExpenseScreen(bookingId: extra as String);
        },
      ),
      GoRoute(
        path: '/active-trip',
        builder: (_, s) =>
            ActiveTripScreen(bookingId: s.extra as String),
      ),
      GoRoute(
        path: '/payment',
        builder: (_, s) =>
            PaymentScreen(bookingId: s.extra as String),
      ),
      GoRoute(
        path: '/payment-received',
        builder: (_, s) =>
            PaymentReceivedScreen(bookingId: s.extra as String),
      ),
      GoRoute(
        path: '/trip-completed',
        builder: (_, s) =>
            TripCompletedSummaryScreen(bookingId: s.extra as String),
      ),

      // ── Profile ────────────────────────────────────────────────────────────
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/setting', builder: (_, __) => const SettingScreen()),
      GoRoute(
          path: '/edit-profile',
          builder: (_, __) => const EditProfileScreen()),
    ],
  );
});
