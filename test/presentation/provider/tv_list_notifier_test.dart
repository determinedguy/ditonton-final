import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTV, GetPopularTV, GetTopRatedTV])
void main() {
  late TVListNotifier provider;
  late MockGetNowPlayingTV mockGetNowPlayingTV;
  late MockGetPopularTV mockGetPopularTV;
  late MockGetTopRatedTV mockGetTopRatedTV;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTV = MockGetNowPlayingTV();
    mockGetPopularTV = MockGetPopularTV();
    mockGetTopRatedTV = MockGetTopRatedTV();
    provider = TVListNotifier(
      getNowPlayingTV: mockGetNowPlayingTV,
      getPopularTV: mockGetPopularTV,
      getTopRatedTV: mockGetTopRatedTV,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTV = TV(
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2, 3],
    id: 1,
    lastAirDate: 'lastAirDate',
    name: 'name',
    originalName: 'originalName',
    overview: 'Overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );
  final tShows = <TV>[tTV];

  group('now playing TV', () {
    test('initialState should be Empty', () {
      expect(provider.nowPlayingState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetNowPlayingTV.execute())
          .thenAnswer((_) async => Right(tShows));
      // act
      provider.fetchNowPlayingTV();
      // assert
      verify(mockGetNowPlayingTV.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetNowPlayingTV.execute())
          .thenAnswer((_) async => Right(tShows));
      // act
      provider.fetchNowPlayingTV();
      // assert
      expect(provider.nowPlayingState, RequestState.Loading);
    });

    test('should change TV when data is gotten successfully', () async {
      // arrange
      when(mockGetNowPlayingTV.execute())
          .thenAnswer((_) async => Right(tShows));
      // act
      await provider.fetchNowPlayingTV();
      // assert
      expect(provider.nowPlayingState, RequestState.Loaded);
      expect(provider.nowPlayingTV, tShows);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetNowPlayingTV.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchNowPlayingTV();
      // assert
      expect(provider.nowPlayingState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular TV', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTV.execute())
          .thenAnswer((_) async => Right(tShows));
      // act
      provider.fetchPopularTV();
      // assert
      expect(provider.popularTVState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change TV data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetPopularTV.execute())
          .thenAnswer((_) async => Right(tShows));
      // act
      await provider.fetchPopularTV();
      // assert
      expect(provider.popularTVState, RequestState.Loaded);
      expect(provider.popularTV, tShows);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTV.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTV();
      // assert
      expect(provider.popularTVState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated TV', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTV.execute())
          .thenAnswer((_) async => Right(tShows));
      // act
      provider.fetchTopRatedTV();
      // assert
      expect(provider.topRatedTVState, RequestState.Loading);
    });

    test('should change TV data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTopRatedTV.execute())
          .thenAnswer((_) async => Right(tShows));
      // act
      await provider.fetchTopRatedTV();
      // assert
      expect(provider.topRatedTVState, RequestState.Loaded);
      expect(provider.topRatedTV, tShows);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTV.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTV();
      // assert
      expect(provider.topRatedTVState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
