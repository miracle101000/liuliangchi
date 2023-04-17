import 'package:flutter/material.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';

import '../../../config/common_config.dart';
import '../../../paxis_fun.dart';
import '../../../view/views.dart';
import '../../home_tag_btn.dart';
import '../duanxin_page.dart';

///合同筛选组件
class HetongShaixuanWidget extends StatefulWidget {
  final Function(String)? callback;
  const HetongShaixuanWidget({Key? key, this.callback}) : super(key: key);
  @override
  _HetongShaixuanWidgetState createState() => _HetongShaixuanWidgetState();
}

class _HetongShaixuanWidgetState extends State<HetongShaixuanWidget> {
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
          HomeTagBtn('全部合同', size: 16, fun: () async {
            var res = await showSheet(builder: (_) {
              return ShaixuanPopup(
                  selectoList: selectoList,
                  valueList: ['全部合同', '我的合同', '我协作的合同']);
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
