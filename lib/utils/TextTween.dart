import 'package:flutter/animation.dart';

class TextTween extends Tween<String> {
  TextTween({String end = ''}) : super(begin: '', end: end);

  @override
  String lerp(double t) {
    // 在动画过程中 t 的值是从 0 到 1
    var cutoff = (end!.length * t).round();
    // 返回动画时钟t时刻 对应的文字。
    return end!.substring(0, cutoff);
  }
}
