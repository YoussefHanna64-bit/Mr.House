import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_house/models/user_model.dart';
import 'package:mr_house/repositories/auth_repository.dart';
import 'package:mr_house/viewmodels/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repo;

  AuthCubit(this._repo) : super(AuthInitial());

  Future<void> checkSession() async {
    final user = await _repo.getCurrentUser();

    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password, UserRole role) async {
    emit(AuthLoading());
    try {
      final user = await _repo.signIn(email, password, role);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String address,
    required String phoneNumber,
    required String gender,
    required UserRole role,
    String? bio,
    String? specialty,
    String? age,
    String? experience,
  }) async {
    emit(AuthLoading());

    try {
      await _repo.signUp(
        email: email,
        password: password,
        name: name,
        address: address,
        phoneNumber: phoneNumber,
        gender: gender,
        role: role,
        bio: bio,
        specialty: specialty,
        age: age,
        experience: experience,
      );

      emit(AuthSignUpSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _repo.signOut();
    emit(AuthUnauthenticated());
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _repo.sendPasswordReset(email);
      emit(AuthPasswordResetSent());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword != confirmPassword) {
      emit(AuthError("Passwords don't match"));
      return;
    }

    emit(AuthLoading());

    try {
      await _repo.reauthenticate(currentPassword);
      await _repo.updatePassword(newPassword);

      emit(AuthPasswordChanged());
    } catch (e) {
      emit(AuthError("Password update failed: $e"));
    }
  }

  Future<void> deleteAccount() async {
    emit(AuthLoading());
    try {
      await _repo.deleteAccount();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
