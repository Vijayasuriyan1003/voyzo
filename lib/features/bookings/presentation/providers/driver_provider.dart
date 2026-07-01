import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverState {
  final String email;
  final String driverId;
  final String fullName;
  final String mobileNo;
  final String license_number;
  final int customNoOfTrips;
  final double rating;

  DriverState({
    required this.email,
    required this.driverId,
    required this.fullName,
    required this.mobileNo,
    required this.license_number,
    required this.customNoOfTrips,
    required this.rating,
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
      license_number: data['license_number'] ?? '',
      customNoOfTrips:
          int.tryParse(data['custom_no_of_trips']?.toString() ?? '0') ?? 0,
      rating: double.tryParse(data['custom_rating']?.toString() ?? '0') ?? 0,
    );
  }

  void logout() {
    state = null;
  }
}

final driverProvider = StateNotifierProvider<DriverNotifier, DriverState?>(
  (ref) => DriverNotifier(),
);
