import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'top_rated_movie_event.dart';

part 'top_rated_movie_state.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  final GetTopRatedMovies _getTopRatedMovies;
  List<Movie> _topRatedList = [];

  List<Movie> get topRatedList => _topRatedList;

  TopRatedMovieBloc({
    required GetTopRatedMovies getTopRatedMovies,
  })  : _getTopRatedMovies = getTopRatedMovies,
        super(TopRatedMovieInitial()) {
    on<LoadTopRatedMovieEvent>((event, emit) async {
      emit(TopRatedMovieInitial());
      final result = await _getTopRatedMovies.execute();
      result.fold(
        (failure) => emit(LoadTopRatedMovieFailureState(
          message: failure.message,
        )),
        (data) {
          _topRatedList = data;
          emit(TopRatedMovieLoadedState());
        },
      );
    });
  }
}
