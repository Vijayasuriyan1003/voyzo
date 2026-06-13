import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/core_providers.dart';

class DriverProfile {
  final String name;
  final String? phone;
  final String? altPhone;
  final String? email;
  final String? supportPhone;
  final String? driverCode;
  final String? vehicleNumber;
  final String? vehicleModel;
  final String? licenseNumber;
  final double? rating;
  final int? totalTrips;

  const DriverProfile({
    required this.name,
    this.phone,
    this.altPhone,
    this.email,
    this.supportPhone,
    this.driverCode,
    this.vehicleNumber,
    this.vehicleModel,
    this.licenseNumber,
    this.rating,
    this.totalTrips,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '??';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  factory DriverProfile.fromJson(Map j) => DriverProfile(
        name: j['full_name']?.toString() ?? j['name']?.toString() ?? '',
        phone: j['mobile_no']?.toString(),
        altPhone: j['alt_phone']?.toString(),
        email: j['email']?.toString(),
        supportPhone: j['support_phone']?.toString(),
        driverCode: j['driver_code']?.toString(),
        vehicleNumber: j['vehicle_number']?.toString(),
        vehicleModel: j['vehicle_model']?.toString(),
        licenseNumber: j['license_number']?.toString(),
        rating: j['rating'] != null
            ? double.tryParse(j['rating'].toString())
            : null,
        totalTrips: j['total_trips'] != null
            ? int.tryParse(j['total_trips'].toString())
            : null,
      );

  DriverProfile copyWith({
    String? name,
    String? phone,
    String? altPhone,
    String? email,
    String? vehicleNumber,
    String? vehicleModel,
    String? licenseNumber,
  }) =>
      DriverProfile(
        name: name ?? this.name,
        phone: phone ?? this.phone,
        altPhone: altPhone ?? this.altPhone,
        email: email ?? this.email,
        supportPhone: supportPhone,
        driverCode: driverCode,
        vehicleNumber: vehicleNumber ?? this.vehicleNumber,
        vehicleModel: vehicleModel ?? this.vehicleModel,
        licenseNumber: licenseNumber ?? this.licenseNumber,
        rating: rating,
        totalTrips: totalTrips,
      );
}

class ProfileRepository {
  ProfileRepository(this._api);
  final ApiClient _api;

  Future<DriverProfile> getDriverProfile() async {
    final m = await _api.get(ApiConfig.getDriverProfile);
    return DriverProfile.fromJson(m as Map);
  }

  Future<DriverProfile> updateDriverProfile({
    required String name,
    String? phone,
    String? email,
    String? vehicleNumber,
    String? vehicleModel,
    String? licenseNumber,
  }) async {
    final m = await _api.post(ApiConfig.updateDriverProfile, data: {
      'full_name': name,
      if (phone != null) 'mobile_no': phone,
      if (email != null) 'email': email,
      if (vehicleNumber != null) 'vehicle_number': vehicleNumber,
      if (vehicleModel != null) 'vehicle_model': vehicleModel,
      if (licenseNumber != null) 'license_number': licenseNumber,
    });
    return DriverProfile.fromJson(m as Map);
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.read(apiClientProvider)),
);
