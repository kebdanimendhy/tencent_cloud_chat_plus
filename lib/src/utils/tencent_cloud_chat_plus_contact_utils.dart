part of 'tencent_cloud_chat_plus_utils.dart';

class _TencentCloudChatPlusContactUtils {
  _TencentCloudChatPlusContactUtils._();

  final sdk = TencentCloudChat.instance.chatSDKInstance.contactSDK;

  /// 获取好友信息
  V2TimFriendInfo? getFriendInfo(String? userID) =>
      _contact.contactList.firstWhereOrNull((e) => e.userID == userID);

  /// 添加好友
  /// see: [TencentCloudChatContactAddContactsInfoBodyState.sendAddFriendApplication]
  /// https://comm.qq.com/im/doc/flutter/zh/SDKAPI/Api/V2TIMFriendshipManager/addFriend.html
  Future<V2TimFriendOperationResult?> addFriend(
    String? userID, {
    String? remark,
    String? friendGroup,
    String? verification,
    String addSource = 'flutter',
    FriendTypeEnum friendType = FriendTypeEnum.V2TIM_FRIEND_TYPE_SINGLE,
  }) async {
    if (TencentCloudChatUtils.checkString(userID) == null) return null;
    final res = await sdk.addFriend(userID!, remark, friendGroup, verification, addSource, friendType);

    // if (res.data?.resultCode == 30015) { // 已是好友?
    //   return true;
    // }
    if (!res.isOk) return null;
    return res.data;
  }

  /// 删除好友
  /// see: [TencentCloudChatUserProfileDeleteButtonState.onDeleteContact]
  /// https://comm.qq.com/im/doc/flutter/zh/SDKAPI/Api/V2TIMFriendshipManager/deleteFromFriendList.html
  Future<List<V2TimFriendOperationResult>> deleteFriends(List<String?> userIDs,
      {FriendTypeEnum friendType = FriendTypeEnum.V2TIM_FRIEND_TYPE_SINGLE}) async {
    final ids = userIDs.where((e) => TencentCloudChatUtils.checkString(e) != null).cast<String>().toList();
    if (userIDs.isEmpty) return [];
    var res = await sdk.deleteFromFriendList(ids, friendType);
    if (!res.isOk) return [];
    return res.data ?? [];
  }

  // 删除好友
  Future<V2TimFriendOperationResult?> deleteFriend(String? userID,
      {FriendTypeEnum friendType = FriendTypeEnum.V2TIM_FRIEND_TYPE_SINGLE}) async {
    final success = await deleteFriends([userID]);
    return success.firstOrNull;
  }

  // 修改好友信息
  // https://comm.qq.com/im/doc/flutter/zh/SDKAPI/Api/V2TIMFriendshipManager/setFriendInfo.html
  Future<V2TimCallback?> setFriendInfo(String? userID,
      {String? friendRemark, Map<String, String>? customInfo}) async {
    if (TencentCloudChatUtils.checkString(userID) == null) return null;
    return sdk.setFriendInfo(userID: userID!, friendRemark: friendRemark, customInfo: customInfo);
  }

  // 修改备注
  Future<V2TimCallback?> setFriendRemark(String? userID, String friendRemark) =>
      setFriendInfo(userID, friendRemark: friendRemark);
}
