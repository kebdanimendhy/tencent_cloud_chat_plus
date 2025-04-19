import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_widgets/tencent_cloud_chat_message_item_builders.dart';

import 'message/tencent_cloud_chat_plus_message_custom.dart';

class TencentCloudChatPlusBuilders {
  TencentCloudChatPlusBuilders._();
  static Widget getMessageItemBuilder({
    Key? key,
    required MessageItemBuilderData data,
    required MessageItemBuilderMethods methods,
    bool tryPlusCustom = true,
  }) {
    if (tryPlusCustom) {
      final widget = TencentCloudChatPlusMessageCustom.decodeAndBuild(
        data.message,
        data: data,
        methods: methods,
        key: key,
      );
      if (widget != null) return widget;
    }

    return TencentCloudChatMessageItemBuilders.getMessageItemBuilder(
      key: key,
      data: data,
      methods: methods,
    );
  }

  /// [MessageSummaryGetter]
  static String? getMessageSummary({
    V2TimMessage? message,
    int? messageReceiveOption,
    int? unreadCount,
    String? draftText,
    required bool needStatus,
    bool tryPlusCustom = true,
  }) {
    if (message == null) return null;
    final msg = TencentCloudChatPlusMessageCustom.decode(message);
    if (msg == null) return null;
    return msg.getSummary();
  }
}
