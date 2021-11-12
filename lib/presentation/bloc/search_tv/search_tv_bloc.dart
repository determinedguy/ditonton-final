// ignore_for_file: deprecated_member_use

import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'search_tv_event.dart';
part 'search_tv_state.dart';

class SearchTVBloc extends Bloc<SearchTVEvent, SearchTVState> {
  final SearchTV _searchTV;

  SearchTVBloc(this._searchTV) : super(SearchTVEmpty());

  @override
  Stream<SearchTVState> mapEventToState(
    SearchTVEvent event,
  ) async* {
    if (event is OnQueryChanged) {
      final query = event.query;

      yield SearchTVLoading();
      final result = await _searchTV.execute(query);

      yield* result.fold(
        (failure) async* {
          yield SearchTVError(failure.message);
        },
        (data) async* {
          yield SearchTVHasData(data);
        },
      );
    }
  }

  @override
  Stream<Transition<SearchTVEvent, SearchTVState>> transformEvents(
    Stream<SearchTVEvent> events,
    TransitionFunction<SearchTVEvent, SearchTVState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }
}
