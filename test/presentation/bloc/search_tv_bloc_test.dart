import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/bloc/search_tv/search_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_tv_bloc_test.mocks.dart';

@GenerateMocks([SearchTV])
void main() {
  late SearchTVBloc searchBloc;
  late MockSearchTV mockSearchTV;

  setUp(() {
    mockSearchTV = MockSearchTV();
    searchBloc = SearchTVBloc(mockSearchTV);
  });

  test('initial state should be empty', () {
    expect(searchBloc.state, SearchTVEmpty());
  });

  final tTVModel = TV(
    backdropPath: '/qw3J9cNeLioOLoR68WX7z79aCdK.jpg',
    firstAirDate: '2021-09-17',
    genreIds: [10759, 9648, 18],
    id: 93405,
    lastAirDate: '',
    name: 'Squid Game',
    originalName: '오징어 게임',
    overview:
        "Hundreds of cash-strapped players accept a strange invitation to compete in children's games—with high stakes. But, a tempting prize awaits the victor.",
    popularity: 3575.758,
    posterPath: '/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
    voteAverage: 7.8,
    voteCount: 8404,
  );
  final tTVList = <TV>[tTVModel];
  final tQuery = 'squid game';

  blocTest<SearchTVBloc, SearchTVState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTV.execute(tQuery))
          .thenAnswer((_) async => Right(tTVList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTVLoading(),
      SearchTVHasData(tTVList),
    ],
    verify: (bloc) {
      verify(mockSearchTV.execute(tQuery));
    },
  );

  blocTest<SearchTVBloc, SearchTVState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTV.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTVLoading(),
      SearchTVError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTV.execute(tQuery));
    },
  );
}
