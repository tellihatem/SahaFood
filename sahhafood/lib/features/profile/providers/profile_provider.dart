import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';

/// Profile state class
/// Holds the current state of user profile
class ProfileState {
  final UserProfile? profile;
  final bool isLoading;
  final String? error;

  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
  });

  /// Initial state
  factory ProfileState.initial() {
    return ProfileState(
      profile: UserProfile.initial(),
    );
  }

  /// Create a copy with modified fields
  ProfileState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Profile notifier - manages profile state
/// Follows architecture rules: business logic separated from UI
class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState.initial());

  /// Update profile
  /// In production: Call API endpoint
  Future<bool> updateProfile(UserProfile updatedProfile) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // await _profileApiService.updateProfile(updatedProfile);
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      state = state.copyWith(
        profile: updatedProfile,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Update profile picture
  /// In production: Upload image and update profile
  Future<bool> updateProfilePicture(String imageUrl) async {
    if (state.profile == null) return false;
    
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // final uploadedUrl = await _profileApiService.uploadImage(imageUrl);
      // await _profileApiService.updateProfilePicture(uploadedUrl);
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      final updatedProfile = state.profile!.copyWith(
        profileImageUrl: imageUrl,
      );
      
      state = state.copyWith(
        profile: updatedProfile,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Load profile from backend
  /// In production: Fetch from API
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // final profile = await _profileApiService.getProfile();
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Using mock data for now
      final profile = UserProfile.initial();
      
      state = state.copyWith(
        profile: profile,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Logout
  /// In production: Clear session and call logout API
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // await _authApiService.logout();
      
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Clear profile
      state = ProfileState.initial().copyWith(profile: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

/// Profile provider - exposes profile state to UI
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier();
});
