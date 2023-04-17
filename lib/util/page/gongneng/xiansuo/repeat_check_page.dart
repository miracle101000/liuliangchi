import 'package:flutter/material.dart';

import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/config/common_config.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:liuliangchi/util/page/gongneng/duanxin_page.dart';
import 'package:liuliangchi/util/page/gongneng/xiansuo/xiansuo_info.dart';
import 'package:liuliangchi/util/paxis_fun.dart';
import 'package:liuliangchi/util/provider/provider_config.dart';
import 'package:liuliangchi/util/view/views.dart';

import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import '../page_model/page_model.dart';

// 查重页
class RepeatCheckPage extends StatefulWidget {
  @override
  _RepeatCheckPageState createState() => _RepeatCheckPageState();
}

class _RepeatCheckPageState extends State<RepeatCheckPage>
    with TickerProviderStateMixin {
  var tabs = ['客户', '线索', '联系人'];
  TabController? tabController;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      appBar: buildTitle(context, title: '查重'),
      body: Stack(children: [
        TabBarView(
            controller: tabController,
            children:
                List.generate(tabs.length, (i) => RepeatCheckChildPage(i))),
        PWidget.positioned(
          PWidget.container(
            TabBar(
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: pColor,
              labelColor: aColor,
              unselectedLabelColor: aColor.withOpacity(0.5),
              tabs: tabs.map((m) => Tab(child: Text(m))).toList(),
              controller: tabController,
            ),
            [null, 40],
            {'bd': PFun.bdLg(aColor.withOpacity(0.1), 0, 1)},
          ),
          [40 + 12 * 2 + 2, null, 0, 0],
        ),
      ]),
    );
  }
}

class RepeatCheckChildPage extends StatefulWidget {
  final int index;
  const RepeatCheckChildPage(this.index, {Key? key}) : super(key: key);
  @override
  _RepeatCheckChildPageState createState() => _RepeatCheckChildPageState();
}

class _RepeatCheckChildPageState extends State<RepeatCheckChildPage>
    with AutomaticKeepAliveClientMixin {
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
    super.build(context);
    var _dataModel = [clueListDm, clueListDm, clueListDm][widget.index];
    var _errorOnTap = [
      () => this.getClueList(isRef: true),
      () => this.getClueList(isRef: true),
      () => this.getClueList(isRef: true),
    ][widget.index];
    _onLoading(p) {
      return [
        () => this.getClueList(page: p),
        () => this.getClueList(isRef: true),
        () => this.getClueList(isRef: true),
      ][widget.index];
    }

    return PWidget.ccolumn([
      TextInputWidget(
        ['客户名称', '电话，手机', '联系人'][widget.index],
        onSubmitted: (v) {
          _dataModel.init();
          setState(() {});
          _errorOnTap();
        },
      ),
      AnimatedSwitchBuilder(
        value: _dataModel,
        errorOnTap: _errorOnTap,
        isExd: true,
        listBuilder: (list, p, h) {
          return MyListView(
            isGengduo: h,
            isOnlyMore: true,
            isShuaxin: false,
            itemCount: list.length,
            onLoading: _onLoading(p),
            item: (i) {
              return xiansuoItemView(list[i]);
            },
          );
        },
      ),
    ]);
  }

  ///线索item
  Widget xiansuoItemView(item) {
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
                      builder: (_) => ShaixuanPopup(
                          valueList: [item['firmPhone'], item['firmMobile']]));
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
          PWidget.text(genjinStatus[item['trackStatus']] ?? '未知', [aColor, 12],
              {'exp': true}),
          PWidget.text(
              item['trackDate'] == null
                  ? '1天未跟进'
                  : toTime(item['trackDate'], false),
              [aColor, 12]),
        ]),
      ]),
      [null, null, Colors.white],
      {'fun': () => jumpPage(XiansuoInfo(item)), 'pd': PFun.lg(12, 12, 24, 24)},
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TextInputWidget extends StatefulWidget {
  final String hintText;
  final void Function(String)? onSubmitted;
  const TextInputWidget(this.hintText, {Key? key, this.onSubmitted})
      : super(key: key);
  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  TextEditingController textCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return PWidget.container(
      PWidget.row([
        PWidget.icon(Icons.search, [aColor.withOpacity(0.25)],
            {'pd': PFun.lg(0, 0, 8, 8)}),
        buildTFView(
          context,
          hintText: widget.hintText,
          isExp: true,
          height: null,
          con: textCon,
          onSubmitted: widget.onSubmitted,
          onChanged: (v) => setState(() {}),
        ),
        if (textCon.text.isNotEmpty)
          PWidget.text('搜索', [
            pColor
          ], {
            'pd': PFun.lg(8, 8, 16, 16),
            'fun': () => widget.onSubmitted!(textCon.text)
          }),
      ]),
      [null, 48],
      {
        'bd': PFun.bdAllLg(aColor.withOpacity(0.1)),
        'mg': PFun.lg(12, 12 + 40, 12, 12),
        'br': 24,
        'ph': true
      },
    );
  }
}
