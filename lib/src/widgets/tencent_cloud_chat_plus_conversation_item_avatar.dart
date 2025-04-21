import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_conversation/widgets/tencent_cloud_chat_conversation_item.dart';
import 'package:tencent_cloud_chat_plus/src/data/tencent_cloud_chat_plus_data.dart';
import 'package:tencent_cloud_chat_plus/src/extension/tencent_cloud_chat_plus_extension.dart';
import 'package:tencent_cloud_chat_plus/src/utils/tencent_cloud_chat_plus_utils.dart';

/// 对[TencentCloudChatConversationItemAvatar]封装
/// [TencentCloudChatConversationItemAvatar]里面这个原来的这个在线状态是从contact里面获取的,
/// 这里修改为从 [TencentCloudChatPlusUtils.onlineStatus] 获取并监听
class TencentCloudChatPlusConversationItemAvatar extends StatefulWidget {
  final V2TimConversation conversation;

  const TencentCloudChatPlusConversationItemAvatar(this.conversation, {super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends TencentCloudChatState<TencentCloudChatPlusConversationItemAvatar> {
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
    final status = TencentCloudChatPlusUtils.onlineStatus.getUserStatus(widget.conversation.userID);
    _isOnline = status?.isOnline ?? false;
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatConversationItemAvatar(
      conversation: widget.conversation,
      isOnline: _isOnline,
    );
  }
}
