part of 'due_bloc.dart';

@immutable
sealed class DueEvent {}

class GetAllDueCount extends DueEvent {}

class GetBuyersWithDueList extends DueEvent {}

class PayDueEvent extends DueEvent {
  final String buyerId;
  final int amount;

  PayDueEvent(this.buyerId, this.amount);
}
