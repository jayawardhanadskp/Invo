part of 'batch_bloc.dart';

@immutable
sealed class BatchState {}

final class BatchInitial extends BatchState {}

class BatchLoading extends BatchState {}
class BatchSuccess extends BatchState {
  final BatchModel batch;

  BatchSuccess(this.batch);
}
class BatchFailure extends BatchState {
  final String error;

  BatchFailure(this.error);
}


class GetBatchLoading extends BatchState {}
class GetBatchSuccess extends BatchState {
  final List<BatchModel> batchList;

  GetBatchSuccess(this.batchList);
}
class GetBatchFailure extends BatchState {
  final String error;

  GetBatchFailure(this.error);
}
