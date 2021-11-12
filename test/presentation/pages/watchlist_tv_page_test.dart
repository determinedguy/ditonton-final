import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ditonton/injection.dart' as di;

import '../../dummy_data/dummy_objects.dart';

class FakeWatchlistTVEvent extends Fake
    implements WatchlistTVEvent {}

class FakeWatchlistTVState extends Fake
    implements WatchlistTVState {}

class MockWatchlistTVBloc
    extends MockBloc<WatchlistTVEvent, WatchlistTVState>
    implements WatchlistTVBloc {}

void main() {
  late WatchlistTVBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeWatchlistTVEvent());
    registerFallbackValue(FakeWatchlistTVState());
  });

  setUp(() async {
    await GetIt.I.reset();
    di.init();
    mockBloc = MockWatchlistTVBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      WatchlistTVInitial(),
    );

    final centerFinder = find.byType(Center);
    final progressFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(WatchlistTVPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display data when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      WatchlistTVLoadedState(),
    );
    when(() => mockBloc.watchlist).thenReturn([testWatchlistTV]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(WatchlistTVPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when data is empty',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      WatchlistTVLoadedState(),
    );
    when(() => mockBloc.watchlist).thenReturn([]);

    final textFinder = find.byKey(Key('empty_message'));

    await tester.pumpWidget(_makeTestableWidget(WatchlistTVPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
        LoadWatchlistTVFailureState(message: "Can't get data"));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(WatchlistTVPage()));

    expect(textFinder, findsOneWidget);
  });
}
