import 'package:tencent_cloud_chat_common/data/tencent_cloud_chat_data_abstract.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

enum TencentCloudChatPlusDataKeys {
  userStatusList,
}

class TencentCloudChatPlusData<T> extends TencentCloudChatDataAB<T> {
  static const eventName = 'TencentCloudChatPlusData';

  TencentCloudChatPlusData(super.currentUpdatedFields);

  @override
  void clear() {}

  @override
  void notifyListener(T key) {
    currentUpdatedFields = key;
    TencentCloudChat.instance.eventBusInstance.fire(this, eventName);
  }

  @override
  Map<String, dynamic> toJson() => {};
}
