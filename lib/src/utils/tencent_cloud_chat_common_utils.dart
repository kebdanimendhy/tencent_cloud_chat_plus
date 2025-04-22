part of 'tencent_cloud_chat_plus_utils.dart';

class _TencentCloudChatCommonUtils {
  _TencentCloudChatCommonUtils._();

  // 设置自己的信息
  // https://comm.qq.com/im/doc/flutter/zh/SDKAPI/Api/V2TIMManager/setSelfInfo.html
  Future<V2TimCallback> setSelfInfo(V2TimUserFullInfo info) async {
    if (info.isAllNull) return V2TimCallback(code: 1, desc: 'null info');
    return _manager.setSelfInfo(userFullInfo: info);
  }

  // 获取用户信息
  Future<List<V2TimUserFullInfo>> getUserInfos(List<String> userIDList) async {
    userIDList = userIDList.where((e) => e.isNotEmpty).toList();
    if (userIDList.isEmpty) return [];
    final res = await _manager.getUsersInfo(userIDList: userIDList);
    if (!res.isOk) return [];
    return res.data ?? [];
  }

  // 获取用户信息
  Future<V2TimUserFullInfo?> getUserInfo(String userID) async {
    final infos = await getUserInfos([userID]);
    return infos.firstOrNull;
  }
}
