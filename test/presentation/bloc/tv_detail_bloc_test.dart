import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTVDetail,
  GetTVRecommendations,
  GetWatchListTVStatus,
  SaveWatchlistTV,
  RemoveWatchlistTV,
])
void main() {
  late TVDetailBloc bloc;
  late MockGetTVDetail mockGetTVDetail;
  late MockGetTVRecommendations mockGetTVRecommendations;
  late MockGetWatchListTVStatus mockGetWatchListTVStatus;
  late MockSaveWatchlistTV mockSaveWatchlist;
  late MockRemoveWatchlistTV mockRemoveWatchlist;

  final tId = 1;

  setUp(() {
    mockGetTVDetail = MockGetTVDetail();
    mockGetTVRecommendations = MockGetTVRecommendations();
    mockGetWatchListTVStatus = MockGetWatchListTVStatus();
    mockSaveWatchlist = MockSaveWatchlistTV();
    mockRemoveWatchlist = MockRemoveWatchlistTV();
    bloc = TVDetailBloc(
      getTVDetail: mockGetTVDetail,
      getWatchListTVStatus: mockGetWatchListTVStatus,
      getTVRecommendations: mockGetTVRecommendations,
      saveWatchlistTV: mockSaveWatchlist,
      removeWatchlistTV: mockRemoveWatchlist,
    );
  });

  blocTest<TVDetailBloc, TVDetailState>(
      "should emit [TVDetailInitial, TVDetailLoadedState] when data tv detail is gotten successfully",
      build: () {
        when(mockGetTVDetail.execute(tId))
            .thenAnswer((_) async => Right(testTVDetail));
        when(mockGetWatchListTVStatus.execute(tId))
            .thenAnswer((_) async => true);
        when(mockGetTVRecommendations.execute(tId))
            .thenAnswer((_) async => Right([testTV]));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTVDetailEvent(id: tId)),
      expect: () => [
            TVDetailInitial(),
            TVDetailLoadedState(),
          ],
      verify: (bloc) {
        verify(mockGetTVDetail.execute(tId));
      });

  blocTest<TVDetailBloc, TVDetailState>(
      "should emit [TVDetailInitial, LoadTVDetailFailureState] when data tv detail is gotten unsuccessfully",
      build: () {
        when(mockGetTVDetail.execute(tId)).thenAnswer((_) async =>
            Left(ConnectionFailure("Failed to connect to the network")));
        when(mockGetWatchListTVStatus.execute(tId))
            .thenAnswer((_) async => true);
        when(mockGetTVRecommendations.execute(tId))
            .thenAnswer((_) async => Right([testTV]));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTVDetailEvent(id: tId)),
      expect: () => [
            TVDetailInitial(),
            LoadTVDetailFailureState(
                message: "Failed to connect to the network"),
          ],
      verify: (bloc) {
        verify(mockGetTVDetail.execute(tId));
      });

  blocTest<TVDetailBloc, TVDetailState>(
      "should emit [TVDetailLoadingState, SuccessAddOrRemoveWatchlistState] when data is added to wishlist",
      build: () {
        when(mockSaveWatchlist.execute(testTVDetail))
            .thenAnswer((_) async => Right("Added to Watchlist"));
        return bloc;
      },
      act: (bloc) => bloc
          .add(AddTVWatchlistEvent(tvDetail: testTVDetail)),
      expect: () => [
            TVDetailLoadingState(),
            SuccessAddOrRemoveWatchlistState(message: "Added to Watchlist"),
          ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testTVDetail));
      });

  blocTest<TVDetailBloc, TVDetailState>(
      "should emit [TVDetailLoadingState, SuccessAddOrRemoveWatchlistState] when data is removed from wishlist",
      build: () {
        when(mockRemoveWatchlist.execute(testTVDetail))
            .thenAnswer((_) async => Right("Removed from Watchlist"));
        return bloc;
      },
      act: (bloc) => bloc.add(
          RemoveTVWatchlistEvent(tvDetail: testTVDetail)),
      expect: () => [
            TVDetailLoadingState(),
            SuccessAddOrRemoveWatchlistState(message: "Removed from Watchlist"),
          ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testTVDetail));
      });
}
