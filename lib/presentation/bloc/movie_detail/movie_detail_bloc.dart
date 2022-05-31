// ignore_for_file: deprecated_member_use

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'movie_detail_event.dart';

part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail _getMovieDetail;
  final GetMovieRecommendations _getMovieRecommendations;
  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  late MovieDetail _movie;
  List<Movie> _movieRecommendations = [];
  bool _isAddedToWatchlist = false;
  String _genres = "";
  String _duration = "";

  MovieDetail get movie => _movie;

  List<Movie> get movieRecommendations => _movieRecommendations;

  bool get isAddedToWatchlist => _isAddedToWatchlist;

  String get genres => _genres;

  String get duration => _duration;

  MovieDetailBloc({
    required GetMovieDetail getMovieDetail,
    required GetMovieRecommendations getMovieRecommendations,
    required GetWatchListStatus getWatchListStatus,
    required SaveWatchlist saveWatchlist,
    required RemoveWatchlist removeWatchlist,
  })  : _getMovieDetail = getMovieDetail,
        _getMovieRecommendations = getMovieRecommendations,
        _getWatchListStatus = getWatchListStatus,
        _saveWatchlist = saveWatchlist,
        _removeWatchlist = removeWatchlist,
        super(MovieDetailInitial()) {
    on<LoadMovieDetailEvent>(_loadDetail);
    on<AddMovieWatchlistEvent>(_addWatchlist);
    on<RemoveMovieWatchlistEvent>(_removeFromWatchlist);
  }

  void _loadDetail(
    LoadMovieDetailEvent event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailInitial());
    final detailResult = await _getMovieDetail.execute(event.id);
    final recommendationResult =
        await _getMovieRecommendations.execute(event.id);
    final statusResult = await _getWatchListStatus.execute(event.id);
    _isAddedToWatchlist = statusResult;
    detailResult.fold(
      (failure) {
        emit(LoadMovieDetailFailureState(message: failure.message));
      },
      (movie) {
        _movie = movie;
        _genres = _toGenresString(movie.genres);
        _duration = _formatDuration(movie.runtime);
        recommendationResult.fold(
          (failure) {
            emit(LoadMovieRecommendationFailureState(message: failure.message));
          },
          (movies) {
            _movieRecommendations = movies;
          },
        );
        emit(MovieDetailLoadedState());
      },
    );
  }

  void _addWatchlist(
    AddMovieWatchlistEvent event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoadingState());
    final result = await _saveWatchlist.execute(event.movie);

    await result.fold(
      (failure) async {
        emit(FailedAddOrRemoveWatchlistState(message: failure.message));
      },
      (successMessage) async {
        _isAddedToWatchlist = true;
        emit(SuccessAddOrRemoveWatchlistState(message: successMessage));
      },
    );
  }

  void _removeFromWatchlist(
    RemoveMovieWatchlistEvent event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoadingState());
    final result = await _removeWatchlist.execute(event.movie);

    await result.fold(
      (failure) async {
        emit(FailedAddOrRemoveWatchlistState(message: failure.message));
      },
      (successMessage) async {
        _isAddedToWatchlist = false;
        emit(SuccessAddOrRemoveWatchlistState(message: successMessage));
      },
    );
  }

  String _toGenresString(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _formatDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
