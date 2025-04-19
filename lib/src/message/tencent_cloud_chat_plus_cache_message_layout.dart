import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_layout/tencent_cloud_chat_message_layout.dart';

part 'tencent_cloud_chat_plus_message_data_provider_cache.dart';

///
/// 这里是把 对应的dataProvider缓存，以方便全局查找,替代到处传递
/// 以解决在message页面外发消息的情况
///
class TencentCloudChatPlusCacheMessageLayout extends StatefulWidget {
  final MessageLayoutBuilderWidgets widgets;
  final MessageLayoutBuilderData data;
  final MessageLayoutBuilderMethods methods;
  final Widget Function(BuildContext context, TencentCloudChatMessageLayout layout) builder;

  const TencentCloudChatPlusCacheMessageLayout({
    super.key,
    required this.widgets,
    required this.data,
    required this.methods,
    required this.builder,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends TencentCloudChatState<TencentCloudChatPlusCacheMessageLayout> {
  late final TencentCloudChatMessageSeparateDataProvider _provider;

  @override
  void didChangeDependencies() {
    _provider = TencentCloudChatMessageDataProviderInherited.of(context);
    TencentCloudChatPlusMessageDataProviderCache._add(_provider);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    TencentCloudChatPlusMessageDataProviderCache._del(_provider);
  }

  @override
  Widget defaultBuilder(BuildContext context) => widget.builder(
        context,
        TencentCloudChatMessageLayout(
          widgets: widget.widgets,
          data: widget.data,
          methods: widget.methods,
        ),
      );
}
