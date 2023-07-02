import 'package:bubble/bubble.dart';
import 'package:chat_message/models/message_model.dart';
import 'package:chat_message/utils/TextTween.dart';
import 'package:chat_message/utils/wechat_date_format.dart';
import 'package:flutter/material.dart';

typedef MessageWidgetBuilder = Widget Function(MessageModel message);
typedef OnBubbleClick = void Function(
    MessageModel message, BuildContext ancestor);

class DefaultMessageWidget extends StatefulWidget {
  final MessageModel message;
  final String? fontFamily;
  final double fontSize;
  final double avatarSize;
  final Color? textColor;
  final Color? backgroundColor;

  final MessageWidgetBuilder? messageWidget;

  final OnBubbleClick? onTap;
  final OnBubbleClick? onPress;

  const DefaultMessageWidget(
      {required GlobalKey key,
      required this.message,
      this.fontFamily,
      this.fontSize = 16,
      this.avatarSize = 40,
      this.textColor,
      this.backgroundColor,
      this.messageWidget,
      this.onTap,
      this.onPress})
      : super(key: key);

  @override
  State<DefaultMessageWidget> createState() => _DefaultMessageWidgetState();
}

class _DefaultMessageWidgetState extends State<DefaultMessageWidget>
    with SingleTickerProviderStateMixin {
  /// 持续时间为10秒的动画控制器
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 888),
  )..forward();

  Widget get _buildCircleAvatar {
    var child = widget.message.avatar is String
        ? ClipOval(
            child: Image.network(
              widget.message.avatar!,
              height: widget.avatarSize,
              width: widget.avatarSize,
            ),
          )
        : CircleAvatar(
            radius: 20,
            child: Text(
              senderInitials,
              style: const TextStyle(fontSize: 16),
            ),
          );
    return child;
  }

  String get senderInitials {
    if (widget.message.ownerName == null) return "";
    List<String> chars = widget.message.ownerName!.split(" ");
    if (chars.length == 1) {
      return chars[0];
    } else {
      return widget.message.ownerName![0];
    }
  }

  double? get contentMargin => widget.avatarSize + 10;

  @override
  Widget build(BuildContext context) {
    if (widget.messageWidget != null) {
      return widget.messageWidget!(widget.message);
    }
    Widget content = widget.message.ownerType == OwnerType.receiver
        ? _buildReceiver(context)
        : _buildSender(context);
    return Column(
      children: [
        if (widget.message.showCreatedTime) _buildCreatedTime(),
        const Padding(padding: EdgeInsets.only(top: 10)),
        content
      ],
    );
  }

  _buildReceiver(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildCircleAvatar,
        Flexible(
            child: Bubble(
          margin: BubbleEdges.fromLTRB(10, 0, contentMargin, 0),
          alignment: Alignment.topLeft,
          stick: true,
          nip: BubbleNip.leftTop,
          color:
              widget.backgroundColor ?? const Color.fromRGBO(233, 233, 252, 19),
          child: _buildContentText(TextAlign.left, context),
        ))
      ],
    );
  }

  _buildSender(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
            child: Bubble(
          margin: BubbleEdges.fromLTRB(contentMargin, 0, 10, 0),
          alignment: Alignment.topRight,
          stick: true,
          nip: BubbleNip.rightTop,
          color: widget.backgroundColor ?? Colors.white,
          child: _buildContentText(TextAlign.left, context),
        )),
        _buildCircleAvatar,
      ],
    );
  }

  _buildContentText(TextAlign align, BuildContext context) {
    late final Animation<String> animation =
        TextTween(end: widget.message.content).animate(_controller);
    return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return InkWell(
            onTap: () => widget.onTap != null
                ? widget.onTap!(widget.message, context)
                : null,
            onLongPress: () => widget.onPress != null
                ? widget.onPress!(widget.message, context)
                : null,
            child: Text(
              widget.message.isLast ? animation.value : widget.message.content,
              textAlign: align,
              style: TextStyle(
                  fontSize: widget.fontSize,
                  color: widget.textColor ?? Colors.black,
                  fontFamily: widget.fontFamily),
            ),
          );
        });
  }

  _buildCreatedTime() {
    String showT =
        WechatDateFormat.format(widget.message.createdAt, dayOnly: false);
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Text(showT),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
