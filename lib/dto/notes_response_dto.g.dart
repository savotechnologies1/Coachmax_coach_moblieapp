// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotesResponseDto _$NotesResponseDtoFromJson(Map<String, dynamic> json) =>
    NotesResponseDto(
      success: json['success'] as bool?,
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => NoteDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotesResponseDtoToJson(NotesResponseDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'totalPages': instance.totalPages,
      'data': instance.data,
    };

NoteDto _$NoteDtoFromJson(Map<String, dynamic> json) => NoteDto(
  id: json['_id'] as String?,
  coach: json['coach'] == null
      ? null
      : NoteCoachDto.fromJson(json['coach'] as Map<String, dynamic>),
  player: json['player'] == null
      ? null
      : NotePlayerDto.fromJson(json['player'] as Map<String, dynamic>),
  classId: json['classId'] == null
      ? null
      : NoteClassIdDto.fromJson(json['classId'] as Map<String, dynamic>),
  noteType: json['noteType'] as String?,
  description: json['description'] as String?,
  isEdited: json['isEdited'] as bool?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  v: (json['__v'] as num?)?.toInt(),
  isPersonal: json['isPersonal'] as bool?,
);

Map<String, dynamic> _$NoteDtoToJson(NoteDto instance) => <String, dynamic>{
  '_id': instance.id,
  'coach': instance.coach,
  'player': instance.player,
  'classId': instance.classId,
  'noteType': instance.noteType,
  'description': instance.description,
  'isEdited': instance.isEdited,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  '__v': instance.v,
  'isPersonal': instance.isPersonal,
};

NoteCoachDto _$NoteCoachDtoFromJson(Map<String, dynamic> json) =>
    NoteCoachDto(id: json['_id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$NoteCoachDtoToJson(NoteCoachDto instance) =>
    <String, dynamic>{'_id': instance.id, 'name': instance.name};

NotePlayerDto _$NotePlayerDtoFromJson(Map<String, dynamic> json) =>
    NotePlayerDto(
      id: json['_id'] as String?,
      fullName: json['fullName'] as String?,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$NotePlayerDtoToJson(NotePlayerDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'fullName': instance.fullName,
      'profileImage': instance.profileImage,
    };

NoteClassIdDto _$NoteClassIdDtoFromJson(Map<String, dynamic> json) =>
    NoteClassIdDto(id: json['_id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$NoteClassIdDtoToJson(NoteClassIdDto instance) =>
    <String, dynamic>{'_id': instance.id, 'name': instance.name};
