import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:liuliangchi/util/paxis_fun.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/custom_scroll_physics.dart';
import 'package:paixs_utils/widget/my_bouncing_scroll_physics.dart';
import 'package:paixs_utils/widget/my_custom_scroll.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import '../../../config/common_config.dart';
import '../../../provider/provider_config.dart';
import '../page_model/page_model.dart';
import 'xiansuo_tab_child_page.dart';

Widget infoBtnView(text, fun, {exp = true}) {
  return PWidget.text(
      text, [pColor, 16], {'pd': 8, 'exp': exp, 'ct': true, 'fun': fun});
}

///打电话方法
void callFun(phone, data) {
  Request.post(
    '/app/callSeat/call',
    data: {
      "qj_companyId": userPro.qj_companyId,
      "qj_userId": userPro.qj_userId,
      "callee": phone,
      "dataSource": "1", //来源（1：线索 2：客户 3：联系人 4：号码管理 5:其他）
      "dataKey": data['id'],
      "dataKeyName": data['name'],
    },
    isLoading: true,
    catchError: (v) => showCustomToast(v),
    success: (v) => showCustomToast('请稍候'),
  );
}

class XiansuoInfo extends StatefulWidget {
  final Map data;
  const XiansuoInfo(this.data, {Key? key}) : super(key: key);
  @override
  _XiansuoInfoState createState() => _XiansuoInfoState();
}

class _XiansuoInfoState extends State<XiansuoInfo>
    with TickerProviderStateMixin {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    tabController = TabController(length: tabList.length, vsync: this);
    getClueDetail(isRef: true);
  }

  ///获取线索详情
  var clueDetailDm = DataModel<Map>(hasNext: false, object: {});
  Future<int> getClueDetail({int page = 1, bool isRef = false}) async {
    await Request.post(
      '/app/clue/getClueDetail',
      data: {
        "qj_companyId": userPro.qj_companyId,
        "qj_userId": userPro.qj_userId,
        "clueId": widget.data['id'],
      },
      catchError: (v) => clueDetailDm.toError(v),
      success: (v) {
        clueDetailDm.object = v['result'];
        clueDetailDm.setTime();
      },
    );
    setState(() {});
    return clueDetailDm.flag!;
  }

  TabController? tabController;
  var tabList = ['销售动态', '详情', '附件'];

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: ExtendedNestedScrollView(
        onlyOneScrollInBody: true,
        physics: MyBouncingScrollPhysics(),
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            elevation: 2,
            shadowColor: aColor.withOpacity(0.2),
            backgroundColor: Colors.white,
            foregroundColor: aColor,
            centerTitle: true,
            title: PWidget.text('线索详情', [aColor, 18, true]),
            flexibleSpace: FlexibleSpaceBar(
                background: objectBuilderView(builder: (obj) => headers(obj))),
            pinned: true,
            expandedHeight: 240,
            bottom: tabBar(),
          ),
        ],
        body: objectBuilderView(
          isShowInit: false,
          builder: (obj) => TabBarView(
            controller: tabController,
            physics: PagePhysics(),
            children: List.generate(tabList.length,
                (i) => XiansuoTabChildPage(i, tabList[i], data: obj)),
          ),
        ),
      ),
    );
  }

  Widget objectBuilderView(
      {bool isShowInit = true,
      Widget Function(Map<dynamic, dynamic>)? builder}) {
    return AnimatedSwitchBuilder<Map>(
      value: clueDetailDm,
      initialState: isShowInit ? null : PWidget.boxh(0),
      noDataView: isShowInit ? null : PWidget.boxh(0),
      errorView: isShowInit ? null : PWidget.boxh(0),
      errorOnTap: () => getClueDetail(),
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
        PWidget.spacer(),
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
      {'pd': PFun.lg(56 + pmPadd.top, 56, 16, 16)},
    );
  }

  PreferredSize tabBar() {
    return PreferredSize(
      preferredSize: Size(double.infinity, 48),
      child: Container(
        color: Colors.white,
        child: TabBar(
          controller: tabController,
          labelColor: pColor,
          unselectedLabelColor: aColor.withOpacity(0.75),
          indicatorColor: pColor,
          onTap: (i) => setState(() {}),
          tabs: List.generate(tabList.length, (i) {
            return Tab(child: Text(tabList[i]));
          }),
        ),
      ),
    );
  }
}
