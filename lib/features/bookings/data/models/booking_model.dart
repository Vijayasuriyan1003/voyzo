import 'expense_model.dart';

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

extension BookingStatusX on BookingStatus {
  static BookingStatus fromString(String? s) {
    switch (s?.toLowerCase()) {
      case 'upcoming':
        return BookingStatus.upcoming;
      case 'active':
      case 'on going':
      case 'ongoing':
        return BookingStatus.active;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
      case 'canceled':
        return BookingStatus.cancelled;
      case 'open':
        return BookingStatus.open;
      case 'booked':
        return BookingStatus.booked;
      case 'draft':
        return BookingStatus.draft;
      case 'pending':
        return BookingStatus.pending;
      default:
        return BookingStatus.upcoming;
    }
  }
}

enum PaymentStatus { pending, paid, partial }

extension PaymentStatusX on PaymentStatus {
  static PaymentStatus fromString(String? s) {
    switch (s?.toLowerCase()) {
      case 'paid':
        return PaymentStatus.paid;
      case 'partial':
        return PaymentStatus.partial;
      default:
        return PaymentStatus.pending;
    }
  }
}

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
  final String dutyType;
  final String tripType;
  final String subTripType;
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

  factory BookingModel.fromJson(Map j) {
    final expenses = (j['expenses'] as List?)
            ?.map((e) => ExpenseModel.fromJson(e as Map))
            .toList() ??
        const [];

    return BookingModel(
      id: j['name']?.toString() ?? '',
      bookingCode: j['booking_code']?.toString() ?? j['name']?.toString() ?? '',
      passengerName: j['passenger_name']?.toString() ?? '',
      passengerPhone: j['passenger_phone']?.toString() ?? '',
      pickupLocation: j['pickup_location']?.toString() ?? '',
      dropLocation: j['drop_location']?.toString() ?? '',
      scheduledDateTime: j['scheduled_date_time'] != null
          ? DateTime.tryParse(j['scheduled_date_time'].toString()) ??
              DateTime.now()
          : DateTime.now(),
      endDateTime: j['end_date_time'] != null
          ? DateTime.tryParse(j['end_date_time'].toString())
          : null,
      status: BookingStatusX.fromString(j['status']?.toString()),
      vehicleInfo: j['vehicle_info']?.toString() ?? '',
      vehicleNumber: j['vehicle_number']?.toString() ?? '',
      tripAmount: double.tryParse(j['trip_amount']?.toString() ?? '0') ?? 0,
      bookingType: j['booking_type']?.toString() ?? '',
      dutyType: j['duty_type']?.toString() ?? '300 KM Per Day',
      tripType: j['trip_type']?.toString() ?? 'Transfer',
      subTripType: j['sub_trip_type']?.toString() ?? 'One way',
      gst: double.tryParse(j['gst']?.toString() ?? '0') ?? 0,
      driverName: j['driver_name']?.toString(),
      driverPhone: j['driver_phone']?.toString(),
      otp: j['otp']?.toString(),
      startKm: j['start_km'] != null
          ? double.tryParse(j['start_km'].toString())
          : null,
      endKm:
          j['end_km'] != null ? double.tryParse(j['end_km'].toString()) : null,
      startTime: j['start_time'] != null
          ? DateTime.tryParse(j['start_time'].toString())
          : null,
      endTime: j['end_time'] != null
          ? DateTime.tryParse(j['end_time'].toString())
          : null,
      expenses: expenses,
      paymentStatus:
          PaymentStatusX.fromString(j['payment_status']?.toString()),
      driverNotes: j['driver_notes']?.toString(),
      totalDistanceKm: j['total_distance_km'] != null
          ? double.tryParse(j['total_distance_km'].toString())
          : null,
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
