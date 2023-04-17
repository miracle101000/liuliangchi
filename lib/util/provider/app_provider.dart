import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  ///首页顶部菜单位置
  double topCaidanValue = 0.0;
  void changeTopCaidanValue(v) {
    topCaidanValue = v;
    Future(() => notifyListeners());
  }

  ///底部导航栏索引
  int btmIndex = 0;
  void changeBtmIndex(v) {
    btmIndex = v;
    Future(() {
      notifyListeners();
    });
  }

  ///首页轮播图
  List getImagePlate(plate) =>
      shouyeLunboDm.list.where((w) => w['plate'] == plate).toList();
  var shouyeLunboDm = DataModel(hasNext: false);
  Future<int> getRecommendImage(int plate) async {
    await Request.post(
      '/app/common/getRecommendImage',
      data: {"plate": "-1"},
      isToken: false,
      catchError: (v) => shouyeLunboDm.toError(v),
      success: (v) => shouyeLunboDm.addList(v['result'], true, 0),
    );
    notifyListeners();
    return shouyeLunboDm.flag!;
  }

  ///首页pageview控制器
  var pageCon = PageController();

  // app包信息
  PackageInfo? packageInfo;

  ///安卓设备信息
  AndroidDeviceInfo? androidInfo;

  ///是否显示首页遮罩
  bool isShowHomeMask = false;
  void setIsShowHomeMask(v) {
    isShowHomeMask = v;
    Future(() => notifyListeners());
  }

  ///首页tab切换控制
  var tabIndex = 0;
  void setTabIndex(v) {
    tabIndex = v;
    notifyListeners();
  }

  ///获取帐号历史
  List<String> zhanghaoList = [];
  Future getZhanghaoList() async {
    var sp = await SharedPreferences.getInstance();
    var info = sp.getStringList('zhanghaoList');
    if (info == null) {
      return;
    }
    zhanghaoList = info;
  }

  ///添加账号
  Future<bool> addZhanghaoListItem([data]) async {
    var sp = await SharedPreferences.getInstance();
    if (data != null) {
      if (zhanghaoList.contains(data)) {
        zhanghaoList.remove(data);
        zhanghaoList.insert(0, data);
      } else {
        zhanghaoList.insert(0, data);
      }
    }
    var info = sp.setStringList('zhanghaoList', zhanghaoList);
    return info;
  }

  var isShowZhanghaoList = false;
  void changeisShowZhanghaoList(v) {
    isShowZhanghaoList = v;
    Future(() => notifyListeners());
  }

  ///是否已经跳转登录到
  bool isJumpLogin = false;
}
