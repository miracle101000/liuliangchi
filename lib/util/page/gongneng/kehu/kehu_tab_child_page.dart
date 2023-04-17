import 'package:flutter/material.dart';

import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/config/common_config.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:liuliangchi/util/page/gongneng/duanxin_page.dart';

import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/my_bouncing_scroll_physics.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import '../../../paxis_fun.dart';
import '../../../provider/provider_config.dart';
import '../../../view/views.dart';
import '../page_model/page_model.dart';
import '../xiansuo/xiansuo_info.dart';

///客户详情子页面
class KehuTabChildPage extends StatefulWidget {
  final int index;
  final String title;
  final Map data;
  const KehuTabChildPage(this.index, this.title,
      {Key? key, this.data = const {}})
      : super(key: key);
  @override
  _KehuTabChildPageState createState() => _KehuTabChildPageState();
}

class _KehuTabChildPageState extends State<KehuTabChildPage>
    with AutomaticKeepAliveClientMixin {
  var infoItemList = [
    '姓名：',
    '公司名称：',
    '电话：',
    '跟进状态：',
    '负责人：',
    '创建人：',
    '所属部门：',
    '创建时间：',
    '更新于：'
  ];

  DataModel? _dataModel;
  Map<String, Future<int> Function()>? _errorOnTap;
  String? _errorMsg;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    if (widget.index == 0) getTrackHistoryList(isRef: true);
    if (widget.index == 2) getOpportunityListByCustomerId(isRef: true);
    if (widget.index == 3) getContractListByCustomerId(isRef: true);
  }

  ///获取销售动态
  var trackHistoryListDm = DataModel(hasNext: false);
  Future<int> getTrackHistoryList({int page = 1, bool isRef = false}) async {
    await Request.post(
      '/app/clue/getTrackHistoryList?page=$page',
      data: {
        "type": 2,
        "qj_companyId": userPro.qj_companyId,
        "qj_userId": userPro.qj_userId,
        "dataId": widget.data['key'],
      },
      catchError: (v) => trackHistoryListDm.toError(v),
      success: (v) => trackHistoryListDm.addListModel(v, isRef),
    );
    setState(() {});
    return trackHistoryListDm.flag!;
  }

  ///获取商机
  var opportunityListByCustomerListDm = DataModel(hasNext: false);
  Future<int> getOpportunityListByCustomerId(
      {int page = 1, bool isRef = false}) async {
    await Request.post(
      '/app/common/getOpportunityListByCustomerId?page=$page',
      data: {
        "qj_companyId": userPro.qj_companyId,
        "qj_userId": userPro.qj_userId,
        "customerId": widget.data['key'],
      },
      catchError: (v) => opportunityListByCustomerListDm.toError(v),
      success: (v) =>
          opportunityListByCustomerListDm.addList(v['result'], isRef, 0),
    );
    setState(() {});
    return opportunityListByCustomerListDm.flag!;
  }

  ///获取合同
  var contractListByCustomerListDm = DataModel(hasNext: false);
  Future<int> getContractListByCustomerId(
      {int page = 1, bool isRef = false}) async {
    await Request.post(
      '/app/common/getContractListByCustomerId?page=$page',
      data: {
        "qj_companyId": userPro.qj_companyId,
        "qj_userId": userPro.qj_userId,
        "customerId": widget.data['key'],
      },
      catchError: (v) => contractListByCustomerListDm.toError(v),
      success: (v) =>
          contractListByCustomerListDm.addList(v['result'], isRef, 0),
    );
    setState(() {});
    return contractListByCustomerListDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _dataModel = {
      '销售动态': trackHistoryListDm,
      '商机': opportunityListByCustomerListDm,
      '合同': contractListByCustomerListDm,
    }[widget.title];
    _errorOnTap = {
      '销售动态': () => getTrackHistoryList(isRef: true),
      '商机': () => getOpportunityListByCustomerId(isRef: true),
      '合同': () => getContractListByCustomerId(isRef: true),
    };
    _errorMsg = {
      '销售动态': trackHistoryListDm.msg,
      '商机': opportunityListByCustomerListDm.msg,
      '合同': contractListByCustomerListDm.msg,
    }[widget.title];
    if (widget.title == '详情') {
      return listviewView(
          (i) => infoView(widget.data)[i], infoView(widget.data).length);
    }
    return AnimatedSwitchBuilder(
      value: _dataModel!,
      errorOnTap: _errorOnTap![widget.title],
      isRef: true,
      noDataView: NoDataWidget("暂无${widget.title}"),
      errorView: NoDataWidget(_errorMsg!),
      initViewIsCenter: true,
      listBuilder: (list, p, h) => listviewView((i) {
        if (widget.index == 0) return xiaoshouDynamicView(list[i]);
        if (widget.index == 2) return shangjiItemView(list[i]);
        if (widget.index == 3) return hetongItemView(list[i]);
        return const SizedBox();
      }, list.length),
    );
  }

  Widget noDataView(errorText) {
    return NoDataWidget(
      errorText,
      // isNative: true,
      // isScroll: true,
      // onRefresh: () => getTrackHistoryList(isRef: true),
      // header: buildClassicHeader(text: errorText),
      // footer: buildCustomFooter(text: errorText),
    );
  }

  Widget listviewView(Widget Function(int) item, int itemCount) {
    return ListView.builder(
      physics: MyBouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (_, i) => item(i),
      itemCount: itemCount,
    );
    // return MyListView(
    //   isShuaxin: false,
    //   flag: false,
    //   controller: controller,
    //   isCloseOpacity: true,
    //   // padding: EdgeInsets.only(top: widget.height + 8, bottom: pmSize.height / 2),
    //   item: (i) => item(i),
    //   itemCount: itemCount,
    // );
  }

  ///销售动态
  Widget xiaoshouDynamicView(data) {
    return PWidget.container(
      PWidget.column([
        // PWidget.text('${[
        //   '${DateTime.parse(data['showDate']).year}年',
        //   '${DateTime.parse(data['showDate']).month}月',
        // ].join('')}'),
        PWidget.row([
          PWidget.ccolumn([
            PWidget.text(
                '${DateTime.parse(data['showDate']).month}月${DateTime.parse(data['showDate']).day}日',
                [aColor.withOpacity(0.75)]),
            PWidget.boxh(8),
            PWidget.text('${data['showDate']}'.split(' ').last,
                [aColor.withOpacity(0.5), 12]),
          ]),
          PWidget.boxw(12),
          PWidget.column([
            PWidget.text('${data['dataKeyName']}', [aColor, 16]),
            PWidget.boxh(16),
            PWidget.text('${data['content']}', [aColor, 12]),
          ]),
        ]),
      ]),
      [null, null, Colors.white],
      {
        'pd': 16,
      },
    );
  }

  ///详情
  List<Widget> infoView(data) {
    return List.generate(infoItemList.length, (i) {
      var item = infoItemList[i];
      return PWidget.container(
        PWidget.row([
          PWidget.container(
              PWidget.text(item, [aColor.withOpacity(0.5)]), [100]),
          PWidget.text(
            {
              '姓名：': data['name'],
              '公司名称：': data['firmName'],
              '电话：': data['firmPhone'],
              '跟进状态：': genjinStatus[data['trackStatus']] ?? '未知',
              '负责人：': data['head'],
              '创建人：': data['operateRealName'],
              '所属部门：': data['departmentName'],
              '创建时间：': data['showDate'],
              '更新于：': data['modifiyDate'],
            }[item],
            [aColor],
            {'exp': true},
          ),
          if (item == '电话：')
            PWidget.icon(
              Icons.sms_rounded,
              [pColor],
              {
                'pd': 8,
                'fun': () {
                  return showCustomToast('对接中');
                  if (isNotNull(data['firmPhone']) &&
                      isNotNull(data['firmMobile'])) {
                    ///两个都不为空
                  } else if (isNotNull(data['firmPhone'])) {
                    ///电话不为空
                  } else if (isNotNull(data['firmMobile'])) {
                    ///手机号不为空
                  }
                },
              },
            ),
          if (item == '电话：')
            PWidget.icon(
              Icons.call_rounded,
              [pColor],
              {
                'pd': 8,
                'fun': () async {
                  if (isNotNull(data['firmPhone']) &&
                      isNotNull(data['firmMobile'])) {
                    var res = await showSheet(
                        builder: (_) => ShaixuanPopup(valueList: [
                              data['firmPhone'],
                              data['firmMobile']
                            ]));
                    if (res != null) callFun(res[0], data);
                    //两个都不为空
                  } else if (isNotNull(data['firmPhone'])) {
                    //电话不为空
                    callFun(data['firmPhone'], data);
                  } else if (isNotNull(data['firmMobile'])) {
                    //手机号不为空
                    callFun(data['firmMobile'], data);
                  }
                },
              },
            ),
        ]),
        [null, null, Colors.white],
        {'pd': 16, 'bd': PFun.bdLg(aColor.withOpacity(0.05), 0, 1)},
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
