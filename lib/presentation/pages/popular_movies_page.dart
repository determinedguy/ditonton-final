import 'package:ditonton/injection.dart';
import 'package:ditonton/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesPage extends StatelessWidget {
  static const ROUTE_NAME = '/popular-movie';
  final PopularMovieBloc popularMovieBloc = locator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: BlocProvider(
        create: (context) => popularMovieBloc,
        child: PopularMovieList(),
      ),
    );
  }
}

class PopularMovieList extends StatefulWidget {
  const PopularMovieList({Key? key}) : super(key: key);

  @override
  _PopularMovieListState createState() => _PopularMovieListState();
}

class _PopularMovieListState extends State<PopularMovieList> {
  late PopularMovieBloc popularMovieBloc;

  @override
  void initState() {
    popularMovieBloc = BlocProvider.of<PopularMovieBloc>(context);
    popularMovieBloc.add(LoadPopularMovieEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: BlocBuilder(
        bloc: popularMovieBloc,
        builder: (context, state) {
          if (state is PopularMovieInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PopularMovieLoadedState &&
              popularMovieBloc.popularList.isNotEmpty) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = popularMovieBloc.popularList[index];
                return MovieCard(movie);
              },
              itemCount: popularMovieBloc.popularList.length,
            );
          } else if (state is PopularMovieLoadedState &&
              popularMovieBloc.popularList.isEmpty) {
            return Center(
              key: Key('empty_message'),
              child: Text("Popular Movie is empty"),
            );
          } else {
            String message =
                state is LoadPopularMovieFailureState ? state.message : "Error";
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
