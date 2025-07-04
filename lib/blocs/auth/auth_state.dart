part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthRegisterSucess extends AuthState {}
class AuthSuccess extends AuthState {
  final UserModel user;

  AuthSuccess(this.user);
}
class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}
