import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_message_options.dart';
import 'package:tencent_cloud_chat_common/data/basic/tencent_cloud_chat_basic_data.dart';
import 'package:tencent_cloud_chat_common/data/contact/tencent_cloud_chat_contact_data.dart';
import 'package:tencent_cloud_chat_common/data/conversation/tencent_cloud_chat_conversation_data.dart';
import 'package:tencent_cloud_chat_common/data/group_profile/tencent_cloud_chat_group_profile_data.dart';
import 'package:tencent_cloud_chat_common/data/message/tencent_cloud_chat_message_data.dart';
import 'package:tencent_cloud_chat_common/eventbus/tencent_cloud_chat_eventbus.dart';
import 'package:tencent_cloud_chat_common/log/tencent_cloud_chat_log.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_navigator.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/error_message_converter.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_contact_add_contacts_info.dart';
import 'package:tencent_cloud_chat_contact/widgets/tencent_cloud_chat_user_profile_body.dart';
import 'package:tencent_cloud_chat_conversation/model/tencent_cloud_chat_conversation_presenter.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_data_tools.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_controller.dart';
import 'package:tencent_cloud_chat_plus/src/data/tencent_cloud_chat_plus_data.dart';

import '../extension/tencent_cloud_chat_plus_extension.dart';
import '../message/tencent_cloud_chat_plus_cache_message_layout.dart';
import '../message/tencent_cloud_chat_plus_message_custom.dart';

part 'tencent_cloud_chat_common_utils.dart';
part 'tencent_cloud_chat_plus_contact_utils.dart';
part 'tencent_cloud_chat_plus_conversation_utils.dart';
part 'tencent_cloud_chat_plus_event_utils.dart';
part 'tencent_cloud_chat_plus_group_utils.dart';
part 'tencent_cloud_chat_plus_message_utils.dart';
part 'tencent_cloud_chat_plush_navigator_utils.dart';
part 'tencent_cloud_chat_online_status_utils.dart';

TencentCloudChat get _instance => TencentCloudChat.instance;
V2TIMManager get _manager => _instance.chatSDKInstance.manager;
V2TIMMessageManager get _messageManager => _manager.getMessageManager();
TencentCloudChatMessageData get _messageData => _instance.dataInstance.messageData;
TencentCloudChatContactData get _contact => _instance.dataInstance.contact;
TencentCloudChatGroupProfileData get _groupProfile => _instance.dataInstance.groupProfile;
TencentCloudChatLog get _log => _instance.logInstance;
void _console(String tag, String log) => _log.console(componentName: tag, logs: log);
void _assertion(String tag, String log) {
  _console(tag, log);
  assert(false, '[$tag]:$log');
}

typedef TencentCloudChatPlusUtilsEventListener<T> = void Function(T event);

final class TencentCloudChatPlusUtils {
  TencentCloudChatPlusUtils._();
  static final navigator = _TencentCloudChatPlushNavigatorUtils._();
  static final conversation = _TencetCloudChatPlusConversationUtils._();
  static final contact = _TencentCloudChatPlusContactUtils._();
  static final message = _TencentCloudChatPlusMessageUtils._();
  static final group = _TencentCloudChatPlusGroupUtils._();
  static final event = _TencentCloudChatPlusEventUtils._();
  static final onlineStatus = _TencentCloudChatOnlineStatusUtils._();
  static final common = _TencentCloudChatCommonUtils._();
}
