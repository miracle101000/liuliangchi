import 'dart:math';
import 'package:flutter/material.dart';
import 'package:liuliangchi/util/config/common_config.dart';
import 'package:liuliangchi/util/paxis_fun.dart';
import 'package:liuliangchi/util/view/views.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

///外呼计划
class WaihuPage extends StatefulWidget {
  @override
  _WaihuPageState createState() => _WaihuPageState();
}

class _WaihuPageState extends State<WaihuPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: '外呼计划', isWhiteBg: true),
      body: PWidget.column([
        WaihuShaixuanWidget(),
        Expanded(child: NoDataWidget('暂无数据', isText: true)),
      ]),
    );
  }
}

///外呼计划筛选组建
class WaihuShaixuanWidget extends StatefulWidget {
  @override
  _WaihuShaixuanWidgetState createState() => _WaihuShaixuanWidgetState();
}

class _WaihuShaixuanWidgetState extends State<WaihuShaixuanWidget> {
  bool isExpanded = false;

  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return PWidget.column([
      PWidget.container(
        PWidget.row([
          PWidget.row([
            PWidget.text('全部'),
            PWidget.boxw(4),
            isOpen ? bottomJtView(12, pi * 1.5) : bottomJtView(12),
          ], {
            'fun': () async {
              setState(() => isOpen = true);
              await showSheet(builder: (_) => WeihuShaixuanWidget());
              setState(() => isOpen = false);
            },
          }),
          PWidget.spacer(),
          PWidget.icon(
            Icons.search_rounded,
            [isExpanded ? pColor : aColor.withOpacity(0.5)],
            {'fun': () => setState(() => isExpanded = !isExpanded)},
          ),
        ]),
        [null, null, sbColor],
        {'pd': PFun.lg(8, 8, 16, 16)},
      ),
      PWidget.container(
        PWidget.row([
          PWidget.container(
            buildTFView(
              context,
              hintText: '请输入任意关键字，以空格隔开',
            ),
            [null, 40, aColor.withOpacity(0.05)],
            {'exp': true, 'br': 4, 'pd': PFun.lg(0, 0, 8, 8)},
          ),
          PWidget.text('取消',
              {'pd': 8, 'fun': () => setState(() => isExpanded = !isExpanded)}),
        ]),
        [null, isExpanded ? 56 : 0, sbColor],
        {'pd': 8},
      ),
      PWidget.container(
        PWidget.row([
          PWidget.text('共0条', [aColor.withOpacity(0.5), 12]),
          PWidget.spacer(),
          PWidget.container(
            PWidget.text('批量暂停', [pColor, 12]),
            [null, null, sbColor],
            {
              'pd': PFun.lg(4, 4, 16, 16),
              'br': 56,
              'bd': PFun.bdAllLg(pColor),
            },
          ),
        ]),
        {'pd': 8},
      ),
    ]);
  }
}

///筛选组建
class WeihuShaixuanWidget extends StatefulWidget {
  @override
  _WeihuShaixuanWidgetState createState() => _WeihuShaixuanWidgetState();
}

class _WeihuShaixuanWidgetState extends State<WeihuShaixuanWidget> {
  @override
  Widget build(BuildContext context) {
    return PWidget.container(
      PWidget.column([
        PWidget.text('计划状态', [aColor, 16, true]),
        PWidget.boxh(16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(4, (i) {
            var width = (pmSize.width - 32 - (12 * 2)) / 3;
            var isDy = true;
            return PWidget.container(
              PWidget.text('文本', [isDy ? pColor : aColor]),
              [
                width,
                null,
                isDy ? pColor.withOpacity(0.1) : aColor.withOpacity(0.05)
              ],
              {
                'pd': PFun.lg(10, 10),
                'ali': PFun.lg(0, 0),
                'br': 4,
              },
            );
          }),
        ),
      ], '000'),
      [null, null, Colors.white],
      {'pd': 16},
    );
  }
}
