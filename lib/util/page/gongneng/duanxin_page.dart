import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liuliangchi/util/config/common_config.dart';
import 'package:liuliangchi/util/paxis_fun.dart';
import 'package:liuliangchi/util/view/views.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

///短信群发
class DuanxinPage extends StatefulWidget {
  @override
  _DuanxinPageState createState() => _DuanxinPageState();
}

class _DuanxinPageState extends State<DuanxinPage> {
  var selectoList1 = [];
  var selectoList2 = [];
  var selectoList3 = [];

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: '短信', isWhiteBg: true),
      body: PWidget.column([
        PWidget.container(
          PWidget.row([
            ShaixuanWidget(
              '短信状态',
              valueList: ['全部', '待审核', '审核通过', '审核未通过', '待发送', '发送失败'],
              selectoList: selectoList1,
              fun: (v) => selectoList1 = v,
            ),
            PWidget.container(null, [1, 40, aColor.withOpacity(0.1)]),
            ShaixuanWidget(
              '时间',
              valueList: ['全部', '今天', '昨天', '本周', '上周', '本月', '上月'],
              selectoList: selectoList2,
              fun: (v) => selectoList2 = v,
            ),
            PWidget.container(null, [1, 40, aColor.withOpacity(0.1)]),
            ShaixuanWidget(
              '发信人',
              valueList: ['全部用户', '海涛', '李维', '何林华', '邱婷', '胡君瑶', '罗琨'],
              selectoList: selectoList3,
              fun: (v) => selectoList3 = v,
            ),
          ]),
          [null, null, sbColor],
          {'bd': PFun.bdLg(Colors.black12, 0, 1)},
        ),
        Expanded(child: NoDataWidget('暂无短信数据', isText: true))
      ]),
      btnBar: PWidget.container(
        PWidget.text('发短信', [pColor], {'ct': true}),
        [null, 40, sbColor],
      ),
    );
  }
}

///筛选组建
class ShaixuanWidget extends StatefulWidget {
  final bool isExp;
  final String text;
  final List valueList;
  final List selectoList;
  final Function(List)? fun;

  const ShaixuanWidget(
    this.text, {
    Key? key,
    this.isExp = true,
    this.valueList = const [],
    this.selectoList = const [],
    this.fun,
  }) : super(key: key);
  @override
  _ShaixuanWidgetState createState() => _ShaixuanWidgetState();
}

class _ShaixuanWidgetState extends State<ShaixuanWidget> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return PWidget.container(
      PWidget.row([
        PWidget.boxw(8),
        PWidget.text(widget.text, {'exp': true}),
        isOpen ? bottomJtView(12, pi * 1.5) : bottomJtView(12),
        PWidget.boxw(8),
      ]),
      {
        'exp': widget.isExp,
        'pd': PFun.lg(12, 12, 4, 4),
        'fun': () async {
          setState(() => isOpen = true);
          var res = await showSheet(
              builder: (_) => ShaixuanPopup(
                  selectoList: widget.selectoList,
                  valueList: widget.valueList));
          setState(() => isOpen = false);
          if (res != null) widget.fun!(res);
        },
      },
    );
  }
}

class ShaixuanPopup extends StatefulWidget {
  final List valueList;
  final List selectoList;

  const ShaixuanPopup({
    Key? key,
    this.valueList = const [],
    this.selectoList = const [],
  }) : super(key: key);
  @override
  _ShaixuanPopupState createState() => _ShaixuanPopupState();
}

class _ShaixuanPopupState extends State<ShaixuanPopup> {
  var selectoList = [];

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    selectoList.addAll(widget.selectoList);
  }

  @override
  Widget build(BuildContext context) {
    return PWidget.container(
      MyListView(
        isShuaxin: false,
        padding: EdgeInsets.only(bottom: pmPadd.bottom + 8, top: 16),
        physics: NeverScrollableScrollPhysics(),
        divider: Divider(height: 0, color: aColor.withOpacity(0.1)),
        itemCount: widget.valueList.length,
        listViewType: ListViewType.Separated,
        item: (i) {
          var isDy = selectoList.contains(widget.valueList[i]);
          return PWidget.container(
            PWidget.row([
              PWidget.icon(
                isDy ? Icons.check_circle_rounded : Icons.radio_button_off,
                [isDy ? pColor : aColor.withOpacity(0.1), 16],
              ),
              PWidget.boxw(8),
              PWidget.text(widget.valueList[i], [aColor.withOpacity(0.75)]),
            ]),
            {
              'pd': 12,
              'fun': () async {
                selectoList.clear();
                selectoList.add(widget.valueList[i]);
                flog(selectoList);
                setState(() {});
                close(selectoList);
              },
            },
          );
        },
      ),
      [null, null, Colors.white],
      {'crr': PFun.lg(16 * 3, 16 * 3)},
    );
  }
}
