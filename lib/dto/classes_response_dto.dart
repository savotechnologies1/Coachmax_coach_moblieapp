import 'package:json_annotation/json_annotation.dart';

part 'classes_response_dto.g.dart';

@JsonSerializable()
class ClassDetailsResponseDto {
  bool? success;
  String? message;
  ClassDataDto? data;

  ClassDetailsResponseDto({
    this.success,
    this.message,
    this.data,
  });

  factory ClassDetailsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ClassDetailsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ClassDetailsResponseDtoToJson(this);
}

@JsonSerializable()
class ClassesResponseDto {
  bool? success;
  String? message;
  int? totalClasses;
  int? page;
  int? limit;
  int? totalPages;
  List<ClassDataDto>? data;

  ClassesResponseDto({
    this.success,
    this.message,
    this.totalClasses,
    this.page,
    this.limit,
    this.totalPages,
    this.data,
  });

  factory ClassesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ClassesResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ClassesResponseDtoToJson(this);
}

@JsonSerializable()
class ClassDataDto {
  String? classId;
  String? className;
  String? dayOfWeek;
  String? startTime;
  String? endTime;
  String? venue;
  String? location;
  int? sessionDuration;
  String? trainingType;
  int? capacity;
  String? chatRoomId;
  TermDto? term;
  ProgramDto? program;
  CategoryDto? category;
  CoachDto? coach;
  int? totalPlayers;
  List<PlayerDto>? players;
  int? totalSessions;
  List<SessionDto>? sessions;

  ClassDataDto({
    this.classId,
    this.className,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
    this.venue,
    this.location,
    this.sessionDuration,
    this.trainingType,
    this.capacity,
    this.chatRoomId,
    this.term,
    this.program,
    this.category,
    this.coach,
    this.totalPlayers,
    this.players,
    this.totalSessions,
    this.sessions,
  });

  factory ClassDataDto.fromJson(Map<String, dynamic> json) =>
      _$ClassDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ClassDataDtoToJson(this);
}

@JsonSerializable()
class TermDto {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  int? year;
  String? startDate;
  String? endDate;

  TermDto({this.id, this.name, this.year, this.startDate, this.endDate});

  factory TermDto.fromJson(Map<String, dynamic> json) =>
      _$TermDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TermDtoToJson(this);
}

@JsonSerializable()
class ProgramDto {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  String? ageGroup;

  ProgramDto({this.id, this.name, this.ageGroup});

  factory ProgramDto.fromJson(Map<String, dynamic> json) =>
      _$ProgramDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProgramDtoToJson(this);
}

@JsonSerializable()
class CategoryDto {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  String? ageRange;

  CategoryDto({this.id, this.name, this.ageRange});

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDtoToJson(this);
}

@JsonSerializable()
class CoachDto {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  String? email;
  String? mobile;

  CoachDto({this.id, this.name, this.email, this.mobile});

  factory CoachDto.fromJson(Map<String, dynamic> json) =>
      _$CoachDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CoachDtoToJson(this);
}

@JsonSerializable()
class PlayerDto {
  @JsonKey(name: '_id')
  String? id;
  String? fullName;
  String? dob;
  String? profileImage;
  bool? isMedicalCondition;
  String? medicalConditionDetails;
  Map<String, dynamic>? attendance;

  PlayerDto({
    this.id,
    this.fullName,
    this.dob,
    this.profileImage,
    this.isMedicalCondition,
    this.medicalConditionDetails,
    this.attendance,
  });

  factory PlayerDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerDtoToJson(this);
}

@JsonSerializable()
class SessionDto {
  String? date;
  int? day;
  int? month;
  int? year;

  SessionDto({this.date, this.day, this.month, this.year});

  factory SessionDto.fromJson(Map<String, dynamic> json) =>
      _$SessionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SessionDtoToJson(this);
}
