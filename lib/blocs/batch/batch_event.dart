// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'batch_bloc.dart';

@immutable
sealed class BatchEvent {}

class CreateBatch extends BatchEvent {
  final String grams;
  final int pieces;
  final String note;
  final DateTime createAt;
  CreateBatch({
    required this.grams,
    required this.pieces,
    required this.note,
    required this.createAt,
  });
}

class GetBatchesEvent extends BatchEvent {}
