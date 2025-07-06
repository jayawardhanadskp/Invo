part of 'biometric_bloc.dart';

@immutable
// sealed class BiometricEvent {}

// --- Events ---
abstract class BiometricEvent extends Equatable {
  const BiometricEvent();

  @override
  List<Object> get props => [];
}

class AuthenticateBiometric extends BiometricEvent {}

