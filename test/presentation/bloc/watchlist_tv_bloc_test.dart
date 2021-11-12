import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTV])
void main() {
  late WatchlistTVBloc bloc;
  late MockGetWatchlistTV mockGetWatchlistTV;

  setUp(() {
    mockGetWatchlistTV = MockGetWatchlistTV();
    bloc =
        WatchlistTVBloc(getWatchlistTV: mockGetWatchlistTV);
  });

  blocTest<WatchlistTVBloc, WatchlistTVState>(
      "should emit [WatchlistTVInitial, WatchlistTVLoadedState] when data is gotten successfully",
      build: () {
        when(mockGetWatchlistTV.execute())
            .thenAnswer((_) async => Right([testWatchlistTV]));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistTVEvent()),
      expect: () => [
            WatchlistTVInitial(),
            WatchlistTVLoadedState(),
          ],
      verify: (bloc) {
        verify(mockGetWatchlistTV.execute());
      });

  blocTest<WatchlistTVBloc, WatchlistTVState>(
      "should emit [WatchlistTVInitial, LoadWatchlistTVFailureState] when get data is unsuccessful",
      build: () {
        when(mockGetWatchlistTV.execute()).thenAnswer(
            (realInvocation) async => Left(DatabaseFailure("Can't get data")));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistTVEvent()),
      expect: () => [
            WatchlistTVInitial(),
            LoadWatchlistTVFailureState(message: "Can't get data"),
          ],
      verify: (bloc) {
        verify(mockGetWatchlistTV.execute());
      });
}
