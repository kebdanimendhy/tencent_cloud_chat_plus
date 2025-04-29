part of 'tencent_cloud_chat_plus_utils.dart';

final class _TencetCloudChatPlusConversationUtils {
  _TencetCloudChatPlusConversationUtils._();

  final _presenter = TencentCloudChatConversationPresenter();

  final sdk = TencentCloudChat.instance.chatSDKInstance.conversationSDK;

  String? genID({String? userID, String? groupID, String? defaultValue}) {
    if (TencentCloudChatUtils.checkString(groupID) != null) {
      return 'group_$groupID';
    } else if (TencentCloudChatUtils.checkString(userID) != null) {
      return 'c2c_$userID';
    }
    return defaultValue;
  }

  /// 置顶
  Future<V2TimCallback> togglePin(V2TimConversation conversation) {
    final to = !conversation.isPin;
    return sdk.pinConversation(
      conversationID: conversation.conversationID,
      isPinned: to,
    );
  }

  /// 删除单个
  Future<V2TimConversationOperationResult?> delete(V2TimConversation conversation,
      {bool clearMessage = true}) async {
    final success = await deleteMany([conversation]);
    return success.firstOrNull;
  }

  /// 删除多个
  Future<List<V2TimConversationOperationResult>> deleteMany(List<V2TimConversation> conversations,
      {bool clearMessage = true}) async {
    if (conversations.isEmpty) return [];
    final ids = conversations.map((e) => e.conversationID).toList();
    final res = await _presenter.cleanConversation(conversationIDList: ids, clearMessage: clearMessage);
    if (!res.isOk) return [];
    return res.data ?? [];
  }

  Future<V2TimCallback> clearMessage(V2TimConversation conversation) async {
    final userID = conversation.userID;
    final groupID = conversation.groupID;
    V2TimCallback res;
    if (TencentCloudChatUtils.checkString(groupID) != null) {
      res = await _messageManager.clearGroupHistoryMessage(groupID: groupID!);
    } else if (TencentCloudChatUtils.checkString(userID) != null) {
      res = await _messageManager.clearC2CHistoryMessage(userID: userID!);
    } else {
      res = V2TimCallback(code: 1, desc: 'bad ID');
    }
    if (res.isOk) {
      _messageData.clearMessageList(userID: userID, groupID: groupID);
    }

    return res;
  }

  int totalUnreadCountWithFilter({bool Function(V2TimConversation)? filter}) {
    if (filter == null || _converstaion.conversationList.isEmpty) {
      return _converstaion.totalUnreadCount;
    }
    return _converstaion.conversationList.where(filter).fold(0, (v, c) => v + (c.unreadCount ?? 0));
  }
}
