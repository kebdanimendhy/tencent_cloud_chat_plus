part of 'tencent_cloud_chat_plus_utils.dart';

class _TencentCloudChatPlusEventUtils {
  _TencentCloudChatPlusEventUtils._();

  StreamSubscription<T> listen<T>(String componentName,
      {required TencentCloudChatPlusUtilsEventListener<T> listener, bool Function(T)? test}) {
    var stream = TencentCloudChat.instance.eventBusInstance.on<T>(componentName)!;
    if (test != null) {
      stream = stream.where(test);
    }
    return stream.listen(listener);
  }

  /// 群监听
  /// [TencentCloudChatGroupProfileDataKeys]
  StreamSubscription<TencentCloudChatGroupProfileData<T>> listenGroup<T>(
          TencentCloudChatPlusUtilsEventListener<TencentCloudChatGroupProfileData> listener,
          {bool Function(TencentCloudChatGroupProfileData)? test}) =>
      listen<TencentCloudChatGroupProfileData<T>>(
        TencentCloudChatEventBus.eventNameGroup,
        listener: listener,
        test: test,
      );

  /// 消息监听
  /// [TencentCloudChatMessageDataKeys]
  StreamSubscription<TencentCloudChatMessageData<T>> listenMessage<T>(
          TencentCloudChatPlusUtilsEventListener<TencentCloudChatMessageData> listener,
          {bool Function(TencentCloudChatMessageData)? test}) =>
      listen<TencentCloudChatMessageData<T>>(
        "TencentCloudChatMessageData",
        listener: listener,
        test: test,
      );

  /// 会话监听
  /// [TencentCloudChatConversationDataKeys]
  StreamSubscription<TencentCloudChatConversationData<T>> listenConversation<T>(
          TencentCloudChatPlusUtilsEventListener<TencentCloudChatConversationData> listener,
          {bool Function(TencentCloudChatConversationData)? test}) =>
      listen<TencentCloudChatConversationData<T>>(
        TencentCloudChatEventBus.eventNameConversation,
        listener: listener,
        test: test,
      );

  /// 有条件的unreadCount总数
  /// [TencentCloudChatConversationData.totalUnreadCount] 这个是独立的的接口，读取未读总数,可以在conversationList未加载的情况下获取
  /// 这里是对converationList进行监听, 必须加载过conversationList才有数据
  StreamSubscription<void> listenConversationUnreadCount(void Function(int unread) listener,
      {bool Function(V2TimConversation)? filter}) {
    return listenConversation(
      (e) {
        if (e.conversationList.isEmpty) {
          listener(e.totalUnreadCount);
          return;
        }
        Iterable<V2TimConversation> conversationList = e.conversationList;
        if (filter != null) {
          conversationList = e.conversationList.where(filter);
        }
        final count = conversationList.fold(0, (v, e) => v + (e.unreadCount ?? 0));
        listener(count);
      },
      test: (e) =>
          e.currentUpdatedFields == TencentCloudChatConversationDataKeys.conversationList ||
          e.currentUpdatedFields == TencentCloudChatConversationDataKeys.totalUnreadCount,
    );
  }

  /// contact监听
  /// [TencentCloudChatContactDataKeys]
  StreamSubscription<TencentCloudChatContactData<T>> listenContact<T>(
          TencentCloudChatPlusUtilsEventListener<TencentCloudChatContactData> listener,
          {bool Function(TencentCloudChatContactData)? test}) =>
      listen<TencentCloudChatContactData<T>>(
        TencentCloudChatEventBus.eventNameContact,
        listener: listener,
        test: test,
      );

  /// basic监听
  /// [TencentCloudChatBasicDataKeys]
  StreamSubscription<TencentCloudChatBasicData<T>> listenBasic<T>(
          TencentCloudChatPlusUtilsEventListener<TencentCloudChatBasicData> listener,
          {bool Function(TencentCloudChatBasicData)? test}) =>
      listen<TencentCloudChatBasicData<T>>(
        'TencentCloudChatBasicData',
        listener: listener,
        test: test,
      );

  /// plus 监听
  /// [TencentCloudChatPlusDataKeys]
  StreamSubscription<TencentCloudChatPlusData<T>> listenPlus<T>(
          TencentCloudChatPlusUtilsEventListener<TencentCloudChatPlusData> listener,
          {bool Function(TencentCloudChatPlusData)? test}) =>
      listen<TencentCloudChatPlusData<T>>(
        TencentCloudChatPlusData.eventName,
        listener: listener,
        test: test,
      );
}
