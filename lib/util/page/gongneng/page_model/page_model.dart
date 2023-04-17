import 'package:flutter/material.dart';

import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:liuliangchi/util/page/gongneng/page_model/Add/tianjiahuikuanjilu.dart';
import 'package:liuliangchi/util/page/gongneng/page_model/Add/tianjiakehu.dart';
import 'package:liuliangchi/util/page/gongneng/page_model/Add/tianjiashangji.dart';
import 'package:liuliangchi/util/page/gongneng/page_model/Add/xiansuoadd.dart';
import 'package:liuliangchi/util/page/gongneng/xiansuo/xiansuo_shaixuan_widget.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import '../../../config/common_config.dart';
import '../../../paxis_fun.dart';
import '../../../provider/provider_config.dart';
import '../duanxin_page.dart';
import '../kehu/kehu_info.dart';
import '../xiansuo/xiansuo_info.dart';
import 'Add/hetong.dart';

///跟进状态
var genjinStatus = {
  0: "未处理",
  1: "已加微信",
  2: "已发资料",
  3: "暂时不需要",
  4: "未接电话",
  5: "挂断",
  6: "同行",
  7: "A类（准客户）",
  8: "B类（意向较强）",
  9: "C类（后期需要）",
  10: "D类（完全无意向）",
  11: "空白"
};

Widget cardLineText(key, value) {
  return PWidget.text('', [], {}, [
    PWidget.textIs('$key：', [aColor.withOpacity(0.5), 12]),
    PWidget.textIs('$value', [aColor.withOpacity(0.75), 12]),
  ]);
}

///线索池列表项
Widget xiansuochiItemView(item) {
  return PWidget.container(
    PWidget.column([
      PWidget.row([
        PWidget.column([
          PWidget.text('${item['title']}', [aColor]),
          PWidget.boxh(8),
          cardLineText('公司名称', '${item['operateRealName']}'),
          PWidget.boxh(8),
          cardLineText('地区', '${item['customerName'] ?? ''}'),
          PWidget.boxh(8),
          cardLineText('前负责人', '${item['contractPrice']}'),
          PWidget.boxh(8),
        ], {
          'exp': 1
        }),
      ]),
    ]),
    [null, null, Colors.white],
    {'fun': () {}, 'pd': PFun.lg(12, 12, 24, 24)},
  );
}

///合同列表项
Widget hetongItemView(item) {
  return PWidget.container(
    PWidget.column([
      PWidget.row([
        PWidget.column([
          PWidget.text('${item['title']}', [aColor]),
          PWidget.boxh(8),
          cardLineText('负责人', '${item['operateRealName']}'),
          PWidget.boxh(8),
          cardLineText('对应客户', '${item['customerName'] ?? ''}'),
          PWidget.boxh(8),
          cardLineText('合同总金额', '${item['contractPrice']}'),
          PWidget.boxh(8),
          cardLineText('合同开始日期', '${toTime('${item['startDate']}', false)}'),
          PWidget.boxh(8),
          cardLineText('合同结束日期', '${toTime('${item['endDate']}', false)}'),
          PWidget.boxh(8),
          cardLineText('对应商机', '${item['opportunityName']}'),
        ], {
          'exp': 1
        }),
      ]),
    ]),
    [null, null, Colors.white],
    {'fun': () {}, 'pd': PFun.lg(12, 12, 24, 24)},
  );
}

///商机列表项
Widget shangjiItemView(item) {
  return PWidget.container(
    PWidget.column([
      PWidget.row([
        PWidget.column([
          PWidget.text('${item['title']}', [aColor]),
          PWidget.boxh(8),
          cardLineText('对应客户', '${item['customerName']}'),
          PWidget.boxh(8),
          cardLineText('预计销售额', '${item['sales']}'),
          PWidget.boxh(8),
          cardLineText('预计签单时间', '${item['showDate']}'),
          PWidget.boxh(8),
          cardLineText('负责人', '${item['operateRealName']}'),
        ], {
          'exp': 1
        }),
      ]),
    ]),
    [null, null, Colors.white],
    {'fun': () {}, 'pd': PFun.lg(12, 12, 24, 24)},
  );
}

