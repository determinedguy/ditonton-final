import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVLocalDataSourceImpl dataSource;
  late MockDatabaseHelperTV mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelperTV();
    dataSource = TVLocalDataSourceImpl(databaseHelperTV: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test('should return success message when insert to database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlistTV(testTVTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertWatchlistTV(testTVTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlistTV(testTVTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.insertWatchlistTV(testTVTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlistTV(testTVTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.removeWatchlistTV(testTVTable);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlistTV(testTVTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.removeWatchlistTV(testTVTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get TV Shows Detail By Id', () {
    final tId = 1;

    test('should return TV Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTVById(tId))
          .thenAnswer((_) async => testTVMap);
      // act
      final result = await dataSource.getTVById(tId);
      // assert
      expect(result, testTVTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTVById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTVById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist tv', () {
    test('should return list of TVTable from database', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistTV())
          .thenAnswer((_) async => [testTVMap]);
      // act
      final result = await dataSource.getWatchlistTV();
      // assert
      expect(result, [testTVTable]);
    });
  });
}
