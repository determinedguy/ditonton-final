part of 'search_tv_bloc.dart';

abstract class SearchTVState extends Equatable {
  const SearchTVState();

  @override
  List<Object> get props => [];
}

class SearchTVEmpty extends SearchTVState {}

class SearchTVLoading extends SearchTVState {}

class SearchTVError extends SearchTVState {
  final String message;

  SearchTVError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchTVHasData extends SearchTVState {
  final List<TV> result;

  SearchTVHasData(this.result);

  @override
  List<Object> get props => [result];
}
