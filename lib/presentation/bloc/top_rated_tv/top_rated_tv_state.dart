part of 'top_rated_tv_bloc.dart';

abstract class TopRatedTVState extends Equatable {
  const TopRatedTVState();

  @override
  List<Object?> get props => [];
}

class TopRatedTVInitial extends TopRatedTVState {}

class TopRatedTVLoadedState extends TopRatedTVState {}

class LoadTopRatedTVFailureState extends TopRatedTVState {
  final String message;

  LoadTopRatedTVFailureState({
    this.message = "",
  });

  @override
  List<Object?> get props => [message];
}
