part of 'purchase_bloc.dart';

@immutable
sealed class PurchaseEvent {}

class CreatePurchaseNewBuyerEvent extends PurchaseEvent {
  final BuyerModel buyer;
  final PurchaseModel purchase;

  CreatePurchaseNewBuyerEvent({
    required this.buyer,
    required this.purchase,
  });
}

