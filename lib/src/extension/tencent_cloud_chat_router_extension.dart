import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_message_options.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_router.dart';

extension TencentCloudChatRouterExt on TencentCloudChatRouter {
  /// see: [TencentCloudChatRouter.getArgumentFromMap]
  T? getArgumentFromRouteArgs<T>(dynamic args, String key) {
    if (args == null || args is! Map) {
      return null;
    }
    Map<String, Object?> argMap = args as Map<String, Object?>;
    return argMap[key] as T?;
  }

  TencentCloudChatMessageOptions? getMessageOptionsFromRouteArgs(dynamic args) =>
      getArgumentFromRouteArgs<TencentCloudChatMessageOptions>(args, 'options');
}
