// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:invo/repositories/due_repository.dart';
import 'package:meta/meta.dart';

part 'due_event.dart';
part 'due_state.dart';

class DueBloc extends Bloc<DueEvent, DueState> {
  final DueRepository _dueRepository;
  DueBloc(this._dueRepository) : super(DueDataState()) {
    on<GetAllDueCount>((event, emit) async {
      emit((state as DueDataState).copyWith(isLoadingCount: true));
      try {
        final dueCount = await _dueRepository.getAllDues();
        emit(
          (state as DueDataState).copyWith(
            count: dueCount,
            isLoadingCount: false,
          ),
        );
      } catch (e) {
        emit(
          (state as DueDataState).copyWith(
            error: e.toString(),
            isLoadingCount: false,
          ),
        );
      }
    });

    on<GetBuyersWithDueList>((event, emit) async {
      emit((state as DueDataState).copyWith(isLoadingList: true));
      try {
        final dueDetailsList = await _dueRepository.getDueDetailList();
        emit(
          (state as DueDataState).copyWith(
            dueDetailsList: dueDetailsList,
            isLoadingList: false,
          ),
        );
      } catch (e) {
        emit(
          (state as DueDataState).copyWith(
            error: e.toString(),
            isLoadingList: false,
          ),
        );
      }
    });

    on<PayDueEvent>((event, emit) async {
      emit((state as DueDataState).copyWith(isLoadingPayDue: true));
      try {
        final payDueSucess = await _dueRepository.payDue(
          event.buyerId,
          event.amount,
        );
        emit((state as DueDataState).copyWith(payDueSucess: payDueSucess));
        // add(GetAllDueCount());
        // add(GetBuyersWithDueList());
      } catch (e) {
        emit(
          (state as DueDataState).copyWith(
            error: e.toString(),
            isLoadingPayDue: false,
          ),
        );
      }
    });
  }
}
