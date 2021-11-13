import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_tv_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTV])
void main() {
  late PopularTVBloc bloc;
  late MockGetPopularTV mockGetPopularTV;

  setUp(() {
    mockGetPopularTV = MockGetPopularTV();
    bloc = PopularTVBloc(getPopularTV: mockGetPopularTV);
  });

  blocTest<PopularTVBloc, PopularTVState>(
      "should emit [PopularTVInitial, PopularTVLoadedState] when data is gotten successfully",
      build: () {
        when(mockGetPopularTV.execute())
            .thenAnswer((_) async => Right([testWatchlistTV]));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadPopularTVEvent()),
      expect: () => [
            PopularTVInitial(),
            PopularTVLoadedState(),
          ],
      verify: (bloc) {
        verify(mockGetPopularTV.execute());
      });

  blocTest<PopularTVBloc, PopularTVState>(
      "should emit [PopularTVInitial, LoadPopularTVFailureState] when get data is unsuccessful",
      build: () {
        when(mockGetPopularTV.execute()).thenAnswer(
            (realInvocation) async => Left(ServerFailure("Server Failure")));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadPopularTVEvent()),
      expect: () => [
            PopularTVInitial(),
            LoadPopularTVFailureState(message: "Server Failure"),
          ],
      verify: (bloc) {
        verify(mockGetPopularTV.execute());
      });
}
