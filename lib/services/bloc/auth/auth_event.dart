part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  AuthLoginRequested({required this.email, required this.password});
}

class AuthRegisterRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  AuthRegisterRequested({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });
}

class AuthGuestRequested extends AuthEvent {}

class AuthGoogleRequested extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}