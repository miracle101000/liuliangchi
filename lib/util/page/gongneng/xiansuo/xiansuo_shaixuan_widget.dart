import 'package:flutter/material.dart';
import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/page/gongneng/duanxin_page.dart';
import 'package:liuliangchi/util/paxis_fun.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';

import '../../../config/common_config.dart';
import '../../../view/views.dart';
import '../../home_tag_btn.dart';

class XiansuoShaixuanWidget extends StatefulWidget {
  final Function(String)? callback;
  const XiansuoShaixuanWidget({Key? key, this.callback}) : super(key: key);
  @override
  _XiansuoShaixuanWidgetState createState() => _XiansuoShaixuanWidgetState();
}

class _XiansuoShaixuanWidgetState extends State<XiansuoShaixuanWidget> {
  var selectoList = [];
  var sousuoSelectoList = [];
  var searchKey = '';
  bool isExpanded = false;

  var textCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PWidget.container(
      PWidget.column([
        PWidget.row([
          HomeTagBtn('全部', size: 16, fun: () async {
            var res = await showSheet(builder: (_) {
              return ShaixuanPopup(
                  selectoList: selectoList,
                  valueList: ['全部线索', '我的线索', '已转化的线索']);
            });
            if (res != null) setState(() => selectoList = res);
            return showCustomToast('开发中');
          }),
          PWidget.spacer(),
          PWidget.icon(
            Icons.search_rounded,
            [isExpanded ? pColor : aColor.withOpacity(0.5)],
            {'fun': () => setState(() => isExpanded = !isExpanded)},
          ),
        ]),
        PWidget.container(
          PWidget.row([
            // HomeTagBtn('姓名', fun: () async {
            //   var res = await showSheet(builder: (_) {
            //     return ShaixuanPopup(selectoList: sousuoSelectoList, valueList: ['姓名']);
            //   });
            //   if (res != null) setState(() => sousuoSelectoList = res);
            // }),
            PWidget.container(
              PWidget.row([
                buildTFView(context, textInputAction: TextInputAction.search,
                    onSubmitted: (v) {
                  widget.callback!(v);
                }, onChanged: (_) {
                  setState(() {});
                }, hintText: '请输入任意关键字', con: textCon, isExp: true),
                if (textCon.text.isNotEmpty)
                  PWidget.icon(
                    Icons.close_rounded,
                    [aColor.withOpacity(0.5), 20],
                    {
                      'pd': 8,
                      'fun': () {
                        textCon.clear();
                        setState(() {});
                        widget.callback!('');
                      },
                    },
                  ),
              ]),
              [null, 40, aColor.withOpacity(0.05)],
              {'exp': true, 'crr': 4 * 3, 'pd': PFun.lg(0, 0, 8, 8)},
            ),
            PWidget.boxw(8),
            PWidget.text(
              textCon.text.isEmpty ? '取消' : '搜索',
              [aColor, 16],
              {
                'pd': 8,
                'fun': () {
                  if (textCon.text.isEmpty) {
                    setState(() => isExpanded = !isExpanded);
                  } else {
                    widget.callback!(textCon.text);
                  }
                }
              },
            ),
          ]),
          [null, isExpanded ? 56 : 0, Colors.white],
          {'pd': 8},
        ),
      ]),
      [null, null, Colors.white],
      {
        'pd': PFun.lg(0, 0, 8, 8),
      },
    );
  }
}
