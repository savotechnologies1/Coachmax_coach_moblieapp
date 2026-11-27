import 'package:coachmax_coach/dto/temporary_player_dtos.dart';
import 'package:equatable/equatable.dart';

abstract class TemporaryPlayersListState extends Equatable {
  const TemporaryPlayersListState();

  @override
  List<Object?> get props => [];
}

class TemporaryPlayersListInitial extends TemporaryPlayersListState {}

class TemporaryPlayersListLoading extends TemporaryPlayersListState {}

class TemporaryPlayersListLoaded extends TemporaryPlayersListState {
  final List<TemporaryPlayerItemDto> players;

  const TemporaryPlayersListLoaded(this.players);

  @override
  List<Object?> get props => [players];
}

class TemporaryPlayersListError extends TemporaryPlayersListState {
  final String message;

  const TemporaryPlayersListError(this.message);

  @override
  List<Object?> get props => [message];
}
