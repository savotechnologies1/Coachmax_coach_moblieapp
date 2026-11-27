// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classes_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassDetailsResponseDto _$ClassDetailsResponseDtoFromJson(
  Map<String, dynamic> json,
) => ClassDetailsResponseDto(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : ClassDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ClassDetailsResponseDtoToJson(
  ClassDetailsResponseDto instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

ClassesResponseDto _$ClassesResponseDtoFromJson(Map<String, dynamic> json) =>
    ClassesResponseDto(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      totalClasses: (json['totalClasses'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ClassDataDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ClassesResponseDtoToJson(ClassesResponseDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'totalClasses': instance.totalClasses,
      'page': instance.page,
      'limit': instance.limit,
      'totalPages': instance.totalPages,
      'data': instance.data,
    };

ClassDataDto _$ClassDataDtoFromJson(Map<String, dynamic> json) => ClassDataDto(
  classId: json['classId'] as String?,
  className: json['className'] as String?,
  dayOfWeek: json['dayOfWeek'] as String?,
  startTime: json['startTime'] as String?,
  endTime: json['endTime'] as String?,
  venue: json['venue'] as String?,
  location: json['location'] as String?,
  sessionDuration: (json['sessionDuration'] as num?)?.toInt(),
  trainingType: json['trainingType'] as String?,
  capacity: (json['capacity'] as num?)?.toInt(),
  chatRoomId: json['chatRoomId'] as String?,
  term: json['term'] == null
      ? null
      : TermDto.fromJson(json['term'] as Map<String, dynamic>),
  program: json['program'] == null
      ? null
      : ProgramDto.fromJson(json['program'] as Map<String, dynamic>),
  category: json['category'] == null
      ? null
      : CategoryDto.fromJson(json['category'] as Map<String, dynamic>),
  coach: json['coach'] == null
      ? null
      : CoachDto.fromJson(json['coach'] as Map<String, dynamic>),
  totalPlayers: (json['totalPlayers'] as num?)?.toInt(),
  players: (json['players'] as List<dynamic>?)
      ?.map((e) => PlayerDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalSessions: (json['totalSessions'] as num?)?.toInt(),
  sessions: (json['sessions'] as List<dynamic>?)
      ?.map((e) => SessionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ClassDataDtoToJson(ClassDataDto instance) =>
    <String, dynamic>{
      'classId': instance.classId,
      'className': instance.className,
      'dayOfWeek': instance.dayOfWeek,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'venue': instance.venue,
      'location': instance.location,
      'sessionDuration': instance.sessionDuration,
      'trainingType': instance.trainingType,
      'capacity': instance.capacity,
      'chatRoomId': instance.chatRoomId,
      'term': instance.term,
      'program': instance.program,
      'category': instance.category,
      'coach': instance.coach,
      'totalPlayers': instance.totalPlayers,
      'players': instance.players,
      'totalSessions': instance.totalSessions,
      'sessions': instance.sessions,
    };

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

ProgramDto _$ProgramDtoFromJson(Map<String, dynamic> json) => ProgramDto(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  ageGroup: json['ageGroup'] as String?,
);

Map<String, dynamic> _$ProgramDtoToJson(ProgramDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'ageGroup': instance.ageGroup,
    };

CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) => CategoryDto(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  ageRange: json['ageRange'] as String?,
);

Map<String, dynamic> _$CategoryDtoToJson(CategoryDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'ageRange': instance.ageRange,
    };

CoachDto _$CoachDtoFromJson(Map<String, dynamic> json) => CoachDto(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  email: json['email'] as String?,
  mobile: json['mobile'] as String?,
);

Map<String, dynamic> _$CoachDtoToJson(CoachDto instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'mobile': instance.mobile,
};

PlayerDto _$PlayerDtoFromJson(Map<String, dynamic> json) => PlayerDto(
  id: json['_id'] as String?,
  fullName: json['fullName'] as String?,
  dob: json['dob'] as String?,
  profileImage: json['profileImage'] as String?,
  isMedicalCondition: json['isMedicalCondition'] as bool?,
  medicalConditionDetails: json['medicalConditionDetails'] as String?,
  attendance: json['attendance'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$PlayerDtoToJson(PlayerDto instance) => <String, dynamic>{
  '_id': instance.id,
  'fullName': instance.fullName,
  'dob': instance.dob,
  'profileImage': instance.profileImage,
  'isMedicalCondition': instance.isMedicalCondition,
  'medicalConditionDetails': instance.medicalConditionDetails,
  'attendance': instance.attendance,
};

SessionDto _$SessionDtoFromJson(Map<String, dynamic> json) => SessionDto(
  date: json['date'] as String?,
  day: (json['day'] as num?)?.toInt(),
  month: (json['month'] as num?)?.toInt(),
  year: (json['year'] as num?)?.toInt(),
);

Map<String, dynamic> _$SessionDtoToJson(SessionDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'day': instance.day,
      'month': instance.month,
      'year': instance.year,
    };
