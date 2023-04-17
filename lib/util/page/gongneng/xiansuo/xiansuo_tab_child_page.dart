import 'package:flutter/material.dart';
import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:liuliangchi/util/paxis_fun.dart';
import 'package:liuliangchi/util/view/views.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/my_bouncing_scroll_physics.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/refresher_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import '../../../config/common_config.dart';
import '../../../provider/provider_config.dart';
import '../page_model/page_model.dart';
import 'xiansuo_info.dart';

class XiansuoTabChildPage extends StatefulWidget {
  final int index;
  final String title;
  final Map data;
  const XiansuoTabChildPage(this.index, this.title,
      {Key? key, this.data = const {}})
      : super(key: key);
  @override
  _XiansuoTabChildPageState createState() => _XiansuoTabChildPageState();
}

class _XiansuoTabChildPageState extends State<XiansuoTabChildPage>
    with AutomaticKeepAliveClientMixin {
  var infoItemList = [
    '姓名：',
    '公司名称：',
    '电话：',
    '手机号：',
    '跟进状态：',
    '负责人：',
    '创建人：',
    '所属部门：',
    '创建时间：',
    '更新于：'
  ];

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    getTrackHistoryList(isRef: true);
  }

  ///获取销售动态
  var trackHistoryListDm = DataModel(hasNext: false);
  Future<int> getTrackHistoryList({int page = 1, bool isRef = false}) async {
    await Request.post(
      '/app/clue/getTrackHistoryList?page=$page',
      data: {
        "type": 1,
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

  DataModel? _dataModel;
  Map<String, Future<int> Function()>? _errorOnTap;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _dataModel = {
      '销售动态': trackHistoryListDm,
      '附件': trackHistoryListDm,
      '任务': trackHistoryListDm
    }[widget.title];
    _errorOnTap = {
      '销售动态': () => getTrackHistoryList(isRef: true),
      '附件': () => getTrackHistoryList(isRef: true),
      '任务': () => getTrackHistoryList(isRef: true),
    };
    _errorMsg = {
      '销售动态': trackHistoryListDm.msg,
      '附件': trackHistoryListDm.msg,
      '任务': trackHistoryListDm.msg
    }[widget.title];

    return ScaffoldWidget(
      // btnBar: btnBarView(),
      body: Builder(builder: (_) {
        ///渲染对应的页面
        if (widget.title == '详情')
          return listviewView(
              (i) => infoView(widget.data)[i], infoView(widget.data).length);
        return AnimatedSwitchBuilder(
          value: _dataModel!,
          errorOnTap: _errorOnTap![widget.title],
          isRef: true,
          noDataView: NoDataWidget("暂无${widget.title}"),
          errorView: NoDataWidget(_errorMsg!),
          initViewIsCenter: true,
          listBuilder: (list, p, h) {
            return listviewView(
                (i) => xiaoshouDynamicView(list[i]), list.length);
          },
        );
      }),
    );
  }

  ///底部操作按钮
  Widget btnBarView() {
    return PWidget.container(
      PWidget.row([
        // if (widget.title == '销售动态') infoBtnView('写跟进', () => jumpPage(GenjinPage())),
        // if (widget.title == '销售动态') infoBtnView('转成新客户', () {}),
        if (widget.title == '销售动态')
          infoBtnView('更多', () {
            showSelectoBtn(context, isDark: false, texts: [
              // '转成已有客户',
              // '编辑',
              // '拜访签到',
              '转移给他人',
              '转到线索池',
              // '发短信',
              '删除',
            ], callback: (s, i) {
              showCustomToast('对接中');
            });
          }),
        if (widget.title == '详情')
          infoBtnView('编辑', () => showCustomToast('对接中')),
        if (widget.title == '附件')
          infoBtnView('新增', () => showCustomToast('对接中')),
        // if (widget.title == '任务') infoBtnView('新增', () => showCustomToast('对接中')),
      ]),
      [null, 48, Colors.white],
      {'sd': PFun.sdLg(Colors.black12)},
    );
  }

  Widget listviewView(Widget Function(int) item, int itemCount) {
    return RefresherWidget(
      isShuaxin: true,
      onRefresh: _errorOnTap![widget.title],
      // isGengduo: _dataModel.hasNext,
      // onLoading: _errorOnTap[widget.title],
      child: ListView.builder(
        physics: MyBouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (_, i) => item(i),
        itemCount: itemCount,
      ),
    );
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
                  '手机号：': data['firmMobile'],
                  '跟进状态：': genjinStatus[data['trackStatus']] ?? '未知',
                  '负责人：': data['head'],
                  '创建人：': data['operateRealName'],
                  '所属部门：': data['departmentName'],
                  '创建时间：': data['showDate'],
                  '更新于：': data['modifiyDate'],
                }[item] ??
                '',
            [aColor],
            {'exp': true},
          ),
          if (['电话：'].contains(item) && isNotNull(data['firmPhone']))
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
          if (['手机号：'].contains(item) && isNotNull(data['firmMobile']))
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
          if (['电话：'].contains(item) && isNotNull(data['firmPhone']))
            PWidget.icon(
              Icons.call_rounded,
              [pColor],
              {
                'pd': 8,
                'fun': () async {
                  // flog(isNotNull(data['firmPhone']) && isNotNull(data['firmMobile']));
                  // return;
                  if (isNotNull(data['firmPhone'])) {
                    //电话不为空
                    callFun(data['firmPhone'], data);
                  } else {
                    showCustomToast('暂无电话');
                  }
                },
              },
            ),
          if (['手机号：'].contains(item) && isNotNull(data['firmMobile']))
            PWidget.icon(
              Icons.call_rounded,
              [pColor],
              {
                'pd': 8,
                'fun': () async {
                  // flog(isNotNull(data['firmPhone']) && isNotNull(data['firmMobile']));
                  // return;
                  if (isNotNull(data['firmMobile'])) {
                    //手机号不为空
                    callFun(data['firmMobile'], data);
                  } else {
                    showCustomToast('暂无电话');
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
