part of 'tencent_cloud_chat_plus_utils.dart';

class _TencentCloudChatPlusMessageUtils {
  final _tag = '_TencentCloudChatPlusMessageUtils';
  _TencentCloudChatPlusMessageUtils._();

  final sdk = TencentCloudChat.instance.chatSDKInstance.messageSDK;

  assertion(String log) => _assertion(_tag, log);

  ///
  /// [TencentCloudChatMessageSeparateDataProvider._sendMessage]
  /// [TencentCloudChatMessageController.sendMessage]
  Future<bool> _sendCustomBySDK(
    String data, {
    String? userID,
    String? groupID,
    String? pushDesc,
    String? pushExtension,
  }) async {
    final messageInfoResult = await sdk.createCustomMessage(
      data: data,
      desc: pushDesc,
      extension: pushExtension,
    );
    if (messageInfoResult == null) return false;
    V2TimGroupInfo? groupInfo;
    if (TencentCloudChatUtils.checkString(groupID) != null) {
      groupInfo = _contact.getGroupInfo(groupID!);
    }
    const topicID = null;
    const V2TimMessage? tempRepliedMessage = null;
    const isResend = false;
    final res = await TencentCloudChatMessageDataTools.sendMessage(
      createdMessage: messageInfoResult,
      userID: userID,
      groupID: groupID,
      topicID: topicID,
      repliedMessage: tempRepliedMessage,
      groupInfo: groupInfo,
      isResend: isResend,
    );
    if (res == null || res.code != 0) {
      TencentCloudChat.instance.callbacks.onSDKFailed(
        "sendMessage",
        res?.code ?? -1,
        ErrorMessageConverter.getErrorMessage(res?.code ?? -1, res!.desc),
      );
      return false;
    }
    return true;
  }

  /// 返回值不表示发送成功，只表示调用发送接口成功
  /// [useDataProviderCache] 是否使用缓存
  /// see: [TencentCloudChatPlusCacheMessageLayout]
  Future<bool> _sendCustom(
    String data, {
    String? pushDesc,
    String? pushExtension,
    String? groupID,
    String? userID,
    TencentCloudChatMessageSeparateDataProvider? dataProvider,
    bool useDataProviderCache = true,
    bool sendIfNullDataProvider = true,
  }) async {
    if (TencentCloudChatUtils.checkString(userID) == null &&
        TencentCloudChatUtils.checkString(groupID) == null) {
      assertion('_sendCustomMessage emptyID userID:$userID,groupID:$groupID,message:$data');
      return false;
    }
    if (dataProvider == null) {
      if (useDataProviderCache) {
        dataProvider = TencentCloudChatPlusMessageDataProviderCache.findLast(
          userID: userID,
          groupID: groupID,
        );
      }
    }
    if (dataProvider != null) {
      dataProvider.sendCustomMesssage(data: data, desc: pushDesc, extension: pushExtension);
      return true;
    }
    if (!sendIfNullDataProvider) {
      return false;
    }
    return _sendCustomBySDK(
      data,
      pushDesc: pushDesc,
      pushExtension: pushExtension,
      userID: userID,
      groupID: groupID,
    );
  }

  Future<bool> sendCustom<T>(
    TencentCloudChatPlusMessageCustom message, {
    String? userID,
    String? groupID,
    TencentCloudChatMessageSeparateDataProvider? dataProvider,
    bool useDataProviderCache = true,
    bool sendIfNullDataProvider = true,
  }) {
    final data = jsonEncode(message.toJson());
    return _sendCustom(
      data,
      pushDesc: message.getPushDesc(),
      pushExtension: message.getPushExtenstion(),
      userID: userID,
      groupID: groupID,
      useDataProviderCache: useDataProviderCache,
      sendIfNullDataProvider: sendIfNullDataProvider,
    );
  }
}
