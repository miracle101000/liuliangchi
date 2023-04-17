import 'package:flutter/material.dart';
import 'package:liuliangchi/util/common_util.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import '../../config/common_config.dart';
import '../../login_page.dart';
import '../../provider/provider_config.dart';
import '../../view/views.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  var itemList = [
    '推送设置',
    '双卡轮拨',
    'SIM卡管理',
    '来电弹屏',
    '呼出快速写跟进',
    '注销账号',
    '退出企业',
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Color(0xFFF3F3F3),
      appBar: buildTitle(context, title: '设置', isWhiteBg: true),
      body: MyListView(
        isShuaxin: false,
        flag: false,
        itemCount: itemList.length + 1,
        dividerBuilder: (i) {
          if (i == itemList.length - 1) {
            return Divider(height: 8, color: Colors.transparent);
          } else {
            return Divider(height: 0);
          }
        },
        item: (i) {
          if (i == itemList.length) {
            return PWidget.container(
              PWidget.text('退出登录', [Colors.red], {'ct': true}),
              [null, null, Colors.white],
              {
                'pd': 12,
                'fun': () {
                  showTc(
                      title: '确定退出登录吗？',
                      onPressed: () {
                        userPro.cleanUserInfo();
                        jumpPage(PhoneLogin(), isClose: true, isMove: false);
                      });
                },
              },
            );
          } else {
            return PWidget.container(
              PWidget.row([
                PWidget.text(itemList[i], [aColor], {'exp': true}),
                rightJtView()
              ]),
              [null, null, Colors.white],
              {'pd': 16, 'fun': () => itemFun(itemList[i])},
            );
          }
        },
      ),
    );
  }

  void itemFun(name) {
    switch (name) {
      case '':
        break;
      default:
        showCustomToast('开发中');
        break;
    }
  }
}
