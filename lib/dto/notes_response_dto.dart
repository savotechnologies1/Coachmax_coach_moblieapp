import 'package:json_annotation/json_annotation.dart';

part 'notes_response_dto.g.dart';

@JsonSerializable()
class NotesResponseDto {
  bool? success;
  int? total;
  int? page;
  int? limit;
  int? totalPages;
  List<NoteDto>? data;

  NotesResponseDto({
    this.success,
    this.total,
    this.page,
    this.limit,
    this.totalPages,
    this.data,
  });

  factory NotesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$NotesResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NotesResponseDtoToJson(this);
}

@JsonSerializable()
class NoteDto {
  @JsonKey(name: '_id')
  String? id;
  NoteCoachDto? coach;
  NotePlayerDto? player;
  NoteClassIdDto? classId;
  String? noteType;
  String? description;
  bool? isEdited;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;
  bool? isPersonal;

  NoteDto({
    this.id,
    this.coach,
    this.player,
    this.classId,
    this.noteType,
    this.description,
    this.isEdited,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isPersonal,
  });

  factory NoteDto.fromJson(Map<String, dynamic> json) =>
      _$NoteDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NoteDtoToJson(this);
}

@JsonSerializable()
class NoteCoachDto {
  @JsonKey(name: '_id')
  String? id;
  String? name;

  NoteCoachDto({this.id, this.name});

  factory NoteCoachDto.fromJson(Map<String, dynamic> json) =>
      _$NoteCoachDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NoteCoachDtoToJson(this);
}

@JsonSerializable()
class NotePlayerDto {
  @JsonKey(name: '_id')
  String? id;
  String? fullName;
  String? profileImage;

  NotePlayerDto({this.id, this.fullName, this.profileImage});

  factory NotePlayerDto.fromJson(Map<String, dynamic> json) =>
      _$NotePlayerDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NotePlayerDtoToJson(this);
}

@JsonSerializable()
class NoteClassIdDto {
  @JsonKey(name: '_id')
  String? id;
  String? name;

  NoteClassIdDto({this.id, this.name});

  factory NoteClassIdDto.fromJson(Map<String, dynamic> json) =>
      _$NoteClassIdDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NoteClassIdDtoToJson(this);
}
