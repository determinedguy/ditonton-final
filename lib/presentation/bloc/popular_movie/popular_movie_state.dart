part of 'popular_movie_bloc.dart';

abstract class PopularMovieState extends Equatable {
  const PopularMovieState();

  @override
  List<Object> get props => [];
}

class PopularMovieInitial extends PopularMovieState {}

class PopularMovieLoadedState extends PopularMovieState {}

class LoadPopularMovieFailureState extends PopularMovieState {
  final String message;

  LoadPopularMovieFailureState({
    this.message = "",
  });

  @override
  List<Object> get props => [message];
}