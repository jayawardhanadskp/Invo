part of 'due_bloc.dart';

@immutable
sealed class DueState {}

class DueDataState extends DueState {
  final int? count;
  final List<dynamic>? dueDetailsList;
  final bool isLoadingCount;
  final bool isLoadingList;
  final bool isLoadingPayDue;
  final String? error;
  final String? payDueSucess;

  DueDataState({
    this.count,
    this.dueDetailsList,
    this.isLoadingCount = false,
    this.isLoadingList = false,
    this.isLoadingPayDue = false,
    this.error,
    this.payDueSucess,
  });

  DueDataState copyWith({
    int? count,
    List<dynamic>? dueDetailsList,
    bool? isLoadingCount,
    bool? isLoadingList,
    bool? isLoadingPayDue,
    String? error,
    String? payDueSucess,
  }) {
    return DueDataState(
      count: count ?? this.count,
      dueDetailsList: dueDetailsList ?? this.dueDetailsList,
      isLoadingCount: isLoadingCount ?? this.isLoadingCount,
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingPayDue: isLoadingPayDue ?? this.isLoadingPayDue,
      error: error ?? this.error,
      payDueSucess: payDueSucess ?? this.payDueSucess,
    );
  }
}
