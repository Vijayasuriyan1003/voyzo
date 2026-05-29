import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/splash_screen.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/bookings/presentation/pages/booking_history_screen.dart';
import '../features/bookings/presentation/pages/trip_completed_summary_screen.dart';
import '../features/bookings/presentation/pages/trip_details_screen.dart';
import '../features/bookings/presentation/pages/active_trip_screen.dart';
import '../features/profile/presentation/pages/edit_profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
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
