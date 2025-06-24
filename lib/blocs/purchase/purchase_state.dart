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


final class GetPurchaseWithBuyerNameLoadingState extends PurchaseState {}

final class GetPurchaseWithBuyerNameSuccessState extends PurchaseState {
  final List<RecentSale> recentSales;

  GetPurchaseWithBuyerNameSuccessState({required this.recentSales});
}
final class GetPurchaseWithBuyerNameEmptyState extends PurchaseState {
  final List emptySales;

  GetPurchaseWithBuyerNameEmptyState({required this.emptySales});
}

final class GetPurchaseWithBuyerNameErrorState extends PurchaseState {
  final String error;

  GetPurchaseWithBuyerNameErrorState({required this.error});
}