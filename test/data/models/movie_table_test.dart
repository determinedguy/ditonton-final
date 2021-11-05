import 'package:ditonton/data/models/movie_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovieTable = MovieTable(
    id: 1,
    overview: 'Overview',
    title: 'Title',
    posterPath: 'posterPath',
  );
  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tMovieTable.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "overview": "Overview",
        "title": "Title",
        "posterPath": "posterPath",
      };
      expect(result, expectedJsonMap);
    });
  });
}
