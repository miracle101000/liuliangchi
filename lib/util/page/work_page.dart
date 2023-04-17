import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:liuliangchi/util/common_util.dart';

import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/my_custom_scroll.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:provider/provider.dart';

import '../config/common_config.dart';
import '../paxis_fun.dart';
import '../provider/app_provider.dart';
import '../provider/provider_config.dart';
import '../widget/triangle_clipper.dart';
import 'gongneng/duanxin_page.dart';
import 'gongneng/xiansuo/xiaosuo_page.dart';
import 'home_tag_btn.dart';

///工作台
class WorkPage extends StatefulWidget {
  @override
  WorkPageState createState() => WorkPageState();
}

class WorkPageState extends State<WorkPage> {
  var selectoList1 = [];
  var selectoList2 = [];

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    app.setIsShowHomeMask(false);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context,
          title: '工作台', isWhiteBg: true, isNoShowLeft: true),
      body: MyCustomScroll(
        isGengduo: false,
        isShuaxin: false,
        headers: [
          itemBgView(Wrap(
            children: item1List.map((m) {
              var wh = (pmSize.width - 32) / 4;
              return PWidget.container(
                PWidget.ccolumn([
                  if (isNotNull(m['img'])) PWidget.image('${m['img']}'),
                  if (m['name'] == '快捷新增')
                    PWidget.icon(Icons.add_box_rounded, [aColor]),
                  if (m['name'] == '更多')
                    PWidget.icon(Icons.more_horiz_rounded, [aColor]),
                  PWidget.boxh(4),
                  PWidget.text(m['name'], [aColor]),
                ], '200'),
                [wh, wh],
                {'ali': PFun.lg(0, 0), 'fun': m['fun']},
              );
            }).toList(),
          )),
          PWidget.boxh(16),
          buildTabBarView(true),
        ],
        onScrollToList: (b, v) => app.setIsShowHomeMask(b),
        maskWidget: () => buildMaskView(),
        maskHeight: 0.0,
        touchBottomAnimationOpacity: 20,
        touchBottomAnimationValue: 0.5,
        headPadding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        itemPadding: const EdgeInsets.all(16),
        divider: const Divider(color: Colors.transparent),
        itemModel: DataModel(flag: 10)..list = item,
        itemModelBuilder: (i, v) {
          return item[i];
        },
        onRefresh: () async {
          return 0;
        },
      ),
    );
  }

  var item1List = [
    {'img': '', 'name': '快捷新增', 'fun': () {}},
    {
      'img': 'assets/管客户/线索.png',
      'name': '线索',
      'fun': () => jumpPage(XiansuoPage())
    },
    {'img': 'assets/管客户/线索池.png', 'name': '线索池', 'fun': () {}},
    {'img': 'assets/销售支持/跟进记录.png', 'name': '跟进记录', 'fun': () {}},
    {'img': 'assets/销售支持/拜访签到.png', 'name': '拜访签到', 'fun': () {}},
    {'img': 'assets/找客户/找企业.png', 'name': '找企业', 'fun': () {}},
    {'img': 'assets/找客户/地图获客.png', 'name': '地图获客', 'fun': () {}},
    {'img': '', 'name': '更多', 'fun': () {}},
  ];

  ///业绩分析
  var item2List = [
    {'icon': '', 'name': '合同总金额', 'value': '¥0.00', 'fun': () {}},
    {'icon': '', 'name': '合同总单数', 'value': '¥0.00', 'fun': () {}},
    {'icon': '', 'name': '合同计划回款', 'value': '¥0.00', 'fun': () {}},
    {'icon': '', 'name': '合同实际回款', 'value': '¥0.00', 'fun': () {}},
    {'icon': '', 'name': '赢单商机总金额', 'value': '¥0.00', 'fun': () {}},
    {'icon': '', 'name': '赢单商机总单数', 'value': '¥0.00', 'fun': () {}},
    {'icon': '', 'name': '赢单商机客单价', 'value': '¥0.00', 'fun': () {}},
  ];

  ///产品销售分析
  var item3List = [
    {'icon': '', 'name': '产品销量总额', 'value': '¥0.00', 'fun': () {}},
    {'icon': '', 'name': '产品销量总量', 'value': '¥0.00', 'fun': () {}},
  ];

  var paiming1 = ['合同回款金额', '合同数', '赢单商机数', '赢单商机金额'];
  var paiming2 = ['跟进次数排名', '拜访签到排名', '新增线索排名'];
  var paiming1Index = 0;
  var paiming2Index = 0;

  ///遮罩层
  Widget buildMaskView() {
    return Selector<AppProvider, bool>(
      selector: (_, k) => k.isShowHomeMask,
      builder: (_, v, view) {
        return PWidget.positioned(
          buildTabBarView(false),
          [v ? 0 : -40, null, 0, 0],
        );
      },
    );
  }

  Widget buildTabBarView(bool flag) {
    return itemBgView(
      PWidget.row([
        HomeTagBtn(selectoList1.isEmpty ? '全部' : selectoList1.join(''),
            fun: () async {
          var res = await showSheet(builder: (_) {
            return ShaixuanPopup(
                selectoList: selectoList1, valueList: ['查看全部', '只看自己']);
          });
          if (res != null) setState(() => selectoList1 = res ?? []);
        }),
        PWidget.spacer(),
        HomeTagBtn(selectoList2.isEmpty ? '上月' : selectoList2.join(''),
            fun: () async {
          var res = await showSheet(builder: (_) {
            return ShaixuanPopup(selectoList: selectoList2, valueList: [
              '今年',
              '去年',
              '本季度',
              '上季度',
              '本月',
              '上月',
              '本周',
              '上周',
              '今天',
              '昨天'
            ]);
          });
          if (res != null) setState(() => selectoList2 = res ?? []);
        }),
      ]),
      isShowSd: flag,
    );
  }

  List<Widget> get item {
    return [
      itemBgView(itemChart(
        list: [
          '业绩目标',
          '全部/上月',
          () {
            FlutterPhoneDirectCaller.callNumber("15243714931");
          }
        ],
        wrap: ['合同回款金额'],
        view: PWidget.row([
          PWidget.container(
              const CircularProgressIndicator(
                value: 0.5,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff5BC1AD)),
                backgroundColor: Color(0x8f5BC1AD),
                strokeWidth: 16,
              ),
              [80, 80],
              {'mg': PFun.lg(32, 32, 48, 32)},
              ObjectKey({'mg': PFun.lg(32, 32, 48, 32)}.toString())),
          PWidget.column([
            PWidget.text('', [], {}, [
              PWidget.textIs('目标：', [aColor.withOpacity(0.5), 10]),
              PWidget.textIs('--', [aColor.withOpacity(0.75), 10]),
            ]),
            PWidget.boxh(4),
            PWidget.text('', [], {}, [
              PWidget.textIs('完成：', [aColor.withOpacity(0.5), 10]),
              PWidget.textIs('¥0.12', [const Color(0xff5BC1AD)]),
            ]),
          ], {
            'exp': 1
          }),
        ]),
      )),
      itemBgView(itemChart(
        list: ['荣誉榜', '全公司/上月', () {}],
        view: PWidget.column([
          buildWrapList(paiming1, paiming1Index,
              (i) => setState(() => paiming1Index = i)),
          buildPaihang([{}, {}, {}]),
          const Divider(height: 32),
          buildWrapList(paiming2, paiming2Index,
              (i) => setState(() => paiming2Index = i)),
          buildPaihang([{}, {}, {}]),
        ]),
      )),
      itemBgView(itemChart(
        list: ['业绩分析', '全部/上月', () {}],
        view: buildYejiFenxiView(item2List),
      )),
      itemBgView(itemChart(
        list: ['产品销售分析', '全部/上月'],
        view: buildYejiFenxiView(item3List),
      )),
      itemBgView(itemChart(
        list: ['通话分析', '全部/上月'],
        view: buildYejiFenxiView([
          {'name': '有效呼出次数', 'value': '0'},
          {'name': '有效呼出时长', 'value': '0'},
          {'name': '呼出总次数', 'value': '0'},
          {'name': '呼出总时长', 'value': '0'},
        ]),
      )),
      itemBgView(itemChart(
        list: ['执行分析', '全部/上月'],
        view: buildYejiFenxiView([
          {'name': '跟进次数', 'value': '0'},
          {'name': '拜访签到次数', 'value': '0'},
          {'name': '新增线索数', 'value': '0'},
          {'name': '新增客户数', 'value': '0'},
        ]),
      )),
      itemBgView(itemChart(
        list: ['转化率分析', '全部/上月'],
        view: buildYejiFenxiView([
          {'name': '线索转客户', 'value': '0.00%'},
        ]),
      )),
      itemBgView(itemChart(
        list: ['销售漏斗', '全部/上月'],
        bottom: 0,
        view: PWidget.ccolumn([
          PWidget.row([
            Stack(children: [
              buildXSLDTB([
                {'color': const Color(0xffE76059), 'text': '¥10.00'},
                {'color': const Color(0xffF48C4B), 'text': '¥10.00'},
                {'color': const Color(0xffF4AD36), 'text': '¥10.00'},
                {'color': const Color(0xff90E4AC), 'text': '¥10.00'},
                {'color': const Color(0xff88DDDC), 'text': '¥10.00'},
              ]),
              PWidget.positioned(
                PWidget.text('输单(0)\n¥0.00', [aColor.withOpacity(0.5), 10]),
                [null, 16, 16, null],
              ),
            ]),
            PWidget.ccolumn(
              List.generate(5, (i) {
                return PWidget.container(
                  PWidget.text(
                    ['初步接洽(O)', '需求确定(0)', '方案/报价(O)', '谈判/合同(0)', '赢单(0)'][i],
                    [
                      [
                        const Color(0xffE76059),
                        const Color(0xffF48C4B),
                        const Color(0xffF4AD36),
                        const Color(0xff90E4AC),
                        const Color(0xff88DDDC)
                      ][i],
                      12
                    ],
                  ),
                  [null, 40],
                  {'ali': PFun.lg(0, 0)},
                );
              }),
              {'exp': 1},
            ),
          ]),
          const Divider(height: 32),
          PWidget.container(
            PWidget.row(
              List.generate(2, (i) {
                return PWidget.ccolumn([
                  PWidget.text(['预计销售总金额', '预计销售总单数'][i],
                      [aColor.withOpacity(0.25), 12]),
                  PWidget.boxh(4),
                  PWidget.text(['¥0.00', '0'][i], [aColor]),
                  PWidget.boxh(8),
                ]);
              }),
              '251',
            ),
          ),
        ]),
      )),
      itemBgView(itemChart(
        list: ['搜客宝分析', '全部/上月'],
        view: buildYejiFenxiView([
          {'name': '已用流量额度', 'value': '2398'},
        ]),
      )),
      itemBgView(itemChart(
        list: ['销售助手', '全部'],
        view: buildXiaoshouZhushouView([
          {'name': '超过7天没有写跟进的客户', 'value': '2398'},
          {'name': '超过7天没有写跟进的未成交客户', 'value': '2398'},
          {'name': '超过15天没有写跟进的成交客户', 'value': '2398'},
          {'name': '超过30天没有成交的客户', 'value': '2398'},
          {'name': '预计30天内签单的商机', 'value': '2398'},
          {'name': '7天内需要回款的合同', 'value': '2398'},
          {'name': '30天内将到期的合同', 'value': '2398'},
          {'name': '最近7天将要过生日的联系人', 'value': '2398'},
          {'name': '最近浏览的客户', 'value': '2398'},
        ]),
      )),
      itemBgView(itemChart(
        list: ['机器人分析', '全部/上月'],
        view: buildYejiFenxiView([
          {'name': '呼叫数', 'value': '2398'},
          {'name': '通话时长', 'value': '2398'},
          {'name': '接通率', 'value': '2398'},
          {'name': '意向标签数（个）', 'value': '2398'},
          {'name': '机器人数', 'value': '2398'},
        ]),
      )),
    ];
  }

  ///销售助手
  Widget buildXiaoshouZhushouView(List list) {
    return Wrap(
      runSpacing: 16,
      children: List.generate(list.length, (i) {
        var map = list[i];
        return PWidget.container(
          PWidget.row([
            PWidget.boxw(8),
            PWidget.icon(Icons.accessibility_new_rounded),
            PWidget.boxw(4),
            PWidget.text(
                map['name'], [aColor.withOpacity(0.75)], {'exp': true}),
            PWidget.text(map['value']),
            PWidget.boxw(8),
          ]),
          {'fun': map['fun']},
        );
      }),
    );
  }

  ///业绩分析or产品销售分析
  Widget buildYejiFenxiView(List list) {
    return Wrap(
      runSpacing: 16,
      children: List.generate(list.length, (i) {
        var width = (pmSize.width - 32) / 2;
        var map = list[i];
        return PWidget.container(
          PWidget.row([
            PWidget.boxw(8),
            PWidget.icon(Icons.accessibility_new_rounded),
            PWidget.boxw(4),
            PWidget.column([
              PWidget.text(map['name'], [aColor.withOpacity(0.5), 12]),
              PWidget.boxh(2),
              PWidget.text(map['value']),
            ]),
          ]),
          [width],
          {'fun': map['fun']},
        );
      }),
    );
  }

  ///工作台组建的背景
  Widget itemBgView(view, {bool isShowSd = true}) {
    return PWidget.container(
      view,
      [null, null, Colors.white],
      {
        if (!isShowSd) 'pd': PFun.lg(0, 0, 16, 16),
        if (isShowSd) 'br': 8 * 3.0,
        if (isShowSd) 'ph': true,
        'sd': PFun.sdLg(aColor.withOpacity(0.05), 1, 0, 2)
      },
    );
  }

  Widget itemChart(
      {List? list, List wrap = const [], Widget? view, double bottom = 16.0}) {
    return PWidget.column([
      PWidget.container(
        PWidget.row([
          PWidget.text(list![0] ?? '业绩目标', [aColor]),
          PWidget.boxw(8),
          PWidget.text(list[1] ?? '全部/上月', [aColor.withOpacity(0.25), 10]),
          PWidget.spacer(),
          if (list.length >= 3)
            PWidget.icon(Icons.settings_rounded, [aColor.withOpacity(0.25), 20],
                {'fun': list[2]}),
        ]),
        {'pd': 12},
      ),
      PWidget.container(
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(wrap.length, (i) {
            var map = wrap[i];
            return PWidget.container(
              PWidget.text(map, [pColor, 10]),
              {
                'pd': PFun.lg(4, 4, 8, 8),
                'br': 56,
                'bd': PFun.bdAllLg(pColor),
              },
            );
          }),
        ),
        {'pd': PFun.lg(0, 0, 12, 12)},
      ),
      view!,
      PWidget.boxh(bottom),
    ]);
  }

  ///排行榜
  Widget buildPaihang(List list) {
    return PWidget.container(
      PWidget.row(
        List.generate(list.length, (i) {
          return PWidget.ccolumn([
            PWidget.boxh(24),
            PWidget.text(['2', '1', '3'][i]),
            PWidget.boxh(8),
            PWidget.container(
              PWidget.text('100', [Colors.white], {'ct': true}),
              [null, PFun.lg(40, 64, 24)[i]],
              {
                'br': PFun.lg(8, 8),
                'gd': PFun.tbGd(
                  Color([0xffE4E3E7, 0xffF9D031, 0xffF3AA76][i]),
                  Color([0xffC0C3CC, 0xffF7B236, 0xffD08452][i]),
                )
              },
            ),
          ], {
            'exp': 1
          });
        }),
        '100',
      ),
      {'pd': PFun.lg(0, 0, 8, 8)},
    );
  }

  buildWrapList(List list, int index, Function(int) fun) {
    return PWidget.row(
      List.generate(list.length, (i) {
        var map = list[i];
        var isDy = index == i;
        return PWidget.container(
          PWidget.text(map, [isDy ? pColor : aColor.withOpacity(0.5), 10]),
          {
            'fun': () => fun(i),
            'mg': PFun.lg(0, 0, 0, 8),
            'pd': PFun.lg(4, 4, 8, 8),
            'br': 56,
            'bd': PFun.bdAllLg(isDy ? pColor : aColor.withOpacity(0.1)),
          },
        );
      }),
      {'pd': PFun.lg(0, 0, 12, 12)},
    );
  }

  ///销售漏斗图表
  Widget buildXSLDTB(List list) {
    return PWidget.container(
      PWidget.ccolumn(
        List.generate(list.length, (i) {
          var map = list[i];
          var view = PWidget.container(
            PWidget.text(map['text'], [Colors.white, 12]),
            [((pmSize.width - 32 - 40) * 0.8 - 40) - (32 * i), 40],
            {
              'ali': PFun.lg(0, 0),
              'mg': PFun.lg(0, 1),
              'gd': PFun.tbGd(
                  map['color'],
                  HSLColor.fromColor(map['color'])
                      .withLightness(0.75)
                      .toColor())
            },
          );
          if (i == 4) return view;
          return ClipPath(
            clipper: TriangleClipper(16),
            child: view,
          );
        }),
      ),
      {'pd': PFun.lg(0, 0, 40)},
    );
  }
}
