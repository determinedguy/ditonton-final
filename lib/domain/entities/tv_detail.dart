import 'package:ditonton/domain/entities/genre.dart';
import 'package:equatable/equatable.dart';

class TVDetail extends Equatable {
  TVDetail({
    required this.backdropPath,
    required this.firstAirDate,
    required this.genres,
    required this.id,
    required this.lastAirDate,
    required this.name,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  final String? backdropPath;
  final String firstAirDate;
  final List<Genre> genres;
  final int id;
  final String? lastAirDate;
  final String name;
  final String originalName;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final int voteCount;

  @override
  List<Object?> get props => [
        backdropPath,
        firstAirDate,
        genres,
        id,
        lastAirDate,
        name,
        originalName,
        overview,
        posterPath,
        voteAverage,
        voteCount,
      ];
}
