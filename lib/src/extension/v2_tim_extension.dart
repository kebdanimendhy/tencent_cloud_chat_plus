part of 'tencent_cloud_chat_plus_extension.dart';

extension V2TimConversationExtension on V2TimConversation {
  // 是否单聊
  bool get isC2C => type == ConversationType.V2TIM_C2C;
  // 是否群聊
  bool get isGroup => type == ConversationType.V2TIM_GROUP;
  // 无效type
  bool get isInvalid => type == ConversationType.CONVERSATION_TYPE_INVALID;
  // 是否置顶
  bool get isPin => isPinned ?? false;
  // toggle置顶
  Future<V2TimCallback?> togglePin() => TencentCloudChatPlusUtils.conversation.togglePin(this);
  // 删除
  Future<V2TimConversationOperationResult?> delete() => TencentCloudChatPlusUtils.conversation.delete(this);
  // 清空
  Future<V2TimCallback?> clearMessage() => TencentCloudChatPlusUtils.conversation.clearMessage(this);
}

extension V2TimCallbackExt on V2TimCallback {
  bool get isOk => code == 0;
}

extension V2TimValueCallbackExt on V2TimValueCallback {
  bool get isOk => code == 0;
}

extension V2TimConversationOperationResultExt on V2TimConversationOperationResult {
  bool get isOk => resultCode == 0;
}

extension V2TimFriendOperationResultExt on V2TimFriendOperationResult {
  bool get isOk => resultCode == 0;
}

extension V2TimGroupInfoResultExt on V2TimGroupInfoResult {
  bool get isOk => resultCode == 0;
}

extension V2TimGroupMemberFullInfoExt on V2TimGroupMemberFullInfo {
  bool get isOwner => role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER;
  bool get isAdmin => role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN;
  bool get isMember => role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER;
  bool get isInvalid => role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_UNDEFINED;
}
