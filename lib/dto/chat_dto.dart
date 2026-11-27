import 'package:json_annotation/json_annotation.dart';

part 'chat_dto.g.dart';

@JsonSerializable()
class ChatListResponseDto {
  bool? success;
  int? total;
  int? page;
  int? limit;
  List<ChatConversationDto>? data;

  ChatListResponseDto({this.success, this.total, this.page, this.limit, this.data});

  factory ChatListResponseDto.fromJson(Map<String, dynamic> json) => _$ChatListResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatListResponseDtoToJson(this);
}

@JsonSerializable()
class ChatConversationDto {
  @JsonKey(name: '_id')
  String? id;
  String? type;
  String? name;
  List<ChatRoomMemberDto>? members;
  ChatLastMessageDto? lastMessage;
  int? unreadCount;
  bool? isPartnerOnline;

  ChatConversationDto({this.id, this.type, this.name, this.members, this.lastMessage, this.unreadCount, this.isPartnerOnline});

  factory ChatConversationDto.fromJson(Map<String, dynamic> json) => _$ChatConversationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatConversationDtoToJson(this);
}

@JsonSerializable()
class ChatRoomMemberDto {
  ChatUserDto? user;
  String? refModel;

  ChatRoomMemberDto({this.user, this.refModel});

  factory ChatRoomMemberDto.fromJson(Map<String, dynamic> json) => _$ChatRoomMemberDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatRoomMemberDtoToJson(this);
}

@JsonSerializable()
class ChatUserDto {
  @JsonKey(name: '_id')
  String? id;
  String? fullName;
  String? name;
  String? email;
  String? phone;
  String? profileImage;

  ChatUserDto({this.id, this.fullName, this.name, this.email, this.phone, this.profileImage});

  factory ChatUserDto.fromJson(Map<String, dynamic> json) => _$ChatUserDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatUserDtoToJson(this);
}

@JsonSerializable()
class ChatLastMessageDto {
  @JsonKey(name: '_id')
  String? id;
  String? text;
  String? status;
  String? tickStatus;
  String? createdAt;
  dynamic sender;
  List<ChatAttachmentDto>? attachments;

  ChatLastMessageDto({this.id, this.text, this.status, this.tickStatus, this.createdAt, this.sender, this.attachments});

  factory ChatLastMessageDto.fromJson(Map<String, dynamic> json) => _$ChatLastMessageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatLastMessageDtoToJson(this);
}

@JsonSerializable()
class ChatMessagesResponseDto {
  bool? success;
  int? total;
  int? page;
  int? limit;
  int? totalPages;
  List<ChatMessageDto>? data;

  ChatMessagesResponseDto({this.success, this.total, this.page, this.limit, this.totalPages, this.data});

  factory ChatMessagesResponseDto.fromJson(Map<String, dynamic> json) => _$ChatMessagesResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessagesResponseDtoToJson(this);
}

@JsonSerializable()
class ChatMessageDto {
  @JsonKey(name: '_id')
  String? id;
  String? text;
  String? createdAt;
  String? tickStatus;
  ChatMessageSenderDto? sender;
  List<ChatAttachmentDto>? attachments;

  ChatMessageDto({this.id, this.text, this.createdAt, this.tickStatus, this.sender, this.attachments});

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) => _$ChatMessageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageDtoToJson(this);
}

@JsonSerializable()
class ChatMessageSenderDto {
  String? refModel;
  ChatUserDto? user;

  ChatMessageSenderDto({this.refModel, this.user});

  factory ChatMessageSenderDto.fromJson(Map<String, dynamic> json) => _$ChatMessageSenderDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageSenderDtoToJson(this);
}

@JsonSerializable()
class ChatAttachmentDto {
  String? url;
  String? fileType;

  ChatAttachmentDto({this.url, this.fileType});

  factory ChatAttachmentDto.fromJson(Map<String, dynamic> json) => _$ChatAttachmentDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatAttachmentDtoToJson(this);
}

@JsonSerializable()
class CreateDirectChatResponseDto {
  bool? success;
  CreateDirectChatDataDto? data;

  CreateDirectChatResponseDto({this.success, this.data});

  factory CreateDirectChatResponseDto.fromJson(Map<String, dynamic> json) => _$CreateDirectChatResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateDirectChatResponseDtoToJson(this);
}

@JsonSerializable()
class CreateDirectChatDataDto {
  @JsonKey(name: '_id')
  String? id;

  CreateDirectChatDataDto({this.id});

  factory CreateDirectChatDataDto.fromJson(Map<String, dynamic> json) => _$CreateDirectChatDataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateDirectChatDataDtoToJson(this);
}

@JsonSerializable()
class ClassParentsResponseDto {
  bool? success;
  List<ClassParentDto>? data;

  ClassParentsResponseDto({this.success, this.data});

  factory ClassParentsResponseDto.fromJson(Map<String, dynamic> json) => _$ClassParentsResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ClassParentsResponseDtoToJson(this);
}

@JsonSerializable()
class ClassParentDto {
  @JsonKey(name: '_id')
  String? id;
  String? fullName;

  ClassParentDto({this.id, this.fullName});

  factory ClassParentDto.fromJson(Map<String, dynamic> json) => _$ClassParentDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ClassParentDtoToJson(this);
}

@JsonSerializable()
class RestMessageFallbackResponseDto {
  bool? success;
  String? message;

  RestMessageFallbackResponseDto({this.success, this.message});

  factory RestMessageFallbackResponseDto.fromJson(Map<String, dynamic> json) => _$RestMessageFallbackResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RestMessageFallbackResponseDtoToJson(this);
}
