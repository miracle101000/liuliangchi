// ignore_for_file: missing_return

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/my_custom_scroll.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:provider/provider.dart';

import '../../config/common_config.dart';
import '../../paxis_fun.dart';
import '../../provider/app_provider.dart';
import '../../provider/provider_config.dart';
import '../../view/views.dart';
import 'duanxin_page.dart';

///外呼数据
class WaihuShujuPage extends StatefulWidget {
  @override
  _WaihuShujuPageState createState() => _WaihuShujuPageState();
}

class _WaihuShujuPageState extends State<WaihuShujuPage> {
  var isOpen = false;

  var selectoList = [];

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    app.setIsShowHomeMask(false);
    app.setTabIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context,
          title: '外呼数据', isWhiteBg: true, isShowBorder: true),
      body: MyCustomScroll(
        isGengduo: false,
        isShuaxin: true,
        onRefresh: () async {
          return 0;
        },
        onLoading: (p) async {
          return 0;
        },
        noDataView: NoDataWidget(
          '暂无数据',
          isText: true,
          bgColor: sbColor,
        ),
        errorOnTap: () {},
        headers: headers,
        onScrollToList: (b, v) => app.setIsShowHomeMask(b),
        animationType: AnimationType.vertical,
        maskWidget: () => buildMaskView(),
        // maskHeight: 40.0,
        itemModel: DataModel(flag: 2)
          ..list = [1, 2, 3, 1, 1, 1, 1, 2, 3, 1, 1, 1],
        itemModelBuilder: (i, v) {
          return PWidget.container(PWidget.text('$v'), {
            'pd': 24,
          });
        },
      ),
    );
  }

  List<Widget> get headers {
    var container = PWidget.container(null, [1, 40, aColor.withOpacity(0.05)]);
    return [
      PWidget.column([
        PWidget.container(
          PWidget.row([
            PWidget.icon(Icons.person_search),
            PWidget.boxw(4),
            PWidget.text('个人数据'),
            PWidget.spacer(),
            PWidget.row([
              PWidget.text('今天', [pColor]),
              PWidget.boxw(8),
              isOpen ? bottomJtView(12, pi * 1.5) : bottomJtView(12),
            ], {
              'fun': () async {
                setState(() => isOpen = true);
                var res = await showSheet(
                  builder: (_) => ShaixuanPopup(
                    valueList: ['今天', '昨天', '本周', '上周', '本月', '上月'],
                    selectoList: selectoList,
                  ),
                );
                if (res != null) selectoList = res;
                setState(() => isOpen = false);
              },
            }),
          ]),
          [null, null, sbColor],
          {'pd': PFun.lg(8, 8, 16, 16)},
        ),
      ]),
      PWidget.container(
        PWidget.ccolumn([
          PWidget.row([
            buildMenuItem('呼出电话量', company: '个'),
            container,
            buildMenuItem('接通率', company: '%'),
          ]),
          Divider(color: aColor.withOpacity(0.05), height: 40),
          PWidget.row([
            buildMenuItem('通话总时长', company: '秒'),
            container,
            buildMenuItem('平均通话时长', company: '秒'),
          ]),
        ]),
        [null, null, sbColor],
        {
          'mg': PFun.lg(10, 10),
          'pd': PFun.lg(24, 24),
        },
      ),
      buildTabBarView(true),
    ];
  }

  ///遮罩层
  Widget buildMaskView() {
    return Selector<AppProvider, bool>(
      selector: (_, k) => k.isShowHomeMask,
      builder: (_, v, view) {
        return PWidget.positioned(
          buildTabBarView(false, v),
          [v ? 0 : -40, null, 0, 0],
        );
      },
    );
  }

  Selector<AppProvider, int> buildTabBarView(vv, [isEvents = true]) {
    return Selector<AppProvider, int>(
      selector: (_, k) => k.tabIndex,
      builder: (_, v, view) {
        return PWidget.container(
          PWidget.row(
            List.generate(2, (i) {
              return PWidget.column(
                [
                  PWidget.spacer(),
                  PWidget.text(
                    // ['收益', '盈利', '胜率', '回撤', '频次'][i],
                    ['A类意向(0)', 'B类意向(0)'][i],
                    [
                      app.tabIndex == i ? pColor : aColor.withOpacity(0.75),
                      12,
                      app.tabIndex == i
                    ],
                  ),
                  PWidget.spacer(),
                  PWidget.container(null,
                      [80, 2, pColor.withOpacity(app.tabIndex == i ? 1 : 0)])
                ],
                '200',
                {'exp': 1, if (isEvents) 'fun': () => pageFun(i)},
              );
            }),
            '200'.split(''),
          ),
          [null, 40, sbColor],
        );
      },
    );
  }

  ///页面切换
  Future<void> pageFun(i) async {
    app.setIsShowHomeMask(false);
    app.setTabIndex(i);
    // setState(() => shouyeTjList.init());
    // sortField = i + 1;
    // this.getIndexGoodsList(isRef: true, isMove: true, isLoading: true);
    // await this.getGoodsList(isRef: true);
  }

  Widget buildMenuItem(text, {value, company, icon}) {
    return PWidget.row([
      PWidget.boxw(24),
      icon ?? PWidget.icon(Icons.wrong_location),
      PWidget.boxw(12),
      PWidget.column([
        PWidget.text(text, [aColor.withOpacity(0.5), 12]),
        PWidget.boxh(16),
        PWidget.text('', [], {}, [
          PWidget.textIs(value ?? '0', [aColor, 16, true]),
          PWidget.textIs(company ?? '个', [aColor, 12, true]),
        ]),
      ], {
        'exp': 1
      }),
    ], {
      'exp': 1,
    });
  }
}
