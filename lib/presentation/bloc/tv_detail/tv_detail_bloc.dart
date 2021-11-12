import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:equatable/equatable.dart';

part 'tv_detail_event.dart';

part 'tv_detail_state.dart';

class TVDetailBloc
    extends Bloc<TVDetailEvent, TVDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTVDetail _getTVDetail;
  final GetTVRecommendations _getTVRecommendations;
  final GetWatchListTVStatus _getWatchListTVStatus;
  final SaveWatchlistTV _saveWatchlistTV;
  final RemoveWatchlistTV _removeWatchlistTV;

  late TVDetail _tvDetail;
  List<TV> _tvRecommendations = [];
  bool _isAddedToWatchlist = false;
  String _genres = "";

  TVDetail get tvDetail => _tvDetail;

  List<TV> get tvRecommendations => _tvRecommendations;

  bool get isAddedToWatchlist => _isAddedToWatchlist;

  String get genres => _genres;

  TVDetailBloc({
    required GetTVDetail getTVDetail,
    required GetTVRecommendations getTVRecommendations,
    required GetWatchListTVStatus getWatchListTVStatus,
    required SaveWatchlistTV saveWatchlistTV,
    required RemoveWatchlistTV removeWatchlistTV,
  })  : _getTVDetail = getTVDetail,
        _getTVRecommendations = getTVRecommendations,
        _getWatchListTVStatus = getWatchListTVStatus,
        _saveWatchlistTV = saveWatchlistTV,
        _removeWatchlistTV = removeWatchlistTV,
        super(TVDetailInitial()) {
    on<LoadTVDetailEvent>(_loadDetail);
    on<AddTVWatchlistEvent>(_addWatchlist);
    on<RemoveTVWatchlistEvent>(_removeFromWatchlist);
  }

  void _loadDetail(
    LoadTVDetailEvent event,
    Emitter<TVDetailState> emit,
  ) async {
    emit(TVDetailInitial());
    final detailResult = await _getTVDetail.execute(event.id);
    final recommendationResult =
        await _getTVRecommendations.execute(event.id);
    final statusResult = await _getWatchListTVStatus.execute(event.id);
    _isAddedToWatchlist = statusResult;
    detailResult.fold(
      (failure) {
        emit(LoadTVDetailFailureState(message: failure.message));
      },
      (tvData) {
        _tvDetail = tvData;
        _genres = _toGenresString(tvDetail.genres);
        recommendationResult.fold(
          (failure) {
            emit(LoadTVDetailFailureState(message: failure.message));
          },
          (tvRecommendation) {
            _tvRecommendations = tvRecommendation;
          },
        );
        emit(TVDetailLoadedState());
      },
    );
  }

  void _addWatchlist(
    AddTVWatchlistEvent event,
    Emitter<TVDetailState> emit,
  ) async {
    emit(TVDetailLoadingState());
    final result = await _saveWatchlistTV.execute(event.tvDetail);

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
    RemoveTVWatchlistEvent event,
    Emitter<TVDetailState> emit,
  ) async {
    emit(TVDetailLoadingState());
    final result = await _removeWatchlistTV.execute(event.tvDetail);

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
}
