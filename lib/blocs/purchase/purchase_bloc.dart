import 'package:bloc/bloc.dart';
import 'package:invo/models/buyer_model.dart';
import 'package:invo/models/purchase_model.dart';
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
  }
}
