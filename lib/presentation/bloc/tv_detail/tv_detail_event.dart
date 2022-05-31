part of 'tv_detail_bloc.dart';

abstract class TVDetailEvent extends Equatable {
  const TVDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadTVDetailEvent extends TVDetailEvent {
  final int id;

  LoadTVDetailEvent({required this.id});
}

class AddTVWatchlistEvent extends TVDetailEvent {
  final TVDetail tvDetail;

  AddTVWatchlistEvent({
    required this.tvDetail,
  });
}

class RemoveTVWatchlistEvent extends TVDetailEvent {
  final TVDetail tvDetail;

  RemoveTVWatchlistEvent({
    required this.tvDetail,
  });
}