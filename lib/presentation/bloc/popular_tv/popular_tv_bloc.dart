import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:equatable/equatable.dart';

part 'popular_tv_event.dart';

part 'popular_tv_state.dart';

class PopularTVBloc
    extends Bloc<PopularTVEvent, PopularTVState> {
  final GetPopularTV _getPopularTV;
  List<TV> _popularList = [];

  List<TV> get popularList => _popularList;

  PopularTVBloc({required GetPopularTV getPopularTV})
      : _getPopularTV = getPopularTV,
        super(PopularTVInitial()) {
    on<LoadPopularTVEvent>((event, emit) async {
      emit(PopularTVInitial());
      final result = await _getPopularTV.execute();
      result.fold(
        (failure) => emit(LoadPopularTVFailureState(
          message: failure.message,
        )),
        (data) {
          _popularList = data;
          emit(PopularTVLoadedState());
        },
      );
    });
  }
}
