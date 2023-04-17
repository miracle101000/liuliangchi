import 'package:flutter/material.dart';
import 'package:flutter_my_picker/common/date.dart';
import 'package:flutter_my_picker/flutter_my_picker.dart';
import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/view/views.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import '../config/common_config.dart';
import '../page/gongneng/duanxin_page.dart';
import '../paxis_fun.dart';

///时间选择器
Widget itemTimeView(title, selectValue,
    {Function(dynamic)? callback, bool isRequired = true}) {
  return itemView(title,
      selectValue: MyDate.format('yyyy-MM-dd hh:mm', selectValue),
      isRequired: isRequired, callback: () {
    MyPicker.showDateTimePicker(
      context: context,
      color: aColor,
      current: DateTime.now(),
      onConfirm: (date) => callback!(date),
    );
  });
}

///类型选择器
Widget itemTypeView(title, List selectoList, List valueList,
    {bool isRequired = true, Function(dynamic)? callback}) {
  return itemView(title,
      selectValue: selectoList.join(),
      isRequired: isRequired, callback: () async {
    var res = await showSheet(builder: (_) {
      return ShaixuanPopup(valueList: valueList, selectoList: selectoList);
    });
    if (isNotNull(res)) callback!(res);
  });
}

///小按钮
Widget iconBtnView(key, {icon}) {
  return PWidget.icon(icon, [
    aColor.withOpacity(0.25)
  ], {
    'fun': () {
      switch (key) {
        case '录音':
          break;
        case '图片':
          break;
        case '定位':
          break;
      }
    },
  });
}

Widget dividerView() => Divider(height: 0, indent: 24);

Widget itemView(
  title, {
  bool isRequired = false,
  bool isInput = false,
  Widget? textInputView,
  TextEditingController? inputCon,
  bool isSelect = true,
  String? selectValue,
  String? hint,
  Function? callback,
  double vPd = 12.0,
  double hPd = 24.0,
}) {
  return PWidget.container(
    PWidget.row([
      PWidget.column([
        PWidget.row([
          PWidget.text(title, [aColor.withOpacity(0.5), 12]),
          if (isRequired) PWidget.text('\t*', [Colors.red]),
        ]),
        PWidget.boxh(8),
        if (isInput)
          textInputView ??
              buildTFView(context,
                  con: inputCon, hintText: hint ?? '请输入$title'),
        if (isSelect)
          PWidget.text(
              isNotNull(selectValue) ? selectValue : hint ?? '请选择$title',
              [aColor.withOpacity(0.75)]),
      ], {
        'exp': 1
      }),
      if (isSelect) rightJtView(),
    ]),
    [null, null, Colors.white],
    {'pd': PFun.lg(vPd, vPd, hPd, hPd), 'fun': callback},
  );
}
