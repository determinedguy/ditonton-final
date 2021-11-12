import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'watchlist_tv_event.dart';

part 'watchlist_tv_state.dart';

class WatchlistTVBloc
    extends Bloc<WatchlistTVEvent, WatchlistTVState> {
  final GetWatchlistTV _getWatchlistTV;
  List<TV> _watchlist = [];

  List<TV> get watchlist => _watchlist;

  WatchlistTVBloc({required GetWatchlistTV getWatchlistTV})
      : _getWatchlistTV = getWatchlistTV,
        super(WatchlistTVInitial()) {
    on<LoadWatchlistTVEvent>((event, emit) async {
      emit(WatchlistTVInitial());
      final result = await _getWatchlistTV.execute();
      result.fold(
        (failure) => emit(LoadWatchlistTVFailureState(
          message: failure.message,
        )),
        (data) {
          _watchlist = data;
          emit(WatchlistTVLoadedState());
        },
      );
    });
  }
}
