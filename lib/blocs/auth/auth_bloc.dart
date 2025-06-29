// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:invo/models/user_model.dart';
import 'package:invo/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SignInWithGoogle>((event, emit) async {
      emit(AuthLoading());

      try {
        await authRepository.signInWithGoogle();
        emit(AuthRegisterSucess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<AuthCheckRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.getCurrentUser();

      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthInitial());
      }
      } catch (e) {
        emit(AuthFailure("Session expired. Please sign in again. $e"));
      }
    });
  }
}
