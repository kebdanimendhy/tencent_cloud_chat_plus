import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_header/tencent_cloud_chat_message_header_info.dart';
import 'package:tencent_cloud_chat_plus/src/data/tencent_cloud_chat_plus_data.dart';
import 'package:tencent_cloud_chat_plus/src/extension/tencent_cloud_chat_plus_extension.dart';
import 'package:tencent_cloud_chat_plus/src/utils/tencent_cloud_chat_plus_utils.dart';

/// 对[TencentCloudChatMessageHeaderInfo]封装
/// [TencentCloudChatMessageHeaderInfo]里面这个原来的这个在线状态是从contact里面获取的,
/// 这里修改为从 [TencentCloudChatPlusUtils.onlineStatus] 获取并监听
class TencentCloudChatPlusMessageHeaderInfo extends StatefulWidget {
  final List<V2TimGroupMemberFullInfo> Function() getGroupMembersInfo;
  final String? userID;
  final String? groupID;
  final V2TimConversation? conversation;

  const TencentCloudChatPlusMessageHeaderInfo({
    super.key,
    required this.getGroupMembersInfo,
    this.userID,
    this.groupID,
    this.conversation,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends TencentCloudChatState<TencentCloudChatPlusMessageHeaderInfo> {
  late bool _isOnline;
  late final StreamSubscription _subs;

  @override
  void initState() {
    _resetOnline();
    _subs = TencentCloudChatPlusUtils.event.listenPlus(
      (e) {
        safeSetState(() {
          _resetOnline();
        });
      },
      test: (e) {
        return e.currentUpdatedFields == TencentCloudChatPlusDataKeys.userStatusList;
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _subs.cancel();
    super.dispose();
  }

  void _resetOnline() {
    final status = TencentCloudChatPlusUtils.onlineStatus.getUserStatus(widget.userID);
    _isOnline = status?.isOnline ?? false;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatMessageHeaderInfo(
      conversation: widget.conversation,
      userID: widget.userID,
      groupID: widget.groupID,
      showName:
          TencentCloudChatUtils.checkString(widget.conversation?.showName) ?? widget.userID ?? tL10n.chat,
      showUserOnlineStatus:
          TencentCloudChat.instance.dataInstance.basic.userConfig.useUserOnlineStatus ?? true,
      getUserOnlineStatus: ({required userID}) {
        return _isOnline;
      },
      getGroupMembersInfo: widget.getGroupMembersInfo,
    );
  }
}
