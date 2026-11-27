import 'package:json_annotation/json_annotation.dart';

part 'notification_dto.g.dart';

@JsonSerializable()
class NotificationListResponseDto {
  final bool? success;
  final String? message;
  final List<NotificationDto>? data;

  NotificationListResponseDto({this.success, this.message, this.data});

  factory NotificationListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationListResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationListResponseDtoToJson(this);
}

@JsonSerializable()
class NotificationDto {
  @JsonKey(name: '_id')
  final String? id;
  final String? title;
  @JsonKey(name: 'message')
  final String? description;
  final String? type;
  final String? createdAt;
  final bool? isRead;
  final Map<String, dynamic>? data;

  NotificationDto({
    this.id,
    this.title,
    this.description,
    this.type,
    this.createdAt,
    this.isRead,
    this.data,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDtoToJson(this);
}
