import 'package:flutter/material.dart';
import 'package:liuliangchi/util/config/common_config.dart';
import 'package:liuliangchi/util/paxis_fun.dart';
import 'package:liuliangchi/util/view/views.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import 'wode/setup_page.dart';

///我的页面
class WodePage extends StatefulWidget {
  @override
  _WodePageState createState() => _WodePageState();
}

class _WodePageState extends State<WodePage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar:
          buildTitle(context, title: '我', isNoShowLeft: true, isWhiteBg: true),
      body: MyListView(
        isShuaxin: false,
        flag: false,
        item: (i) => item[i],
        itemCount: item.length,
        padding: EdgeInsets.all(16),
        touchBottomAnimationOpacity: 50,
      ),
    );
  }

  var itemList = ['客服电话', '更新日志', '关于', '法律与合规', '设置', '切换极速版APP'];

  List<Widget> get item {
    return [
      PWidget.row([
        PWidget.container(
          PWidget.text('测试', [Colors.white, 20, true]),
          [80, 80, Colors.blueGrey.withOpacity(0.5)],
          {'br': 80, 'ali': PFun.lg(0, 0)},
        ),
        PWidget.boxw(16),
        PWidget.column([
          PWidget.text('测试', [Colors.black, 16]),
          PWidget.boxh(12),
          PWidget.text('', [], {}, [
            PWidget.textIs('公司：', [Colors.black.withOpacity(0.4), 12]),
            PWidget.textIs('测试', [Colors.black, 12]),
          ]),
          PWidget.boxh(8),
          PWidget.text('', [], {}, [
            PWidget.textIs('部门：', [Colors.black.withOpacity(0.4), 12]),
            PWidget.textIs('测试', [Colors.black, 12]),
          ]),
          PWidget.boxh(8),
          PWidget.text('', [], {}, [
            PWidget.textIs('角色：', [Colors.black.withOpacity(0.4), 12]),
            PWidget.textIs('测试', [Colors.black, 12]),
          ]),
        ]),
      ]),
      PWidget.boxh(16),
      PWidget.row([
        huiyuanCard([
          'CRM【专业版】',
          '试用',
          '总工号',
          '到期时间',
          '即将到期',
          '5',
          DateTime.now().toString().split(' ').first
        ]),
        PWidget.boxw(8),
        huiyuanCard([
          '搜客宝【高级数据版】',
          '试用',
          '流量额度',
          '到期时间',
          '即将到期',
          '30/30',
          DateTime.now().toString().split(' ').first
        ]),
      ]),
      PWidget.boxh(8),
      ...List.generate(itemList.length, (i) {
        return PWidget.container(
          PWidget.row([
            PWidget.icon(Icons.ac_unit_rounded, [Colors.blue]),
            PWidget.boxw(8),
            PWidget.text(itemList[i], [aColor], {'exp': true}),
            rightJtView(),
          ]),
          {
            'pd': PFun.lg(16, 16, 8, 8),
            if (i != itemList.length - 1)
              'bd': PFun.bdLg(aColor.withOpacity(0.05), 0, 1),
            'fun': () => itemFun(itemList[i])
          },
        );
      }),
    ];
  }

  void itemFun(name) {
    switch (name) {
      case '客服电话':
        break;
      case '更新日志':
        break;
      case '关于':
        break;
      case '法律与合规':
        break;
      case '设置':
        jumpPage(SetupPage());
        break;
      case '切换极速版APP':
        break;
    }
  }

  ///会员卡片
  Widget huiyuanCard(list) {
    return PWidget.container(
      PWidget.column([
        PWidget.row([
          PWidget.text(list[0], [aColor, 12], {'exp': true}),
          PWidget.container(
            PWidget.text(list[1], [Color(0xff795923), 10]),
            [null, null, Color(0xffD1B38E)],
            {'br': 4, 'pd': PFun.lg(2, 2, 4, 4)},
          ),
        ]),
        PWidget.boxh(8),
        PWidget.row([
          PWidget.text(list[2], [Color(0xff9F8B6B), 10], {'exp': true}),
          PWidget.text(list[3], [Color(0xff9F8B6B), 10]),
          PWidget.boxw(16),
          PWidget.text(list[4], [Colors.red, 10])
        ]),
        PWidget.boxh(8),
        PWidget.row([
          PWidget.text(list[5], [Color(0xff9F8B6B)], {'exp': true}),
          PWidget.text(list[6], [Color(0xff9F8B6B)]),
          // PWidget.boxw(12),
        ]),
      ]),
      [null, null, Color(0xffFCF1D9)],
      {'exp': true, 'pd': PFun.lg(12, 12, 8, 8), 'br': 24, 'ph': true},
    );
  }
}
