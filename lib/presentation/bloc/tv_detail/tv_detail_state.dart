part of 'tv_detail_bloc.dart';

abstract class TVDetailState extends Equatable {
  const TVDetailState();

  @override
  List<Object> get props => [];
}

class TVDetailInitial extends TVDetailState {}

class TVDetailLoadingState extends TVDetailState {}

class TVDetailLoadedState extends TVDetailState {}

class SuccessAddOrRemoveWatchlistState extends TVDetailState {
  final String message;

  SuccessAddOrRemoveWatchlistState({
    this.message = "",
  });
}

class FailedAddOrRemoveWatchlistState extends TVDetailState {
  final String message;

  FailedAddOrRemoveWatchlistState({
    this.message = "",
  });
}

class LoadTVDetailFailureState extends TVDetailState {
  final String message;

  LoadTVDetailFailureState({
    this.message = "",
  });
}

class LoadTVRecommendationFailureState extends TVDetailState {
  final String message;

  LoadTVRecommendationFailureState({
    this.message = "",
  });
}