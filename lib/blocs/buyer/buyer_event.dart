// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'buyer_bloc.dart';

@immutable
sealed class BuyerEvent {}

class GetBuyersListEvent extends BuyerEvent {}

class GetBuyerByIdEvent extends BuyerEvent {
  String buyerId;
  GetBuyerByIdEvent({
    required this.buyerId,
  });
}
