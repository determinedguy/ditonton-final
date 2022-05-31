import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tSeasonModel = SeasonModel(
    airDate: 'airDate',
    episodeCount: 7,
    id: 1,
    name: 'Company',
    overview: 'Overview',
    posterPath: 'posterPath',
    seasonNumber: 7,
  );

  final tSeason = Season(
    airDate: 'airDate',
    episodeCount: 7,
    id: 1,
    name: 'Company',
    overview: 'Overview',
    posterPath: 'posterPath',
    seasonNumber: 7,
  );

  test('should be a subclass of Season entity', () async {
    final result = tSeasonModel.toEntity();
    expect(result, tSeason);
  });
}
