import 'expense_model.dart';

enum BookingStatus { upcoming, active, completed, cancelled }

enum PaymentStatus { pending, paid, partial }

class BookingModel {
  final String id;
  final String bookingCode;
  final String passengerName;
  final String passengerPhone;
  final String pickupLocation;
  final String dropLocation;
  final DateTime scheduledDateTime;
  final BookingStatus status;
  final String vehicleInfo;
  final String vehicleNumber;
  final double tripAmount;
  final String bookingType;
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

  double get totalAmount => tripAmount + totalExpenses;

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
        status: status ?? this.status,
        vehicleInfo: vehicleInfo,
        vehicleNumber: vehicleNumber,
        tripAmount: tripAmount,
        bookingType: bookingType,
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
