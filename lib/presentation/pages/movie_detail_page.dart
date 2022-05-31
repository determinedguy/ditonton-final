import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/injection.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieDetailPage extends StatelessWidget {
  static const ROUTE_NAME = '/detail-movie';
  final MovieDetailBloc movieDetailBloc = locator();

  final int id;
  MovieDetailPage({required this.id});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) => movieDetailBloc,
          child: MovieDetailContentSection(
            id: id,
          ),
        ),
      ),
    );
  }
}

class MovieDetailContentSection extends StatefulWidget {
  final int id;

  const MovieDetailContentSection({
    required this.id,
  });

  @override
  _MovieDetailContentSectionState createState() =>
      _MovieDetailContentSectionState();
}

class _MovieDetailContentSectionState extends State<MovieDetailContentSection> {
  late MovieDetailBloc movieDetailBloc;

  @override
  void initState() {
    movieDetailBloc = BlocProvider.of<MovieDetailBloc>(context);
    movieDetailBloc.add(LoadMovieDetailEvent(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocListener(
      bloc: movieDetailBloc,
      listener: (context, state) {
        if (state is SuccessAddOrRemoveWatchlistState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            duration: Duration(seconds: 5),
          ));
        } else if (state is FailedAddOrRemoveWatchlistState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            duration: Duration(seconds: 2),
          ));
        }
      },
      child: BlocBuilder(
          bloc: movieDetailBloc,
          builder: (context, state) {
            if (state is MovieDetailInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/w500${movieDetailBloc.movie.posterPath}',
                    width: screenWidth,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 48 + 8),
                    child: DraggableScrollableSheet(
                      builder: (context, scrollController) {
                        return Container(
                          decoration: BoxDecoration(
                            color: kRichBlack,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 16,
                            right: 16,
                          ),
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movieDetailBloc.movie.title,
                                        style: kHeading5,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (!movieDetailBloc
                                              .isAddedToWatchlist) {
                                            movieDetailBloc.add(
                                                AddMovieWatchlistEvent(
                                                    movie:
                                                        movieDetailBloc.movie));
                                          } else {
                                            movieDetailBloc.add(
                                                RemoveMovieWatchlistEvent(
                                                    movie:
                                                        movieDetailBloc.movie));
                                          }
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            movieDetailBloc.isAddedToWatchlist
                                                ? Icon(Icons.check)
                                                : Icon(Icons.add),
                                            Text('Watchlist'),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        movieDetailBloc.genres,
                                      ),
                                      Text(
                                        movieDetailBloc.duration,
                                      ),
                                      Row(
                                        children: [
                                          RatingBarIndicator(
                                            rating: movieDetailBloc
                                                    .movie.voteAverage /
                                                2,
                                            itemCount: 5,
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: kMikadoYellow,
                                            ),
                                            itemSize: 24,
                                          ),
                                          Text(
                                              '${movieDetailBloc.movie.voteAverage}')
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Overview',
                                        style: kHeading6,
                                      ),
                                      Text(
                                        movieDetailBloc.movie.overview,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Recommendations',
                                        style: kHeading6,
                                      ),
                                      Visibility(
                                        visible: movieDetailBloc
                                            .movieRecommendations.isNotEmpty,
                                        child: Container(
                                          height: 150,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final movie = movieDetailBloc
                                                  .movieRecommendations[index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator
                                                        .pushReplacementNamed(
                                                      context,
                                                      MovieDetailPage
                                                          .ROUTE_NAME,
                                                      arguments: movie.id,
                                                    );
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(8),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                      placeholder:
                                                          (context, url) =>
                                                              Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            itemCount: movieDetailBloc
                                                .movieRecommendations.length,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: movieDetailBloc
                                            .movieRecommendations.isEmpty,
                                        child: Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                            top: 20,
                                          ),
                                          child: Text(
                                              "No movie recommendation found"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  color: Colors.white,
                                  height: 4,
                                  width: 48,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      // initialChildSize: 0.5,
                      minChildSize: 0.25,
                      // maxChildSize: 1.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: kRichBlack,
                      foregroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              );
            }
          }),
    );
  }
}
