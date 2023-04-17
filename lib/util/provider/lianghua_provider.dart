import 'package:flutter/material.dart';

class LianghuaPro extends ChangeNotifier {
  ///添加合约时预计使用的slider值
  List addHeyueSliderValue = [0.0, 0.0];
  void changeaddHeyueSliderValue(v1, v2) {
    addHeyueSliderValue = [v1, v2];
    notifyListeners();
  }

  ///执行量化方案的标记
  List startLianghuaFlags = [];
  void changeStartLianghuaFlag(int v) {
    if (v == 0) {
      startLianghuaFlags.clear();
    } else {
      startLianghuaFlags.add(v);
    }
    Future(() => notifyListeners());
  }

  ///量化默认查询状态
  var lianghuaStatus = 20;

  ///策略默认查询状态
  var celueStatus = 20;
}
