import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:liuliangchi/util/page/gongneng/xiansuochi/xiansuochi_info.dart';
import 'package:liuliangchi/util/provider/provider_config.dart';
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
import '../page_model/page_model.dart';
import '../xiansuo/xiansuo_shaixuan_widget.dart';

class XiansuoChiPage extends StatefulWidget {
  @override
  _XiansuoChiPageState createState() => _XiansuoChiPageState();
}

class _XiansuoChiPageState extends State<XiansuoChiPage> {
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
  Future<int?> getClueList({int page = 1, bool isRef = false}) async {
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
    return clueListDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '线索池',
        isWhiteBg: true,
        // rigthWidget: PWidget.text('批量', [aColor, 16], {'pd': PFun.lg(4, 4, 8, 8)}),
      ),
      body: PWidget.ccolumn([
        XiansuoShaixuanWidget(callback: (v) {
          searchKey = v;
          getClueList(isRef: true);
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
          errorOnTap: () async {
            getClueList(isRef: true);
            return 0;
          },
          listBuilder: (List<dynamic> list, p, h) {
            return MyListView(
              isShuaxin: true,
              isGengduo: h,
              divider: Divider(color: Colors.transparent, height: 8),
              onLoading: () async {
                this.getClueList(page: p);
                return 0;
              },
              onRefresh: () async {
                getClueList(isRef: true);
                return 0;
              },
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
                        // cardLineText('最新跟进记录', ''),
                        // PWidget.boxh(8),
                        cardLineText('下次跟进时间', ''),
                        PWidget.boxh(8),
                        cardLineText('最新转入时间', ''),
                        PWidget.boxh(8),
                        cardLineText('最新通话时间', ''),
                      ], {
                        'exp': 1
                      }),
                    ]),
                    Divider(height: 32),
                    PWidget.row([
                      PWidget.text(genjinStatus[item['trackStatus']] ?? '未知',
                          [aColor, 12], {'exp': true}),
                      PWidget.container(
                        PWidget.text(
                          '转移',
                          [Colors.white, 12],
                        ),
                        [null, null, pColor],
                        {'br': 24, 'pd': PFun.lg(4, 4, 12, 12)},
                      ),
                    ]),
                  ]),
                  [null, null, Colors.white],
                  {
                    'fun': () => jumpPage(XiansuochiInfo(item)),
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
