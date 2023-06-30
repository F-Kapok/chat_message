import 'dart:async';

import 'package:chat_message/models/message_model.dart';
import 'package:chat_message/widget/default_message_widget.dart';
import 'package:flutter/widgets.dart';

class ChatController implements IChatController {
  //初始化数据
  final List<MessageModel> initialMessageList;
  final ScrollController scrollController;
  final MessageWidgetBuilder? messageWidgetBuilder;

  //展示时间的间隔
  final int timePellet;
  final List<int> pelletShow = [];

  ChatController(
      {required this.timePellet,
      required this.initialMessageList,
      required this.scrollController,
      this.messageWidgetBuilder}) {
    for (var message in initialMessageList.reversed) {
      inflateMessage(message);
    }
  }

  StreamController<List<MessageModel>> messageStreamController =
      StreamController();

  void dispose() {
    messageStreamController.close();
    scrollController.dispose();
  }

  void widgetReady() {
    if (!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
    }
    //有消息滚动到底部
    if (initialMessageList.isNotEmpty) {
      scrollToLastMessage();
    }
  }

  void scrollToLastMessage() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  @override
  void addMessage(MessageModel message) {
    if (messageStreamController.isClosed) return;
    inflateMessage(message);
    //list反转后列是从底部向上展示，所以新来的消息需要插入到数据第0个位置
    initialMessageList.insert(0, message);
    messageStreamController.sink.add(initialMessageList);
    scrollToLastMessage();
  }

  @override
  void loadMoreData(List<MessageModel> messageList) {
    messageList = List.from(messageList.reversed);
    List<MessageModel> tempList = [...initialMessageList, ...messageList];
    for (var message in tempList.reversed) {
      inflateMessage(message);
    }
    initialMessageList.clear();
    initialMessageList.addAll(tempList);
    if (messageStreamController.isClosed) return;
    messageStreamController.sink.add(initialMessageList);
  }

  //设置消息的时间是否展示
  void inflateMessage(MessageModel message) {
    int pellet = (message.createdAt / (timePellet * 1000)).truncate();
    if (!pelletShow.contains(pellet)) {
      pelletShow.add(pellet);
      message.showCreatedTime = true;
    } else {
      message.showCreatedTime = false;
    }
  }
}

abstract class IChatController {
  void addMessage(MessageModel message);

  void loadMoreData(List<MessageModel> messageList);
}
