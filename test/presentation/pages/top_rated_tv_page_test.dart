import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class FakeTopRatedTVEvent extends Fake implements TopRatedTVEvent {}

class FakeTopRatedTVState extends Fake implements TopRatedTVState {}

class MockTopRatedTVBloc
    extends MockBloc<TopRatedTVEvent, TopRatedTVState>
    implements TopRatedTVBloc {}

void main() {
  late MockTopRatedTVBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTopRatedTVEvent());
    registerFallbackValue(FakeTopRatedTVState());
  });

  setUp(() async {
    mockBloc = MockTopRatedTVBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTVBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets('TopRatedTVList should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TopRatedTVInitial());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTVList()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('TopRatedTVList should display when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TopRatedTVLoadedState());
    when(() => mockBloc.topRatedList).thenReturn([testTV]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTVList()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets(
      'TopRatedTVList should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
        LoadTopRatedTVFailureState(message: 'Server Failure'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedTVList()));

    expect(textFinder, findsOneWidget);
  });
}
