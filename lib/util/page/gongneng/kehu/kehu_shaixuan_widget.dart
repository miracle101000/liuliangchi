import 'package:flutter/material.dart';
import 'package:liuliangchi/util/config/common_config.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';

import '../../../paxis_fun.dart';
import '../../../view/views.dart';
import '../../home_tag_btn.dart';
import '../duanxin_page.dart';

///客户筛选组件
class KehuShaixuanWidget extends StatefulWidget {
  final Function(String)? callback;
  const KehuShaixuanWidget({Key? key, this.callback}) : super(key: key);
  @override
  _KehuShaixuanWidgetState createState() => _KehuShaixuanWidgetState();
}

class _KehuShaixuanWidgetState extends State<KehuShaixuanWidget> {
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
          HomeTagBtn(selectoList.isEmpty ? '全部客户' : selectoList.join(),
              size: 16, fun: () async {
            var res = await showSheet(builder: (_) {
              return ShaixuanPopup(
                  selectoList: selectoList, valueList: ['全部客户', '我的客户']);
            });
            if (res != null) setState(() => selectoList = res);
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
