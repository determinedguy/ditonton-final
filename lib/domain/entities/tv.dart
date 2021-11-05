import 'package:equatable/equatable.dart';

// Docs can be find here: https://developers.themoviedb.org/3/tv/get-tv-details

class TV extends Equatable {
  TV({
    required this.backdropPath,
    required this.firstAirDate,
    required this.genreIds,
    required this.id,
    required this.lastAirDate,
    required this.name,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  TV.watchlist({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  });

  String? backdropPath;
  String? firstAirDate;
  List<int>? genreIds;
  int id;
  String? lastAirDate;
  String? name;
  String? originalName;
  String? overview;
  double? popularity;
  String? posterPath;
  double? voteAverage;
  int? voteCount;

  @override
  List<Object?> get props => [
        backdropPath,
        firstAirDate,
        genreIds,
        id,
        lastAirDate,
        name,
        originalName,
        overview,
        popularity,
        posterPath,
        voteAverage,
        voteCount,
      ];
}
