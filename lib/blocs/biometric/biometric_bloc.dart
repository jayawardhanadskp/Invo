import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:invo/repositories/biometric_repository.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'biometric_event.dart';
part 'biometric_state.dart';

// class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
//   BiometricBloc() : super(BiometricInitial()) {
//     on<BiometricEvent>((event, emit) {
//       // TODO: implement event handler
//     });
//   }
// }

// --- Bloc ---
class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  final BiometricRepository biometricRepository;

  BiometricBloc(this.biometricRepository) : super(BiometricInitial()) {
    on<AuthenticateBiometric>(_onAuthenticateBiometric);
  }

  Future<void> _onAuthenticateBiometric(
    AuthenticateBiometric event,
    Emitter<BiometricState> emit,
  ) async {
    emit(BiometricLoading());
    try {
      final bool isAuthenticated = await biometricRepository.authenticate();
      if (isAuthenticated) {
        emit(BiometricSuccess());
      } else {
        // The repository already handles common errors by returning false,
        // but for specific error messages, you might need more detailed info from the repository.
        emit(const BiometricFailure('Authentication failed.'));
      }
    } on PlatformException catch (e) {
      String errorMessage = 'An error occurred during authentication.';
      if (e.code == auth_error.notEnrolled) {
        errorMessage = 'No biometrics enrolled. Please set up biometrics in your device settings.';
        emit(BiometricUnavailable(errorMessage));
        return;
      } else if (e.code == auth_error.passcodeNotSet) {
        errorMessage = 'Device passcode not set. Please set a passcode in your device settings.';
        emit(BiometricUnavailable(errorMessage));
        return;
      } else if (e.code == auth_error.lockedOut || e.code == auth_error.permanentlyLockedOut) {
        errorMessage = 'Biometrics temporarily locked out. Please try again later or use your device PIN/pattern.';
      }
      emit(BiometricFailure(errorMessage));
    } catch (e) {
      emit(BiometricFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
