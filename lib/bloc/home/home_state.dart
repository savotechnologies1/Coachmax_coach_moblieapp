import 'package:coachmax_coach/dto/classes_response_dto.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ClassDataDto> classes;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const HomeLoaded(
    this.classes, {
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [classes, hasReachedMax, isLoadingMore];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class HomeBroadcastLoading extends HomeState {}

class HomeBroadcastSuccess extends HomeState {
  final String message;
  final String conversationId;
  final String conversationName;
  const HomeBroadcastSuccess(this.message, this.conversationId, this.conversationName);
  @override
  List<Object?> get props => [message, conversationId, conversationName];
}

class HomeBroadcastError extends HomeState {
  final String message;
  const HomeBroadcastError(this.message);
  @override
  List<Object?> get props => [message];
}
