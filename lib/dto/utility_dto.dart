import 'dart:convert';

class UtilityDto {
  UtilityDto({
    this.result,
    this.success,
    this.message,
    this.eventId,
    this.expiresAt,
    this.refreshExpiresAt,
    this.firebaseToken,
    this.accessToken,
    this.refreshToken,
    this.url,
    this.name,
    this.mimeType,
    this.thumbnail,
    this.id,
    this.userId,
    this.uid,
    this.hostId,
    this.status,
    this.count,
    this.token,
    this.role,
    this.feedId,
    this.scope,
  });

  Result? result;
  bool? success; // ✅ Added field
  String? message;
  String? eventId;
  int? feedId;
  int? hostId;
  int? expiresAt;
  int? refreshExpiresAt;
  dynamic firebaseToken, uid;
  String? accessToken;
  String? refreshToken;
  String? url;
  String? name;
  String? mimeType;
  String? thumbnail;
  dynamic id;
  dynamic userId;
  int? count;
  dynamic status;
  String? token;
  List<String>? role;
  String? scope;

  factory UtilityDto.fromRawJson(String str) =>
      UtilityDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UtilityDto.fromJson(Map<String, dynamic> json) => UtilityDto(
    result: json.containsKey("result") && json["result"] != null
        ? Result.fromJson(json["result"])
        : null,
    success: json["success"], // ✅ parse success
    message: json["message"],
    eventId: json["eventId"],
    url: json["url"],
    expiresAt: json["expiresAt"],
    feedId: json["feedId"],
    uid: json["uid"],
    refreshExpiresAt: json["refreshExpiresAt"],
    firebaseToken: json["firebaseToken"],
    accessToken: json["accessToken"],
    refreshToken: json["refreshToken"],
    id: json["id"],
    userId: json["userId"],
    status: json["status"],
    count: json["count"],
    token: json["token"],
    hostId: json["hostId"],
    role: json["role"] == null
        ? []
        : List<String>.from(json["role"]!.map((x) => x)),
    scope: json["scope"],
  );

  Map<String, dynamic> toJson() => {
    "result": result?.toJson(),
    "success": success, // ✅ added in toJson
    "message": message,
    "eventId": eventId,
    "url": url,
    "expiresAt": expiresAt,
    "feedId": feedId,
    "uid": uid,
    "refreshExpiresAt": refreshExpiresAt,
    "accessToken": accessToken,
    "firebaseToken": firebaseToken,
    "refreshToken": refreshToken,
    "id": id,
    "userId": userId,
    "status": status,
    "count": count,
    "token": token,
    "hostId": hostId,
    "role":
    role == null ? [] : List<dynamic>.from(role!.map((x) => x)),
    "scope": scope,
  };
}

class Result {
  Result({
    this.id,
    this.rateId,
    this.message,
    this.token,
    this.uid,
  });

  dynamic id, uid;
  String? rateId;
  String? message;
  String? token;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    uid: json["uid"],
    rateId: json["rateId"],
    message: json["message"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "rateId": rateId,
    "message": message,
    "token": token,
  };
}
