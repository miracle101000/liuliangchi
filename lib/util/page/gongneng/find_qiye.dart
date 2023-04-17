import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liuliangchi/util/paxis_fun.dart';
import 'package:liuliangchi/util/view/views.dart';
import 'package:liuliangchi/util/widget/tab_widget.dart';

import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import '../../config/common_config.dart';

///找企业
class FindQiye extends StatefulWidget {
  @override
  _FindQiyeState createState() => _FindQiyeState();
}

class _FindQiyeState extends State<FindQiye> {
  ///菜单
  var tabList = [
    {'text': '附近客户'},
    {'text': '拜访签到'},
    {'text': '跟进记录'},
    {'text': '工作报告'},
    {'text': '费用报销'},
    {'text': '知识库'},
    {'text': '名片扫描'},
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: '找企业', isWhiteBg: true),
      body: MyListView(
        isShuaxin: false,
        item: (i) => item[i],
        itemCount: item.length,
        padding: EdgeInsets.all(12),
        listViewType: ListViewType.Separated,
      ),
    );
  }

  List<Widget> get item {
    return [
      PWidget.container(
        PWidget.column([
          PWidget.container(
            buildTFView(
              context,
              hintText: '请输入任意关键字，以空格隔开',
            ),
            [null, 40, Colors.white],
            {'mg': PFun.lg(0, 20, 12, 12), 'br': 4, 'pd': PFun.lg(0, 0, 8, 8)},
          ),
        ], '011'),
        [null, 124, Colors.deepOrange],
        {'br': 8},
      ),
      buildItem(tabList),
      buildTuijian(),
    ];
  }

  Widget buildItem(list) {
    return PWidget.container(
      Wrap(
        children: List.generate(list.length, (i) {
          var item = list[i];
          var wh = (pmSize.width - 24) / 5;
          return PWidget.container(
            PWidget.column([
              PWidget.icon(
                Icons.add_reaction_rounded,
                [Colors.primaries[Random().nextInt(Colors.primaries.length)]],
              ),
              PWidget.boxh(8),
              PWidget.text(item['text'], [aColor.withOpacity(0.75), 12]),
            ], '221'),
            [wh, wh],
            // {if (item['fun'] != null) 'fun': item['fun']},
            {
              'fun': () => jumpPage(FindQiyePage(
                  i, tabList.map<String>((m) => m['text']!).toList()))
            },
          );
        }),
      ),
      {'pd': PFun.lg(8, 8)},
    );
  }

  Widget buildTuijian() {
    return PWidget.container(
      PWidget.column([
        PWidget.text('为你推荐', {'pd': 12}),
      ]),
      [null, null, sbColor],
      {'crr': 8},
    );
  }
}

///找企业
class FindQiyePage extends StatefulWidget {
  final List<String> tabList;
  final int index;

  const FindQiyePage(this.index, this.tabList, {Key? key}) : super(key: key);
  @override
  _FindQiyePageState createState() => _FindQiyePageState();
}

class _FindQiyePageState extends State<FindQiyePage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: '找企业', isWhiteBg: true),
      body: TabWidget(
        tabList: widget.tabList,
        page: widget.index,
        tabPage: List.generate(widget.tabList.length, (i) {
          return FindQiyeChild();
        }),
      ),
    );
  }
}

///找企业子页面
class FindQiyeChild extends StatefulWidget {
  @override
  _FindQiyeChildState createState() => _FindQiyeChildState();
}

class _FindQiyeChildState extends State<FindQiyeChild> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: PWidget.container(
        PWidget.container(
          buildTFView(
            context,
            hintText: '请输入任意关键字，以空格隔开',
          ),
          [null, 40, sbColor],
          {'pd': 8, 'br': 4, 'bd': PFun.bdAllLg(Colors.black12), 'mg': 8},
        ),
        [null, null, sbColor],
      ),
    );
  }
}
