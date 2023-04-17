import 'package:flutter/material.dart';
import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/config/common_config.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:liuliangchi/util/view/xiansuo_view.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import '../../../paxis_fun.dart';
import '../../../view/views.dart';

class GenjinPage extends StatefulWidget {
  @override
  _GenjinPageState createState() => _GenjinPageState();
}

class _GenjinPageState extends State<GenjinPage> {
  ///跟进类型选择的list
  var genjinTypeSelectoList = ['电话', 'QQ', '微信', '拜访', '邮件', '短信', '其他'];
  var genjinStateSelectoList = ['初访', '意向', '报价', '成交', '暂时搁置'];
  var genjinType = [];
  var genjinState = [];
  var shiJiGenJinShiJian;
  var xiaCiGenJinShiJian;
  var genjinTextCon = TextEditingController();
  var guanlianRen;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: '写跟进', isWhiteBg: true),
      btnBar: btnBarView(context),
      body: MyListView(
        isShuaxin: false,
        flag: false,
        item: (i) => item[i],
        itemCount: item.length,
        touchBottomAnimationValue: 0.5,
        touchBottomAnimationOpacity: 50,
        divider: Divider(color: Colors.transparent, height: 10),
      ),
    );
  }

  Widget btnBarView(BuildContext context) {
    return PWidget.container(
      PWidget.row([
        PWidget.text('保存草稿', [pColor, 16], {'exp': true, 'ct': true}),
        PWidget.container(
          PWidget.text('保存', [Colors.white, 16], {'ct': true}),
          [null, null, pColor],
          {
            'exp': true,
            'fun': () {
              if (genjinType == null) return showCustomToast('请选择跟进类型');
              if (shiJiGenJinShiJian == null)
                return showCustomToast('请选择实际跟进时间');
              Request.post('/app/clue/addTrackHistory',
                  data: {},
                  isLoading: true,
                  catchError: (v) => showCustomToast(v),
                  success: (v) {},
                  context: context);
              // addTrackHistory
            },
          },
        ),
      ]),
      [null, 48, Colors.white],
      {'sd': PFun.sdLg(Colors.black12, 4)},
    );
  }

  List<Widget> get item {
    return [
      PWidget.column([
        itemTypeView('跟进类型', genjinType, genjinTypeSelectoList,
            callback: (res) => setState(() => genjinType = res)),
        dividerView(),
        itemTimeView('实际跟进时间', shiJiGenJinShiJian,
            callback: (date) => setState(() => shiJiGenJinShiJian = date)),
      ]),
      PWidget.container(
        PWidget.column([
          buildTFView(
            context,
            hintText: '勤跟进，勤记录，请输入新的跟进记录',
            maxLines: 5,
            con: genjinTextCon,
            height: null,
          ),
          Wrap(spacing: 16, children: [
            iconBtnView('录音', icon: Icons.keyboard_voice_rounded),
            iconBtnView('图片', icon: Icons.crop_original_rounded),
            iconBtnView('定位', icon: Icons.location_pin),
          ]),
        ]),
        [null, null, Colors.white],
        {'pd': PFun.lg(16, 16, 24, 24)},
      ),
      PWidget.column([
        itemView('客户', selectValue: '客户', callback: () async {}),
        dividerView(),
        itemView('关联联系人', selectValue: guanlianRen, callback: () {}),
      ]),
      PWidget.column([
        itemTypeView('跟进状态', genjinState, genjinStateSelectoList,
            isRequired: false,
            callback: (res) => setState(() => genjinState = res)),
        dividerView(),
        itemTimeView('下次跟进时间', xiaCiGenJinShiJian,
            callback: (date) => setState(() => xiaCiGenJinShiJian = date),
            isRequired: false),
      ]),
      itemView('同步划入公海', isRequired: false),
      itemView('通知他人', isRequired: false),
    ];
  }
}
