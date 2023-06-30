import 'package:chat_message/utils/wechat_date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chat_message/chat_message.dart';

void main() {
  test('time test', () {
    debugPrint(WechatDateFormat.format(1987776661234, dayOnly: false));
  });
}
