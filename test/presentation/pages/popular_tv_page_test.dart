import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:ditonton/presentation/pages/popular_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class FakePopularTVEvent extends Fake implements PopularTVEvent {}

class FakePopularTVState extends Fake implements PopularTVState {}

class MockPopularTVBloc
    extends MockBloc<PopularTVEvent, PopularTVState>
    implements PopularTVBloc {}

void main() {
  late MockPopularTVBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakePopularTVEvent());
    registerFallbackValue(FakePopularTVState());
  });

  setUp(() async {
    mockBloc = MockPopularTVBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTVBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets('PopularTVList should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(PopularTVInitial());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularTVList()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('PopularTVList should display when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(PopularTVLoadedState());
    when(() => mockBloc.popularList).thenReturn([testTV]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularTVList()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('PopularTVList should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(LoadPopularTVFailureState(message: 'Server Failure'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularTVList()));

    expect(textFinder, findsOneWidget);
  });
}
