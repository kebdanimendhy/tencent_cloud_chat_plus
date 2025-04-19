import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';

typedef TencentCloudChatPlusMessageCustomDecoder = TencentCloudChatPlusMessageCustom Function(dynamic json);
typedef TencentCloudChatPlusMessageCustomBuilder = Widget? Function({
  required TencentCloudChatPlusMessageCustom message,
  required MessageItemBuilderMethods methods,
  required MessageItemBuilderData data,
  Key? key,
});

class _Pair {
  final TencentCloudChatPlusMessageCustomDecoder decoder;
  final TencentCloudChatPlusMessageCustomBuilder builder;
  _Pair(this.decoder, this.builder);
}

abstract class TencentCloudChatPlusMessageCustom {
  // 允许自定义
  static String businessIdKey = 'businessId';
  static final _messages = <String, _Pair>{};

  String getSummary();
  String? getPushDesc() => null;
  String? getPushExtenstion() => null;

  final String businessId;

  TencentCloudChatPlusMessageCustom({required this.businessId});
  TencentCloudChatPlusMessageCustom.fromJson(Map<String, dynamic> json) : businessId = json[businessIdKey];

  @mustCallSuper
  Map<String, dynamic> toJson() => {businessIdKey: businessId};

  static void register(
    String businessId, {
    required TencentCloudChatPlusMessageCustomDecoder decoder,
    required TencentCloudChatPlusMessageCustomBuilder builder,
  }) {
    _messages[businessId] = _Pair(decoder, builder);
  }

  static T? getBusinessIdFromJson<T>(dynamic json) {
    if (json is! Map) return null;
    return json[businessIdKey] as T?;
  }

  static TencentCloudChatPlusMessageCustom? decode<T>(V2TimMessage message) {
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM &&
        message.customElem != null &&
        message.customElem!.data != null) {
      final data = message.customElem!.data!;
      try {
        final jsonData = json.decode(data);
        final businessId = getBusinessIdFromJson(jsonData);
        if (businessId == null) return null;
        final pair = _messages[businessId];
        if (pair == null) {
          assert(false, 'businessId:$businessId no decoder');
          return null;
        }
        return pair.decoder(jsonData);
      } catch (err) {
        //err
      }
    }
    return null;
  }

  static Widget? decodeAndBuild(
    V2TimMessage message, {
    Key? key,
    required MessageItemBuilderData data,
    required MessageItemBuilderMethods methods,
  }) {
    final msg = decode(message);
    if (msg == null) return null;
    final pair = _messages[msg.businessId];
    if (pair == null) return null;
    return pair.builder(
      key: key,
      message: msg,
      data: data,
      methods: methods,
    );
  }
}
