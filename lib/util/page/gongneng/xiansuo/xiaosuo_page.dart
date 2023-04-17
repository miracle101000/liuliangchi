import 'package:flutter/material.dart';
import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:liuliangchi/util/page/gongneng/xiansuo/xiansuo_info.dart';
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
import 'add_xiansuo_page.dart';

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

class XiansuoPage extends StatefulWidget {
  @override
  _XiansuoPageState createState() => _XiansuoPageState();
}

class _XiansuoPageState extends State<XiansuoPage> {
  var searchKey = '';

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    getClueList(isRef: true);
  }

  ///获取线索列表
  var clueListDm = DataModel(hasNext: false);
  Future<int> getClueList({int page = 1, bool isRef = false}) async {
    await Request.post(
      '/app/clue/getClueList?page=$page',
      data: {
        if (searchKey != '') "searchType": "name",
        if (searchKey != '') "searchKey": searchKey,
        "qj_companyId": userPro.qj_companyId,
        "qj_userId": userPro.qj_userId,
      },
      catchError: (v) => clueListDm.toError(v),
      success: (v) => clueListDm.addListModel(v, isRef),
    );
    setState(() {});
    return clueListDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '线索',
        isWhiteBg: true,
        // rigthWidget: PWidget.text('批量', [aColor, 16], {'pd': PFun.lg(4, 4, 8, 8)}),
      ),
      btnBar: PWidget.container(
        PWidget.row([
          infoBtnView('新增', () => jumpPage(AddXianSuoPage())),
          // infoBtnView('查重', () => jumpPage(RepeatCheckPage())),
        ]),
        [null, 48, Colors.white],
      ),
      body: PWidget.ccolumn([
        XiansuoShaixuanWidget(callback: (v) {
          searchKey = v;
          this.getClueList(isRef: true);
        }),
        PWidget.container(
          PWidget.row([
            PWidget.text('共${clueListDm.total}条', [aColor.withOpacity(0.5)])
          ]),
          {'pd': PFun.lg(12, 12, 24, 24)},
        ),
        AnimatedSwitchBuilder(
          value: clueListDm,
          isExd: true,
          initViewIsCenter: true,
          errorOnTap: () => this.getClueList(isRef: true),
          listBuilder: (List<dynamic> list, p, h) {
            return MyListView(
              isShuaxin: true,
              isGengduo: h,
              divider: Divider(color: Colors.transparent, height: 8),
              onLoading: () => this.getClueList(page: p),
              onRefresh: () => this.getClueList(isRef: true),
              touchBottomAnimationOpacity: 10,
              itemCount: list.length,
              item: (i) {
                var item = list[i];
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
                                  builder: (_) => ShaixuanPopup(valueList: [
                                        item['firmPhone'],
                                        item['firmMobile']
                                      ]));
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
                    Divider(height: 32),
                    PWidget.row([
                      PWidget.text(genjinStatus[item['trackStatus']] ?? '未知',
                          [aColor, 12], {'exp': true}),
                      PWidget.text(
                          item['trackDate'] == null
                              ? '1天未跟进'
                              : toTime(item['trackDate'], false),
                          [aColor, 12]),
                    ]),
                  ]),
                  [null, null, Colors.white],
                  {
                    'fun': () => jumpPage(XiansuoInfo(item)),
                    'pd': PFun.lg(12, 12, 24, 24)
                  },
                );
              },
            );
          },
        ),
      ]),
    );
  }
}
