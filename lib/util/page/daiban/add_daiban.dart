import 'package:flutter/material.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import '../../config/common_config.dart';
import '../../view/views.dart';
import '../../widget/date_picker.dart';

///新增代办
class AddDaiban extends StatefulWidget {
  @override
  _AddDaibanState createState() => _AddDaibanState();
}

class _AddDaibanState extends State<AddDaiban> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: '新建任务', isWhiteBg: true),
      body: MyListView(
        isShuaxin: false,
        item: (i) => item[i],
        itemCount: item.length,
        listViewType: ListViewType.Separated,
        divider: Divider(height: 8, color: Colors.transparent),
      ),
    );
  }

  var itemList = [
    {'text': '关联业务'},
    {'text': '开始时间'},
    {'text': '提醒时间'},
    {'text': '参与人'},
    {'text': '重复任务'},
  ];

  List<Widget> get item {
    return [
      PWidget.container(
        PWidget.column([
          buildTFView(context,
              hintText: '任务内容',
              height: 120,
              maxLines: 80,
              padding: EdgeInsets.all(8)),
          PWidget.icon(
            Icons.photo_outlined,
            [aColor.withOpacity(0.25)],
            {'pd': 8},
          ),
        ]),
        [null, null, sbColor],
        {'pd': 8},
      ),
      PWidget.container(
        MyListView(
          isShuaxin: false,
          itemCount: itemList.length,
          physics: NeverScrollableScrollPhysics(),
          listViewType: ListViewType.Separated,
          divider: Divider(height: 24),
          item: (i) {
            var item = itemList[i];
            return PWidget.row([
              PWidget.column([
                PWidget.text(item['text'], [aColor.withOpacity(0.5), 12]),
                PWidget.boxh(8),
                PWidget.text('请选择', [aColor.withOpacity(0.5), 12]),
              ], {
                'exp': 1,
              }),
              rightJtView(),
            ], {
              'fun': () {
                switch (item['text']) {
                  case "关联业务":
                    break;
                  case "开始时间":
                    DatePicker.showDatePicker(context);
                    break;
                  case "提醒时间":
                    break;
                  case "参与人":
                    break;
                  case "重复任务":
                    break;
                }
              },
            });
          },
        ),
        [null, null, sbColor],
        {'pd': 16},
      ),
    ];
  }
}
