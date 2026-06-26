import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyzo/features/auth/data/auth_api.dart';
import 'package:voyzo/features/bookings/presentation/providers/driver_provider.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/expense_model.dart';
import '../../../../shared/mock_data/mock_data.dart';

class BookingState {
  final List<BookingModel> bookings;
  final String activeFilter; // 'all', 'upcoming', 'completed'

  const BookingState({required this.bookings, this.activeFilter = 'all'});

  List<BookingModel> get filteredBookings {
    switch (activeFilter) {
      case 'upcoming':
        return bookings
            .where(
              (b) =>
                  b.status == BookingStatus.upcoming ||
                  b.status == BookingStatus.active,
            )
            .toList();
      case 'completed':
        return bookings
            .where((b) => b.status == BookingStatus.completed)
            .toList();
      default:
        return bookings;
    }
  }

  BookingState copyWith({List<BookingModel>? bookings, String? activeFilter}) =>
      BookingState(
        bookings: bookings ?? this.bookings,
        activeFilter: activeFilter ?? this.activeFilter,
      );
}

class BookingNotifier extends StateNotifier<BookingState> {
  final Ref ref;

  BookingNotifier(this.ref)
    : super(BookingState(bookings: List.from(MockData.bookings)));
  Future<void> fetchDriverBookings() async {
    final driverEmail = ref.read(driverProvider)?.email;

    if (driverEmail == null || driverEmail.isEmpty) {
      print('Driver email not found');
      return;
    }

    final bookingData = await AuthApi.getDriverBookings(
      driverEmail: driverEmail,
    );

    final apiBookings = bookingData
        .map((item) => BookingModel.fromDriverApi(item))
        .toList();

    state = state.copyWith(bookings: apiBookings);
  }

  void setFilter(String filter) {
    state = state.copyWith(activeFilter: filter);
  }

  void startTrip(String bookingId, double startKm, String otp) {
    final updated = state.bookings.map((b) {
      if (b.id == bookingId) {
        return b.copyWith(
          status: BookingStatus.active,
          startKm: startKm,
          startTime: DateTime.now(),
          otp: otp,
        );
      }
      return b;
    }).toList();
    state = state.copyWith(bookings: updated);
  }

  void addExpense(String bookingId, ExpenseModel expense) {
    final updated = state.bookings.map((b) {
      if (b.id == bookingId) {
        final newExpenses = [...b.expenses, expense];
        return b.copyWith(expenses: newExpenses);
      }
      return b;
    }).toList();
    state = state.copyWith(bookings: updated);
  }

  void updateExpense(String bookingId, ExpenseModel expense) {
    final updated = state.bookings.map((b) {
      if (b.id == bookingId) {
        return b.copyWith(
          expenses: b.expenses
              .map((e) => e.id == expense.id ? expense : e)
              .toList(),
        );
      }
      return b;
    }).toList();
    state = state.copyWith(bookings: updated);
  }

  void removeExpense(String bookingId, String expenseId) {
    final updated = state.bookings.map((b) {
      if (b.id == bookingId) {
        return b.copyWith(
          expenses: b.expenses.where((e) => e.id != expenseId).toList(),
        );
      }
      return b;
    }).toList();
    state = state.copyWith(bookings: updated);
  }

  void endTrip(String bookingId, double endKm) {
    final updated = state.bookings.map((b) {
      if (b.id == bookingId) {
        return b.copyWith(
          status: BookingStatus.completed,
          endKm: endKm,
          endTime: DateTime.now(),
          paymentStatus: PaymentStatus.paid,
        );
      }
      return b;
    }).toList();
    state = state.copyWith(bookings: updated);
  }

  BookingModel? getBookingById(String id) {
    try {
      return state.bookings.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
}

final bookingProvider = StateNotifierProvider<BookingNotifier, BookingState>((
  ref,
) {
  return BookingNotifier(ref);
});

final selectedBookingProvider = StateProvider<BookingModel?>((ref) => null);
final selectedBookingIdProvider = StateProvider<String?>((ref) => null);
