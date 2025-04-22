part of 'tencent_cloud_chat_plus_utils.dart';

// 在contact中实现了一个状态的监听
// 但是在实际需求中, 并不是所有的都有加好友的前提
// 这里的实现并不依赖contact加好友
// 不支持自己
class _TencentCloudChatOnlineStatusUtils {
  static final _tag = '_TencentCloudChatOnlineStatusUtils';
  _TencentCloudChatOnlineStatusUtils._();

  final _subscribes = <String>{};
  final _statusInfos = <String, V2TimUserStatus>{};

  console({required String logs}) => _console(_tag, logs);

  Map<String, V2TimUserStatus> get statsusInfos => _statusInfos;

  List<String> _revise(List<String?> userIDs) {
    return userIDs.where((e) => TencentCloudChatUtils.checkString(e) != null).cast<String>().toList();
  }

  Future<V2TimCallback> subscribleAllIfNeed(List<String?> userIDs, {bool getNow = true}) async {
    final list = _revise(userIDs);
    final set = list.toSet();
    if (set.length == _subscribes.length && set.containsAll(_subscribes)) {
      return V2TimCallback(code: 0, desc: '');
    }
    await unsubscribeAll();
    return subscribe(list, getNow: true);
  }

  Future<V2TimCallback> unsubscribeAll() async {
    final res = await _manager.unsubscribeUserStatus(userIDList: []);
    if (res.isOk) {
      _subscribes.clear();
    }
    return res;
  }

  Future<V2TimCallback> unsubscribe(List<String?> userIDs) async {
    final list = _revise(userIDs);
    if (list.isEmpty) return V2TimCallback(code: 0, desc: '');
    final res = await _manager.unsubscribeUserStatus(userIDList: list);
    if (res.isOk) {
      _subscribes.removeAll(list);
    }
    return res;
  }

  Future<V2TimCallback> subscribe(List<String?> userIDs, {bool getNow = true}) async {
    final list = _revise(userIDs);
    if (list.isEmpty) return V2TimCallback(code: 0, desc: '');
    await unsubscribe(userIDs);
    final res = await _manager.subscribeUserStatus(userIDList: list);
    if (res.isOk) {
      _subscribes.addAll(list);
    }
    if (getNow) {
      getUsersStatusFromRemote(userIDs).then((v) {
        onUserStatusChanged(v);
      });
    }
    return res;
  }

  Future<List<V2TimUserStatus>> getUsersStatusFromRemote(List<String?> userIDs) async {
    final list = _revise(userIDs);
    if (list.isEmpty) return [];
    final res = await _manager.getUserStatus(userIDList: list);
    if (!res.isOk) return [];
    return res.data ?? [];
  }

  Future<V2TimUserStatus?> getUserStatusFromRemote(String? userID) async {
    final res = await getUsersStatusFromRemote([userID]);
    return res.firstOrNull;
  }

  List<V2TimUserStatus> getUsersStatus(List<String?> userIDs) {
    final list = _revise(userIDs);
    if (list.isEmpty) return [];
    return list.map((e) => _statusInfos[e]).nonNulls.toList();
  }

  V2TimUserStatus? getUserStatus(String? userID) => getUsersStatus([userID]).firstOrNull;

  ///see: [TencentCloudChatContactData.buildUserStatusList];
  /// [TencentCloudChatCallbacks] 中调用
  void onUserStatusChanged(List<V2TimUserStatus> userStatus) {
    for (var e in userStatus) {
      if (TencentCloudChatUtils.checkString(e.userID) == null) continue;
      _statusInfos[e.userID!] = e;
    }
    console(
      logs:
          "onUserStatusChanged ${userStatus.length} changed. total userStatus length is ${_statusInfos.length}",
    );

    final key = TencentCloudChatPlusDataKeys.userStatusList;
    // 目前不用携带任何数据， 直接从源数据读
    TencentCloudChatPlusData(key).notifyListener(key);
  }
}
