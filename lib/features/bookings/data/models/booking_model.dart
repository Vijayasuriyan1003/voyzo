import 'expense_model.dart';

// Figma statuses: On Going, Completed, Cancelled, Draft, Open, Booked, Pending.
// `active` is rendered as "On Going".
enum BookingStatus {
  upcoming,
  active,
  completed,
  cancelled,
  open,
  booked,
  draft,
  pending,
}

enum PaymentStatus { pending, paid, partial }

class BookingModel {
  final String id;
  final String bookingCode;
  final String passengerName;
  final String passengerPhone;
  final String pickupLocation;
  final String dropLocation;
  final DateTime scheduledDateTime;
  final DateTime? endDateTime;
  final BookingStatus status;
  final String vehicleInfo;
  final String vehicleNumber;
  final double tripAmount;
  final String bookingType;
  // Figma trip-detail fields.
  final String dutyType; // e.g. "300 KM Per Day"
  final String tripType; // e.g. "Transfer"
  final String subTripType; // e.g. "One way"
  final double gst;
  final String? driverName;
  final String? driverPhone;
  final String? otp;
  final double? startKm;
  final double? endKm;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<ExpenseModel> expenses;
  final PaymentStatus paymentStatus;
  final String? driverNotes;
  final double? totalDistanceKm;

  const BookingModel({
    required this.id,
    required this.bookingCode,
    required this.passengerName,
    required this.passengerPhone,
    required this.pickupLocation,
    required this.dropLocation,
    required this.scheduledDateTime,
    required this.status,
    required this.vehicleInfo,
    required this.vehicleNumber,
    required this.tripAmount,
    required this.bookingType,
    this.endDateTime,
    required this.dutyType,
    required this.tripType,
    required this.subTripType,
    this.gst = 0,
    this.driverName,
    this.driverPhone,
    this.otp,
    this.startKm,
    this.endKm,
    this.startTime,
    this.endTime,
    this.expenses = const [],
    this.paymentStatus = PaymentStatus.pending,
    this.driverNotes,
    this.totalDistanceKm,
  });

  double get totalExpenses => expenses.fold(0, (sum, e) => sum + e.amount);

  double get totalAmount => tripAmount + totalExpenses + gst;

  double? get distanceTravelled =>
      (startKm != null && endKm != null) ? endKm! - startKm! : totalDistanceKm;

  factory BookingModel.fromDriverApi(Map<String, dynamic> json) {
    DateTime parseDate(String? value) {
      if (value == null || value.isEmpty) return DateTime.now();
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    BookingStatus parseStatus(String? value) {
      switch ((value ?? '').toLowerCase()) {
        case 'completed':
        case 'trip completed':
          return BookingStatus.completed;

        case 'cancelled':
        case 'canceled':
          return BookingStatus.cancelled;

        case 'open':
          return BookingStatus.upcoming;

        case 'booked':
          return BookingStatus.booked;

        case 'draft':
          return BookingStatus.draft;

        case 'pending':
          return BookingStatus.pending;

        case 'on going':
        case 'ongoing':
        case 'active':
        case 'trip started':
          return BookingStatus.active;

        default:
          return BookingStatus.upcoming;
      }
    }

    return BookingModel(
      id: json['name'] ?? '',
      bookingCode: json['name'] ?? '',
      passengerName: json['guest_name'] ?? '',
      passengerPhone: json['guest_phone_number'] ?? '',
      pickupLocation: json['pick_up_location'] ?? '',
      dropLocation: json['drop_off_location'] ?? '',
      scheduledDateTime: parseDate(json['from_date_time']),
      endDateTime: parseDate(json['to_date_time']),
      status: parseStatus(json['trip_status']),
      vehicleInfo: json['vehicle_type'] ?? '',
      vehicleNumber: '',
      tripAmount: 0,
      bookingType: json['trip_type'] ?? '',
      dutyType: json['duty_type'] ?? '',
      tripType: json['trip_type'] ?? '',
      subTripType: json['sub_trip_type'] ?? '',
    );
  }

  BookingModel copyWith({
    BookingStatus? status,
    double? startKm,
    double? endKm,
    DateTime? startTime,
    DateTime? endTime,
    List<ExpenseModel>? expenses,
    PaymentStatus? paymentStatus,
    String? driverNotes,
    String? otp,
  }) => BookingModel(
    id: id,
    bookingCode: bookingCode,
    passengerName: passengerName,
    passengerPhone: passengerPhone,
    pickupLocation: pickupLocation,
    dropLocation: dropLocation,
    scheduledDateTime: scheduledDateTime,
    endDateTime: endDateTime,
    status: status ?? this.status,
    vehicleInfo: vehicleInfo,
    vehicleNumber: vehicleNumber,
    tripAmount: tripAmount,
    bookingType: bookingType,
    dutyType: dutyType,
    tripType: tripType,
    subTripType: subTripType,
    gst: gst,
    driverName: driverName,
    driverPhone: driverPhone,
    otp: otp ?? this.otp,
    startKm: startKm ?? this.startKm,
    endKm: endKm ?? this.endKm,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    expenses: expenses ?? this.expenses,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    driverNotes: driverNotes ?? this.driverNotes,
    totalDistanceKm: totalDistanceKm,
  );
}
