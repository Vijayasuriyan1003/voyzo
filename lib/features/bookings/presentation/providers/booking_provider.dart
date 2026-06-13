import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/booking_repository.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/expense_model.dart';

class BookingState {
  final List<BookingModel> bookings;
  final String activeFilter;
  final bool isLoading;
  final String? error;

  const BookingState({
    this.bookings = const [],
    this.activeFilter = 'all',
    this.isLoading = false,
    this.error,
  });

  List<BookingModel> get filteredBookings {
    switch (activeFilter) {
      case 'upcoming':
        return bookings
            .where((b) =>
                b.status == BookingStatus.upcoming ||
                b.status == BookingStatus.active)
            .toList();
      case 'completed':
        return bookings
            .where((b) => b.status == BookingStatus.completed)
            .toList();
      default:
        return bookings;
    }
  }

  BookingState copyWith({
    List<BookingModel>? bookings,
    String? activeFilter,
    bool? isLoading,
    String? error,
  }) =>
      BookingState(
        bookings: bookings ?? this.bookings,
        activeFilter: activeFilter ?? this.activeFilter,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class BookingNotifier extends StateNotifier<BookingState> {
  BookingNotifier(this._repo)
      : super(const BookingState(isLoading: true)) {
    _load();
  }

  final BookingRepository _repo;

  Future<void> _load() async {
    try {
      final bookings = await _repo.getMyBookings();
      state = state.copyWith(bookings: bookings, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() => _load();

  void setFilter(String filter) {
    state = state.copyWith(activeFilter: filter);
  }

  Future<void> startTrip(String bookingId, double startKm) async {
    try {
      final updated =
          await _repo.startTrip(bookingId: bookingId, startKm: startKm);
      _replaceBooking(updated);
    } catch (e) {
      // Optimistic fallback so the UI still transitions.
      _updateLocal(bookingId, (b) => b.copyWith(
            status: BookingStatus.active,
            startKm: startKm,
            startTime: DateTime.now(),
          ));
      rethrow;
    }
  }

  Future<void> endTrip(String bookingId, double endKm) async {
    try {
      final updated =
          await _repo.endTrip(bookingId: bookingId, endKm: endKm);
      _replaceBooking(updated);
    } catch (e) {
      _updateLocal(bookingId, (b) => b.copyWith(
            status: BookingStatus.completed,
            endKm: endKm,
            endTime: DateTime.now(),
            paymentStatus: PaymentStatus.paid,
          ));
      rethrow;
    }
  }

  Future<void> addExpense(String bookingId, ExpenseModel expense) async {
    try {
      final updated =
          await _repo.addExpense(bookingId: bookingId, expense: expense);
      _replaceBooking(updated);
    } catch (e) {
      _updateLocal(bookingId,
          (b) => b.copyWith(expenses: [...b.expenses, expense]));
      rethrow;
    }
  }

  Future<void> updateExpense(String bookingId, ExpenseModel expense) async {
    try {
      final updated =
          await _repo.updateExpense(bookingId: bookingId, expense: expense);
      _replaceBooking(updated);
    } catch (e) {
      _updateLocal(
          bookingId,
          (b) => b.copyWith(
              expenses: b.expenses
                  .map((ex) => ex.id == expense.id ? expense : ex)
                  .toList()));
      rethrow;
    }
  }

  Future<void> removeExpense(String bookingId, String expenseId) async {
    try {
      final updated =
          await _repo.deleteExpense(bookingId: bookingId, expenseId: expenseId);
      _replaceBooking(updated);
    } catch (e) {
      _updateLocal(
          bookingId,
          (b) => b.copyWith(
              expenses: b.expenses.where((ex) => ex.id != expenseId).toList()));
      rethrow;
    }
  }

  BookingModel? getBookingById(String id) {
    try {
      return state.bookings.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  void _replaceBooking(BookingModel updated) {
    final idx = state.bookings.indexWhere((b) => b.id == updated.id);
    if (idx == -1) return;
    final list = [...state.bookings];
    list[idx] = updated;
    state = state.copyWith(bookings: list);
  }

  void _updateLocal(String bookingId, BookingModel Function(BookingModel) fn) {
    final updated =
        state.bookings.map((b) => b.id == bookingId ? fn(b) : b).toList();
    state = state.copyWith(bookings: updated);
  }
}

final bookingProvider =
    StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  return BookingNotifier(ref.read(bookingRepositoryProvider));
});

final selectedBookingIdProvider = StateProvider<String?>((ref) => null);

// ── Booking requests (Booked / Cancelled / Draft) ─────────────────────────

class BookingRequestNotifier
    extends StateNotifier<AsyncValue<List<BookingModel>>> {
  BookingRequestNotifier(this._repo)
      : super(const AsyncValue.loading()) {
    _load();
  }

  final BookingRepository _repo;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.getBookingRequests());
  }

  Future<void> refresh() => _load();
}

final bookingRequestProvider = StateNotifierProvider<BookingRequestNotifier,
    AsyncValue<List<BookingModel>>>((ref) {
  return BookingRequestNotifier(ref.read(bookingRepositoryProvider));
});

// ── Booking list (Open / Completed / Cancelled / Draft) ───────────────────

class BookingListNotifier
    extends StateNotifier<AsyncValue<List<BookingModel>>> {
  BookingListNotifier(this._repo)
      : super(const AsyncValue.loading()) {
    _load();
  }

  final BookingRepository _repo;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.getBookingList());
  }

  Future<void> refresh() => _load();
}

final bookingListProvider = StateNotifierProvider<BookingListNotifier,
    AsyncValue<List<BookingModel>>>((ref) {
  return BookingListNotifier(ref.read(bookingRepositoryProvider));
});
