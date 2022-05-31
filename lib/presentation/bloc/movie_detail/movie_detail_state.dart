part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoadingState extends MovieDetailState {}

class MovieDetailLoadedState extends MovieDetailState {}

class SuccessAddOrRemoveWatchlistState extends MovieDetailState {
  final String message;

  SuccessAddOrRemoveWatchlistState({
    this.message = "",
  });

  @override
  List<Object> get props => [message];
}

class FailedAddOrRemoveWatchlistState extends MovieDetailState {
  final String message;

  FailedAddOrRemoveWatchlistState({
    this.message = "",
  });
}

class LoadMovieDetailFailureState extends MovieDetailState {
  final String message;

  LoadMovieDetailFailureState({
    this.message = "",
  });
}

class LoadMovieRecommendationFailureState extends MovieDetailState {
  final String message;

  LoadMovieRecommendationFailureState({
    this.message = "",
  });
}
