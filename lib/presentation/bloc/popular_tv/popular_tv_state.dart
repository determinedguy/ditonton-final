part of 'popular_tv_bloc.dart';

abstract class PopularTVState extends Equatable {
  const PopularTVState();

  @override
  List<Object> get props => [];
}

class PopularTVInitial extends PopularTVState {}

class PopularTVLoadedState extends PopularTVState {}

class LoadPopularTVFailureState extends PopularTVState {
  final String message;

  LoadPopularTVFailureState({
    this.message = "",
  });

  @override
  List<Object> get props => [message];
}
