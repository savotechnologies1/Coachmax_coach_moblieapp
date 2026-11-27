import 'package:coachmax_coach/dto/player_profile_response_dto.dart';
import 'package:coachmax_coach/dto/notes_response_dto.dart';

abstract class PlayerProfileState {}

class PlayerProfileInitial extends PlayerProfileState {}

class PlayerProfileLoading extends PlayerProfileState {}

class PlayerProfileLoaded extends PlayerProfileState {
  final PlayerDetailDataDto data;
  final List<NoteDto>? notes;
  
  PlayerProfileLoaded(this.data, {this.notes});
}

class PlayerProfileError extends PlayerProfileState {
  final String message;
  PlayerProfileError(this.message);
}

class PlayerProfileDirectMessageSuccess extends PlayerProfileState {
  final String chatRoomId;
  PlayerProfileDirectMessageSuccess(this.chatRoomId);
}

class PlayerProfileDirectMessageError extends PlayerProfileState {
  final String message;
  PlayerProfileDirectMessageError(this.message);
}
