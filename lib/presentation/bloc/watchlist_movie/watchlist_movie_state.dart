part of 'watchlist_movie_bloc.dart';

@immutable
abstract class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();

  @override
  List<Object> get props => [];
}

class WatchlistMovieInitial extends WatchlistMovieState {}

class WatchlistMovieLoadedState extends WatchlistMovieState {}

class LoadWatchlistMovieFailureState extends WatchlistMovieState {
  final String message;

  LoadWatchlistMovieFailureState({
    this.message = "",
  });
}
