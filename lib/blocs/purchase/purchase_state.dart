part of 'purchase_bloc.dart';

@immutable
sealed class PurchaseState {}

final class PurchaseInitial extends PurchaseState {}

final class PurchaseLoadingState extends PurchaseState {}

final class PurchaseSuccessState extends PurchaseState {
  final String message;

  PurchaseSuccessState({required this.message});
}

final class PurchaseErrorState extends PurchaseState {
  final String error;

  PurchaseErrorState({required this.error});
}