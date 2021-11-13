import 'package:ditonton/injection.dart';
import 'package:ditonton/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMoviesPage extends StatelessWidget {
  static const ROUTE_NAME = '/top-rated-movie';
  final TopRatedMovieBloc topRatedMovieBloc = locator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: BlocProvider(
        create: (context) => topRatedMovieBloc,
        child: TopRatedMovieList(),
      ),
    );
  }
}

class TopRatedMovieList extends StatefulWidget {
  const TopRatedMovieList({Key? key}) : super(key: key);

  @override
  _TopRatedMovieListState createState() => _TopRatedMovieListState();
}

class _TopRatedMovieListState extends State<TopRatedMovieList> {
  late TopRatedMovieBloc topRatedMovieBloc;

  @override
  void initState() {
    topRatedMovieBloc = BlocProvider.of<TopRatedMovieBloc>(context);
    topRatedMovieBloc.add(LoadTopRatedMovieEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: BlocBuilder(
        bloc: topRatedMovieBloc,
        builder: (context, state) {
          if (state is TopRatedMovieInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TopRatedMovieLoadedState &&
              topRatedMovieBloc.topRatedList.isNotEmpty) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = topRatedMovieBloc.topRatedList[index];
                return MovieCard(
                  movie,
                );
              },
              itemCount: topRatedMovieBloc.topRatedList.length,
            );
          } else if (state is TopRatedMovieLoadedState &&
              topRatedMovieBloc.topRatedList.isEmpty) {
            return Center(
              key: Key('empty_message'),
              child: Text("Top Rated Movie is empty"),
            );
          } else {
            String message = state is LoadTopRatedMovieFailureState
                ? state.message
                : "Error";
            return Center(
              key: Key('error_message'),
              child: Text(message),
            );
          }
        },
      ),
    );
  }
}
