import 'package:bloc/bloc.dart';
import 'package:invo/models/buyer_model.dart';
import 'package:invo/repositories/buyer_repository.dart';
import 'package:meta/meta.dart';

part 'buyer_event.dart';
part 'buyer_state.dart';

class BuyerBloc extends Bloc<BuyerEvent, BuyerState> {
  final BuyerRepository buyerRepository;
  BuyerBloc(this.buyerRepository) : super(BuyerInitial()) {
    
    on<GetBuyersListEvent>((event, emit) async {
      emit(BuyerLoadingState());
      try {
        final buyers = await buyerRepository.getBuyers();
        if (buyers != null) {
          emit(BuyersListLoadedState(buyers));
        } else {
          emit(BuyersListLoadedState([]));
        }
      } catch (e) {
        emit(BuyerErrorState(e.toString()));
      }
    });
  }
}
