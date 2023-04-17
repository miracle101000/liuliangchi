import 'package:flutter/material.dart';
import 'package:liuliangchi/util/page/gongneng/hetong/add_hetong_page.dart';

import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/route.dart';

import '../../../config/common_config.dart';
import '../../../paxis_fun.dart';
import '../../../provider/provider_config.dart';
import '../xiansuo/xiansuo_info.dart';
import '../xiansuo/xiaosuo_page.dart';
import 'hetong_shaixuan_widget.dart';

///合同
class HetongPage extends StatefulWidget {
  @override
  _HetongPageState createState() => _HetongPageState();
}

class _HetongPageState extends State<HetongPage> {
  var searchKey = '';

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    getContractList(isRef: true);
  }

  ///获取合同列表
  var contractListDm = DataModel(hasNext: false);
  Future<int?> getContractList({int page = 1, bool isRef = false}) async {
    await Request.post(
      '/app/contract/getContractList?page=$page',
      data: {
        if (searchKey != '') "searchType": "name",
        if (searchKey != '') "searchKey": searchKey,
        "qj_companyId": userPro.qj_companyId,
        "qj_userId": userPro.qj_userId,
      },
      catchError: (v) => contractListDm.toError(v),
      success: (v) => contractListDm.addListModel(v, isRef),
    );
    setState(() {});
    return contractListDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '合同',
        isWhiteBg: true,
        // rigthWidget: PWidget.text('批量', [aColor, 16], {'pd': PFun.lg(4, 4, 8, 8)}),
      ),
      btnBar: PWidget.container(
        PWidget.row([
          infoBtnView('新增', () => jumpPage(AddHetongPage())),
          // infoBtnView('查重', () => jumpPage(RepeatCheckPage())),
        ]),
        [null, 48, Colors.white],
      ),
      body: PWidget.ccolumn([
        HetongShaixuanWidget(callback: (v) {
          searchKey = v;
          getContractList(isRef: true);
        }),
        PWidget.container(
          PWidget.row([
            PWidget.text('共${contractListDm.total}条', [aColor.withOpacity(0.5)])
          ]),
          {'pd': PFun.lg(12, 12, 24, 24)},
        ),
        AnimatedSwitchBuilder(
          value: contractListDm,
          isExd: true,
          initViewIsCenter: true,
          errorOnTap: () async {
            getContractList(isRef: true);
            return 0;
          },
          listBuilder: (List<dynamic> list, p, h) {
            return MyListView(
              isShuaxin: true,
              isGengduo: h,
              divider: Divider(color: Colors.transparent, height: 8),
              onLoading: () async {
                getContractList(page: p);
                return 0;
              },
              onRefresh: () async {
                getContractList(isRef: true);
                return 0;
              },
              touchBottomAnimationOpacity: 10,
              itemCount: list.length,
              item: (i) {
                var data = list[i];
                mapFlog(data, i);
                return PWidget.container(
                  PWidget.column([
                    PWidget.text('${data['title']}'),
                    PWidget.boxh(8),
                    cardLineText('对应客户', '${data['customerName'] ?? ''}'),
                    PWidget.boxh(8),
                    cardLineText(
                        '合同开始日期', '${toTime('${data['startDate']}', false)}'),
                    PWidget.boxh(8),
                    cardLineText(
                        '合同结束日期', '${toTime('${data['endDate']}', false)}'),
                  ]),
                  [double.infinity, null, Colors.white],
                  {
                    'fun': () => jumpPage(XiansuoInfo(data)),
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
