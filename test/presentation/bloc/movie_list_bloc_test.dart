import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    bloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  blocTest<MovieListBloc, MovieListState>(
      'should emit [MovieListInitial, MovieListLoadedState] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadMovieListEvent()),
      expect: () => [
            MovieListInitial(),
            MovieListLoadedState(),
          ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
        verify(mockGetPopularMovies.execute());
        verify(mockGetTopRatedMovies.execute());
      });

  blocTest<MovieListBloc, MovieListState>(
      "should emit [MovieListInitial, LoadMovieListFailureState] when get data is unsuccessful",
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadMovieListEvent()),
      expect: () => [
            MovieListInitial(),
            LoadMovieListFailureState(message: 'Server Failure'),
          ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
        verify(mockGetPopularMovies.execute());
        verify(mockGetTopRatedMovies.execute());
      });
}
