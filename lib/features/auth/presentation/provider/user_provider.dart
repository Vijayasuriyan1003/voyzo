import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final String email;
  final String fullName;
  final String mobileNo;
  final String customerId;
  final String customerName;

  UserState({
    required this.email,
    required this.fullName,
    required this.mobileNo,
    required this.customerId,
    required this.customerName,
  });
}

class UserNotifier extends StateNotifier<UserState?> {
  UserNotifier() : super(null);

  void setUser(Map<String, dynamic> data) {
    state = UserState(
      email: data['email'] ?? '',
      fullName: data['full_name'] ?? '',
      mobileNo: data['mobile_no'] ?? '',
      customerId: data['customer_id'] ?? '',
      customerName: data['customer_name'] ?? '',
    );
  }

  void logout() {
    state = null;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState?>(
  (ref) => UserNotifier(),
);
