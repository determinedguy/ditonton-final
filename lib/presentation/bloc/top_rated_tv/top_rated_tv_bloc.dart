import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_tv_event.dart';

part 'top_rated_tv_state.dart';

class TopRatedTVBloc
    extends Bloc<TopRatedTVEvent, TopRatedTVState> {
  final GetTopRatedTV _getTopRatedTV;
  List<TV> _topRatedList = [];

  List<TV> get topRatedList => _topRatedList;

  TopRatedTVBloc({
    required GetTopRatedTV getTopRatedTV,
  })  : _getTopRatedTV = getTopRatedTV,
        super(TopRatedTVInitial()) {
    on<LoadTopRatedTVEvent>((event, emit) async {
      emit(TopRatedTVInitial());
      final result = await _getTopRatedTV.execute();
      result.fold(
        (failure) => emit(LoadTopRatedTVFailureState(
          message: failure.message,
        )),
        (data) {
          _topRatedList = data;
          emit(TopRatedTVLoadedState());
        },
      );
    });
  }
}
