import 'package:bloc/bloc.dart';
import 'package:invo/models/batch_model.dart';
import 'package:invo/repositories/batch_repository.dart';
import 'package:meta/meta.dart';

part 'batch_event.dart';
part 'batch_state.dart';

class BatchBloc extends Bloc<BatchEvent, BatchState> {
  final BatchRepository batchRepository;
  BatchBloc(this.batchRepository) : super(BatchInitial()) {
    on<CreateBatch>((event, emit) {
      emit(BatchLoading());

      try {
        final batch = BatchModel(
          grams: event.grams,
          pieces: event.pieces,
          createdAt: event.createAt,
          note: event.note,
        );

        batchRepository.createBatch(
          batch.grams,
          batch.pieces,
          batch.pieces,
          batch.note ?? '',
          batch.createdAt,
        );
        emit(BatchSuccess(batch));
      } catch (e) {
        emit(BatchFailure(e.toString()));
      }
    });
  }
}
