part of 'due_bloc.dart';

@immutable
sealed class DueState {}

final class DueInitial extends DueState {}

final class GetAllDueCountLoading extends DueState {}

final class GetAllDueCountSuccess extends DueState {
  final int count;

  GetAllDueCountSuccess(this.count);
}

final class GetAllDueCountError extends DueState {
  final String message;

  GetAllDueCountError(this.message);
}
