part of 'search_tv_bloc.dart';

abstract class SearchTVEvent extends Equatable {
  const SearchTVEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchTVEvent {
  final String query;

  OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
