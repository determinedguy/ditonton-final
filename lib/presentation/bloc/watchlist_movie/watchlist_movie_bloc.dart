import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'watchlist_movie_event.dart';

part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies _getWatchlistMovies;
  List<Movie> _watchlist = [];

  List<Movie> get watchlist => _watchlist;

  WatchlistMovieBloc({
    required GetWatchlistMovies getWatchlistMovies,
  })  : _getWatchlistMovies = getWatchlistMovies,
        super(WatchlistMovieInitial()) {
    on<LoadWatchlistMovieEvent>((event, emit) async {
      emit(WatchlistMovieInitial());
      final result = await _getWatchlistMovies.execute();
      result.fold(
        (failure) => emit(LoadWatchlistMovieFailureState()),
        (data) {
          _watchlist = data;
          emit(WatchlistMovieLoadedState());
        },
      );
    });
  }
}
