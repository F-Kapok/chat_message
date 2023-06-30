import 'package:bubble/bubble.dart';
import 'package:chat_message/models/message_model.dart';
import 'package:chat_message/utils/wechat_date_format.dart';
import 'package:flutter/material.dart';

typedef MessageWidgetBuilder = Widget Function(MessageModel message);
typedef OnBubbleClick = void Function(
    MessageModel message, BuildContext ancestor);

class DefaultMessageWidget extends StatelessWidget {
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

  Widget get _buildCircleAvatar {
    var child = message.avatar is String
        ? ClipOval(
            child: Image.network(
              message.avatar!,
              height: avatarSize,
              width: avatarSize,
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
    if (message.ownerName == null) return "";
    List<String> chars = message.ownerName!.split(" ");
    if (chars.length == 1) {
      return chars[0];
    } else {
      return message.ownerName![0];
    }
  }

  double? get contentMargin => avatarSize + 10;

  @override
  Widget build(BuildContext context) {
    if (messageWidget != null) return messageWidget!(message);
    Widget content = message.ownerType == OwnerType.receiver
        ? _buildReceiver(context)
        : _buildSender(context);
    return Column(
      children: [
        if (message.showCreatedTime) _buildCreatedTime(),
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
          color: backgroundColor ?? const Color.fromRGBO(233, 233, 252, 19),
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
          color: backgroundColor ?? Colors.white,
          child: _buildContentText(TextAlign.left, context),
        )),
        _buildCircleAvatar,
      ],
    );
  }

  _buildContentText(TextAlign align, BuildContext context) {
    return InkWell(
      onTap: () => onTap != null ? onTap!(message, context) : null,
      onLongPress: () => onPress != null ? onPress!(message, context) : null,
      child: Text(
        message.content,
        textAlign: align,
        style: TextStyle(
            fontSize: fontSize,
            color: textColor ?? Colors.black,
            fontFamily: fontFamily),
      ),
    );
  }

  _buildCreatedTime() {
    String showT = WechatDateFormat.format(message.createdAt, dayOnly: false);
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Text(showT),
    );
  }
}
