// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_profile_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyProfileResponseDto _$MyProfileResponseDtoFromJson(
  Map<String, dynamic> json,
) => MyProfileResponseDto(
  success: json['success'] as bool?,
  role: json['role'] as String?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : ProfileDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MyProfileResponseDtoToJson(
  MyProfileResponseDto instance,
) => <String, dynamic>{
  'success': instance.success,
  'role': instance.role,
  'message': instance.message,
  'data': instance.data,
};

ProfileDataDto _$ProfileDataDtoFromJson(Map<String, dynamic> json) =>
    ProfileDataDto(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      isOtpVerified: json['isOtpVerified'] as bool?,
      role: json['role'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: (json['v'] as num?)?.toInt(),
      fcmTokens: (json['fcmTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      profileImage: json['profileImage'] as String?,
      profile: json['profile'] as String?,
      players: json['players'] as List<dynamic>?,
      unpaidInvoiceCount: (json['unpaidInvoiceCount'] as num?)?.toInt(),
      assignedClassesCount: (json['assignedClassesCount'] as num?)?.toInt(),
      uniquePlayersCount: (json['uniquePlayersCount'] as num?)?.toInt(),
      overallAttendancePercentage: json['overallAttendancePercentage'] as num?,
      temporaryPlayersThisMonthCount:
          (json['temporaryPlayersThisMonthCount'] as num?)?.toInt(),
      sessionsToBeDeliveredThisMonthCount:
          (json['sessionsToBeDeliveredThisMonthCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProfileDataDtoToJson(ProfileDataDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'mobile': instance.mobile,
      'isOtpVerified': instance.isOtpVerified,
      'role': instance.role,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'v': instance.v,
      'fcmTokens': instance.fcmTokens,
      'profileImage': instance.profileImage,
      'profile': instance.profile,
      'players': instance.players,
      'unpaidInvoiceCount': instance.unpaidInvoiceCount,
      'assignedClassesCount': instance.assignedClassesCount,
      'uniquePlayersCount': instance.uniquePlayersCount,
      'overallAttendancePercentage': instance.overallAttendancePercentage,
      'temporaryPlayersThisMonthCount': instance.temporaryPlayersThisMonthCount,
      'sessionsToBeDeliveredThisMonthCount':
          instance.sessionsToBeDeliveredThisMonthCount,
    };
