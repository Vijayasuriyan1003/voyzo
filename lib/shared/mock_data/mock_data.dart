import '../../features/bookings/data/models/booking_model.dart';
import '../../features/bookings/data/models/expense_model.dart';

class MockData {
  MockData._();

  // ── Driver Booking History ────────────────────────────────────────────────
  // Figma driver flow: trips Jaipur station…. → Delhi airport, with Upcoming
  // (blue) and Completed (green) statuses.
  static final List<BookingModel> bookings = [
    _trip('BO-10-012', BookingStatus.upcoming, '1234', expenses: [
      ExpenseModel(id: 'EX001', type: 'Toll', amount: 450, addedAt: _t(11, 0)),
      ExpenseModel(
          id: 'EX002',
          type: 'Night',
          amount: 300,
          notes: 'Nights x1',
          addedAt: _t(22, 0)),
      ExpenseModel(
          id: 'EX003', type: 'Parking', amount: 100, addedAt: _t(12, 30)),
    ]),
    _trip('BO-10-013', BookingStatus.completed, '5678',
        startKm: 12100, endKm: 12260),
    _trip('BO-10-014', BookingStatus.completed, '9012',
        startKm: 12450, endKm: 12722),
  ];

  /// Driver-flow trip: same Jaipur station…. → Delhi airport route, guest Anand
  /// Vyas, driver Abhay Dolas (matches the Figma board).
  static BookingModel _trip(
    String code,
    BookingStatus status,
    String otp, {
    List<ExpenseModel> expenses = const [],
    double? startKm,
    double? endKm,
  }) =>
      BookingModel(
        id: code,
        bookingCode: code,
        passengerName: 'Anand Vyas',
        passengerPhone: '+91 88984 41289',
        pickupLocation: 'Jaipur station....',
        dropLocation: 'Delhi airport',
        scheduledDateTime: DateTime(2025, 10, 27, 9, 5, 51),
        endDateTime: DateTime(2025, 10, 27, 19, 11, 37),
        status: status,
        vehicleInfo: 'KUV',
        vehicleNumber: 'RJ19CH7897',
        tripAmount: 2500,
        bookingType: 'Air',
        dutyType: '300 KM Per Day',
        tripType: 'Transfer',
        subTripType: 'One way',
        gst: 100,
        driverName: 'Abhay Dolas',
        driverPhone: '+91 89282 62991',
        otp: otp,
        startKm: startKm,
        endKm: endKm,
        paymentStatus:
            status == BookingStatus.completed ? PaymentStatus.paid : PaymentStatus.pending,
        expenses: expenses,
      );

  // ── Booking Request list (Booked / Cancelled / Draft) ─────────────────────
  static final List<BookingModel> bookingRequests = [
    _request('BO-10-012', 'Raj Panday', BookingStatus.booked, 12600),
    _request('BO-10-012', 'Ramesh Jain', BookingStatus.cancelled, 8400),
    _request('BO-10-012', 'Anil Kapoor', BookingStatus.draft, 5200),
    _request('BO-10-012', 'Neha Gupta', BookingStatus.booked, 9100),
    _request('BO-10-012', 'Vikram Singh', BookingStatus.cancelled, 4300),
    _request('BO-10-012', 'Pooja Verma', BookingStatus.draft, 6700),
  ];

  // ── Booking List (Open / Completed / Cancelled / Draft) ───────────────────
  static final List<BookingModel> bookingList = [
    _request('BO-10-012', 'Raj Panday', BookingStatus.open, 12600),
    _request('BO-10-012', 'Priya Sharma', BookingStatus.completed, 1800),
    _request('BO-10-012', 'Anand Vyas', BookingStatus.completed, 2800),
    _request('BO-10-012', 'Riya Singh', BookingStatus.cancelled, 950),
    _request('BO-10-012', 'Karan Mehta', BookingStatus.draft, 3200),
    _request('BO-10-012', 'Sunita Rao', BookingStatus.completed, 1100),
  ];

  static BookingModel _request(
    String code,
    String name,
    BookingStatus status,
    double amount,
  ) =>
      BookingModel(
        id: '$code-$name',
        bookingCode: code,
        passengerName: name,
        passengerPhone: '+91 88984 41289',
        pickupLocation:
            'Jaipur International Airport Terminal, Sanganer Airport Area, Jaipur, Rajasthan, 302041',
        dropLocation:
            'Jaipur International Airport Terminal, Sanganer Airport Area, Jaipur, Rajasthan, 302041',
        scheduledDateTime: DateTime(2025, 10, 27, 9, 5, 51),
        endDateTime: DateTime(2025, 10, 27, 19, 11, 37),
        status: status,
        vehicleInfo: 'KUV',
        vehicleNumber: 'RJ19CH7897',
        tripAmount: amount,
        bookingType: 'Air',
        dutyType: '300 KM Per Day',
        tripType: 'Transfer',
        subTripType: 'One way',
        driverName: 'Ramesh Jain',
        driverPhone: '+91 89282 62991',
      );

  static DateTime _t(int h, int m) => DateTime(2025, 10, 27, h, m);

  // ── Driver (Figma Profile: Abhay Dolas / AD) ──────────────────────────────
  static const Map<String, dynamic> driver = {
    'id': 'DRV001',
    'name': 'Abhay Dolas',
    'initials': 'AD',
    'phone': '+8834567 567',
    'altPhone': '+91 8928262991',
    'email': 'abhay@gmail.com',
    'supportPhone': '+91 1234567890',
    'driverCode': '#231D12457',
    'vehicleNumber': 'RJ19CH7897',
    'vehicleModel': 'Maruti Swift Dzire',
    'licenseNumber': 'RJ-0120210001234',
    'rating': 4.8,
    'totalTrips': 247,
  };
}
