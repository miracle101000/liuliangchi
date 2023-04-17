import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/page/gongneng/duanxin_page.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import '../config/common_config.dart';
import '../paxis_fun.dart';
import 'gongneng/chanpin/chanpin_page.dart';
import 'gongneng/find_qiye.dart';
import 'gongneng/page_model/page_model.dart';
import 'gongneng/waihu_shuju_page.dart';

///功能页面
class GongnengPage extends StatefulWidget {
  @override
  _GongnengPageState createState() => _GongnengPageState();
}

class _GongnengPageState extends State<GongnengPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar:
          buildTitle(context, title: '功能', isWhiteBg: true, isNoShowLeft: true),
      body: MyListView(
        isShuaxin: false,
        item: (i) => item[i],
        itemCount: item.length,
        listViewType: ListViewType.Separated,
        padding: EdgeInsets.all(16),
        divider: Divider(height: 16, color: Colors.transparent),
      ),
    );
  }

  ///找客户
  var findKehuList = [
    {
      'text': '找企业',
      'fun': () => jumpPage(FindQiye()),
    },
    // {'text': '地图获客'},
  ];

  ///筛客户
  List get selectoKehuList => [
        {'text': '短信群发', 'fun': () => jumpPage(DuanxinPage())},
        {'text': '社交推广'},
        // {'text': '智能外呼', 'fun': () => jumpPage(WaihuPage())},
        // {'text': '外呼数据', 'fun': () => jumpPage(WaihuShujuPage())},
      ];

  ///管客户
  var adminKehuList = [
    {'text': '线索', 'fun': () => jumpPage(PageModel('线索'))},
    {'text': '客户', 'fun': () => jumpPage(PageModel('客户'))},
    {'text': '商机', 'fun': () => jumpPage(PageModel('商机'))},
    {'text': '合同', 'fun': () => jumpPage(PageModel('合同'))},
    {'text': '线索池', 'fun': () => jumpPage(PageModel('线索池'))},
    {'text': '客户公海', 'fun': () => showCustomToast('开发中')},
    {'text': '联系人', 'fun': () => showCustomToast('开发中')},
    {'text': '回款记录', 'fun': () => jumpPage(PageModel('回款记录'))},
    {'text': '产品', 'fun': () => jumpPage(ChanpinPage())},
  ];

  ///销售支持
  var salesSupportList = [
    // {'text': '附近客户'},
    {'text': '拜访签到'},
    {'text': '跟进记录'},
    {'text': '工作报告'},
    {'text': '费用报销'},
    {'text': '知识库'},
    {'text': '名片扫描'},
  ];

  List<Widget> get item {
    return [
      buildItem('找客户', findKehuList),
      buildItem('筛客户', selectoKehuList),
      buildItem('管客户', adminKehuList),
      buildItem('销售支持', salesSupportList),
    ];
  }

  Widget buildItem(text, List list) {
    return PWidget.container(
      PWidget.column([
        PWidget.text(text, {'pd': 12}),
        Divider(height: 0, thickness: 0.75, color: aColor.withOpacity(0.05)),
        Wrap(
          children: List.generate(list.length, (i) {
            var item = list[i];
            // flog(item);
            var wh = (pmSize.width - 32) / 4;
            return PWidget.container(
              PWidget.column([
                // PWidget.icon(
                //   Icons.add_reaction_rounded,
                //   [Colors.primaries[Random().nextInt(Colors.primaries.length)]],
                // ),
                if (!['智能外呼', '外呼数据'].contains(item['text']))
                  PWidget.image('assets/$text/${item['text']}.png'),
                PWidget.boxh(8),
                PWidget.text(item['text'], [aColor.withOpacity(0.75), 12]),
              ], '221'),
              [wh, wh, sbColor],
              {
                'bd': PFun.bdLg(aColor.withOpacity(0.05), 0,
                    list.length <= 4 ? 0 : 1, 0, (i + 1) % 4 == 0 ? 0 : 1),
                if (item['fun'] != null) 'fun': item['fun']
              },
            );
          }),
        ),
      ]),
      [null, null, sbColor],
      {'crr': 32},
    );
  }
}
