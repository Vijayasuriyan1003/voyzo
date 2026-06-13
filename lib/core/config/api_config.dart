/// Central API configuration for the Voyzo Frappe backend.
class ApiConfig {
  ApiConfig._();

  /// Override per build flavour: --dart-define=VOYZO_BASE_URL=https://...
  static const String baseUrl = String.fromEnvironment(
    'VOYZO_BASE_URL',
    defaultValue: 'https://dev-taxi.m.frappe.cloud',
  );

  /// Frappe whitelisted-method namespace.
  /// Update the app/module name if the Frappe app is not named "taxi".
  static const String _ns = '/api/method/taxi.api';

  // ── Authentication ────────────────────────────────────────────────────────

  /// Frappe built-in session login — used by the Driver Login page.
  static const String driverLogin = '/api/method/login';

  static const String login = '$_ns.auth.login';
  static const String register = '$_ns.auth.register';
  static const String currentUser = '$_ns.auth.get_current_user';
  static const String requestPasswordReset = '$_ns.auth.request_password_reset';

  /// Frappe built-in session logout (invalidates server-side session).
  static const String logout = '/api/method/logout';

  // ── Driver – bookings / trips ─────────────────────────────────────────────
  static const String getMyBookings = '$_ns.bookings.get_my_bookings';
  static const String getBooking = '$_ns.bookings.get_booking';
  static const String startTrip = '$_ns.bookings.start_trip';
  static const String endTrip = '$_ns.bookings.end_trip';
  static const String addExpense = '$_ns.bookings.add_expense';
  static const String updateExpense = '$_ns.bookings.update_expense';
  static const String deleteExpense = '$_ns.bookings.delete_expense';

  // ── Booking requests / admin list ─────────────────────────────────────────
  static const String getBookingRequests = '$_ns.bookings.get_booking_requests';
  static const String getBookingList = '$_ns.bookings.get_booking_list';
  static const String createBookingRequest = '$_ns.bookings.create_booking_request';

  // ── Customer ──────────────────────────────────────────────────────────────
  static const String createCustomerBooking = '$_ns.customer.create_booking';
  static const String getCustomerBookings = '$_ns.customer.get_my_bookings';

  // ── Profile ───────────────────────────────────────────────────────────────
  static const String getDriverProfile = '$_ns.profile.get_driver_profile';
  static const String updateDriverProfile = '$_ns.profile.update_driver_profile';

  // ── File upload ───────────────────────────────────────────────────────────
  static const String uploadFile = '/api/method/upload_file';
}
