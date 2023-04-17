import 'package:flutter/material.dart';

import 'package:liuliangchi/util/http.dart';
import 'package:liuliangchi/util/paxis_fun.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:liuliangchi/util/common_util.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/mylistview.dart';

import '../../../config/common_config.dart';
import '../../../provider/provider_config.dart';
import '../../../view/views.dart';
import '../page_model/Add/tianJiaChanPin.dart';
import '../xiansuo/xiansuo_info.dart';
import 'add_chanpin_page.dart';
import 'chanpin_Info.dart';
import 'chanpin_shaixuan_widget.dart';

///产品
class ChanpinPage extends StatefulWidget {
  final bool isSelect;
  const ChanpinPage({Key? key, this.isSelect = false}) : super(key: key);
  @override
  _ChanpinPageState createState() => _ChanpinPageState();
}

class _ChanpinPageState extends State<ChanpinPage> {
  var selectValue = [];

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    getProductList(isRef: true);
  }

  ///获取产品列表
  var chanpinListDm = DataModel(hasNext: false);
  Future<int> getProductList({int page = 1, bool isRef = false}) async {
    await Request.post(
      '/app/product/getProductList?page=$page',
      data: {
        "qj_companyId": userPro.qj_companyId,
        "qj_userId": userPro.qj_userId
      },
      catchError: (v) => chanpinListDm.toError(v),
      success: (v) => chanpinListDm.addListModel(v, isRef),
    );
    setState(() {});
    return chanpinListDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context,
          title: widget.isSelect ? '关联产品' : '产品',
          rigthWidget: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.add,
              color: pColor,
            ),
          ), rightCallback: () {
        jumpPage(TianJiaChanPin());
      }),
      btnBar: PWidget.container(
        Builder(builder: (context) {
          if (widget.isSelect) {
            return PWidget.row([
              btnView('已选产品\t(${selectValue.length})',
                  isAnima: false, redius: 0, isExp: true, textSize: 14),
              VerticalDivider(width: 1, color: Colors.white),
              btnView('下一步',
                  isAnima: false,
                  redius: 0,
                  isExp: true,
                  textSize: 14, fun: () {
                close(selectValue);
              }),
            ]);
          }
          return infoBtnView('新增', () {
            jumpPage(AddChanpinPage(), callback: (v) {
              if (v != null) getProductList(isRef: true);
            });
          }, exp: false);
        }),
        [null, 48, Colors.white],
      ),
      body: PWidget.ccolumn([
        ChanpinShaixuanWidget(callback: (v) {
          this.getProductList(isRef: true);
        }),
        PWidget.container(
          PWidget.row([
            PWidget.text('共${chanpinListDm.total}条', [aColor.withOpacity(0.5)])
          ]),
          {'pd': PFun.lg(12, 12, 24, 24)},
        ),
        AnimatedSwitchBuilder(
          value: chanpinListDm,
          isExd: true,
          initViewIsCenter: true,
          errorOnTap: () => this.getProductList(isRef: true),
          listBuilder: (List<dynamic> list, p, h) {
            return MyListView(
              isShuaxin: true,
              isGengduo: h,
              divider: Divider(color: Colors.transparent, height: 8),
              onLoading: () => this.getProductList(page: p),
              onRefresh: () => this.getProductList(isRef: true),
              touchBottomAnimationOpacity: 10,
              itemCount: list.length,
              item: (i) {
                var item = list[i];
                var isContains = selectValue.contains(item);
                var images = '${item['image']}'.trim().split(',');
                images.remove('');
                return PWidget.container(
                  PWidget.row([
                    if (images.isNotEmpty)
                      PWidget.container(
                          PWidget.wrapperImage(images.first, [56, 56]),
                          {'crr': 8 * 2}),
                    if (images.isNotEmpty) PWidget.boxw(8),
                    PWidget.column([
                      PWidget.text(
                          '${item['productName']}\t|\t${item['productCode']}',
                          [aColor]),
                      PWidget.boxh(8),
                      PWidget.text('', [], {}, [
                        PWidget.textIs('标准单价：', [aColor.withOpacity(0.5), 12]),
                        PWidget.textIs('¥${item['price']}\t/\t${item['unit']}',
                            [pColor, 12]),
                      ]),
                    ], {
                      'exp': 1
                    }),
                    if (widget.isSelect)
                      PWidget.icon(
                        isContains
                            ? Icons.radio_button_checked_sharp
                            : Icons.radio_button_off,
                        [isContains ? pColor : aColor.withOpacity(0.25)],
                      ),
                  ]),
                  [null, null, Colors.white],
                  {
                    'fun': () {
                      if (widget.isSelect) {
                        setState(() {
                          if (isContains) {
                            selectValue.remove(item);
                          } else {
                            selectValue.add(item);
                          }
                        });
                      } else {
                        jumpPage(ChanpinInfo(item), callback: (v) {
                          if (v != null) this.getProductList(isRef: true);
                        });
                      }
                    },
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
