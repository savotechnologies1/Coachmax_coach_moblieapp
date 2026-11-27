import 'package:coachmax_coach/dto/classes_response_dto.dart';

abstract class ClassDetailsState {}

class ClassDetailsInitial extends ClassDetailsState {}

class ClassDetailsLoading extends ClassDetailsState {}

class ClassDetailsLoaded extends ClassDetailsState {
  final ClassDataDto classDetails;

  ClassDetailsLoaded(this.classDetails);
}

class ClassDetailsError extends ClassDetailsState {
  final String message;

  ClassDetailsError(this.message);
}