///线索列表项
Widget xiansuoItemView(item) {
  return PWidget.container(
    PWidget.column([
      PWidget.row([
        PWidget.column([
          PWidget.text('${item['name']}', [aColor]),
          PWidget.boxh(8),
          cardLineText('公司名字', '${item['firmName']}'),
          PWidget.boxh(8),
          cardLineText('最新跟进记录', ''),
          PWidget.boxh(8),
          cardLineText('下次跟进时间', ''),
          PWidget.boxh(8),
          cardLineText('最后通话时间', ''),
        ], {
          'exp': 1
        }),
        PWidget.container(
          PWidget.icon(Icons.call_rounded, [pColor]),
          [40, 40],
          {
            'br': 40,
            'bd': PFun.bdAllLg(pColor, 2),
            'fun': () async {
              if (isNotNull(item['firmPhone']) &&
                  isNotNull(item['firmMobile'])) {
                var res = await showSheet(
                    builder: (_) => ShaixuanPopup(
                        valueList: [item['firmPhone'], item['firmMobile']]));
                if (res != null) callFun(res[0], item);
                //两个都不为空
              } else if (isNotNull(item['firmPhone'])) {
                //电话不为空
                callFun(item['firmPhone'], item);
              } else if (isNotNull(item['firmMobile'])) {
                //手机号不为空
                callFun(item['firmMobile'], item);
              }
            }
          },
        ),
      ]),
      const Divider(height: 32),
      PWidget.row([
        PWidget.text(genjinStatus[item['trackStatus']] ?? '未知', [aColor, 12],
            {'exp': true}),
        PWidget.text(
            item['trackDate'] == null
                ? '1天未跟进'
                : toTime(item['trackDate'], false),
            [aColor, 12]),
      ]),
    ]),
    [null, null, Colors.white],
    {'fun': () => jumpPage(XiansuoInfo(item)), 'pd': PFun.lg(12, 12, 24, 24)},
  );
}

///客户列表项
Widget kehuItemView(item, {isSelect = false}) {
  if (isSelect) {
    return PWidget.container(
      PWidget.text('${item['name']}', [aColor]),
      [double.infinity, null, Colors.white],
      {'fun': () => close(item), 'pd': PFun.lg(12, 12, 24, 24)},
    );
  }
  return PWidget.container(
    PWidget.column([
      PWidget.row([
        PWidget.column([
          PWidget.text('${item['name']}', [aColor]),
          // PWidget.boxh(8),
          // cardLineText('公司名字', '${item['firmName']}'),
          PWidget.boxh(8),
          cardLineText('最新跟进记录', ''),
          PWidget.boxh(8),
          cardLineText('下次跟进时间', ''),
          PWidget.boxh(8),
          cardLineText('最后通话时间', ''),
        ], {
          'exp': 1
        }),
        PWidget.container(
          PWidget.icon(Icons.call_rounded, [pColor]),
          [40, 40],
          {
            'br': 40,
            'bd': PFun.bdAllLg(pColor, 2),
            'fun': () async {
              if (isNotNull(item['firmPhone']) &&
                  isNotNull(item['firmMobile'])) {
                var res = await showSheet(
                    builder: (_) => ShaixuanPopup(
                        valueList: [item['firmPhone'], item['firmMobile']]));
                if (res != null) callFun(res[0], item);
                //两个都不为空
              } else if (isNotNull(item['firmPhone'])) {
                //电话不为空
                callFun(item['firmPhone'], item);
              } else if (isNotNull(item['firmMobile'])) {
                //手机号不为空
                callFun(item['firmMobile'], item);
              }
            }
          },
        ),
      ]),
      const Divider(height: 32),
      PWidget.row([
        PWidget.text(genjinStatus[item['trackStatus']] ?? '未知', [aColor, 12],
            {'exp': true}),
        // PWidget.text(item['trackDate'] == null ? '1天未跟进' : toTime(item['trackDate'], false), [aColor, 12]),
      ]),
    ]),
    [null, null, Colors.white],
    {'fun': () => jumpPage(KehuInfo(item)), 'pd': PFun.lg(12, 12, 24, 24)},
    // {'fun': () => jumpPage(MyNestedListView()), 'pd': PFun.lg(12, 12, 24, 24)},
  );
}

///功能页面模型
class PageModel extends StatefulWidget {
  final String title;
  final bool isSelect;
  const PageModel(this.title, {Key? key, this.isSelect = false})
      : super(key: key);
  @override
  _PageModelState createState() => _PageModelState();
}

