import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_tv_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTV])
void main() {
  late TopRatedTVBloc bloc;
  late MockGetTopRatedTV mockGetTopRatedTV;

  setUp(() {
    mockGetTopRatedTV = MockGetTopRatedTV();
    bloc = TopRatedTVBloc(getTopRatedTV: mockGetTopRatedTV);
  });

  blocTest<TopRatedTVBloc, TopRatedTVState>(
      "should emit [TopRatedTVInitial, TopRatedTVLoadedState] when data is gotten successfully",
      build: () {
        when(mockGetTopRatedTV.execute())
            .thenAnswer((_) async => Right([testWatchlistTV]));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTopRatedTVEvent()),
      expect: () => [
            TopRatedTVInitial(),
            TopRatedTVLoadedState(),
          ],
      verify: (bloc) {
        verify(mockGetTopRatedTV.execute());
      });

  blocTest<TopRatedTVBloc, TopRatedTVState>(
      "should emit [TopRatedTVInitial, LoadTopRatedTVFailureState] when get data is unsuccessful",
      build: () {
        when(mockGetTopRatedTV.execute()).thenAnswer(
            (realInvocation) async => Left(ServerFailure("Server Failure")));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTopRatedTVEvent()),
      expect: () => [
            TopRatedTVInitial(),
            LoadTopRatedTVFailureState(message: "Server Failure"),
          ],
      verify: (bloc) {
        verify(mockGetTopRatedTV.execute());
      });
}
