import 'package:ditonton/injection.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';

  @override
  _WatchlistTVPageState createState() => _WatchlistTVPageState();
}

class _WatchlistTVPageState extends State<WatchlistTVPage> {
  WatchlistTVBloc watchlistTVBloc = locator();

  @override
  void initState() {
    watchlistTVBloc.add(LoadWatchlistTVEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Shows Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder(
          bloc: watchlistTVBloc,
          builder: (context, state) {
            if (state is WatchlistTVInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistTVLoadedState &&
                watchlistTVBloc.watchlist.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = watchlistTVBloc.watchlist[index];
                  return TVCard(tv);
                },
                itemCount: watchlistTVBloc.watchlist.length,
              );
            } else if (state is WatchlistTVLoadedState &&
                watchlistTVBloc.watchlist.isEmpty) {
              return Center(
                key: Key('empty_message'),
                child: Text("TV Watchlist is empty"),
              );
            } else {
              String message = state is LoadWatchlistTVFailureState
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
