// States

part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AuthStatus status;
  final String? error;
  const AuthState({required this.status, this.error});
  factory AuthState.unknown() => const AuthState(status: AuthStatus.unknown);
  factory AuthState.authenticated() =>
      const AuthState(status: AuthStatus.authenticated);
  factory AuthState.unauthenticated([String? error]) =>
      AuthState(status: AuthStatus.unauthenticated, error: error);
  @override
  List<Object?> get props => [status, error];
}
