import 'package:flutter/material.dart';
import 'package:liuliangchi/util/paxis_fun.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../config/common_config.dart';
import '../../view/views.dart';
import 'add_daiban.dart';

class DaibanChild extends StatefulWidget {
  @override
  _DaibanChildState createState() => _DaibanChildState();
}

class _DaibanChildState extends State<DaibanChild> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: MyListView(
        isShuaxin: false,
        item: (i) => item[i],
        itemCount: item.length,
        padding: EdgeInsets.all(16),
        divider: Divider(color: Colors.transparent),
        listViewType: ListViewType.Separated,
      ),
    );
  }

  var itemList = [
    {'text': '客户', 'value': '0'},
    {'text': '商机', 'value': '0'},
    {'text': '合同', 'value': '0'},
    {'text': '报告', 'value': '0'},
  ];

  List<Widget> get item {
    return [
      PWidget.container(
        PWidget.column([
          PWidget.text('审批事项', {'pd': 16}),
          Divider(height: 0, color: aColor.withOpacity(0.25)),
          Wrap(
            children: List.generate(itemList.length, (i) {
              var item = itemList[i];
              // flog(item);
              var width = (pmSize.width - 32) / 3;
              return PWidget.container(
                PWidget.column([
                  PWidget.text(item['value'], [aColor.withOpacity(0.5)]),
                  PWidget.boxh(8),
                  PWidget.text(item['text'], [aColor.withOpacity(0.5), 12]),
                ], '221'),
                [width, null, sbColor],
                {
                  'pd': PFun.lg(16, 16),
                  'bd': PFun.bdLg(
                      aColor.withOpacity(0.05),
                      0,
                      itemList.length <= 3 ? 0 : 1,
                      0,
                      (i + 1) % 3 == 0 ? 0 : 1),
                  if (item['fun'] != null) 'fun': item['fun']
                },
              );
            }),
          ),
        ]),
        [null, null, sbColor],
        {'br': 8},
      ),
      PWidget.container(
        PWidget.column([
          PWidget.text('审批事项', {'pd': 16, 'fun': () => jumpPage(AddDaiban())}),
          Divider(height: 0, color: aColor.withOpacity(0.25)),
          TableCalendar(
            locale: 'zh_CH',
            focusedDay: DateTime.now(),
            firstDay: DateTime.now()..subtract(Duration(days: 10)),
            lastDay: DateTime.now()..add(Duration(days: 10)),
          ),
          NoDataWidget('暂无数据', height: 56, isText: true)
        ]),
        [null, null, sbColor],
        {'br': 8},
      ),
    ];
  }
}
