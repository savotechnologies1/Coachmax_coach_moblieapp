import 'package:json_annotation/json_annotation.dart';
import 'package:coachmax_coach/dto/classes_response_dto.dart';

part 'player_profile_response_dto.g.dart';

@JsonSerializable()
class PlayerProfileResponseDto {
  bool? success;
  String? message;
  PlayerDetailDataDto? data;

  PlayerProfileResponseDto({this.success, this.message, this.data});

  factory PlayerProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerProfileResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerProfileResponseDtoToJson(this);
}

@JsonSerializable()
class PlayerDetailDataDto {
  PlayerDetailDto? player;
  ParentDetailDto? parent;
  List<AttendanceRecordDto>? perDayAttendance;
  OverallAttendanceDto? overallAttendance;

  PlayerDetailDataDto({
    this.player,
    this.parent,
    this.perDayAttendance,
    this.overallAttendance,
  });

  factory PlayerDetailDataDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerDetailDataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerDetailDataDtoToJson(this);
}

@JsonSerializable()
class PlayerDetailDto {
  @JsonKey(name: '_id')
  String? id;
  String? firstName;
  String? lastName;
  String? fullName;
  String? email;
  String? phone;
  String? dob;
  String? gender;
  String? profileImage;
  String? additionalComments;
  String? comments;
  dynamic jerseyNumber;
  String? paymentStatus;
  CategoryDto? category;
  List<ProgramDto>? programs;
  TermDto? term;
  int? rating;
  bool? isBlocked;
  List<ClassDataDto>? assignedClasses;
  List<dynamic>? removedClasses;
  PlayerStatisticsDto? statistics;
  num? attendancePercentage;
  String? joinedDate;
  String? createdAt;
  String? updatedAt;
  bool? isMedicalCondition;
  String? medicalConditionDetails;
  bool? hasPendingRequest;

  PlayerDetailDto({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.email,
    this.phone,
    this.dob,
    this.gender,
    this.profileImage,
    this.additionalComments,
    this.comments,
    this.jerseyNumber,
    this.paymentStatus,
    this.category,
    this.programs,
    this.term,
    this.rating,
    this.isBlocked,
    this.assignedClasses,
    this.removedClasses,
    this.statistics,
    this.attendancePercentage,
    this.joinedDate,
    this.createdAt,
    this.updatedAt,
    this.isMedicalCondition,
    this.medicalConditionDetails,
    this.hasPendingRequest,
  });

  factory PlayerDetailDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerDetailDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerDetailDtoToJson(this);
}

@JsonSerializable()
class PlayerStatisticsDto {
  int? appearances;
  int? goals;
  int? assists;
  int? cleanSheets;
  int? yellowCards;
  int? redCards;
  int? minutesPlayed;

  PlayerStatisticsDto({
    this.appearances,
    this.goals,
    this.assists,
    this.cleanSheets,
    this.yellowCards,
    this.redCards,
    this.minutesPlayed,
  });

  factory PlayerStatisticsDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerStatisticsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerStatisticsDtoToJson(this);
}

@JsonSerializable()
class ParentDetailDto {
  @JsonKey(name: '_id')
  String? id;
  String? fullName;
  String? email;
  String? phone;
  String? address;
  String? city;
  String? state;
  String? postcode;
  String? country;
  String? emergencyContact;
  String? relationship;
  String? status;
  bool? emailVerified;
  bool? phoneVerified;
  bool? isBlocked;
  bool? isOtpVerified;
  String? profileImage;
  String? createdAt;
  String? updatedAt;

  ParentDetailDto({
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.postcode,
    this.country,
    this.emergencyContact,
    this.relationship,
    this.status,
    this.emailVerified,
    this.phoneVerified,
    this.isBlocked,
    this.isOtpVerified,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  factory ParentDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ParentDetailDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ParentDetailDtoToJson(this);
}

@JsonSerializable()
class AttendanceRecordDto {
  String? attendanceId;
  @JsonKey(name: 'class')
  ClassDataDto? classData;
  String? sessionDate;
  String? status;
  String? comment;
  String? remarks;
  String? reason;
  bool? markedByParent;
  bool? lateArrival;
  String? attendanceType;

  AttendanceRecordDto({
    this.attendanceId,
    this.classData,
    this.sessionDate,
    this.status,
    this.comment,
    this.remarks,
    this.reason,
    this.markedByParent,
    this.lateArrival,
    this.attendanceType,
  });

  factory AttendanceRecordDto.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AttendanceRecordDtoToJson(this);
}

@JsonSerializable()
class OverallAttendanceDto {
  int? totalSessions;
  int? presentCount;
  int? absentCount;
  int? lateCount;
  int? trialCount;
  int? attendedCount;
  num? percentage;

  OverallAttendanceDto({
    this.totalSessions,
    this.presentCount,
    this.absentCount,
    this.lateCount,
    this.trialCount,
    this.attendedCount,
    this.percentage,
  });

  factory OverallAttendanceDto.fromJson(Map<String, dynamic> json) =>
      _$OverallAttendanceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$OverallAttendanceDtoToJson(this);
}
