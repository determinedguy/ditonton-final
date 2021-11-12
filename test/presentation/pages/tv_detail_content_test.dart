import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class FakeTVDetailEvent extends Fake implements TVDetailEvent {}

class FakeTVDetailState extends Fake implements TVDetailState {}

class MockTVDetailBloc extends MockBloc<TVDetailEvent, TVDetailState>
    implements TVDetailBloc {}

void main() {
  late MockTVDetailBloc mockBloc;
  int tId = 1;

  setUpAll(() {
    registerFallbackValue(FakeTVDetailEvent());
    registerFallbackValue(FakeTVDetailState());
  });

  setUp(() async {
    mockBloc = MockTVDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TVDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when tv series not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TVDetailLoadedState());
    when(() => mockBloc.tvDetail).thenReturn(testTVDetail);
    when(() => mockBloc.tvRecommendations).thenReturn([testTV]);
    when(() => mockBloc.genres).thenReturn("Action");
    when(() => mockBloc.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TVDetailContentSection(
      id: tId,
    )));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv series is added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TVDetailLoadedState());
    when(() => mockBloc.tvDetail).thenReturn(testTVDetail);
    when(() => mockBloc.tvRecommendations).thenReturn([testTV]);
    when(() => mockBloc.genres).thenReturn("Action");
    when(() => mockBloc.isAddedToWatchlist).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TVDetailContentSection(
      id: tId,
    )));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when success added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TVDetailLoadedState());
    when(() => mockBloc.tvDetail).thenReturn(testTVDetail);
    when(() => mockBloc.tvRecommendations).thenReturn([testTV]);
    when(() => mockBloc.genres).thenReturn("Action");
    when(() => mockBloc.isAddedToWatchlist).thenReturn(false);

    final expectedStates = [
      TVDetailLoadedState(),
      SuccessAddOrRemoveWatchlistState(message: "Added to Watchlist")
    ];
    whenListen(mockBloc, Stream.fromIterable(expectedStates));

    final watchlistButton = find.byType(ElevatedButton);

    await tester
        .pumpWidget(_makeTestableWidget(TVDetailContentSection(id: tId)));

    expect(watchlistButton, findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when add to watchlist failed',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TVDetailLoadedState());
    when(() => mockBloc.tvDetail).thenReturn(testTVDetail);
    when(() => mockBloc.tvRecommendations).thenReturn([testTV]);
    when(() => mockBloc.genres).thenReturn("Action");
    when(() => mockBloc.isAddedToWatchlist).thenReturn(false);

    final expectedStates = [
      TVDetailLoadedState(),
      FailedAddOrRemoveWatchlistState(message: "Failed")
    ];
    whenListen(mockBloc, Stream.fromIterable(expectedStates));

    final watchlistButton = find.byType(ElevatedButton);

    await tester
        .pumpWidget(_makeTestableWidget(TVDetailContentSection(id: tId)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
