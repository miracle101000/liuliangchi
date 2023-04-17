import 'package:flutter/material.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:paixs_utils/model/data_model.dart';

import 'provider_config.dart';

class ShouyiPro extends ChangeNotifier {
  ///钱包信息
  var qianbaoDm = DataModel<Map>(object: {});
  Future<void> userWallet() async {
    qianbaoDm.flag = 0;
    qianbaoDm.object = {};
    Future(() => notifyListeners());
    await Request.get(
      '/maxmoneycloud-funds/api/wallet/userWallet',
      data: {'userId': user['id']},
      catchError: (v) => qianbaoDm.toError(v),
      success: (v) {
        qianbaoDm.object = v['data'] ?? {};
        qianbaoDm.setTime();
      },
    );
    Future(() => notifyListeners());
  }

  ///是否显示星号
  bool isShowAsterisk = true;
  void changeIsShowAsterisk() {
    // isShowAsterisk = v;
    isShowAsterisk = !isShowAsterisk;
    notifyListeners();
  }
}
