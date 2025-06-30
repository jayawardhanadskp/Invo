// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:invo/models/buyer_model.dart';
import 'package:invo/models/purchase_model.dart';
import 'package:invo/models/recent_sale_model.dart';
import 'package:invo/repositories/buyer_repository.dart';
import 'package:invo/repositories/purchases_repository.dart';
import 'package:meta/meta.dart';

part 'purchase_event.dart';
part 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final PurchasesRepository purchasesRepository;
  PurchaseBloc(this.purchasesRepository) : super(PurchaseInitial()) {
    on<CreatePurchaseNewBuyerEvent>((event, emit) {
      emit(PurchaseLoadingState());
      try {
        purchasesRepository.createPurchaseNewBuyer(event.buyer, event.purchase);
        emit(PurchaseSuccessState(message: 'Purchase created successfully'));
      } catch (e) {
        emit(PurchaseErrorState(error: e.toString()));
      }
    });

    on<CreatePurchaseExistingBuyerEvent>((event, emit) {
      emit(PurchaseLoadingState());
      try {
        purchasesRepository.createPurchaseExistingBuyer(
          event.buyer,
          event.purchase,
        );
        emit(PurchaseSuccessState(message: 'Purchase created successfully'));
      } catch (e) {
        emit(PurchaseErrorState(error: e.toString()));
      }
    });

    on<GetPurchaseWithBuyerNameEvent>((event, emit) async {
      emit(GetPurchaseWithBuyerNameLoadingState());
      try {
        final purchases = await purchasesRepository.getPurchasesWithBuyerName();
        List<RecentSale> recentSales = [];
        if (purchases.isEmpty) {
            emit(GetPurchaseWithBuyerNameEmptyState(emptySales: []));
          }

        for (var purchase in purchases) {
          final buyer = await BuyerRepository().getBuyerBuyerId(
            purchase.buyerId ?? '',
          );

          

          recentSales.add(
            RecentSale(
              customerName: buyer!.name,
              amount: purchase.amount.toString(),
              pieces: purchase.pieces,
              dateTime: purchase.purchaseDate,
              paymentMethod: purchase.paymentType,
            ),
          );
          if (recentSales.isEmpty) {
            emit(GetPurchaseWithBuyerNameEmptyState(emptySales: []));
          } else {
            emit(GetPurchaseWithBuyerNameSuccessState(recentSales: recentSales));
          }
        }
      } catch (error) {
        emit(GetPurchaseWithBuyerNameErrorState(error: error.toString()));
      }
    });
  }
}
