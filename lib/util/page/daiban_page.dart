import 'package:flutter/material.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import '../widget/tab_widget.dart';
import 'daiban/daiban_child.dart';
import 'daiban/xiaoxi_page.dart';

///代办页面
class DaibanPage extends StatefulWidget {
  @override
  _DaibanPageState createState() => _DaibanPageState();
}

class _DaibanPageState extends State<DaibanPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar:
          buildTitle(context, title: '代办', isWhiteBg: true, isNoShowLeft: true),
      body: TabWidget(
        tabList: ['代办', '消息中心'],
        isScrollable: false,
        tabPage: [DaibanChild(), XiaoxiPage()],
      ),
    );
  }
}
