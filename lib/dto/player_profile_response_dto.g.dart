// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_profile_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerProfileResponseDto _$PlayerProfileResponseDtoFromJson(
  Map<String, dynamic> json,
) => PlayerProfileResponseDto(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : PlayerDetailDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PlayerProfileResponseDtoToJson(
  PlayerProfileResponseDto instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

PlayerDetailDataDto _$PlayerDetailDataDtoFromJson(Map<String, dynamic> json) =>
    PlayerDetailDataDto(
      player: json['player'] == null
          ? null
          : PlayerDetailDto.fromJson(json['player'] as Map<String, dynamic>),
      parent: json['parent'] == null
          ? null
          : ParentDetailDto.fromJson(json['parent'] as Map<String, dynamic>),
      perDayAttendance: (json['perDayAttendance'] as List<dynamic>?)
          ?.map((e) => AttendanceRecordDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      overallAttendance: json['overallAttendance'] == null
          ? null
          : OverallAttendanceDto.fromJson(
              json['overallAttendance'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$PlayerDetailDataDtoToJson(
  PlayerDetailDataDto instance,
) => <String, dynamic>{
  'player': instance.player,
  'parent': instance.parent,
  'perDayAttendance': instance.perDayAttendance,
  'overallAttendance': instance.overallAttendance,
};

PlayerDetailDto _$PlayerDetailDtoFromJson(Map<String, dynamic> json) =>
    PlayerDetailDto(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      dob: json['dob'] as String?,
      gender: json['gender'] as String?,
      profileImage: json['profileImage'] as String?,
      additionalComments: json['additionalComments'] as String?,
      comments: json['comments'] as String?,
      jerseyNumber: json['jerseyNumber'],
      paymentStatus: json['paymentStatus'] as String?,
      category: json['category'] == null
          ? null
          : CategoryDto.fromJson(json['category'] as Map<String, dynamic>),
      programs: (json['programs'] as List<dynamic>?)
          ?.map((e) => ProgramDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      term: json['term'] == null
          ? null
          : TermDto.fromJson(json['term'] as Map<String, dynamic>),
      rating: (json['rating'] as num?)?.toInt(),
      isBlocked: json['isBlocked'] as bool?,
      assignedClasses: (json['assignedClasses'] as List<dynamic>?)
          ?.map((e) => ClassDataDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      removedClasses: json['removedClasses'] as List<dynamic>?,
      statistics: json['statistics'] == null
          ? null
          : PlayerStatisticsDto.fromJson(
              json['statistics'] as Map<String, dynamic>,
            ),
      attendancePercentage: json['attendancePercentage'] as num?,
      joinedDate: json['joinedDate'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      isMedicalCondition: json['isMedicalCondition'] as bool?,
      medicalConditionDetails: json['medicalConditionDetails'] as String?,
      hasPendingRequest: json['hasPendingRequest'] as bool?,
    );

Map<String, dynamic> _$PlayerDetailDtoToJson(PlayerDetailDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'dob': instance.dob,
      'gender': instance.gender,
      'profileImage': instance.profileImage,
      'additionalComments': instance.additionalComments,
      'comments': instance.comments,
      'jerseyNumber': instance.jerseyNumber,
      'paymentStatus': instance.paymentStatus,
      'category': instance.category,
      'programs': instance.programs,
      'term': instance.term,
      'rating': instance.rating,
      'isBlocked': instance.isBlocked,
      'assignedClasses': instance.assignedClasses,
      'removedClasses': instance.removedClasses,
      'statistics': instance.statistics,
      'attendancePercentage': instance.attendancePercentage,
      'joinedDate': instance.joinedDate,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isMedicalCondition': instance.isMedicalCondition,
      'medicalConditionDetails': instance.medicalConditionDetails,
      'hasPendingRequest': instance.hasPendingRequest,
    };

PlayerStatisticsDto _$PlayerStatisticsDtoFromJson(Map<String, dynamic> json) =>
    PlayerStatisticsDto(
      appearances: (json['appearances'] as num?)?.toInt(),
      goals: (json['goals'] as num?)?.toInt(),
      assists: (json['assists'] as num?)?.toInt(),
      cleanSheets: (json['cleanSheets'] as num?)?.toInt(),
      yellowCards: (json['yellowCards'] as num?)?.toInt(),
      redCards: (json['redCards'] as num?)?.toInt(),
      minutesPlayed: (json['minutesPlayed'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PlayerStatisticsDtoToJson(
  PlayerStatisticsDto instance,
) => <String, dynamic>{
  'appearances': instance.appearances,
  'goals': instance.goals,
  'assists': instance.assists,
  'cleanSheets': instance.cleanSheets,
  'yellowCards': instance.yellowCards,
  'redCards': instance.redCards,
  'minutesPlayed': instance.minutesPlayed,
};

ParentDetailDto _$ParentDetailDtoFromJson(Map<String, dynamic> json) =>
    ParentDetailDto(
      id: json['_id'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postcode: json['postcode'] as String?,
      country: json['country'] as String?,
      emergencyContact: json['emergencyContact'] as String?,
      relationship: json['relationship'] as String?,
      status: json['status'] as String?,
      emailVerified: json['emailVerified'] as bool?,
      phoneVerified: json['phoneVerified'] as bool?,
      isBlocked: json['isBlocked'] as bool?,
      isOtpVerified: json['isOtpVerified'] as bool?,
      profileImage: json['profileImage'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$ParentDetailDtoToJson(ParentDetailDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'postcode': instance.postcode,
      'country': instance.country,
      'emergencyContact': instance.emergencyContact,
      'relationship': instance.relationship,
      'status': instance.status,
      'emailVerified': instance.emailVerified,
      'phoneVerified': instance.phoneVerified,
      'isBlocked': instance.isBlocked,
      'isOtpVerified': instance.isOtpVerified,
      'profileImage': instance.profileImage,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

AttendanceRecordDto _$AttendanceRecordDtoFromJson(Map<String, dynamic> json) =>
    AttendanceRecordDto(
      attendanceId: json['attendanceId'] as String?,
      classData: json['class'] == null
          ? null
          : ClassDataDto.fromJson(json['class'] as Map<String, dynamic>),
      sessionDate: json['sessionDate'] as String?,
      status: json['status'] as String?,
      comment: json['comment'] as String?,
      remarks: json['remarks'] as String?,
      reason: json['reason'] as String?,
      markedByParent: json['markedByParent'] as bool?,
      lateArrival: json['lateArrival'] as bool?,
      attendanceType: json['attendanceType'] as String?,
    );

Map<String, dynamic> _$AttendanceRecordDtoToJson(
  AttendanceRecordDto instance,
) => <String, dynamic>{
  'attendanceId': instance.attendanceId,
  'class': instance.classData,
  'sessionDate': instance.sessionDate,
  'status': instance.status,
  'comment': instance.comment,
  'remarks': instance.remarks,
  'reason': instance.reason,
  'markedByParent': instance.markedByParent,
  'lateArrival': instance.lateArrival,
  'attendanceType': instance.attendanceType,
};

OverallAttendanceDto _$OverallAttendanceDtoFromJson(
  Map<String, dynamic> json,
) => OverallAttendanceDto(
  totalSessions: (json['totalSessions'] as num?)?.toInt(),
  presentCount: (json['presentCount'] as num?)?.toInt(),
  absentCount: (json['absentCount'] as num?)?.toInt(),
  lateCount: (json['lateCount'] as num?)?.toInt(),
  trialCount: (json['trialCount'] as num?)?.toInt(),
  attendedCount: (json['attendedCount'] as num?)?.toInt(),
  percentage: json['percentage'] as num?,
);

Map<String, dynamic> _$OverallAttendanceDtoToJson(
  OverallAttendanceDto instance,
) => <String, dynamic>{
  'totalSessions': instance.totalSessions,
  'presentCount': instance.presentCount,
  'absentCount': instance.absentCount,
  'lateCount': instance.lateCount,
  'trialCount': instance.trialCount,
  'attendedCount': instance.attendedCount,
  'percentage': instance.percentage,
};
