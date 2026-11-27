// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatListResponseDto _$ChatListResponseDtoFromJson(Map<String, dynamic> json) =>
    ChatListResponseDto(
      success: json['success'] as bool?,
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ChatConversationDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatListResponseDtoToJson(
  ChatListResponseDto instance,
) => <String, dynamic>{
  'success': instance.success,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
  'data': instance.data,
};

ChatConversationDto _$ChatConversationDtoFromJson(Map<String, dynamic> json) =>
    ChatConversationDto(
      id: json['_id'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => ChatRoomMemberDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] == null
          ? null
          : ChatLastMessageDto.fromJson(
              json['lastMessage'] as Map<String, dynamic>,
            ),
      unreadCount: (json['unreadCount'] as num?)?.toInt(),
      isPartnerOnline: json['isPartnerOnline'] as bool?,
    );

Map<String, dynamic> _$ChatConversationDtoToJson(
  ChatConversationDto instance,
) => <String, dynamic>{
  '_id': instance.id,
  'type': instance.type,
  'name': instance.name,
  'members': instance.members,
  'lastMessage': instance.lastMessage,
  'unreadCount': instance.unreadCount,
  'isPartnerOnline': instance.isPartnerOnline,
};

ChatRoomMemberDto _$ChatRoomMemberDtoFromJson(Map<String, dynamic> json) =>
    ChatRoomMemberDto(
      user: json['user'] == null
          ? null
          : ChatUserDto.fromJson(json['user'] as Map<String, dynamic>),
      refModel: json['refModel'] as String?,
    );

Map<String, dynamic> _$ChatRoomMemberDtoToJson(ChatRoomMemberDto instance) =>
    <String, dynamic>{'user': instance.user, 'refModel': instance.refModel};

ChatUserDto _$ChatUserDtoFromJson(Map<String, dynamic> json) => ChatUserDto(
  id: json['_id'] as String?,
  fullName: json['fullName'] as String?,
  name: json['name'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  profileImage: json['profileImage'] as String?,
);

Map<String, dynamic> _$ChatUserDtoToJson(ChatUserDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'fullName': instance.fullName,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'profileImage': instance.profileImage,
    };

ChatLastMessageDto _$ChatLastMessageDtoFromJson(Map<String, dynamic> json) =>
    ChatLastMessageDto(
      id: json['_id'] as String?,
      text: json['text'] as String?,
      status: json['status'] as String?,
      tickStatus: json['tickStatus'] as String?,
      createdAt: json['createdAt'] as String?,
      sender: json['sender'],
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => ChatAttachmentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatLastMessageDtoToJson(ChatLastMessageDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'text': instance.text,
      'status': instance.status,
      'tickStatus': instance.tickStatus,
      'createdAt': instance.createdAt,
      'sender': instance.sender,
      'attachments': instance.attachments,
    };

ChatMessagesResponseDto _$ChatMessagesResponseDtoFromJson(
  Map<String, dynamic> json,
) => ChatMessagesResponseDto(
  success: json['success'] as bool?,
  total: (json['total'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  limit: (json['limit'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => ChatMessageDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ChatMessagesResponseDtoToJson(
  ChatMessagesResponseDto instance,
) => <String, dynamic>{
  'success': instance.success,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
  'totalPages': instance.totalPages,
  'data': instance.data,
};

ChatMessageDto _$ChatMessageDtoFromJson(Map<String, dynamic> json) =>
    ChatMessageDto(
      id: json['_id'] as String?,
      text: json['text'] as String?,
      createdAt: json['createdAt'] as String?,
      tickStatus: json['tickStatus'] as String?,
      sender: json['sender'] == null
          ? null
          : ChatMessageSenderDto.fromJson(
              json['sender'] as Map<String, dynamic>,
            ),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => ChatAttachmentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatMessageDtoToJson(ChatMessageDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'text': instance.text,
      'createdAt': instance.createdAt,
      'tickStatus': instance.tickStatus,
      'sender': instance.sender,
      'attachments': instance.attachments,
    };

ChatMessageSenderDto _$ChatMessageSenderDtoFromJson(
  Map<String, dynamic> json,
) => ChatMessageSenderDto(
  refModel: json['refModel'] as String?,
  user: json['user'] == null
      ? null
      : ChatUserDto.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChatMessageSenderDtoToJson(
  ChatMessageSenderDto instance,
) => <String, dynamic>{'refModel': instance.refModel, 'user': instance.user};

ChatAttachmentDto _$ChatAttachmentDtoFromJson(Map<String, dynamic> json) =>
    ChatAttachmentDto(
      url: json['url'] as String?,
      fileType: json['fileType'] as String?,
    );

Map<String, dynamic> _$ChatAttachmentDtoToJson(ChatAttachmentDto instance) =>
    <String, dynamic>{'url': instance.url, 'fileType': instance.fileType};

CreateDirectChatResponseDto _$CreateDirectChatResponseDtoFromJson(
  Map<String, dynamic> json,
) => CreateDirectChatResponseDto(
  success: json['success'] as bool?,
  data: json['data'] == null
      ? null
      : CreateDirectChatDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreateDirectChatResponseDtoToJson(
  CreateDirectChatResponseDto instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

CreateDirectChatDataDto _$CreateDirectChatDataDtoFromJson(
  Map<String, dynamic> json,
) => CreateDirectChatDataDto(id: json['_id'] as String?);

Map<String, dynamic> _$CreateDirectChatDataDtoToJson(
  CreateDirectChatDataDto instance,
) => <String, dynamic>{'_id': instance.id};

ClassParentsResponseDto _$ClassParentsResponseDtoFromJson(
  Map<String, dynamic> json,
) => ClassParentsResponseDto(
  success: json['success'] as bool?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => ClassParentDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ClassParentsResponseDtoToJson(
  ClassParentsResponseDto instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

ClassParentDto _$ClassParentDtoFromJson(Map<String, dynamic> json) =>
    ClassParentDto(
      id: json['_id'] as String?,
      fullName: json['fullName'] as String?,
    );

Map<String, dynamic> _$ClassParentDtoToJson(ClassParentDto instance) =>
    <String, dynamic>{'_id': instance.id, 'fullName': instance.fullName};

RestMessageFallbackResponseDto _$RestMessageFallbackResponseDtoFromJson(
  Map<String, dynamic> json,
) => RestMessageFallbackResponseDto(
  success: json['success'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$RestMessageFallbackResponseDtoToJson(
  RestMessageFallbackResponseDto instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
};
