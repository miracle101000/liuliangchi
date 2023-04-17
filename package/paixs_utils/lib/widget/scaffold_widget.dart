import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util/utils.dart';
import '../widget/views.dart';

class ScaffoldWidget extends StatefulWidget {
  final Widget? appBar;
  final String? title;
  final Widget? body;
  final Widget? btnBar;
  final Widget? drawer;
  final Widget? bottomSheet;
  final Brightness brightness;
  final Color? bgColor;
  final bool resizeToAvoidBottomInset;

  const ScaffoldWidget({
    Key? key,
    this.appBar,
    this.body,
    this.btnBar,
    this.brightness = Brightness.dark,
    this.title,
    this.bgColor,
    this.resizeToAvoidBottomInset = true,
    this.drawer,
    this.bottomSheet,
  }) : super(key: key);
  @override
  _ScaffoldWidgetState createState() => _ScaffoldWidgetState();
}

class _ScaffoldWidgetState extends State<ScaffoldWidget> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: widget.brightness,
        statusBarColor: Colors.transparent,
        statusBarBrightness:
            Brightness.values[widget.brightness.index == 1 ? 0 : 1],
        // systemNavigationBarColor: Colors.white,
      ),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: handleGlowNotification,
        child: Container(
          child: SafeArea(
            top: false,
            child: Scaffold(
              // resizeToAvoidBottomInset: true,
              resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
              backgroundColor:
                  widget.bgColor ?? (Theme.of(context).scaffoldBackgroundColor),
              body: Column(children: <Widget>[
                if (widget.appBar == null)
                  widget.title != null
                      ? buildTitle(context,
                          title: widget.title!, isNoShowLeft: true)
                      : SizedBox()
                else
                  widget.appBar!,
                Expanded(child: widget.body ?? SizedBox()),
                // if (widget.resizeToAvoidBottomInset)
                //   if (widget.btnBar != null) widget.btnBar!,
              ]),
              drawer: widget.drawer,
              bottomSheet: widget.bottomSheet,
              bottomNavigationBar:
                  widget.resizeToAvoidBottomInset ? null : widget.btnBar,
            ),
          ),
        ),
      ),
    );
  }
}
