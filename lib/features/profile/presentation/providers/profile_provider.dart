import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/profile_repository.dart';
export '../../data/profile_repository.dart' show DriverProfile;

class ProfileState {
  final DriverProfile? profile;
  final bool isLoading;
  final String? error;

  const ProfileState({this.profile, this.isLoading = false, this.error});

  ProfileState copyWith({
    DriverProfile? profile,
    bool? isLoading,
    String? error,
  }) =>
      ProfileState(
        profile: profile ?? this.profile,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier(this._repo) : super(const ProfileState(isLoading: true)) {
    _load();
  }

  final ProfileRepository _repo;

  Future<void> _load() async {
    try {
      final profile = await _repo.getDriverProfile();
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() => _load();

  Future<void> save({
    required String name,
    String? phone,
    String? email,
    String? vehicleNumber,
    String? vehicleModel,
    String? licenseNumber,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final updated = await _repo.updateDriverProfile(
        name: name,
        phone: phone,
        email: email,
        vehicleNumber: vehicleNumber,
        vehicleModel: vehicleModel,
        licenseNumber: licenseNumber,
      );
      state = state.copyWith(profile: updated, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(ref.read(profileRepositoryProvider));
});
