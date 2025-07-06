part of 'biometric_bloc.dart';

@immutable
// sealed class BiometricState {}

// final class BiometricInitial extends BiometricState {}

// --- States ---
abstract class BiometricState extends Equatable {
  const BiometricState();

  @override
  List<Object> get props => [];
}


class BiometricInitial extends BiometricState {}
class BiometricLoading extends BiometricState {}
class BiometricSuccess extends BiometricState {}
class BiometricFailure extends BiometricState {
  final String message;
  const BiometricFailure(this.message);

  @override
  List<Object> get props => [message];
}
class BiometricUnavailable extends BiometricState {
  final String message;
  const BiometricUnavailable(this.message);

  @override
  List<Object> get props => [message];
}

