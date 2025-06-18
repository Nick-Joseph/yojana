import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yojana/features/auth/data/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

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