class _PageModelState extends State<PageModel> {
  var searchKey = '';
  bool get isXiansuo => widget.title == '线索';
  bool get isKehu => widget.title == '客户';
  bool get isShangji => widget.title == '商机';
  bool get isHetong => widget.title == '合同';
  bool get isXiansuochi => widget.title == '线索池';
  bool get isHuiKuanjilu => widget.title == '回款记录';
  var selectTitleMap = {'客户': '选择对应客户'};
  String? get title =>
      widget.isSelect ? selectTitleMap[widget.title] : widget.title;

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    getDataList(isRef: true);
  }

  ///获取列表
  var dataListDm = DataModel(hasNext: false);
  Future<int> getDataList({int page = 1, bool isRef = false}) async {
    var url;
    if (isXiansuo) url = '/app/clue/getClueList?page=$page';
    if (isKehu) url = '/app/customer/getCustomerList?page=$page';
    if (isShangji) url = '/app/opportunity/getOpportunityList?page=$page';
    if (isHetong) url = '/app/contract/getContractList?page=$page';
    if (isXiansuochi) url = '/app/clue/getCluePoolList?page=$page';
    if (isHuiKuanjilu) url = '/app/payment/addPaymentHistory?page=$page';
    var data = {
      if (searchKey != '') "searchType": "name",
      if (searchKey != '') "searchKey": searchKey,
      "qj_companyId": userPro.qj_companyId,
      "qj_userId": userPro.qj_userId,
    };
    await Request.post(
      url,
      data: data,
      isToken: false,
      catchError: (v) => dataListDm.toError(v),
      success: (v) => dataListDm.addListModel(v, isRef),
    );
    setState(() {});
    return dataListDm.flag!;
  }

  List<String> titles = ['线索', '客户', '合同', '商机', '回款记录', '产品'];
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context,
          title: title!,
          isWhiteBg: true,
          rigthWidget: titles.contains(title)
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.add,
                    color: pColor,
                  ),
                )
              : null,
          rightCallback: title == '线索'
              ? () {
                  jumpPage(const XianSuoAdd(), isMoveBtm: true);
                }
              : title == '客户'
                  ? () {
                      jumpPage(const TianJiaKehu(), isMoveBtm: true);
                    }
                  : title == '合同'
                      ? () {
                          jumpPage(const HeTong(), isMoveBtm: true);
                        }
                      : title == '商机'
                          ? () {
                              jumpPage(const TianjiaShangji(), isMoveBtm: true);
                            }
                          : title == '回款记录'
                              ? () {
                                  jumpPage(const TianHuiKuanJiLu(),
                                      isMoveBtm: true);
                                }
                              : null),
      btnBar: btnBarView(),
      body: PWidget.ccolumn([
        XiansuoShaixuanWidget(callback: (v) {
          searchKey = v;
          getDataList(isRef: true);
        }),
        PWidget.container(
          PWidget.row([
            PWidget.text('共${dataListDm.total}条', [aColor.withOpacity(0.5)])
          ]),
          {'pd': PFun.lg(12, 12, 24, 24)},
        ),
        AnimatedSwitchBuilder(
          value: dataListDm,
          isExd: true,
          initViewIsCenter: true,
          errorOnTap: () => getDataList(isRef: true),
          listBuilder: (list, p, h) {
            return MyListView(
              isShuaxin: true,
              isGengduo: h,
              divider: const Divider(color: Colors.transparent, height: 8),
              onLoading: () => getDataList(page: p),
              onRefresh: () => getDataList(isRef: true),
              touchBottomAnimationOpacity: 10,
              itemCount: list.length,
              item: (i) {
                if (isXiansuo) return xiansuoItemView(list[i]);
                if (isKehu)
                  return kehuItemView(list[i], isSelect: widget.isSelect);
                if (isShangji) return shangjiItemView(list[i]);
                if (isHetong) return hetongItemView(list[i]);
                if (isXiansuochi) return xiansuochiItemView(list[i]);
              },
            );
          },
        ),
      ]),
    );
  }

  ///底部栏
  Widget btnBarView() {
    if (isXiansuo) return btnBarButton('新增', () => showCustomToast('开发中'));
    if (isKehu) return btnBarButton('新增', () => showCustomToast('开发中'));
    if (isShangji) return btnBarButton('新增', () => showCustomToast('开发中'));
    if (isHetong) return btnBarButton('新增', () => showCustomToast('开发中'));
    return PWidget.boxh(0);
  }

  ///底部按钮
  Widget btnBarButton(text, fun) {
    return PWidget.container(
      PWidget.row([
        infoBtnView(text, fun),
        // infoBtnView('查重', () => jumpPage(RepeatCheckPage())),
      ]),
      [null, 48, Colors.white],
    );
  }
}
