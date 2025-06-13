import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yojana/features/auth/data/auth_repository.dart';

// Events
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

// States
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

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(AuthState.unknown()) {
    on<AuthCheckRequested>((event, emit) async {
      final isSignedIn = await authRepository.isSignedIn();
      if (isSignedIn) {
        emit(AuthState.authenticated());
      } else {
        emit(AuthState.unauthenticated());
      }
    });
    on<AuthSignInRequested>((event, emit) async {
      try {
        await authRepository.signIn(event.email, event.password);
        emit(AuthState.authenticated());
      } catch (e) {
        emit(AuthState.unauthenticated(e.toString()));
      }
    });
    on<AuthSignUpRequested>((event, emit) async {
      try {
        await authRepository.signUp(event.email, event.password);
        emit(AuthState.authenticated());
      } catch (e) {
        emit(AuthState.unauthenticated(e.toString()));
      }
    });
    on<AuthSignOutRequested>((event, emit) async {
      await authRepository.signOut();
      emit(AuthState.unauthenticated());
    });
  }
}
