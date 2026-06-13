import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';
import 'models/booking_model.dart';
import 'models/expense_model.dart';

class BookingRepository {
  BookingRepository(this._api);
  final ApiClient _api;

  // ── Driver booking history ────────────────────────────────────────────────

  Future<List<BookingModel>> getMyBookings({String? filter}) async {
    final m = await _api.get(ApiConfig.getMyBookings,
        query: {if (filter != null && filter != 'all') 'filter': filter});
    final list = (m as List?) ?? [];
    return list.map((e) => BookingModel.fromJson(e as Map)).toList();
  }

  Future<BookingModel> getBooking(String bookingId) async {
    final m = await _api.get(ApiConfig.getBooking,
        query: {'booking_id': bookingId});
    return BookingModel.fromJson(m as Map);
  }

  Future<BookingModel> startTrip({
    required String bookingId,
    required double startKm,
  }) async {
    final m = await _api.post(ApiConfig.startTrip, data: {
      'booking_id': bookingId,
      'start_km': startKm,
    });
    return BookingModel.fromJson(m as Map);
  }

  Future<BookingModel> endTrip({
    required String bookingId,
    required double endKm,
  }) async {
    final m = await _api.post(ApiConfig.endTrip, data: {
      'booking_id': bookingId,
      'end_km': endKm,
    });
    return BookingModel.fromJson(m as Map);
  }

  // ── Expenses ──────────────────────────────────────────────────────────────

  Future<BookingModel> addExpense({
    required String bookingId,
    required ExpenseModel expense,
  }) async {
    final m = await _api.post(ApiConfig.addExpense, data: {
      'booking_id': bookingId,
      ...expense.toJson(),
    });
    return BookingModel.fromJson(m as Map);
  }

  Future<BookingModel> updateExpense({
    required String bookingId,
    required ExpenseModel expense,
  }) async {
    final m = await _api.post(ApiConfig.updateExpense, data: {
      'booking_id': bookingId,
      'expense_id': expense.id,
      ...expense.toJson(),
    });
    return BookingModel.fromJson(m as Map);
  }

  Future<BookingModel> deleteExpense({
    required String bookingId,
    required String expenseId,
  }) async {
    final m = await _api.post(ApiConfig.deleteExpense, data: {
      'booking_id': bookingId,
      'expense_id': expenseId,
    });
    return BookingModel.fromJson(m as Map);
  }

  // ── Booking request / list ────────────────────────────────────────────────

  Future<List<BookingModel>> getBookingRequests() async {
    final m = await _api.get(ApiConfig.getBookingRequests);
    final list = (m as List?) ?? [];
    return list.map((e) => BookingModel.fromJson(e as Map)).toList();
  }

  Future<List<BookingModel>> getBookingList() async {
    final m = await _api.get(ApiConfig.getBookingList);
    final list = (m as List?) ?? [];
    return list.map((e) => BookingModel.fromJson(e as Map)).toList();
  }
}

final bookingRepositoryProvider = Provider<BookingRepository>(
  (ref) => BookingRepository(ref.read(apiClientProvider)),
);
