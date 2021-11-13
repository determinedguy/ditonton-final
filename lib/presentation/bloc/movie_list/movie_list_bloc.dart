import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

part 'movie_list_event.dart';

part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies _getNowPlayingMovies;
  final GetPopularMovies _getPopularMovies;
  final GetTopRatedMovies _getTopRatedMovies;
  List<Movie> _nowPlaying = [];
  List<Movie> _popular = [];
  List<Movie> _topRated = [];

  MovieListBloc({
    required GetNowPlayingMovies getNowPlayingMovies,
    required GetPopularMovies getPopularMovies,
    required GetTopRatedMovies getTopRatedMovies,
  })  : _getNowPlayingMovies = getNowPlayingMovies,
        _getPopularMovies = getPopularMovies,
        _getTopRatedMovies = getTopRatedMovies,
        super(MovieListInitial()) {
    on<LoadMovieListEvent>(_loadHome);
  }

  List<Movie> get nowPlaying => _nowPlaying;

  List<Movie> get popular => _popular;

  List<Movie> get topRated => _topRated;

  void _loadHome(
    LoadMovieListEvent event,
    Emitter<MovieListState> emit,
  ) async {
    emit(MovieListInitial());
    final nowPlayingResult = await _getNowPlayingMovies.execute();
    final popularResult = await _getPopularMovies.execute();
    final topRatedResult = await _getTopRatedMovies.execute();
    int countResult = 0;
    String errorMessage = "";
    nowPlayingResult.fold((failure) {
      errorMessage = failure.message;
    }, (movie) {
      countResult++;
      _nowPlaying = movie;
    });

    if (countResult == 1) {
      popularResult.fold((failure) {
        errorMessage = failure.message;
      }, (movie) {
        countResult++;
        _popular = movie;
      });
    }

    if (countResult == 2) {
      topRatedResult.fold((failure) {
        errorMessage = failure.message;
      }, (movie) {
        countResult++;
        _topRated = movie;
      });
    }

    if (countResult == 3) {
      emit(MovieListLoadedState());
    } else {
      emit(LoadMovieListFailureState(
        message: errorMessage,
      ));
    }
  }
}
