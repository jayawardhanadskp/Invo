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
        final user = await authRepository.signInWithGoogle();
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<AuthCheckRequested>((event, emit) {
emit(AuthLoading());
  final user = authRepository.getCurrentUser();

  if (user != null) {
    emit(AuthSuccess(user));
  } else {
    emit(AuthInitial());
  }
});

  }
}
