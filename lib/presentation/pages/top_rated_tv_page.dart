import 'package:ditonton/injection.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTVPage extends StatelessWidget {
  static const ROUTE_NAME = '/top-rated-tv';
  final TopRatedTVBloc topRatedTVBloc = locator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated TV'),
      ),
      body: BlocProvider(
        create: (context) => topRatedTVBloc,
        child: TopRatedTVList(),
      ),
    );
  }
}

class TopRatedTVList extends StatefulWidget {
  const TopRatedTVList({Key? key}) : super(key: key);

  @override
  _TopRatedTVListState createState() => _TopRatedTVListState();
}

class _TopRatedTVListState extends State<TopRatedTVList> {
  late TopRatedTVBloc topRatedTVBloc;

  @override
  void initState() {
    topRatedTVBloc = BlocProvider.of<TopRatedTVBloc>(context);
    topRatedTVBloc.add(LoadTopRatedTVEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: BlocBuilder(
        bloc: topRatedTVBloc,
        builder: (context, state) {
          if (state is TopRatedTVInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TopRatedTVLoadedState &&
              topRatedTVBloc.topRatedList.isNotEmpty) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = topRatedTVBloc.topRatedList[index];
                return TVCard(tv);
              },
              itemCount: topRatedTVBloc.topRatedList.length,
            );
          } else if (state is TopRatedTVLoadedState &&
              topRatedTVBloc.topRatedList.isEmpty) {
            return Center(
              key: Key('empty_message'),
              child: Text("Top Rated TV is empty"),
            );
          } else {
            String message = state is LoadTopRatedTVFailureState
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
