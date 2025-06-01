part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignInWithGoogle extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
