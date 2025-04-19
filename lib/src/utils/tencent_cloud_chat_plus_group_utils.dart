part of 'tencent_cloud_chat_plus_utils.dart';

class _TencentCloudChatPlusGroupUtils {
  _TencentCloudChatPlusGroupUtils._();

  // 获取群成员列表
  // 从SDK的缓存中获取，不是直接从远端
  List<V2TimGroupMemberFullInfo> getGroupMemberList(String groupID) {
    final res = _groupProfile.getGroupMemberList(groupID);
    return res.whereType<V2TimGroupMemberFullInfo>().toList();
  }

  // 获取群主
  // 从SDK的缓存中获取，不是直接从远端
  V2TimGroupMemberFullInfo? getGroupOwner(String groupID) {
    final memeberList = getGroupMemberList(groupID);
    final info = memeberList.firstWhereOrNull((e) => e.isOwner);
    return info;
  }

  // 获取群管理
  // 从SDK的缓存中获取，不是直接从远端
  List<V2TimGroupMemberFullInfo> getGroupAdmin(String groupID) {
    final memeberList = getGroupMemberList(groupID);
    return memeberList.where((e) => e.isAdmin).toList();
  }

  // 获取群信息(列表)
  Future<List<V2TimGroupInfo>> getGroupsInfo(List<String> groupIDs) async {
    if (groupIDs.isEmpty) return [];
    final res = await _manager.getGroupManager().getGroupsInfo(groupIDList: groupIDs);
    if (!res.isOk) return [];
    if (res.data == null || res.data!.isEmpty) return [];
    final success = <V2TimGroupInfo>[];
    for (final e in res.data!) {
      if (e.isOk && e.groupInfo != null) {
        success.add(e.groupInfo!);
      }
    }
    return success;
  }

  // 获取群信息
  Future<V2TimGroupInfo?> getGroupInfo(String groupID) async {
    final success = await getGroupsInfo([groupID]);
    return success.firstOrNull;
  }

  // 设置群信息
  Future<V2TimCallback> setGroupInfo(V2TimGroupInfo info) {
    return _manager.getGroupManager().setGroupInfo(info: info);
  }

  // 设置群成员
  Future<V2TimCallback> setGroupMemberInfo(
    String groupID, {
    required String userID,
    String? nameCard,
    Map<String, String>? customInfo,
  }) {
    return _manager.getGroupManager().setGroupMemberInfo(
          groupID: groupID,
          userID: userID,
          nameCard: nameCard,
          customInfo: customInfo,
        );
  }

  // 设置管理
  // 设置群成员
  Future<V2TimCallback> setGroupMemberRole(
    String groupID, {
    required String userID,
    required GroupMemberRoleTypeEnum role,
  }) {
    return _manager.getGroupManager().setGroupMemberRole(
          groupID: groupID,
          userID: userID,
          role: role,
        );
  }
}
