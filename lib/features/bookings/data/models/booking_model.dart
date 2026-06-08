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
    this.dutyType = '300 KM Per Day',
    this.tripType = 'Transfer',
    this.subTripType = 'One way',
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

  BookingModel copyWith({
    BookingStatus? status,
    double? startKm,
    double? endKm,
    DateTime? startTime,
    DateTime? endTime,
    List<ExpenseModel>? expenses,
    PaymentStatus? paymentStatus,
    String? driverNotes,
  }) =>
      BookingModel(
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
        otp: otp,
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
