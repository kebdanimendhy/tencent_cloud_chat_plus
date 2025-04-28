import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';

// double _getSquareSize(double size) => TencentCloudChatScreenAdapter.getSquareSize(size);
double _getWidth(double w) => TencentCloudChatScreenAdapter.getWidth(w);
double _getHeight(double h) => TencentCloudChatScreenAdapter.getHeight(h);

Widget _defaultIconBuilder(BuildContext _, double v) {
  return TencentCloudChatThemeWidget(
    build: (_, colorTheme, textStyle) {
      return Icon(
        Icons.add_circle_outline_rounded,
        size: textStyle.inputAreaIcon,
        color: colorTheme.inputAreaIconColor.withValues(alpha: v),
      );
    },
  );
}

Widget _defaultSendBuilder(BuildContext _, double v) {
  return TencentCloudChatThemeWidget(
    build: (_, colorTheme, textStyle) {
      return Container(
        decoration: BoxDecoration(
          color: colorTheme.inputAreaIconColor.withValues(alpha: v),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: _getWidth(12) * v, vertical: _getHeight(3)),
        alignment: Alignment.center,
        child: Text(
          '发送',
          style: TextStyle(color: Colors.white, fontSize: textStyle.fontsize_14),
        ),
      );
    },
  );
}

class TencentCloudChatPlusWxStyleSendButtonController {
  _State? _state;
  void showSend() => _state?._showSend();
  void showIcon() => _state?._showIcon();
}

class TencentCloudChatPlusWxStyleSendButton extends StatefulWidget {
  // value向1靠近说明正在显示
  final Widget Function(BuildContext context, double value) iconBuilder;
  final Widget Function(BuildContext context, double value) sendBuilder;
  final VoidCallback? onTapIcon;
  final VoidCallback? onTapSend;
  final TencentCloudChatPlusWxStyleSendButtonController? controller;
  const TencentCloudChatPlusWxStyleSendButton({
    super.key,
    this.iconBuilder = _defaultIconBuilder,
    this.sendBuilder = _defaultSendBuilder,
    this.onTapIcon,
    this.onTapSend,
    this.controller,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends TencentCloudChatState<TencentCloudChatPlusWxStyleSendButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animateController;

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
    _animateController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.controller?._state == this) {
      widget.controller?._state = null;
    }
    _animateController.dispose();
  }

  void _showSend() => _animateController.forward();

  void _showIcon() => _animateController.reverse();

  @override
  Widget defaultBuilder(BuildContext context) => AnimatedBuilder(
        animation: _animateController,
        builder: (context, child) {
          final value = _animateController.value;
          return GestureDetector(
            onTap: () {
              if (value == 1) {
                widget.onTapSend?.call();
              } else if (value == 0) {
                widget.onTapIcon?.call();
              } else {
                // 其他时候不能点?
              }
            },
            child: Stack(
              children: [
                Visibility(
                  visible: value != 1,
                  child: widget.iconBuilder(context, 1 - value),
                ),
                Visibility(
                  visible: value != 0,
                  child: widget.sendBuilder(context, value),
                )
              ],
            ),
          );
        },
      );
}
