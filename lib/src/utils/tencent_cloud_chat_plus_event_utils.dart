part of 'tencent_cloud_chat_plus_utils.dart';

class _TencentCloudChatPlusEventUtils {
  _TencentCloudChatPlusEventUtils._();

  StreamSubscription<T> listen<T>(String componentName,
      {required TencentCloudChatPlusUtilsEventListenr<T> listener, bool Function(T)? test}) {
    var stream = TencentCloudChat.instance.eventBusInstance.on<T>(componentName)!;
    if (test != null) {
      stream = stream.where(test);
    }
    return stream.listen(listener);
  }

  /// 群监听
  /// [TencentCloudChatGroupProfileDataKeys]
  StreamSubscription<TencentCloudChatGroupProfileData<T>> listenGroup<T>(
          TencentCloudChatPlusUtilsEventListenr<TencentCloudChatGroupProfileData> listener,
          {bool Function(TencentCloudChatGroupProfileData)? test}) =>
      listen<TencentCloudChatGroupProfileData<T>>(
        TencentCloudChatEventBus.eventNameGroup,
        listener: listener,
        test: test,
      );

  /// 消息监听
  /// [TencentCloudChatMessageDataKeys]
  StreamSubscription<TencentCloudChatMessageData<T>> listenMessage<T>(
          TencentCloudChatPlusUtilsEventListenr<TencentCloudChatMessageData> listener,
          {bool Function(TencentCloudChatMessageData)? test}) =>
      listen<TencentCloudChatMessageData<T>>(
        "TencentCloudChatMessageData",
        listener: listener,
        test: test,
      );

  /// 会话监听
  /// [TencentCloudChatConversationDataKeys]
  StreamSubscription<TencentCloudChatConversationData<T>> listenConversation<T>(
          TencentCloudChatPlusUtilsEventListenr<TencentCloudChatConversationData> listener,
          {bool Function(TencentCloudChatConversationData)? test}) =>
      listen<TencentCloudChatConversationData<T>>(
        TencentCloudChatEventBus.eventNameConversation,
        listener: listener,
        test: test,
      );

  /// contact监听
  /// [TencentCloudChatContactDataKeys]
  StreamSubscription<TencentCloudChatContactData<T>> listenContact<T>(
          TencentCloudChatPlusUtilsEventListenr<TencentCloudChatContactData> listener,
          {bool Function(TencentCloudChatContactData)? test}) =>
      listen<TencentCloudChatContactData<T>>(
        TencentCloudChatEventBus.eventNameContact,
        listener: listener,
        test: test,
      );
}
