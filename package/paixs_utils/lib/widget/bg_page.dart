import 'package:flutter/material.dart';

class BgPage extends StatefulWidget {
  final Widget child;

  const BgPage(this.child, {Key? key}) : super(key: key);
  @override
  _BgPageState createState() => _BgPageState();
}

class _BgPageState extends State<BgPage> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
    // return Stack(
    //   children: [
    //     PWidget.container(
    //       null,
    //       [null,null,Theme.of(context).scaffoldBackgroundColor],
    //     ),
    //     PWidget.container(
    //       null,
    //       [pmSize.width, pmSize.width, Colors.green],
    //       {'br': pmSize.width},
    //     ),
    //     ClipRect(
    //       child: BackdropFilter(
    //         filter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
    //         child: PWidget.container(
    //           null,
    //           [null, null, Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7)],
    //           // [null, null, Colors.red.withOpacity(0.5)],
    //         ),
    //       ),
    //     ),
    //     widget.child,
    //   ],
    // );
  }
}
