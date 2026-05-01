part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String name;
  final String email;
  final bool isGuest;

  AuthAuthenticated({
    required this.userId,
    required this.name,
    required this.email,
    this.isGuest = false,
  });
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class AuthRegistered extends AuthState {
  final String message;
  AuthRegistered(this.message);
}