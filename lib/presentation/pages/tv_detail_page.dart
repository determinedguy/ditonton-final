import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/injection.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TVDetailPage extends StatelessWidget {
  static const ROUTE_NAME = '/detail-tv';

  final int id;
  final TVDetailBloc tvDetailBloc = locator();
  TVDetailPage({required this.id});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) => tvDetailBloc,
          child: TVDetailContentSection(
            id: id,
          ),
        ),
      ),
    );
  }
}

class TVDetailContentSection extends StatefulWidget {
  final int id;

  const TVDetailContentSection({
    required this.id,
  });

  @override
  _TVDetailContentSectionState createState() =>
      _TVDetailContentSectionState();
}

class _TVDetailContentSectionState
    extends State<TVDetailContentSection> {
  late TVDetailBloc tvDetailBloc;

  @override
  void initState() {
    tvDetailBloc = BlocProvider.of<TVDetailBloc>(context);
    tvDetailBloc.add(LoadTVDetailEvent(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocListener(
      bloc: tvDetailBloc,
      listener: (context, state) {
        if (state is SuccessAddOrRemoveWatchlistState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            duration: Duration(seconds: 2),
          ));
        } else if (state is FailedAddOrRemoveWatchlistState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            duration: Duration(seconds: 2),
          ));
        }
      },
      child: BlocBuilder(
          bloc: tvDetailBloc,
          builder: (context, state) {
            if (state is TVDetailInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/w500${tvDetailBloc.tvDetail.posterPath}',
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
                                        tvDetailBloc
                                                .tvDetail.name,
                                        style: kHeading5,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (!tvDetailBloc
                                              .isAddedToWatchlist) {
                                            tvDetailBloc.add(
                                                AddTVWatchlistEvent(
                                                    tvDetail:
                                                        tvDetailBloc
                                                            .tvDetail));
                                          } else {
                                            tvDetailBloc.add(
                                                RemoveTVWatchlistEvent(
                                                    tvDetail:
                                                        tvDetailBloc
                                                            .tvDetail));
                                          }
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            tvDetailBloc
                                                    .isAddedToWatchlist
                                                ? Icon(Icons.check)
                                                : Icon(Icons.add),
                                            Text('Watchlist'),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        tvDetailBloc.genres,
                                      ),
                                      Row(
                                        children: [
                                          RatingBarIndicator(
                                            rating: tvDetailBloc
                                                    .tvDetail
                                                    .voteAverage,
                                            itemCount: 5,
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: kMikadoYellow,
                                            ),
                                            itemSize: 24,
                                          ),
                                          Text(
                                              '${tvDetailBloc.tvDetail.voteAverage}')
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Overview',
                                        style: kHeading6,
                                      ),
                                      Text(
                                        tvDetailBloc
                                                .tvDetail.overview,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Recommendations',
                                        style: kHeading6,
                                      ),
                                      Visibility(
                                        visible: tvDetailBloc
                                            .tvRecommendations.isNotEmpty,
                                        child: Container(
                                          height: 150,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final tvSeries = tvDetailBloc
                                                      .tvRecommendations[
                                                  index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator
                                                        .pushReplacementNamed(
                                                      context,
                                                      TVDetailPage
                                                          .ROUTE_NAME,
                                                      arguments: tvSeries.id,
                                                    );
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(8),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
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
                                            itemCount: tvDetailBloc
                                                .tvRecommendations.length,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: tvDetailBloc
                                            .tvRecommendations.isEmpty,
                                        child: Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                            top: 20,
                                          ),
                                          child: Text(
                                              "No tv series recommendation found"),
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
