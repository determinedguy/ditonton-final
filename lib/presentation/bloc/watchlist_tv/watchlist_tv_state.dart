part of 'watchlist_tv_bloc.dart';

@immutable
abstract class WatchlistTVState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WatchlistTVInitial extends WatchlistTVState {}

class WatchlistTVLoadedState extends WatchlistTVState {}

class LoadWatchlistTVFailureState extends WatchlistTVState {
  final String message;

  LoadWatchlistTVFailureState({
    this.message = "",
  });

  @override
  List<Object?> get props => [message];
}
