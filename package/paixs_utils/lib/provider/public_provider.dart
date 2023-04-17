import 'package:flutter/material.dart';

///公共的数据共享
class PublicProvider extends ValueNotifier {
  PublicProvider() : super(null);

  ///是否全屏sheet
  var isFullSheet = false;
  void changeIsFullSheet([bool? v]) {
    if (v == null) {
      isFullSheet = !isFullSheet;
    } else {
      isFullSheet = v;
    }
    notifyListeners();
  }
}
