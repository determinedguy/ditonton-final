import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTV, GetPopularTV, GetTopRatedTV])
void main() {
  late TVListBloc bloc;
  late MockGetNowPlayingTV mockGetNowPlayingTV;
  late MockGetPopularTV mockGetPopularTV;
  late MockGetTopRatedTV mockGetTopRatedTV;

  setUp(() {
    mockGetNowPlayingTV = MockGetNowPlayingTV();
    mockGetPopularTV = MockGetPopularTV();
    mockGetTopRatedTV = MockGetTopRatedTV();
    bloc = TVListBloc(
      getNowPlayingTV: mockGetNowPlayingTV,
      getPopularTV: mockGetPopularTV,
      getTopRatedTV: mockGetTopRatedTV,
    );
  });

  blocTest<TVListBloc, TVListState>(
      'should emit [TVListInitial, TVListLoadedState] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingTV.execute())
            .thenAnswer((_) async => Right([testTV]));
        when(mockGetPopularTV.execute())
            .thenAnswer((_) async => Right([testTV]));
        when(mockGetTopRatedTV.execute())
            .thenAnswer((_) async => Right([testTV]));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTVListEvent()),
      expect: () => [
            TVListInitial(),
            TVListLoadedState(),
          ],
      verify: (bloc) {
        verify(mockGetNowPlayingTV.execute());
        verify(mockGetPopularTV.execute());
        verify(mockGetTopRatedTV.execute());
      });

  blocTest<TVListBloc, TVListState>(
      "should emit [TVListInitial, LoadTVListFailureState] when get data is unsuccessful",
      build: () {
        when(mockGetNowPlayingTV.execute())
            .thenAnswer((_) async => Right([testTV]));
        when(mockGetPopularTV.execute())
            .thenAnswer((_) async => Right([testTV]));
        when(mockGetTopRatedTV.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTVListEvent()),
      expect: () => [
            TVListInitial(),
            LoadTVListFailureState(message: 'Server Failure'),
          ],
      verify: (bloc) {
        verify(mockGetNowPlayingTV.execute());
        verify(mockGetPopularTV.execute());
        verify(mockGetTopRatedTV.execute());
      });
}
