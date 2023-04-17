import 'dart:math';

import 'package:flutter/material.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import '../config/common_config.dart';
import '../paxis_fun.dart';
import '../view/views.dart';

///首页小按钮
class HomeTagBtn extends StatefulWidget {
  final String text;
  final double size;
  final Function? fun;

  const HomeTagBtn(this.text, {Key? key, this.fun, this.size = 12.0})
      : super(key: key);
  @override
  _HomeTagBtnState createState() => _HomeTagBtnState();
}

class _HomeTagBtnState extends State<HomeTagBtn> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return PWidget.container(
      PWidget.row([
        PWidget.text(
            widget.text, PFun.lg2(isOpen ? pColor : aColor, widget.size)),
        PWidget.boxw(4),
        isOpen
            ? bottomJtView(widget.size, pi * 1.5, pColor)
            : bottomJtView(widget.size),
      ]),
      {
        'pd': 12,
        'fun': () async {
          setState(() => isOpen = true);
          await widget.fun!();
          setState(() => isOpen = false);
        }
      },
    );
  }
}
