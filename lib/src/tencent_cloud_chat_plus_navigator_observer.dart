import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_router.dart';

class TencentCloudChatPlusNavigatorObserver extends NavigatorObserver {
  TencentCloudChatPlusNavigatorObserver._();

  static final _instance = TencentCloudChatPlusNavigatorObserver._();

  static TencentCloudChatPlusNavigatorObserver get instance => _instance;

  void Function({required String name, required RouteSettings settings})? _onPush;
  void Function({required String name, required RouteSettings settings})? _onPop;
  void Function({required String name, required RouteSettings? settings})? _onReplace;

  void setHandler({
    void Function({required String name, required RouteSettings settings})? onPush,
    void Function({required String name, required RouteSettings settings})? onPop,
    void Function({required String name, required RouteSettings? settings})? onReplace,
  }) {
    _onPush = onPush ?? _onPush;
    _onPop = onPop ?? _onPop;
    _onReplace = onReplace ?? _onReplace;
  }

  static String? getTencentPageName(Route? route) {
    if (route == null) return null;
    if (route is MaterialPageRoute) {
      for (final MapEntry(:key, :value) in TencentCloudChatRouter().routes.entries) {
        if (route.builder == value) return key;
      }
    }
    return null;
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    if (_onPush == null) return;
    final name = getTencentPageName(route);
    if (name == null) return;
    _onPush!(name: name, settings: route.settings);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    if (_onPop == null) return;
    final name = getTencentPageName(route);
    if (name == null) return;
    _onPop!(name: name, settings: route.settings);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    if (_onReplace == null) return;
    final name = getTencentPageName(oldRoute);
    if (name == null) return;
    _onReplace!(name: name, settings: oldRoute?.settings);
  }
}
