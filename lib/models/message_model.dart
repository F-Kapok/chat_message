import 'package:flutter/cupertino.dart';

enum OwnerType { receiver, sender }

OwnerType _of(String name) {
  if (name == OwnerType.receiver.toString()) {
    return OwnerType.receiver;
  } else {
    return OwnerType.sender;
  }
}

class MessageModel {
  final int? id;

  //为了避免添加数据的时候重新刷新问题
  final GlobalKey key;

  //消息发送或接收的标识，用于决定消息展示在哪一侧
  final OwnerType ownerType;
  final String? ownerName;
  final String? avatar;
  final String content;

  //milliseconds since
  final int createdAt;

  //是否展示创建时间
  bool showCreatedTime;

  //是否为最后一条消息
  bool isLast;

  MessageModel(
      {this.id,
      this.ownerName,
      required this.ownerType,
      this.avatar,
      required this.content,
      required this.createdAt,
      this.showCreatedTime = false,
      this.isLast = false})
      : key = GlobalKey();

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
      ownerType: _of(json['ownerType']),
      content: json['content'],
      ownerName: json['ownerName'],
      createdAt: json['createAt'],
      avatar: json['avatar'],
      id: json['id']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "ownerType": ownerType.toString(),
        "content": content,
        "ownerName": ownerName,
        "createAt": createdAt,
        "avatar": avatar,
      };
}
