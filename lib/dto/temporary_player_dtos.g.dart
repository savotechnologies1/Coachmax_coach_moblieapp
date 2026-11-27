// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temporary_player_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) => CategoryDto(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  isEvent: json['isEvent'] as bool?,
);

Map<String, dynamic> _$CategoryDtoToJson(CategoryDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'isEvent': instance.isEvent,
    };

ProgramDto _$ProgramDtoFromJson(Map<String, dynamic> json) => ProgramDto(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  category: json['category'] as String?,
);

Map<String, dynamic> _$ProgramDtoToJson(ProgramDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'category': instance.category,
    };

TermResponseDto _$TermResponseDtoFromJson(Map<String, dynamic> json) =>
    TermResponseDto(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TermDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TermResponseDtoToJson(TermResponseDto instance) =>
    <String, dynamic>{'success': instance.success, 'data': instance.data};

TermDto _$TermDtoFromJson(Map<String, dynamic> json) => TermDto(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  year: (json['year'] as num?)?.toInt(),
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
);

Map<String, dynamic> _$TermDtoToJson(TermDto instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'year': instance.year,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
};

ClassDropdownResponseDto _$ClassDropdownResponseDtoFromJson(
  Map<String, dynamic> json,
) => ClassDropdownResponseDto(
  success: json['success'] as bool?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => ClassDropdownDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ClassDropdownResponseDtoToJson(
  ClassDropdownResponseDto instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

ClassDropdownDto _$ClassDropdownDtoFromJson(Map<String, dynamic> json) =>
    ClassDropdownDto(
      classId: json['_id'] as String?,
      className: json['className'] as String?,
      location: json['location'] as String?,
      startTime: json['startTime'] as String?,
      dayOfWeek: json['dayOfWeek'] as String?,
    );

Map<String, dynamic> _$ClassDropdownDtoToJson(ClassDropdownDto instance) =>
    <String, dynamic>{
      '_id': instance.classId,
      'className': instance.className,
      'location': instance.location,
      'startTime': instance.startTime,
      'dayOfWeek': instance.dayOfWeek,
    };

TemporaryPlayersListResponseDto _$TemporaryPlayersListResponseDtoFromJson(
  Map<String, dynamic> json,
) => TemporaryPlayersListResponseDto(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => TemporaryPlayerItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TemporaryPlayersListResponseDtoToJson(
  TemporaryPlayersListResponseDto instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

TemporaryPlayerItemDto _$TemporaryPlayerItemDtoFromJson(
  Map<String, dynamic> json,
) => TemporaryPlayerItemDto(
  id: json['_id'] as String?,
  player: json['player'] == null
      ? null
      : TempPlayerDetailsDto.fromJson(json['player'] as Map<String, dynamic>),
  status: json['status'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$TemporaryPlayerItemDtoToJson(
  TemporaryPlayerItemDto instance,
) => <String, dynamic>{
  '_id': instance.id,
  'player': instance.player,
  'status': instance.status,
  'createdAt': instance.createdAt,
};

TempPlayerDetailsDto _$TempPlayerDetailsDtoFromJson(
  Map<String, dynamic> json,
) => TempPlayerDetailsDto(
  id: json['_id'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  fullName: json['fullName'] as String?,
  dob: json['dob'] as String?,
  profileImage: json['profileImage'] as String?,
);

Map<String, dynamic> _$TempPlayerDetailsDtoToJson(
  TempPlayerDetailsDto instance,
) => <String, dynamic>{
  '_id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'fullName': instance.fullName,
  'dob': instance.dob,
  'profileImage': instance.profileImage,
};
