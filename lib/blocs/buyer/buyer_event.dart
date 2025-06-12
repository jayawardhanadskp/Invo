part of 'buyer_bloc.dart';

@immutable
sealed class BuyerEvent {}

class GetBuyersListEvent extends BuyerEvent {}
