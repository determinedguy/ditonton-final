import 'package:ditonton/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTVTable = TVTable(
    id: 1,
    name: 'name',
    overview: 'Overview',
    posterPath: 'posterPath',
  );
  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTVTable.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "name": "name",
        "overview": "Overview",
        "posterPath": "posterPath",
      };
      expect(result, expectedJsonMap);
    });
  });
}
