import 'package:flutter/material.dart';

import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';
import 'package:provider/provider.dart';

import '../provider/app_provider.dart';
import '../provider/provider_config.dart';

class BnbWidget extends StatefulWidget {
  final Function(int)? callback;

  const BnbWidget({Key? key, this.callback}) : super(key: key);
  @override
  _BnbWidgetState createState() => _BnbWidgetState();
}

class _BnbWidgetState extends State<BnbWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(bottom: pmPadd.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: const Border(top: const BorderSide(color: Colors.black12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Row(
              children: <Widget>[
                buildBtb('工作台', 0),
                buildBtb('代办', 1),
                buildBtb('功能', 2),
                buildBtb('我', 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBtb(text, _index) {
    var container = Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      // height: 56,
      alignment: Alignment.center,
      child: Selector<AppProvider, int>(
        selector: (_, k) => k.btmIndex,
        builder: (_, v, view) {
          return Column(
            children: [
              Container(
                width: 24,
                height: 24,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      curve: Curves.easeOutCubic,
                      duration: const Duration(milliseconds: 200),
                      top: v == _index ? -56 : 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedOpacity(
                        opacity: v == _index ? 0 : 1,
                        curve: Curves.linear,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          [
                            Icons.home_work_rounded,
                            Icons.date_range_rounded,
                            Icons.find_in_page,
                            Icons.person,
                          ][_index],
                          color: Colors.grey,
                        ),
                        // child: Image.asset(
                        //   [
                        //     'assets/img/home/new/home_1.png',
                        //     'assets/img/home/new/home_2.png',
                        //     'assets/img/home/new/home_2.png',
                        //     'assets/img/home/new/home_3.png',
                        //     'assets/img/home/new/home_4.png',
                        //   ][_index],
                        //   width: 24,
                        //   height: 24,
                        //   color: Colors.grey,
                        // ),
                      ),
                    ),
                    AnimatedPositioned(
                      curve: Curves.easeOutCubic,
                      duration: const Duration(milliseconds: 200),
                      top: v != _index ? 56 : 0,
                      left: 0,
                      right: 0,
                      // bottom: 0,
                      child: AnimatedOpacity(
                        opacity: v != _index ? 0 : 1,
                        curve: Curves.linear,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          [
                            Icons.home_work_rounded,
                            Icons.date_range_rounded,
                            Icons.find_in_page,
                            Icons.person,
                          ][_index],
                          color: Theme.of(context).primaryColor,
                        ),
                        // child: Image.asset(
                        //   [
                        //     'assets/img/home/new/home_1.png',
                        //     'assets/img/home/new/home_2.png',
                        //     'assets/img/home/new/home_2.png',
                        //     'assets/img/home/new/home_3.png',
                        //     'assets/img/home/new/home_4.png',
                        //   ][_index],
                        //   width: 24,
                        //   height: 24,
                        //   color: Theme.of(context).primaryColor,
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              MyText(
                text,
                size: 12,
                color:
                    _index == v ? Theme.of(context).primaryColor : Colors.grey,
              ),
            ],
          );
        },
      ),
    );

    // var dituView = Image.asset('assets/img/ditu/红包卡券 @2x.png', width: 40);
    return Expanded(
      child: WidgetTap(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // if (_index == 3 || _index == 2) {
          //   if (user != null) {
          //     widget.callback(_index);
          //     app.changeBtmIndex(_index);
          //   } else {
          //     jumpPage(PassWordLogin(), isMoveBtm: true);
          //     showCustomToast('请先登录');
          //     return;
          //   }
          // } else {
          ///除首页以外的判断
          // if (_index != 0 && user == null) {
          //   return jumpPage(PhoneLogin());
          // }

          ///收益判断
          // if (_index == 3 && user['isHasWallet'] != (kDebugMode ? 1 : 1)) {
          //   return jumpPage(ShenqingPage(), callback: (v) {
          //     if (v != null) {
          //       widget.callback(_index);
          //       app.changeBtmIndex(_index);
          //     }
          //   });
          // }
          widget.callback!(_index);
          app.changeBtmIndex(_index);
          // }
        },
        child: container,
      ),
    );
  }
}
