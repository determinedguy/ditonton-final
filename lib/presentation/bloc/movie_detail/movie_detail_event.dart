part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadMovieDetailEvent extends MovieDetailEvent {
  final int id;

  LoadMovieDetailEvent({required this.id});
}

class AddMovieWatchlistEvent extends MovieDetailEvent {
  final MovieDetail movie;

  AddMovieWatchlistEvent({
    required this.movie,
  });
}

class RemoveMovieWatchlistEvent extends MovieDetailEvent {
  final MovieDetail movie;

  RemoveMovieWatchlistEvent({
    required this.movie,
  });
}
