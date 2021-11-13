import 'package:ditonton/injection.dart';
import 'package:ditonton/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTVPage extends StatelessWidget {
  static const ROUTE_NAME = '/popular-tv';
  final PopularTVBloc popularTVBloc = locator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TV'),
      ),
      body: BlocProvider(
        create: (context) => popularTVBloc,
        child: PopularTVList(),
      ),
    );
  }
}

class PopularTVList extends StatefulWidget {
  const PopularTVList({Key? key}) : super(key: key);

  @override
  _PopularTVListState createState() => _PopularTVListState();
}

class _PopularTVListState extends State<PopularTVList> {
  late PopularTVBloc popularTVBloc;

  @override
  void initState() {
    popularTVBloc = BlocProvider.of<PopularTVBloc>(context);
    popularTVBloc.add(LoadPopularTVEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: BlocBuilder(
        bloc: popularTVBloc,
        builder: (context, state) {
          if (state is PopularTVInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PopularTVLoadedState &&
              popularTVBloc.popularList.isNotEmpty) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = popularTVBloc.popularList[index];
                return TVCard(tv);
              },
              itemCount: popularTVBloc.popularList.length,
            );
          } else if (state is PopularTVLoadedState &&
              popularTVBloc.popularList.isEmpty) {
            return Center(
              key: Key('empty_message'),
              child: Text("Popular TV is empty"),
            );
          } else {
            String message = state is LoadPopularTVFailureState
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
