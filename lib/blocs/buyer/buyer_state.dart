part of 'buyer_bloc.dart';

@immutable
sealed class BuyerState {}

final class BuyerInitial extends BuyerState {}

final class BuyerLoadingState extends BuyerState {}
final class BuyersListLoadedState extends BuyerState {
  final List<BuyerModel> buyers;

  BuyersListLoadedState(this.buyers);
}

final class BuyerErrorState extends BuyerState {
  final String error;

  BuyerErrorState(this.error);
}




