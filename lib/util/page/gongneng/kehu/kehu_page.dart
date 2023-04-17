import 'package:flutter/material.dart';

import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/http.dart';
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
import '../page_model/page_model.dart';
import '../xiansuo/xiansuo_info.dart';
import 'kehu_info.dart';
import 'kehu_shaixuan_widget.dart';

class KehuPage extends StatefulWidget {
  ///选择
  final bool isSelect;
  const KehuPage({Key? key, this.isSelect = false}) : super(key: key);
  @override
  _KehuPageState createState() => _KehuPageState();
}

class _KehuPageState extends State<KehuPage> {
  var searchKey = '';

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    getCustomerList(isRef: true);
  }

  ///获取客户列表
  var customerListDm = DataModel(hasNext: false);
  Future<int> getCustomerList({int page = 1, bool isRef = false}) async {
    await Request.post(
      '/app/customer/getCustomerList?page=$page',
      data: {
        if (searchKey != '') "searchType": "name",
        if (searchKey != '') "searchKey": searchKey,
        "qj_companyId": userPro.qj_companyId,
        "qj_userId": userPro.qj_userId,
      },
      catchError: (v) => customerListDm.toError(v),
      success: (v) => customerListDm.addListModel(v, isRef),
    );
    setState(() {});
    return customerListDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context,
          title: widget.isSelect ? '选择对应客户' : '客户', isWhiteBg: true),
      btnBar: PWidget.container(
        PWidget.row([
          infoBtnView('新增', () {}),
          // infoBtnView('查重', () {}),
        ]),
        [null, 48, Colors.white],
      ),
      body: PWidget.ccolumn([
        KehuShaixuanWidget(callback: (v) {
          searchKey = v;
          this.getCustomerList(isRef: true);
        }),
        PWidget.container(
          PWidget.row([
            PWidget.text('共${customerListDm.total}条', [aColor.withOpacity(0.5)])
          ]),
          {'pd': PFun.lg(12, 12, 24, 24)},
        ),
        AnimatedSwitchBuilder(
          value: customerListDm,
          isExd: true,
          initViewIsCenter: true,
          errorOnTap: () => this.getCustomerList(isRef: true),
          listBuilder: (List<dynamic> list, p, h) {
            return MyListView(
              isShuaxin: true,
              isGengduo: h,
              divider: Divider(
                  color: Colors.transparent, height: widget.isSelect ? 1 : 8),
              onLoading: () => this.getCustomerList(page: p),
              onRefresh: () => this.getCustomerList(isRef: true),
              itemCount: list.length,
              item: (i) {
                var item = list[i];
                if (widget.isSelect) {
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
                      // PWidget.text(item['trackDate'] == null ? '1天未跟进' : toTime(item['trackDate'], false), [aColor, 12]),
                    ]),
                  ]),
                  [null, null, Colors.white],
                  {
                    'fun': () => jumpPage(KehuInfo(item)),
                    'pd': PFun.lg(12, 12, 24, 24)
                  },
                  // {'fun': () => jumpPage(MyNestedListView()), 'pd': PFun.lg(12, 12, 24, 24)},
                );
              },
            );
          },
        ),
      ]),
    );
  }
}
