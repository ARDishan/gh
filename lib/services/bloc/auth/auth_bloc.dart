import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthGuestRequested>(_onGuest);
    on<AuthGoogleRequested>(_onGoogle);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthCheckRequested>(_onCheck);
  }

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 2)); // Simulate network call

    // Mock validation
    if (event.email.isEmpty || event.password.isEmpty) {
      emit(AuthFailure('Please fill in all fields.'));
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(event.email)) {
      emit(AuthFailure('Please enter a valid email address.'));
      return;
    }

    if (event.password.length < 6) {
      emit(AuthFailure('Password must be at least 6 characters.'));
      return;
    }

    // Mock successful login
    emit(AuthAuthenticated(
      userId: 'user_001',
      name: event.email.split('@').first.capitalize(),
      email: event.email,
    ));
  }

  Future<void> _onRegister(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 2));

    if (event.fullName.isEmpty ||
        event.email.isEmpty ||
        event.phone.isEmpty ||
        event.password.isEmpty) {
      emit(AuthFailure('Please fill in all fields.'));
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(event.email)) {
      emit(AuthFailure('Please enter a valid email address.'));
      return;
    }

    if (event.password.length < 6) {
      emit(AuthFailure('Password must be at least 6 characters.'));
      return;
    }

    emit(AuthRegistered('Account created successfully! Please log in.'));
  }

  Future<void> _onGuest(
    AuthGuestRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 800));
    emit(AuthAuthenticated(
      userId: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Guest',
      email: '',
      isGuest: true,
    ));
  }

  Future<void> _onGoogle(
    AuthGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));
    // Mock Google sign-in
    emit(AuthAuthenticated(
      userId: 'google_user_001',
      name: 'John Silva',
      email: 'john.silva@gmail.com',
    ));
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheck(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    emit(AuthUnauthenticated());
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}