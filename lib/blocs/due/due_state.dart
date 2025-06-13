part of 'due_bloc.dart';

@immutable
sealed class DueState {}

class DueDataState extends DueState {
  final int? count;
  final List<dynamic>? dueDetailsList;
  final bool isLoadingCount;
  final bool isLoadingList;
  final String? error;

  DueDataState({
    this.count,
    this.dueDetailsList,
    this.isLoadingCount = false,
    this.isLoadingList = false,
    this.error,
  });

  DueDataState copyWith({
    int? count,
    List<dynamic>? dueDetailsList,
    bool? isLoadingCount,
    bool? isLoadingList,
    String? error,
  }) {
    return DueDataState(
      count: count ?? this.count,
      dueDetailsList: dueDetailsList ?? this.dueDetailsList,
      isLoadingCount: isLoadingCount ?? this.isLoadingCount,
      isLoadingList: isLoadingList ?? this.isLoadingList,
      error: error ?? this.error,
    );
  }
}
