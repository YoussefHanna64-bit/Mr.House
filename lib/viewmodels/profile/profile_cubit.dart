import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_house/models/user_model.dart';
import 'package:mr_house/repositories/auth_repository.dart';
import 'package:mr_house/repositories/user_repository.dart';
import 'package:mr_house/viewmodels/profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository _userRepo;
  final AuthRepository _authRepo;

  ProfileCubit(this._userRepo, this._authRepo) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final user = await _authRepo.getCurrentUser();

      if (user != null) {
        emit(ProfileLoaded(user));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile(UserRole role, String field, dynamic value) async {
    await _userRepo.updateProfile(role, field, value);
    await loadProfile();
  }

  Future<void> updateEmail(UserRole role, String newEmail) async {
    await _userRepo.updateEmail(role, newEmail);
    await loadProfile();
  }
}
