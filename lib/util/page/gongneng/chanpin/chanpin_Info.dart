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
import 'package:paixs_utils/widget/wrapImg_widget.dart';

import '../../../config/common_config.dart';
import '../../../paxis_fun.dart';
import '../../../provider/provider_config.dart';
import '../xiansuo/xiansuo_info.dart';
import 'add_chanpin_page.dart';

///产品详情
class ChanpinInfo extends StatefulWidget {
  final Map data;
  const ChanpinInfo(this.data, {Key? key}) : super(key: key);
  @override
  _ChanpinInfoState createState() => _ChanpinInfoState();
}

class _ChanpinInfoState extends State<ChanpinInfo> {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    getProductDetail(isRef: true);
  }

  ///获取产品列表
  var productDetailDm = DataModel(hasNext: false);
  Future<int> getProductDetail({int page = 1, bool isRef = false}) async {
    await Request.post(
      '/app/product/getProductDetail',
      data: {
        "qj_companyId": userPro.qj_companyId,
        "qj_userId": userPro.qj_userId,
        "productId": widget.data['id']
      },
      catchError: (v) => productDetailDm.toError(v),
      success: (v) {
        productDetailDm.object = v['result'];
        productDetailDm.setTime();
      },
    );
    setState(() {});
    return productDetailDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: '产品详情'),
      btnBar: PWidget.container(
        PWidget.row([
          infoBtnView('编辑', () {
            jumpPage(AddChanpinPage(data: productDetailDm.object),
                callback: (v) {
              if (v != null) this.getProductDetail();
            });
          }),
          infoBtnView('删除', () {
            showTc(
              title: '确认删除？',
              onPressed: () {
                Request.post(
                  '/app/product/deleteProduct',
                  data: {
                    "qj_companyId": userPro.qj_companyId,
                    "qj_userId": userPro.qj_userId,
                    "dataIds": widget.data['id']
                  },
                  isLoading: true,
                  catchError: (v) => showCustomToast(v),
                  success: (v) {
                    showCustomToast('删除成功');
                    close(true);
                  },
                );
              },
            );
          }),
        ]),
        [null, 48, Colors.white],
      ),
      body: AnimatedSwitchBuilder(
        value: productDetailDm,
        initViewIsCenter: true,
        errorOnTap: () => this.getProductDetail(isRef: true),
        objectBuilder: (dynamic v) {
          return MyListView(
            isShuaxin: false,
            flag: false,
            padding: EdgeInsets.symmetric(vertical: 8),
            itemCount: itemList.length,
            divider: Divider(height: 0),
            item: (i) {
              return PWidget.container(
                PWidget.row([
                  PWidget.container(
                    PWidget.text('${itemList[i]}', [aColor.withOpacity(0.5)]),
                    [100],
                  ),
                  PWidget.container(
                    Builder(builder: (context) {
                      if (itemList[i] == '产品图片：') {
                        return WrapImgWidget(
                            imgs: isNotNull(v[itemValueList[i]])
                                ? '${v[itemValueList[i]]}'.split(',')
                                : [],
                            remove: 48 + 100.0,
                            radius: 4);
                      }
                      return PWidget.text('${v[itemValueList[i]] ?? ''}',
                          [aColor.withOpacity(0.75)], {'isOf': false});
                    }),
                    {'exp': true},
                  ),
                ]),
                [null, null, Colors.white],
                {
                  'pd': PFun.lg(12, 12, 24, 24),
                },
              );
            },
          );
        },
      ),
    );
  }

  var itemList = [
    '产品名称：',
    '产品编号：',
    '标准单价：',
    '销售单位：',
    '单位成本：',
    '毛利率：',
    '规格：',
    '产品分类：',
    '产品图片：',
    '产品介绍：',
    '创建时间：',
    '更新于：',
  ];

  var itemValueList = [
    'productName',
    'productCode',
    'price',
    'unit',
    'unitCost',
    'grossProfitRate',
    '',
    '',
    'image',
    'description',
    'showDate',
    'showDate',
  ];
}
