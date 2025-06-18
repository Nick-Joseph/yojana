// Events
part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  AuthSignInRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  AuthSignUpRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class AuthSignOutRequested extends AuthEvent {}
