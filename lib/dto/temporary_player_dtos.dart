import 'package:json_annotation/json_annotation.dart';

part 'temporary_player_dtos.g.dart';

@JsonSerializable()
class CategoryDto {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  bool? isEvent;

  CategoryDto({this.id, this.name, this.isEvent});

  factory CategoryDto.fromJson(Map<String, dynamic> json) => _$CategoryDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryDtoToJson(this);
}

@JsonSerializable()
class ProgramDto {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  String? category;

  ProgramDto({this.id, this.name, this.category});

  factory ProgramDto.fromJson(Map<String, dynamic> json) => _$ProgramDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ProgramDtoToJson(this);
}

@JsonSerializable()
class TermResponseDto {
  bool? success;
  List<TermDto>? data;

  TermResponseDto({this.success, this.data});

  factory TermResponseDto.fromJson(Map<String, dynamic> json) => _$TermResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TermResponseDtoToJson(this);
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

  factory TermDto.fromJson(Map<String, dynamic> json) => _$TermDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TermDtoToJson(this);
}

@JsonSerializable()
class ClassDropdownResponseDto {
  bool? success;
  List<ClassDropdownDto>? data;

  ClassDropdownResponseDto({this.success, this.data});

  factory ClassDropdownResponseDto.fromJson(Map<String, dynamic> json) => _$ClassDropdownResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ClassDropdownResponseDtoToJson(this);
}

@JsonSerializable()
class ClassDropdownDto {
  @JsonKey(name: '_id')
  String? classId;
  String? className;
  String? location;
  String? startTime;
  String? dayOfWeek;

  ClassDropdownDto({this.classId, this.className, this.location, this.startTime, this.dayOfWeek});

  factory ClassDropdownDto.fromJson(Map<String, dynamic> json) => _$ClassDropdownDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ClassDropdownDtoToJson(this);
}

@JsonSerializable()
class TemporaryPlayersListResponseDto {
  bool? success;
  String? message;
  List<TemporaryPlayerItemDto>? data;

  TemporaryPlayersListResponseDto({this.success, this.message, this.data});

  factory TemporaryPlayersListResponseDto.fromJson(Map<String, dynamic> json) => _$TemporaryPlayersListResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TemporaryPlayersListResponseDtoToJson(this);
}

@JsonSerializable()
class TemporaryPlayerItemDto {
  @JsonKey(name: '_id')
  String? id;
  TempPlayerDetailsDto? player;
  String? status;
  String? createdAt;

  TemporaryPlayerItemDto({
    this.id,
    this.player,
    this.status,
    this.createdAt,
  });

  factory TemporaryPlayerItemDto.fromJson(Map<String, dynamic> json) => _$TemporaryPlayerItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TemporaryPlayerItemDtoToJson(this);
}

@JsonSerializable()
class TempPlayerDetailsDto {
  @JsonKey(name: '_id')
  String? id;
  String? firstName;
  String? lastName;
  String? fullName;
  String? dob;
  String? profileImage;

  TempPlayerDetailsDto({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.dob,
    this.profileImage,
  });

  factory TempPlayerDetailsDto.fromJson(Map<String, dynamic> json) => _$TempPlayerDetailsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TempPlayerDetailsDtoToJson(this);
}
