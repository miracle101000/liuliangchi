import 'package:flutter/material.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import '../../config/common_config.dart';
import '../../paxis_fun.dart';
import '../gongneng/duanxin_page.dart';
import '../home_tag_btn.dart';

class XiaoxiPage extends StatefulWidget {
  @override
  _XiaoxiPageState createState() => _XiaoxiPageState();
}

class _XiaoxiPageState extends State<XiaoxiPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: PWidget.container(
        PWidget.row([
          HomeTagBtn(
            '全部消息',
            fun: () {
              showSheet(builder: (_) {
                return ShaixuanPopup(
                  selectoList: [],
                  valueList: [
                    '全部消息',
                    '任务提醒',
                    '线索/线索池',
                    '客户/客户公海',
                    '评论',
                    '公司公告',
                    '搜客宝',
                  ],
                );
              });
            },
          ),
          PWidget.spacer(),
          PWidget.container(
            PWidget.row([
              PWidget.icon(Icons.cleaning_services_rounded,
                  [aColor.withOpacity(0.5), 12]),
              PWidget.boxw(4),
              PWidget.text('全部标为已读', PFun.lg2(aColor.withOpacity(0.5), 12)),
            ]),
            {'pd': 12},
          ),
        ]),
        [null, null, sbColor],
      ),
    );
  }
}
