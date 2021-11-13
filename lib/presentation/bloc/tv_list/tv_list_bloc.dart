import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:equatable/equatable.dart';

part 'tv_list_event.dart';

part 'tv_list_state.dart';

class TVListBloc extends Bloc<TVListEvent, TVListState> {
  final GetNowPlayingTV _getNowPlayingTV;
  final GetPopularTV _getPopularTV;
  final GetTopRatedTV _getTopRatedTV;
  List<TV> _nowPlaying = [];
  List<TV> _popular = [];
  List<TV> _topRated = [];

  TVListBloc({
    required GetNowPlayingTV getNowPlayingTV,
    required GetPopularTV getPopularTV,
    required GetTopRatedTV getTopRatedTV,
  })  : _getNowPlayingTV = getNowPlayingTV,
        _getPopularTV = getPopularTV,
        _getTopRatedTV = getTopRatedTV,
        super(TVListInitial()) {
    on<LoadTVListEvent>(_loadHome);
  }

  List<TV> get nowPlaying => _nowPlaying;

  List<TV> get popular => _popular;

  List<TV> get topRated => _topRated;

  void _loadHome(
    LoadTVListEvent event,
    Emitter<TVListState> emit,
  ) async {
    emit(TVListInitial());
    final nowPlayingResult = await _getNowPlayingTV.execute();
    final popularResult = await _getPopularTV.execute();
    final topRatedResult = await _getTopRatedTV.execute();
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
      emit(TVListLoadedState());
    } else {
      emit(LoadTVListFailureState(
        message: errorMessage,
      ));
    }
  }
}
