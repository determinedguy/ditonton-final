part of 'top_rated_movie_bloc.dart';

@immutable
abstract class TopRatedMovieState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TopRatedMovieInitial extends TopRatedMovieState {}

class TopRatedMovieLoadedState extends TopRatedMovieState {}

class LoadTopRatedMovieFailureState extends TopRatedMovieState {
  final String message;

  LoadTopRatedMovieFailureState({
    this.message = "",
  });

  @override
  List<Object?> get props => [message];
}
