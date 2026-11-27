// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationListResponseDto _$NotificationListResponseDtoFromJson(
  Map<String, dynamic> json,
) => NotificationListResponseDto(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => NotificationDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$NotificationListResponseDtoToJson(
  NotificationListResponseDto instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

NotificationDto _$NotificationDtoFromJson(Map<String, dynamic> json) =>
    NotificationDto(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      description: json['message'] as String?,
      type: json['type'] as String?,
      createdAt: json['createdAt'] as String?,
      isRead: json['isRead'] as bool?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NotificationDtoToJson(NotificationDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'message': instance.description,
      'type': instance.type,
      'createdAt': instance.createdAt,
      'isRead': instance.isRead,
      'data': instance.data,
    };
