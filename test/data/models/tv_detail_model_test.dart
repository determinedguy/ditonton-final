import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTVDetail = TVDetailResponse(
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genres: [GenreModel(id: 1, name: 'Action')],
    homepage: "https://google.com",
    id: 1,
    lastAirDate: 'lastAirDate',
    name: 'Name',
    numberOfEpisodes: 12,
    numberOfSeasons: 3,
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 1,
    posterPath: 'posterPath',
    seasons: [
      SeasonModel(
          airDate: 'airDate',
          episodeCount: 7,
          id: 1,
          name: 'Company',
          overview: 'Overview',
          posterPath: 'posterPath',
          seasonNumber: 7)
    ],
    status: 'Status',
    tagline: 'Tagline',
    voteAverage: 1,
    voteCount: 1,
  );

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTVDetail.toJson();
      // assert
      final expectedJsonMap = {
        "backdrop_path": "backdropPath",
        "first_air_date": "firstAirDate",
        "genres": [
          {"id": 1, "name": "Action"}
        ],
        "homepage": "https://google.com",
        "id": 1,
        "last_air_date": "lastAirDate",
        "name": "Name",
        "number_of_episodes": 12,
        "number_of_seasons": 3,
        "original_language": "en",
        "original_name": "Original Name",
        "overview": "Overview",
        "popularity": 1,
        "poster_path": "posterPath",
        "seasons": [
          {
            "air_date": "airDate",
            "episode_count": 7,
            "id": 1,
            "name": "Company",
            "overview": "Overview",
            "poster_path": "posterPath",
            "season_number": 7
          }
        ],
        "status": "Status",
        "tagline": "Tagline",
        "vote_average": 1,
        "vote_count": 1
      };
      expect(result, expectedJsonMap);
    });
  });
}
