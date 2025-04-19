part of 'tencent_cloud_chat_plus_cache_message_layout.dart';

class TencentCloudChatPlusMessageDataProviderCache {
  TencentCloudChatPlusMessageDataProviderCache._();

  static final _tag = 'TencentCloudChatPlusMessageDataProviderCache';
  static final _cache = <TencentCloudChatMessageSeparateDataProvider>[];

  static console(String log, {bool assertion = false}) {
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: log,
    );
    if (assertion) {
      assert(false, '[$_tag]:$log');
    }
  }

  static List<TencentCloudChatMessageSeparateDataProvider> findAll({String? userID, String? groupID}) {
    final findGroup = TencentCloudChatUtils.checkString(groupID) != null;
    final findC2C = TencentCloudChatUtils.checkString(userID) != null;
    if (!findC2C && !findGroup) {
      console('find bad userID:$userID, groupID:$groupID', assertion: true);
    }
    return _cache.where((e) {
      if (findGroup) return e.groupID == groupID;
      if (findC2C) return e.userID == userID;
      return false;
    }).toList();
  }

  static TencentCloudChatMessageSeparateDataProvider? findFirst({String? userID, String? groupID}) =>
      findAll(userID: userID, groupID: groupID).firstOrNull;

  static TencentCloudChatMessageSeparateDataProvider? findLast({String? userID, String? groupID}) =>
      findAll(userID: userID, groupID: groupID).lastOrNull;

  static void _add(TencentCloudChatMessageSeparateDataProvider dataProvider) {
    final userID = dataProvider.userID;
    final groupID = dataProvider.groupID;
    console('add userID:$userID, groupID:$groupID provider:${identityHashCode(dataProvider)}');
    if (!_cache.contains(dataProvider)) {
      _cache.add(dataProvider);
    }
  }

  static void _del(TencentCloudChatMessageSeparateDataProvider dataProvider) {
    final userID = dataProvider.userID;
    final groupID = dataProvider.groupID;
    console('del userID:$userID, groupID:$groupID provider:${dataProvider.hashCode}');
    _cache.remove(dataProvider);
  }
}
