import 'package:chat_message/core/chat_controller.dart';
import 'package:chat_message/models/message_model.dart';
import 'package:chat_message/widget/default_message_widget.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  final ChatController chatController;
  final EdgeInsetsGeometry? padding;

  final OnBubbleClick? onTap;
  final OnBubbleClick? onPress;

  const ChatList(
      {super.key,
      required this.chatController,
      this.padding,
      this.onTap,
      this.onPress});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  ChatController get chatController => widget.chatController;

  MessageWidgetBuilder? get messageWidgetBuilder =>
      chatController.messageWidgetBuilder;

  ScrollController get scrollerController => chatController.scrollController;

  Widget get _chatStreamBuilder => StreamBuilder<List<MessageModel>>(
      stream: chatController.messageStreamController.stream,
      builder:
          (BuildContext context, AsyncSnapshot<List<MessageModel>> snapshot) {
        return snapshot.connectionState == ConnectionState.active
            ? ListView.builder(
                shrinkWrap: true,
                reverse: true,
                padding: widget.padding,
                controller: scrollerController,
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  var model = snapshot.data![index];
                  return DefaultMessageWidget(
                    key: model.key,
                    message: model,
                    duration: Duration(milliseconds: model.content.length * 80),
                    onTap: widget.onTap,
                    onPress: widget.onPress,
                    messageWidget: messageWidgetBuilder,
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: _chatStreamBuilder,
    );
  }

  @override
  void initState() {
    super.initState();
    chatController.widgetReady();
  }

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }
}
