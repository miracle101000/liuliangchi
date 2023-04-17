import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/custom_scroll_physics.dart';
import 'package:paixs_utils/widget/my_bouncing_scroll_physics.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import '../../../config/common_config.dart';
import '../../../paxis_fun.dart';
import '../../../provider/provider_config.dart';
import '../page_model/page_model.dart';
import 'kehu_tab_child_page.dart';

///打电话方法
// void callFun(phone, data) {
//   Request.post(
//     '/app/callSeat/call',
//     data: {
//       "qj_companyId": userPro.qj_companyId,
//       "qj_userId": userPro.qj_userId,
//       "callee": phone,
//       "dataSource": "1", //来源（1：线索 2：客户 3：联系人 4：号码管理 5:其他）
//       "dataKey": data['id'],
//       "dataKeyName": data['name'],
//     },
//     isLoading: true,
//     catchError: (v) => showCustomToast(v),
//     success: (v) => showCustomToast('请稍候'),
//   );
// }

class KehuInfo extends StatefulWidget {
  final Map data;
  const KehuInfo(this.data, {Key? key}) : super(key: key);
  @override
  _KehuInfoState createState() => _KehuInfoState();
}

class _KehuInfoState extends State<KehuInfo> with TickerProviderStateMixin {
  TabController? tabController;
  List get tabList => [
        '销售动态',
        '详情',
        // '联系人',
        // '写作人',
        '商机',
        '合同',
        // '费用',
        // '任务',
        // '附件',
        // '下级客户',
        // '线索',
      ];

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    tabController = TabController(length: tabList.length, vsync: this);
    getCustomerDetail(isRef: true);
  }

  ///获取客户详情
  var customerDetailDm = DataModel<Map>(hasNext: false, object: {});
  Future<int> getCustomerDetail({int page = 1, bool isRef = false}) async {
    await Request.post(
      '/app/customer/getCustomerDetail',
      data: {
        "qj_companyId": userPro.qj_companyId,
        "qj_userId": userPro.qj_userId,
        "customerId": widget.data['id'],
      },
      catchError: (v) => customerDetailDm.toError(v),
      success: (v) {
        customerDetailDm.object = v['result'] ?? {};
        customerDetailDm.setTime();
      },
    );
    setState(() {});
    return customerDetailDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      // appBar: buildTitle(context, title: '客户详情', isWhiteBg: true),
      // btnBar: btnBarView(),
      body: ExtendedNestedScrollView(
        onlyOneScrollInBody: true,
        physics: MyBouncingScrollPhysics(),
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: aColor,
            centerTitle: true,
            title: PWidget.text('客户详情', [aColor, 18, true]),
            // flexibleSpace: headers(obj),
            flexibleSpace: FlexibleSpaceBar(
                background: objectBuilderView(builder: (obj) => headers(obj)),
                collapseMode: CollapseMode.pin),
            pinned: true,
            expandedHeight: 200,
            bottom: PreferredSize(
                child: tabBar(), preferredSize: Size(double.infinity, 48)),
          ),
        ],
        body: objectBuilderView(
          isShowInit: false,
          builder: (obj) => TabBarView(
            controller: tabController,
            physics: PagePhysics(),
            children: List.generate(tabList.length,
                (i) => KehuTabChildPage(i, tabList[i], data: obj)),
          ),
        ),
      ),
    );
  }

  // ///底部操作按钮
  // Widget btnBarView() {
  //   if (customerDetailDm.object.isEmpty) return PWidget.boxh(0);
  //   return PWidget.container(
  //     PWidget.row([
  //       if (tabController.index == 0)
  //         infoBtnView('写跟进', () {
  //           jumpPage(GenjinPage());
  //         }),
  //       if (tabController.index == 0) infoBtnView('转成新客户', () {}),
  //       if (tabController.index == 0)
  //         infoBtnView('更多', () {
  //           showSelectoBtn(context, isDark: false, texts: ['转成已有客户', '编辑', '拜访签到', '转移给他人', '转到线索池', '发短信', '删除'], callback: (s, i) {
  //             showCustomToast('对接中');
  //           });
  //         }),
  //       if (tabController.index == 1) infoBtnView('编辑', () => showCustomToast('对接中')),
  //       if (tabController.index == 2) infoBtnView('新增', () => showCustomToast('对接中')),
  //       if (tabController.index == 3) infoBtnView('新增', () => showCustomToast('对接中')),
  //     ]),
  //     [null, 48, Colors.white],
  //     {'sd': PFun.sdLg(Colors.black12)},
  //   );
  // }

  // Widget infoBtnView(text, fun) {
  //   return PWidget.text(text, [pColor, 16], {'pd': 8, 'exp': true, 'ct': true, 'fun': fun});
  // }

  Widget objectBuilderView(
      {bool isShowInit = true,
      Widget Function(Map<dynamic, dynamic>)? builder}) {
    return AnimatedSwitchBuilder<Map>(
      value: customerDetailDm,
      initialState: isShowInit ? null : PWidget.boxh(0),
      noDataView: isShowInit ? null : PWidget.boxh(0),
      errorView: isShowInit ? null : PWidget.boxh(0),
      errorOnTap: () => getCustomerDetail(),
      initViewIsCenter: true,
      objectBuilder: (obj) {
        if (!isShowInit && obj.isEmpty) return PWidget.boxh(0);
        return builder!(obj);
      },
    );
  }

  Widget headers(item) {
    return PWidget.container(
      PWidget.column([
        PWidget.text('${item['name']}', [aColor]),
        PWidget.spacer(),
        PWidget.text('', [], {}, [
          if (isNotNull(item['head']))
            PWidget.textIs('${item['head']}', [aColor.withOpacity(0.5), 12]),
          if (isNotNull(item['departmentName']))
            PWidget.textIs('\t|\t', [aColor.withOpacity(0.5), 12]),
          if (isNotNull(item['departmentName']))
            PWidget.textIs('${item['departmentName']}', [aColor, 12]),
        ]),
        PWidget.spacer(),
        cardLineText('公司名字', '${item['firmName']}'),
        PWidget.spacer(),
        PWidget.row([
          cardLineText('下次跟进', '${item['nextTrackDate'] ?? '--'}'),
          PWidget.spacer(),
          PWidget.container(
            PWidget.text(
                genjinStatus[item['trackStatus']] ?? '未知', [pColor, 12]),
            [null, null, pColor.withOpacity(0.25)],
            {'pd': PFun.lg(2, 2, 8, 8), 'br': 4},
          ),
        ]),
      ]),
      [null, null, Colors.white],
      {'pd': PFun.lg(56 + pmPadd.top, 48, 16, 16)},
    );
  }

  ///选项卡
  Widget tabBar() {
    return Container(
      child: TabBar(
        controller: tabController,
        labelColor: pColor,
        physics: MyBouncingScrollPhysics(),
        // isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelColor: aColor.withOpacity(0.75),
        indicatorColor: pColor,
        // onTap: (i) => setState(() {}),
        tabs: List.generate(tabList.length, (i) {
          return Tab(child: Text(tabList[i]));
        }),
      ),
    );
  }
}
