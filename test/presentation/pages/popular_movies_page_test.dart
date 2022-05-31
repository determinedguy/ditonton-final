import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class FakePopularMovieEvent extends Fake implements PopularMovieEvent {}

class FakePopularMovieState extends Fake implements PopularMovieState {}

class MockPopularMovieBloc
    extends MockBloc<PopularMovieEvent, PopularMovieState>
    implements PopularMovieBloc {}

void main() {
  late MockPopularMovieBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakePopularMovieEvent());
    registerFallbackValue(FakePopularMovieState());
  });

  setUp(() async {
    mockBloc = MockPopularMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularMovieBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets('PopularMovieList should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(PopularMovieInitial());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularMovieList()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('PopularMovieList should display when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(PopularMovieLoadedState());
    when(() => mockBloc.popularList).thenReturn(testMovieList);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularMovieList()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('PopularMovieList should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(LoadPopularMovieFailureState(message: 'Server Failure'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularMovieList()));

    expect(textFinder, findsOneWidget);
  });
}
