import 'package:json_annotation/json_annotation.dart';

part 'my_profile_response_dto.g.dart';

@JsonSerializable()
class MyProfileResponseDto {
  bool? success;
  String? role;
  String? message;
  ProfileDataDto? data;

  MyProfileResponseDto({this.success, this.role, this.message, this.data});

  factory MyProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MyProfileResponseDtoToJson(this);
}

@JsonSerializable()
class ProfileDataDto {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  String? email;
  String? mobile;
  bool? isOtpVerified;
  String? role;
  String? createdAt;
  String? updatedAt;
  int? v;
  List<String>? fcmTokens;
  String? profileImage;
  String? profile;
  List<dynamic>? players;
  int? unpaidInvoiceCount;
  int? assignedClassesCount;
  int? uniquePlayersCount;
  num? overallAttendancePercentage;
  int? temporaryPlayersThisMonthCount;
  int? sessionsToBeDeliveredThisMonthCount;

  ProfileDataDto({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.isOtpVerified,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.fcmTokens,
    this.profileImage,
    this.profile,
    this.players,
    this.unpaidInvoiceCount,
    this.assignedClassesCount,
    this.uniquePlayersCount,
    this.overallAttendancePercentage,
    this.temporaryPlayersThisMonthCount,
    this.sessionsToBeDeliveredThisMonthCount,
  });

  factory ProfileDataDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDataDtoToJson(this);
}
