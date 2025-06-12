import 'package:bloc/bloc.dart';
import 'package:invo/repositories/due_repository.dart';
import 'package:meta/meta.dart';

part 'due_event.dart';
part 'due_state.dart';

class DueBloc extends Bloc<DueEvent, DueState> {
  final DueRepository _dueRepository;
  DueBloc(this._dueRepository) : super(DueInitial()) {
    on<GetAllDueCount>((event, emit) async {
      emit(GetAllDueCountLoading());
      try {
        final dueCount = await _dueRepository.getAllDues();
        emit(GetAllDueCountSuccess(dueCount));
      } catch (e) {
        emit((GetAllDueCountError(e.toString())));
      }
    });
  }
}
