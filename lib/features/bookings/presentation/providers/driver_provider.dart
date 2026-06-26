import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverState {
  final String email;
  final String driverId;
  final String fullName;
  final String mobileNo;

  DriverState({
    required this.email,
    required this.driverId,
    required this.fullName,
    required this.mobileNo,
  });
}

class DriverNotifier extends StateNotifier<DriverState?> {
  DriverNotifier() : super(null);

  void setDriver(Map<String, dynamic> data) {
    state = DriverState(
      email: data['email'] ?? '',
      driverId: data['driver_id'] ?? '',
      fullName: data['full_name'] ?? '',
      mobileNo: data['mobile_no'] ?? '',
    );
  }

  void logout() {
    state = null;
  }
}

final driverProvider = StateNotifierProvider<DriverNotifier, DriverState?>(
  (ref) => DriverNotifier(),
);
