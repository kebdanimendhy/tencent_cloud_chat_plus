part of 'tencent_cloud_chat_plus_utils.dart';

class _TencentCloudChatPlushNavigatorUtils {
  _TencentCloudChatPlushNavigatorUtils._();

  Future<T?>? toMessageC2C<T extends Object?>(
    String userID, {
    required BuildContext context,
    V2TimMessage? targetMessage,
    String? draftText,
  }) {
    return navigateToMessage<T>(
      context: context,
      options: TencentCloudChatMessageOptions(
        userID: userID,
        targetMessage: targetMessage,
        draftText: draftText,
      ),
    );
  }

  Future<T?>? toMessageGroup<T extends Object?>(
    String groupID, {
    required BuildContext context,
    V2TimMessage? targetMessage,
    String? draftText,
  }) {
    return navigateToMessage<T>(
      context: context,
      options: TencentCloudChatMessageOptions(
        groupID: groupID,
        targetMessage: targetMessage,
        draftText: draftText,
      ),
    );
  }
}
