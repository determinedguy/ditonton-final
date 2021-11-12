import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage> {
  late WatchlistMovieBloc watchlistMovieBloc;

  @override
  void initState() {
    watchlistMovieBloc = BlocProvider.of<WatchlistMovieBloc>(context);
    watchlistMovieBloc.add(LoadWatchlistMovieEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder(
          bloc: watchlistMovieBloc,
          builder: (context, state) {
            if (state is WatchlistMovieInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistMovieLoadedState &&
                watchlistMovieBloc.watchlist.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = watchlistMovieBloc.watchlist[index];
                  return MovieCard(movie);
                },
                itemCount: watchlistMovieBloc.watchlist.length,
              );
            } else if (state is WatchlistMovieLoadedState &&
                watchlistMovieBloc.watchlist.isEmpty) {
              return Center(
                key: Key('empty_message'),
                child: Text("Movie Watchlist is empty"),
              );
            } else {
              String message = state is LoadWatchlistMovieFailureState
                  ? state.message
                  : "Error";
              return Center(
                key: Key('error_message'),
                child: Text(message),
              );
            }
          },
        ),
      ),
    );
  }
}
