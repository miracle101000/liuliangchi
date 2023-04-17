import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:flutter/material.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';

import 'provider_config.dart';

class GouwucheProvider extends ChangeNotifier {
  ///购物车模型
  var gouwucheDm = DataModel();
  Future<int> getShoppingCartList({bool isLoading = false}) async {
    await Request.post(
      '/app/userGWC/getShoppingCartList',
      data: {"sourceType": "-1", "userId": user['id']},
      isLoading: isLoading,
      catchError: (v) => gouwucheDm.toError(v),
      success: (v) => gouwucheDm.addList(v['result'], true, 0),
    );
    // await Request.post(
    //   '/app/userGWC/getShoppingCartList',
    //   data: {"sourceType": "2", "userId": user['id']},
    //   catchError: (v) => gouwucheDm.toError(v),
    //   success: (v) => gouwucheDm.addList(v['result'], false, 0),
    // );
    _notifyListeners();
    return gouwucheDm.flag!;
  }

  ///添加商品
  Future<void> addGoods(v, String optionId, int count) async {
    var indexWhere = gouwucheDm.list.indexWhere((w) => w['goods']['id'] == '');
    // var indexWhere = gouwucheList.indexWhere((w) => w['id'] == v['id']);
    if (indexWhere == -1) {
      // v['count'] = 1;
      gouwucheDm.list.add({'goods': v, 'count': count});
      this._notifyListeners();

      ///添加到购物车：接口
      await Request.post(
        '/app/userGWC/addShoppingCart',
        data: {
          "sourceType": v['goodsType'],
          "userId": user['id'],
          "goodsId": v['id'],
          "count": count,
          "goodsOptionId": optionId,
        },
        catchError: (msg) {
          gouwucheDm.list.removeWhere((w) => w['goods']['id'] == v['id']);
          this._notifyListeners();
          showCustomToast(msg);
        },
        success: (v) => this.getShoppingCartList(),
      );
    } else {
      gouwucheDm.list[indexWhere]['count'] =
          gouwucheDm.list[indexWhere]['count'] + count;
      this._notifyListeners();

      ///修改购物车：接口
      // await Request.post(
      //   '/app/userGWC/upateShoppingCart',
      //   data: {
      //     "userId": user['id'],
      //     "shoppingCartId": gouwucheDm.list[indexWhere]['id'],
      //     "count": '1',
      //     "operateType": "1",
      //   },
      //   catchError: (msg) {
      //     gouwucheDm.list[indexWhere]['count']--;
      //     this._notifyListeners();
      //     showCustomToast(msg);
      //   },
      //   success: (v) => this.getShoppingCartList(),
      // );
      await Request.post(
        '/app/userGWC/addShoppingCart',
        data: {
          "sourceType": v['goodsType'],
          "userId": user['id'],
          "goodsId": v['id'],
          "count": count,
          "goodsOptionId": optionId,
        },
        catchError: (msg) {
          gouwucheDm.list[indexWhere]['count'] =
              gouwucheDm.list[indexWhere]['count'] - count;
          this._notifyListeners();
          showCustomToast(msg);
        },
        success: (v) => this.getShoppingCartList(),
      );
    }
    gouwucheDm.list
        .map((m) => {'count': m['count'], 'name': m['goods']['title']})
        .forEach((element) {
      flog(element, 'gouwucheListItem');
    });
  }

  ///删除商品
  Future<void> removeGoods(v) async {
    var indexWhere =
        gouwucheDm.list.indexWhere((w) => w['goods']['id'] == v['id']);
    var count = gouwucheDm.list[indexWhere]['count'];
    if (count == 1) {
      var gouwuInfo = gouwucheDm.list[indexWhere];
      gouwucheDm.list.removeAt(indexWhere);
      this._notifyListeners();

      /// 修改购物车商品
      await Request.post(
        '/app/userGWC/deleteShoppingCartMoreGoods',
        data: {
          "userId": user['id'],
          "shoppingCartIds": [gouwuInfo['id']].join(','),
        },
        catchError: (msg) {
          gouwucheDm.list.add(gouwuInfo);
          this._notifyListeners();
          showCustomToast(msg);
        },
        success: (v) => this.getShoppingCartList(),
      );
    } else {
      gouwucheDm.list[indexWhere]['count']--;
      this._notifyListeners();

      /// 修改购物车商品
      await Request.post(
        '/app/userGWC/upateShoppingCart',
        data: {
          "userId": user['id'],
          "shoppingCartId": gouwucheDm.list[indexWhere]['id'],
          "count": '1',
          "operateType": "2",
        },
        catchError: (msg) {
          gouwucheDm.list[indexWhere]['count']++;
          this._notifyListeners();
          showCustomToast(msg);
        },
        success: (v) => this.getShoppingCartList(),
      );
    }
    gouwucheDm.list
        .map((m) => {'count': m['count'], 'name': m['goods']['title']})
        .forEach((element) {
      flog(element, 'gouwucheListItem');
    });
  }

  ///通知刷新
  void _notifyListeners() {
    gouwucheDm.setTime();
    Future(() => notifyListeners());
  }

  ///批量加入购物车
  Future<void> againShoppingCart(orderId, Function fun) async {
    await Request.post(
      '/app/userGWC/againShoppingCart',
      data: {"orderId": orderId},
      isLoading: true,
      catchError: (v) => showCustomToast(v),
      success: (v) async {
        await this.getShoppingCartList(isLoading: true);
        fun();
      },
    );
  }

  ///批量删除商品
  Future<void> clearGoodsList(gouwucheList) async {
    await Request.post(
      '/app/userGWC/deleteShoppingCartMoreGoods',
      data: {
        "userId": user['id'],
        "shoppingCartIds": gouwucheList.join(','),
      },
      isLoading: true,
      catchError: (msg) => showCustomToast(msg),
      success: (v) => this.getShoppingCartList(),
    );
  }

  ///是否编辑
  var isEdit = false;
  void changeisEdit() {
    isEdit = !isEdit;
    Future(() => notifyListeners());
  }
}
