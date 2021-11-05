import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TVDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTVDetail getTVDetail;
  final GetTVRecommendations getTVRecommendations;
  final GetWatchListTVStatus getWatchListTVStatus;
  final SaveWatchlistTV saveWatchlistTV;
  final RemoveWatchlistTV removeWatchlistTV;

  TVDetailNotifier({
    required this.getTVDetail,
    required this.getTVRecommendations,
    required this.getWatchListTVStatus,
    required this.saveWatchlistTV,
    required this.removeWatchlistTV,
  });

  late TVDetail _tv;
  TVDetail get tv => _tv;

  RequestState _tvState = RequestState.Empty;
  RequestState get tvState => _tvState;

  List<TV> _tvRecommendations = [];
  List<TV> get tvRecommendations => _tvRecommendations;

  RequestState _tvRecommendationState = RequestState.Empty;
  RequestState get tvRecommendationState => _tvRecommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlistTV = false;
  bool get isAddedToWatchlistTV => _isAddedtoWatchlistTV;

  Future<void> fetchTVDetail(int id) async {
    _tvState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTVDetail.execute(id);
    final recommendationResult = await getTVRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        _tvRecommendationState = RequestState.Loading;
        _tv = tv;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _tvRecommendationState = RequestState.Error;
            _message = failure.message;
          },
          (shows) {
            _tvRecommendationState = RequestState.Loaded;
            _tvRecommendations = shows;
          },
        );
        _tvState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlistTV(TVDetail tv) async {
    final result = await saveWatchlistTV.execute(tv);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistTVStatus(tv.id);
  }

  Future<void> removeFromWatchlistTV(TVDetail tv) async {
    final result = await removeWatchlistTV.execute(tv);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistTVStatus(tv.id);
  }

  Future<void> loadWatchlistTVStatus(int id) async {
    final result = await getWatchListTVStatus.execute(id);
    _isAddedtoWatchlistTV = result;
    notifyListeners();
  }
}
