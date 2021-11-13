part of 'tv_list_bloc.dart';

abstract class TVListState extends Equatable {
  const TVListState();

  @override
  List<Object> get props => [];
}

class TVListInitial extends TVListState {}

class TVListLoadedState extends TVListState {}

class LoadTVListFailureState extends TVListState {
  final String message;

  LoadTVListFailureState({
    this.message = "",
  });
}
