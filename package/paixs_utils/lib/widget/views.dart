import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/progress_indicator.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/widget_tap.dart';
import '../model/data_model.dart';
import '../util/utils.dart';
import '../widget/sheet_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'CPicker_widget.dart';
import 'anima_switch_widget.dart';
import 'button.dart';
import 'inkbtn_widget.dart';
import 'my_classicHeader.dart' as myh;
import 'mylistview.dart';
import 'mytext.dart';
import 'paixs_widget.dart';
import 'progress_indicator.dart';
import 'route.dart';
import 'widget_tap.dart';

///
///全局可用的小功能
///

///分割线
const divider = Divider(
  color: Color(0x10000000),
  thickness: 1,
  indent: 18,
  height: 0,
  endIndent: 18,
);

///屏幕宽高
Size size(context) => MediaQuery.of(context).size;

///屏幕顶部和底部
EdgeInsets padd(context) => MediaQuery.of(context).padding;

///屏幕宽高
Size get pmSize => MediaQuery.of(context).size;

///屏幕顶部和底部
EdgeInsets get pmPadd => MediaQuery.of(context).padding;

///选择器
Future showSelecto(
  BuildContext context, {
  void Function(String, int)? callback,
  List texts = const ['不限', '1~3', '3~5'],
  int index = 0,
}) {
  var value = texts.first;
  FocusScope.of(context).requestFocus(FocusNode());
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.75),
    builder: (_) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Container(
          height: size(context).height / 3,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        '取消',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff999999),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        debugPrint(index.toString());
                        debugPrint(value.toString());
                        callback!(value.toString(), index);
                      },
                      child: Text(
                        '确认',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CPickerWidget(
                  backgroundColor: Colors.white,
                  scrollController:
                      FixedExtentScrollController(initialItem: index),
                  onSelectedItemChanged: (i) {
                    index = i;
                    value = texts[i];
                  },
                  children: texts.map((v) {
                    return Text(
                      v.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

///选择器
Future showSelectoBtn(
  BuildContext context, {
  void Function(String, int)? callback,
  List texts = const ['不限', '1~3', '3~5'],
  List<Widget> icons = const [],
  bool isDark = true,
  dynamic value,
}) {
  // var value = texts.first;
  // var index = 0;
  FocusScope.of(context).requestFocus(FocusNode());
  return showSheet(
    // context: context,
    // backgroundColor: Colors.transparent,
    builder: (_) {
      return ClipPath(
        clipper: const ShapeBorderClipper(
            shape: ContinuousRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16 * 2.5)))),
        child: Container(
          // height: size(context).width / 1.5,
          color: isDark ? const Color(0xFF545454) : Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MyListView(
                isShuaxin: false,
                flag: !false,
                listViewType: ListViewType.Separated,
                divider: Divider(
                    height: 0, color: isDark ? Colors.white10 : Colors.black12),
                itemCount: texts.length,
                animationDelayed: 0,
                animationType: AnimationType.close,
                physics: const NeverScrollableScrollPhysics(),
                item: (i) {
                  return WidgetTap(
                    // isElastic: true,
                    onTap: () {
                      close();
                      callback!(texts[i], i);
                    },
                    child: Opacity(
                      opacity:
                          value == null ? 1 : (value == texts[i] ? 1 : 0.25),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            icons.length >= texts.length
                                ? icons[i]
                                : PWidget.boxw(0),
                            MyText(
                              texts[i],
                              size: 16,
                              color: !isDark
                                  ? const Color(0xFF545454)
                                  : Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Divider(
                height: 0,
                thickness: 4,
                color: isDark
                    ? Colors.white.withOpacity(0.025)
                    : Colors.black.withOpacity(0.025),
              ),
              WidgetTap(
                isElastic: true,
                onTap: () => close(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: isDark ? const Color(0xFF545454) : Colors.white,
                  alignment: Alignment.center,
                  child: MyText('取消',
                      size: 16,
                      color: !isDark ? const Color(0xFF545454) : Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

///选择器
Future showPopup(
  BuildContext context, {
  void Function(List)? callback,
  List<Widget>? children,
}) {
  FocusScope.of(context).requestFocus(FocusNode());
  return showSheetWidget(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Stack(
        children: <Widget>[
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => pop(context),
              child: Container(),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: children!,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

///选择器
Future showSelectoindex(
  BuildContext context, {
  void Function(String)? callback,
  List texts = const ['不限', '1~3', '3~5'],
}) {
  var value = 0;
  FocusScope.of(context).requestFocus(FocusNode());
  return showModalBottomSheet(
    context: context,
    builder: (_) {
      return SizedBox(
        height: 200,
        child: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      '取消',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      callback!(value.toString());
                    },
                    child: Text(
                      '确认',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 48,
                magnification: 1.25,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                onSelectedItemChanged: (i) => value = i,
                children: texts.map((v) {
                  return Center(
                    child: Text(
                      v.toString(),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    },
  );
}

///记录sheet
List sheetLog = [];

///底部悬浮菜单
Future<dynamic> showSheet({
  List<Widget> children = const <Widget>[],
  Widget Function(ScrollController?)? builder,
  bool? isScrollControlled,
  bool isDraggableList = !true,
  bool isClose = false,
  Color? barrierColor,
}) {
  FocusScope.of(context).requestFocus(FocusNode());
  return showModalBottomSheet(
    context: context,
    isDismissible: !isClose,
    enableDrag: !isClose,
    backgroundColor: Colors.transparent,
    barrierColor: barrierColor ?? Colors.black.withOpacity(0.75),
    isScrollControlled: isScrollControlled ?? true,
    builder: (_) {
      return WillPopScope(
        child: builder!(null),
        onWillPop: () async => !isClose,
      );
    },
  );
}

///加载框
buildShowDialog(
  context, {
  isClose = false,
  String? text,
}) {
  FocusScope.of(context).requestFocus(FocusNode());
  return showDialog(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: isClose, //x点击空白关闭
    builder: (_) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Center(
            child: CircularProgressIndicatorWidget(
              strokeWidth: 3,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        if (text != null) const SizedBox(height: 8),
        if (text != null) MyText(text.toString(), color: Colors.white)
      ],
    ),
  );
}

///加载框
Widget buildLoad({
  ///大小
  double size = 24,
  double radius = 10,

  ///粗细
  double width = 2,

  ///是否居中
  bool isCenter = true,

  ///颜色
  Color? color,
}) {
  if (isCenter) {
    // return Center(
    //   child: CupertinoActivityIndicator(radius: radius),
    // );
    return Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: Center(
          child: CircularProgressIndicatorWidget(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
                color ?? Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  } else {
    // return CupertinoActivityIndicator(radius: radius);
    return SizedBox(
      height: 24,
      width: 24,
      child: Center(
        child: CircularProgressIndicatorWidget(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}

Widget buildBallPulse({
  Color color = Colors.white54,
  double height = 32,
}) {
  return SizedBox(
    height: height,
    child: SizedBox(
      height: 24,
      width: 24,
      child: Center(
        child: CircularProgressIndicatorWidget(
          strokeWidth: 3,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    ),
    // child: LoadingIndicator(
    //   color: color,
    //   colors: [color],
    //   indicatorType: Indicator.circleStrokeSpin,
    // ),
  );
}

///上拉加载更多的底部
CustomFooter buildCustomFooter({
  Color? color,
  String? text,
}) {
  color = color ?? Theme.of(context).primaryColor;
  var dataModel = DataModel(flag: 3);
  return CustomFooter(
    builder: (BuildContext context, LoadStatus? mode) {
      Widget? body;
      if (mode == LoadStatus.idle) {
        body = Text("上拉加载更多",
            style: TextStyle(color: color), key: const ValueKey(1));
      } else if (mode == LoadStatus.loading) {
        body = SizedBox(
          height: 16,
          width: 16,
          child: Center(
            child: CircularProgressIndicatorWidget(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(color!.withOpacity(1)),
            ),
          ),
        );
      } else if (mode == LoadStatus.canLoading) {
        body =
            Text("松开", style: TextStyle(color: color), key: const ValueKey(2));
      } else if (mode == LoadStatus.failed) {
        body = Text(text ?? "加载失败", style: TextStyle(color: color));
      } else if (mode == LoadStatus.noMore) {
        body = Text("松开", style: TextStyle(color: color));
      }
      return SizedBox(
        height: 56,
        child: AnimatedSwitchBuilder(
          value: dataModel,
          alignment: Alignment.center,
          defaultBuilder: () => body!,
          errorOnTap: () async {
            return 0;
          },
        ),
      );
    },
  );
}

///下拉刷新的头部
buildClassicHeader({
  Color? color,
  String? text,
}) {
  color = color ?? Theme.of(context).primaryColor;
  return myh.MyClassicHeader(
    height: 56.0,
    textStyle: TextStyle(color: color),
    releaseText: '松开刷新',
    releaseIcon: null,
    completeText: '刷新成功',
    completeIcon: null,
    failedText: text ?? '刷新失败',
    failedIcon: null,
    idleText: '下拉刷新',
    // outerBuilder: (v) {
    //   return Container(
    //     child: Column(children: [Text('data'), v]),
    //     padding: EdgeInsets.symmetric(vertical: 16),
    //   );
    // },
    idleIcon: null,
    refreshingText: null,
    refreshStyle: RefreshStyle.Follow,
    // refreshingIcon: Container(
    //   height: 24,
    //   child: LoadingIndicator(
    //     color: color.withOpacity(0.5),
    //     colors: [color.withOpacity(0.5)],
    //     indicatorType: Indicator.circleStrokeSpin,
    //   ),
    // ),
    refreshingIcon: SizedBox(
      height: 16,
      width: 16,
      child: Center(
        child: CircularProgressIndicatorWidget(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color.withOpacity(1)),
        ),
      ),
    ),
  );
}

///初始化显示的试图
Center buildNoDataOrInitView(isInit, [text = '暂无数据', key]) {
  return Center(
    key: ValueKey(key),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (isInit)
          const Column(
            children: <Widget>[
              CupertinoActivityIndicator(radius: 8),
              SizedBox(height: 8),
            ],
          ),
        Text(
          isInit ? '请稍候' : text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    ),
  );
}

///初始化显示的试图
Center buildNoDataOrInitView2(isInit, Function() callbackgowuche,
    [text = '暂无数据', key]) {
  return Center(
    key: ValueKey(key),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (isInit)
          const Column(
            children: <Widget>[
              CupertinoActivityIndicator(radius: 8),
              SizedBox(height: 8),
            ],
          ),
        if (!isInit)
          Image.asset(
            'assets/img/mao@2x.png',
            width: 187,
            height: 153,
          ),
        const SizedBox(height: 16),
        if (!isInit)
          const SizedBox(
            height: 20,
          ),
        Text(
          isInit ? '请稍候' : text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black54),
        ),
        if (!isInit)
          const SizedBox(
            height: 20,
          ),
        if (!isInit)
          GestureDetector(
            onTap: callbackgowuche,
            // app.pageCon.jumpToPage(0);
            // app.changeIndex(0);
            // closePage(count: app.spFlag);

            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 100),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: const BoxDecoration(
                  color: Color(0xffE7011D),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: const MyText("马上去购物", color: Colors.white),
            ),
          )
      ],
    ),
  );
}

///标题栏
Widget buildTitle(
  BuildContext context, {
  Color bwColor = const Color(0x00ffffff),
  Color widgetColor = Colors.black,
  Widget? rigthWidget,
  Widget? leftIcon,
  String title = '标题',
  Function()? rightCallback,
  Function? leftCallback,
  bool isHongBao = false,
  bool isNoShowLeft = !true,
  bool isTitleBold = true,
  int s = 0,
  Color? color,
  bool isShowBorder = false,
  bool isAnima = false,
  bool isWhiteBg = true,
  bool isTransparentBg = false,
  double sigma = 0.0,
}) {
  color = Theme.of(context).primaryColor;
  if (isWhiteBg) {
    widgetColor = Colors.black.withOpacity(0.8);
  } else {
    widgetColor = Colors.white;
  }
  return sigma == 0.0
      ? AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: isTransparentBg
                ? Colors.transparent
                : (isWhiteBg ? Colors.white : null),
            gradient: isTransparentBg
                ? null
                : (isWhiteBg
                    ? null
                    : const LinearGradient(
                        colors: [Color(0xffFB8931), Color(0xffF95A22)])),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: padd(context).top),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: isShowBorder
                          ? Colors.black.withOpacity(0.05)
                          : Colors.transparent,
                    ),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: <Widget>[
                    if (!isNoShowLeft)
                      Stack(
                        children: <Widget>[
                          if (isHongBao)
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: Row(
                                children: <Widget>[
                                  InkBtn(
                                    bwColor: bwColor,
                                    onTap: () {
                                      if (leftCallback == null) {
                                        Navigator.pop(context);
                                      } else {
                                        leftCallback();
                                      }
                                    },
                                    child: RouteState.isFromDown
                                        ? const Icon(Icons.close_rounded)
                                        : SvgPicture.asset(
                                            'package/paixs_utils/assets/svg/back.svg',
                                          ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(56),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      alignment: Alignment.center,
                                      color: widgetColor,
                                      child: MyText('$s'),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: IconButton(
                                splashColor: bwColor,
                                icon: leftIcon ??
                                    (RouteState.isFromDown
                                        ? Icon(
                                            Icons.close_rounded,
                                            color: widgetColor,
                                          )
                                        : SvgPicture.asset(
                                            'package/paixs_utils/assets/svg/back.svg',
                                            width: 20,
                                            height: 20,
                                            color: widgetColor,
                                          )),
                                onPressed: () {
                                  if (leftCallback == null) {
                                    Navigator.pop(context);
                                  } else {
                                    leftCallback();
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    if (rigthWidget != null)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: rightCallback,
                            radius: 20,
                            child: Container(
                              alignment: Alignment.center,
                              // padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: rigthWidget,
                            ),
                          ),
                        ),
                      ),
                    if (isNoShowLeft || RouteState.isFromDown)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 56),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children:
                                  List.generate(title.split('').length, (i) {
                                return Text(
                                  title.split('')[i],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: widgetColor,
                                    fontWeight: isTitleBold
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      )
                    else
                      Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children:
                                List.generate(title.split('').length, (i) {
                              return Text(
                                title.split('')[i],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: widgetColor,
                                  fontWeight: isTitleBold
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: WidgetTap(
                    //     isElastic: true,
                    //     child: Padding(
                    //       padding: EdgeInsets.all(16.0),
                    //       child: Icon(
                    //         Icons.account_circle_outlined,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        )
      : ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              color: color,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: padd(context).top),
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: isShowBorder
                              ? Colors.black12
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: <Widget>[
                        if (!isNoShowLeft)
                          Stack(
                            children: <Widget>[
                              if (isHongBao)
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Row(
                                    children: <Widget>[
                                      InkBtn(
                                        bwColor: bwColor,
                                        onTap: () {
                                          if (leftCallback == null) {
                                            Navigator.pop(context);
                                          } else {
                                            leftCallback();
                                          }
                                        },
                                        child: RouteState.isFromDown
                                            ? const Icon(Icons.close_rounded)
                                            : SvgPicture.asset(
                                                'package/paixs_utils/assets/svg/back.svg',
                                              ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(56),
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          alignment: Alignment.center,
                                          color: widgetColor,
                                          child: MyText('$s'),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: IconButton(
                                    splashColor: bwColor,
                                    icon: leftIcon ??
                                        (RouteState.isFromDown
                                            ? Icon(
                                                Icons.close_rounded,
                                                color: widgetColor,
                                              )
                                            : SvgPicture.asset(
                                                'package/paixs_utils/assets/svg/back.svg',
                                                width: 20,
                                                height: 20,
                                                color: widgetColor,
                                              )),
                                    onPressed: () {
                                      if (leftCallback == null) {
                                        Navigator.pop(context);
                                      } else {
                                        leftCallback();
                                      }
                                    },
                                  ),
                                ),
                            ],
                          ),
                        if (rigthWidget != null)
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: rightCallback,
                                radius: 20,
                                child: Container(
                                  alignment: Alignment.center,
                                  // padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: rigthWidget,
                                ),
                              ),
                            ),
                          ),
                        if (isNoShowLeft || RouteState.isFromDown)
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 56),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    List.generate(title.split('').length, (i) {
                                  return Text(
                                    title.split('')[i],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: widgetColor,
                                      fontWeight: isTitleBold
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          )
                        else
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 56),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    List.generate(title.split('').length, (i) {
                                  return Text(
                                    title.split('')[i],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: widgetColor,
                                      fontWeight: isTitleBold
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        // Center(
                        //   child: Padding(
                        //     padding: EdgeInsets.symmetric(horizontal: 56),
                        //     child: Text(
                        //       title,
                        //       maxLines: 1,
                        //       overflow: TextOverflow.ellipsis,
                        //       style: TextStyle(
                        //         fontSize: 20,
                        //         color: widgetColor,
                        //         fontWeight: isTitleBold ? FontWeight.bold : FontWeight.normal,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: WidgetTap(
                        //     isElastic: true,
                        //     child: Padding(
                        //       padding: EdgeInsets.all(16.0),
                        //       child: Icon(
                        //         Icons.account_circle_outlined,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
}

Future showTc({
  String? title,
  String? content,
  String cancelText = '取消',
  String okText = '确定',
  Color? okColor,
  Color? bgColor,
  bool isDark = false,
  bool isAutoClose = true,
  bool isTips = false,
  bool isClose = true,
  bool isCenter = true,
  double? lineH,
  bool isAlign = false,
  Widget? titleWidget,
  required Function() onPressed,
}) {
  FocusScope.of(context).requestFocus(FocusNode());
  return showGeneralDialog(
    context: context,
    barrierLabel: "你好",
    barrierColor:
        bgColor ?? (isMobile ? Colors.black.withOpacity(0.5) : Colors.black12),
    transitionDuration: const Duration(milliseconds: 200),
    transitionBuilder: (_, a1, a2, child) {
      switch (a1.status) {
        case AnimationStatus.reverse:
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(a1),
            // child: ScaleTransition(
            //   scale: Tween(begin: 1.1, end: 1.0).animate(a1),
            //   child: child,
            // ),
            child: isAlign
                ? child
                : ScaleTransition(
                    scale: Tween(begin: 1.05, end: 1.0).animate(a1),
                    child: child),
          );
          break;
        default:
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(a1),
            child: isAlign
                ? child
                : ScaleTransition(
                    scale: Tween(begin: 0.9, end: 1.0).animate(CurvedAnimation(
                        parent: a1, curve: Curves.easeOutCubic)),
                    child: child),
          );
      }
    },
    pageBuilder: (_, a1, ___) {
      return WillPopScope(
        onWillPop: () => Future(() => isClose),
        child: GestureDetector(
          onTap: () {
            if (isClose) pop(context);
          },
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 24 : size(context).width / 3),
                  child: Container(
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        const BoxShadow(
                          blurRadius: 24,
                          spreadRadius: -8,
                          color: Colors.black26,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: AlignWHTransition(
                      alignment: Alignment.center,
                      wh: CurvedAnimation(
                        parent: Tween(begin: 0.15, end: 1.0).animate(a1),
                        curve: Curves.easeOutCubic,
                      ),
                      isOpen: isAlign,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (title != null)
                            Padding(
                              // padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16)
                              padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 24,
                                  bottom: content == null ? 24 : 16),
                              child: MyText(
                                title,
                                size: 18,
                                isBold: true,
                                isOverflow: false,
                                color: isDark
                                    ? Colors.white
                                    : Colors.black.withOpacity(0.8),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (titleWidget != null)
                            Padding(
                              // padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16)
                              padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 24,
                                  bottom: content == null ? 24 : 16),
                              child: titleWidget,
                            ),
                          if (content != null)
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 32,
                                  top: title == null && titleWidget == null
                                      ? 32
                                      : 0),
                              child: MyText(
                                content,
                                isBold: true,
                                color: (isDark ? Colors.white : Colors.black)
                                    .withOpacity(0.5),
                                isOverflow: false,
                                height: lineH,
                                textAlign: isCenter
                                    ? TextAlign.center
                                    : TextAlign.left,
                              ),
                            ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            color: isDark
                                ? Colors.white10
                                : const Color(0x10000000),
                          ),
                          Row(
                            children: <Widget>[
                              if (!isTips)
                                Expanded(
                                  child: Button(
                                    height: 48,
                                    onPressed: () => pop(context, 0),
                                    child: MyText(
                                      cancelText,
                                      isBold: true,
                                      size: 16,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              if (!isTips)
                                Container(
                                    height: 32,
                                    width: 1,
                                    color: isDark
                                        ? Colors.white10
                                        : const Color(0x10000000)),
                              Expanded(
                                child: Button(
                                  height: 48,
                                  onPressed: () {
                                    if (isAutoClose) pop(context, 1);
                                    onPressed();
                                  },
                                  child: MyText(
                                    okText,
                                    isBold: true,
                                    size: 16,
                                    color: okColor ??
                                        Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

///Align宽高转换
class AlignWHTransition extends AnimatedWidget {
  const AlignWHTransition({
    Key? key,
    required Animation<double> wh,
    this.alignment = Alignment.center,
    this.child,
    this.isOpen = false,
  })  : assert(wh != null),
        super(key: key, listenable: wh);
  Animation<double> get wh => listenable as Animation<double>;
  final Alignment alignment;
  final Widget? child;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final double whValue = wh.value;
    if (isOpen) {
      return Align(
        alignment: alignment,
        heightFactor: whValue,
        widthFactor: whValue,
        child: child,
      );
    } else {
      return child!;
    }
  }
}

///小图
String getSmall([w = 100]) => ''; //?x-oss-process=image/resize,w_$w

///大图
String getBig([w = 500]) => ''; //?x-oss-process=image/resize,w_$w

Future showTcWidget({
  bool isClose = true,
  Widget? child,
  double? horizontal,
  bool isRadius = true,
  bool isBgColor = false,
  bool isAnima = true,
  bool isNormal = false,
  Alignment alignment = Alignment.centerLeft,
}) {
  FocusScope.of(context).requestFocus(FocusNode());
  return showGeneralDialog(
    context: context,
    barrierLabel: "hello flutter",
    barrierColor: isBgColor
        // ? Colors.black.withOpacity(0.1)
        ? [
            Colors.white.withOpacity(0.0),
            Colors.black.withOpacity(0.0),
          ][Theme.of(context).brightness.index]
        : isMobile
            ? Colors.black54
            : [
                Colors.white.withOpacity(0.0),
                Colors.black.withOpacity(0.0),
              ][Theme.of(context).brightness.index],
    transitionDuration:
        Duration(milliseconds: isMobile ? 200 : (isNormal ? 200 : 400)),
    transitionBuilder: (_, a1, a2, child) {
      if (!isAnima) {
        switch (a1.status) {
          case AnimationStatus.reverse:
            return FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(a1),
              child: child,
            );
            break;
          default:
            return FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(a1),
              child: child,
            );
        }
      }
      if (isNormal) {
        switch (a1.status) {
          case AnimationStatus.reverse:
            return FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(a1),
              // child: ScaleTransition(
              child: SlideTransition(
                position:
                    Tween(begin: const Offset(0, 0.1), end: const Offset(0, 0))
                        .animate(a1),
                child: child,
              ),
            );
            break;
          default:
            return FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(a1),
              // child: ScaleTransition(
              child: SlideTransition(
                position: Tween(
                  // begin: !isMobile ? 0.5 : 1.5,
                  begin: const Offset(0, 0.1),
                  end: const Offset(0, 0),
                ).animate(
                  CurvedAnimation(parent: a1, curve: Curves.ease),
                ),
                child: child,
              ),
            );
        }
      } else {
        return !RouteState.isShowMenuAnimation
            ? SlideTransition(
                position: CurvedAnimation(
                  parent: a1,
                  curve: Curves.easeOutCubic,
                  reverseCurve: Curves.easeInCubic,
                ).drive(
                  Tween(
                    begin: {
                      Alignment.centerLeft: Offset(-(300 / pmSize.width), 0),
                      Alignment.centerRight: Offset(300 / pmSize.width, 0),
                      Alignment.topCenter:
                          Offset(0, -(pmSize.height / 3 + 10) / pmSize.height),
                      Alignment.bottomCenter:
                          Offset(0, -(pmSize.height / 3 + 10) / pmSize.height),
                    }[alignment],
                    end: const Offset(0, 0),
                  ),
                ),
                child: child,
              )
            : SlideTransition(
                position: CurvedAnimation(
                  parent: a1,
                  curve: Curves.easeOutCubic,
                  reverseCurve: Curves.easeInCubic,
                ).drive(
                  Tween(
                    begin: {
                      Alignment.centerLeft: Offset(-(300 / pmSize.width), 0),
                      Alignment.centerRight: Offset(300 / pmSize.width, 0),
                      Alignment.topCenter:
                          Offset(0, -(pmSize.height / 3 + 10) / pmSize.height),
                      Alignment.bottomCenter:
                          Offset(0, (pmSize.height / 5) / pmSize.height),
                    }[alignment],
                    end: const Offset(0, 0),
                  ),
                ),
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: a1,
                    curve: Curves.easeOutCubic,
                    reverseCurve: Curves.easeInCubic,
                  ).drive(Tween(begin: 0.0, end: 1.0)),
                  child: child,
                ),
              );
      }
    },
    // transitionBuilder: (_, a1, a2, child) {
    //   switch (a1.status) {
    //     case AnimationStatus.reverse:
    //       return FadeTransition(
    //         opacity: Tween(begin: 1.0, end: 1.0).animate(a1),
    //         // child: ScaleTransition(
    //         //   scale: Tween(begin: 0.8, end: 1.0).animate(a1),
    //         //   child: child,
    //         // ),
    //         child: SlideTransition(
    //           position: Tween(
    //             begin: {
    //               Alignment.centerLeft: Offset(-(310 / pmSize.width), 0),
    //               Alignment.centerRight: Offset((310 / pmSize.width), 0),
    //               Alignment.topCenter: Offset(0, -(pmSize.height / 3 + 10) / pmSize.height),
    //             }[alignment],
    //             end: Offset(0, 0),
    //           ).animate(CurvedAnimation(parent: a1, curve: Curves.easeInCubic)),
    //           child: child,
    //         ),
    //       );
    //       break;
    //     default:
    //       return FadeTransition(
    //         opacity: Tween(begin: 1.0, end: 1.0).animate(a1),
    //         child: SlideTransition(
    //           position: Tween(
    //             begin: {
    //               Alignment.centerLeft: Offset(-(310 / pmSize.width), 0),
    //               Alignment.centerRight: Offset((310 / pmSize.width), 0),
    //               Alignment.topCenter: Offset(0, -(pmSize.height / 3 + 10) / pmSize.height),
    //             }[alignment],
    //             end: Offset(0, 0),
    //           ).animate(CurvedAnimation(parent: a1, curve: Curves.easeOutCubic)),
    //           child: child,
    //         ),
    //       );
    //   }
    // },
    pageBuilder: (_, __, ___) {
      return Listener(
        onPointerDown: (event) {
          if (event.kind == PointerDeviceKind.mouse &&
              event.buttons == kSecondaryMouseButton) close();
        },
        child: WillPopScope(
          onWillPop: () => Future(() => isClose),
          child: GestureDetector(
            onTap: () {
              if (isClose) close();
            },
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontal ?? 24.0),
                  child: isRadius
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: child,
                        )
                      : child,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future showTc1({
  String? title,
  String? content,
  String cancelText = '取消',
  String okText = '确定',
  Color? okColor,
  bool isClose = true,
  bool isNoCancel = false,
  List<Widget> children = const [],
  String? image,
  double? imgHeight,
  double? imgWidth,
  int type = 0, //0：带图片的弹窗，1：纯文本弹窗
  bool isExp = false,
  bool isCenter = false,
  EdgeInsets? padding,
  bool isImg = false,
  Function()? onPressed,
}) {
  return showGeneralDialog(
    context: context,
    barrierLabel: "你好",
    barrierColor: Colors.black45,
    barrierDismissible: !isClose,
    // transitionDuration: Duration(milliseconds: 500),
    // transitionBuilder: (_, a1, a2, child) {
    //   return FadeTransition(
    //     opacity: a1.drive(CurveTween(curve: Interval(0.25, 0.5))),
    //     child: ScaleTransition(
    //       scale: a1.drive(CurveTween(curve: ElasticOutCurve(1.75))),
    //       child: child,
    //     ),
    //   );
    // },
    pageBuilder: (_, __, ___) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () => pop(context),
          child: Material(
            color: Colors.black.withOpacity(0.0),
            child: Center(
              child: GestureDetector(
                onTap: isImg ? () => close() : () {},
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (isExp)
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: isImg ? 0 : 15),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      MyListView(
                                        isShuaxin: false,
                                        itemCount: children.length,
                                        listViewType:
                                            ListViewType.SeparatedExpanded,
                                        padding: padding ??
                                            onlyEdgeInset(
                                                0,
                                                type == 0
                                                    ? imgHeight! / 3 + 16
                                                    : 16,
                                                0,
                                                type == 0 ? 40 : 16),
                                        // physics: NeverScrollableScrollPhysics(),
                                        divider: const Divider(
                                            height: 16,
                                            color: Colors.transparent),
                                        item: (i) => children[i],
                                      ),
                                      if (type == 0)
                                        Button(
                                          onPressed: () {
                                            close();
                                            onPressed!();
                                          },
                                          isFill: true,
                                          radius: 56,
                                          width: double.infinity,
                                          fillColor: const Color(0xffFFD102),
                                          child: MyText(okText,
                                              size: 15, isBold: true),
                                        ),
                                      if (type == 0) const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                color: Colors.white,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: isImg ? 0 : 15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    MyListView(
                                      isShuaxin: false,
                                      itemCount: children.length,
                                      listViewType: ListViewType.Separated,
                                      // padding: padding ?? onlyEdgeInset(0, type == 0 ? imgHeight / 3 + 16 : 16, 0, type == 0 ? 40 : 16),
                                      // physics: NeverScrollableScrollPhysics(),
                                      divider: const Divider(
                                          height: 16,
                                          color: Colors.transparent),
                                      item: (i) {
                                        if (isCenter) {
                                          return Center(child: children[i]);
                                        } else {
                                          return children[i];
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

////标题点击查看更多/双向标题
Widget buildTitleRight({
  String text = '月销售排行',
  void Function()? onTap,
  bool isBold = true,
  Widget? rightChild,
  Widget? leftChild,
  Color? bgColor,
  double topheight = 16.0,
  double height = 16.0,
  double width = 16.0,
  double leftPadd = 16.0,
  double rightPadd = 16.0,
}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: onTap!,
    child: Container(
      alignment: Alignment.center,
      color: bgColor,
      padding: EdgeInsets.only(
          top: height, bottom: height, left: leftPadd, right: rightPadd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (leftChild == null)
            MyText(
              text,
              size: 16,
              isBold: isBold,
            )
          else
            leftChild,
          if (rightChild == null)
            Transform.rotate(
              angle: pi,
              child: SvgPicture.asset(
                'package/paixs_utils/assets/svg/back.svg',
                width: 16,
                height: 16,
                color: Colors.black26,
              ),
            )
          else
            rightChild,
        ],
      ),
    ),
  );
}

///两个文字组合
Widget buildTwoText({
  String leftText = '5级',
  String nullValue = '暂无',
  dynamic rightText = '广州创客股份有限公司',
  Color leftColor = Colors.black,
  Color rightColor = Colors.grey,
}) {
  return MyText(
    '$leftText\t:\t',
    nullValue: nullValue,
    color: leftColor,
    isOverflow: false,
    children: [
      MyText.ts(
        rightText.toString(),
        color: rightColor,
        nullValue: nullValue,
      ),
    ],
  );
}

///圆角输入框
Widget buildTextField({
  double height = 33.0,
  bool enabled = true,
  Color bgColor = const Color(0x10000000),
  String hint = '请输入',
  TextEditingController? con,
  bool isExd = true,
  bool isBig = false,
  bool isRight = false,
  bool isLeft = false,
  bool isTran = false,
  int maxLines = 10,
  double? fontSize,
  Color borderColor = const Color(0x10000000),
  void Function()? onEditingComplete,
  void Function(String)? onSubmitted,
  void Function(String)? onChanged,
  TextInputAction? textInputAction,
  List<TextInputFormatter>? inputFormatters,
  int? maxLength,
  TextInputType? keyboardType,
  FocusNode? focusNode,
  TextStyle? textStyle,
  EdgeInsetsGeometry? contentPadding,
}) {
  if (isLeft) {
    return Expanded(
      child: TextField(
        controller: con,
        enabled: enabled,
        focusNode: focusNode,
        style: TextStyle(fontSize: fontSize),
        // textAlign: TextAlign.end,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          counterText: '',
          hintText: '$hint\t\t',
          hintStyle: TextStyle(color: Colors.black26, fontSize: fontSize),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  } else if (isRight) {
    return Expanded(
      child: TextField(
        controller: con,
        enabled: enabled,
        focusNode: focusNode,
        style: TextStyle(fontSize: fontSize),
        textAlign: TextAlign.end,
        onSubmitted: onSubmitted,
        onEditingComplete: onEditingComplete,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: '$hint\t\t',
          hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  } else if (isBig) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: borderColor)),
      child: TextField(
        controller: con,
        enabled: enabled,
        maxLines: maxLines,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        focusNode: focusNode,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: fontSize),
        decoration: InputDecoration(
          hintText: '\t\t$hint',
          contentPadding: contentPadding ?? const EdgeInsets.all(8),
          hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  } else if (isExd) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          Container(
            height: height,
            padding: const EdgeInsets.only(left: 23),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: borderColor),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: con,
              enabled: enabled,
              focusNode: focusNode,
              textInputAction: textInputAction,
              onSubmitted: onSubmitted,
              onEditingComplete: onEditingComplete,
              style: TextStyle(fontSize: fontSize),
              inputFormatters: inputFormatters,
              maxLength: maxLength,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 8, right: 16),
                counterText: "",
                hintText: '$hint',
                hintStyle: TextStyle(
                  fontSize: fontSize,
                  color: const Color(0xffCACBCD),
                ),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          Positioned(
            left: 11,
            child: SvgPicture.asset(
              'package/paixs_utils/assets/svg/sousuo.svg',
              width: 14,
              height: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  } else {
    return Container(
      height: height,
      color: bgColor,
      alignment: Alignment.center,
      child: TextField(
        controller: con,
        enabled: enabled,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        textAlign: TextAlign.center,
        keyboardType: keyboardType,
        style: textStyle,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: '$hint',
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

///圆角输入框
Widget buildTextField2({
  double height = 33.0,
  bool enabled = true,
  Color bgColor = const Color(0x10000000),
  String hint = '请输入',
  TextEditingController? con,
  bool isExd = true,
  bool isBig = false,
  bool isRight = false,
  int maxLines = 10,
  double fontSize = 16,
  Color borderColor = const Color(0x10000000),
  void Function()? onEditingComplete,
  void Function(String)? onSubmitted,
  TextInputAction? textInputAction,
  List<TextInputFormatter>? inputFormatters,
  int? maxLength,
  TextInputType? keyboardType,
}) {
  // con = TextEditingController();
  if (isRight) {
    return Expanded(
      child: Container(
        height: 40,
        child: TextField(
          controller: con,
          enabled: enabled,
          style: TextStyle(fontSize: fontSize),
          textAlign: TextAlign.end,
          onSubmitted: onSubmitted,
          onEditingComplete: onEditingComplete,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: '$hint\t\t',
            hintStyle: const TextStyle(color: Color(0xffB1B1B1), fontSize: 12),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  } else if (isBig) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: borderColor)),
      child: TextField(
        controller: con,
        enabled: enabled,
        maxLines: maxLines,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: fontSize),
        decoration: InputDecoration(
          hintText: '\t\t$hint',
          contentPadding: const EdgeInsets.all(8),
          hintStyle: const TextStyle(color: Color(0xffB1B1B1), fontSize: 12),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  } else if (isExd) {
    return Expanded(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              height: height,
              color: bgColor,
              padding: const EdgeInsets.only(left: 6),
              alignment: Alignment.center,
              child: TextField(
                controller: con,
                enabled: enabled,
                textInputAction: textInputAction,
                onSubmitted: onSubmitted,
                onEditingComplete: onEditingComplete,
                style: TextStyle(fontSize: fontSize),
                inputFormatters: inputFormatters,
                maxLength: maxLength,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 16, right: 48),
                  hintText: '\t\t$hint',
                  hintStyle:
                      const TextStyle(color: Color(0xffB1B1B1), fontSize: 12),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            child: GestureDetector(
              // onTap: () => onSubmitted(),
              child: SvgPicture.asset(
                'assets/svg/sousuo.svg',
                width: 12,
                height: 12,
                color: const Color(0xffB1B1B1),
              ),
            ),
          ),
        ],
      ),
    );
  } else {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Container(
            height: height,
            color: bgColor,
            alignment: Alignment.center,
            child: TextField(
              controller: con,
              enabled: enabled,
              inputFormatters: inputFormatters,
              maxLength: maxLength,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 16, right: 48),
                hintText: '\t$hint',
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 12,
          child: GestureDetector(
            // onTap: () => onSubmitted(con.text),
            child: SvgPicture.asset(
              'assets/svg/sousuo.svg',
              width: 16,
              height: 16,
            ),
          ),
        ),
      ],
    );
  }
}

RichText buildRow(String title, var content,
    {Color? titleColor,
    Color? contentColor,
    double titlesize = 12,
    double contentsize = 12,
    bool? titleisbold,
    bool? contentisbold}) {
  return RichText(
    text: TextSpan(
        text: title,
        style: TextStyle(
            color: titleColor,
            fontSize: titlesize,
            fontWeight:
                titleisbold == true ? FontWeight.bold : FontWeight.normal),
        children: <InlineSpan>[
          TextSpan(
              text: content,
              style: TextStyle(
                  color: contentColor,
                  fontSize: contentsize,
                  fontWeight: contentisbold == true
                      ? FontWeight.bold
                      : FontWeight.normal)),
        ]),
  );
}

Row buildRow1(String title, var content,
    {Color? titleColor,
    Color? contentColor,
    double titlesize = 12,
    double contentsize = 12}) {
  return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
    Container(
      padding: const EdgeInsets.only(bottom: 3),
      child: MyText(
        title,
        size: titlesize,
        color: titleColor ?? const Color(0xff333333),
      ),
    ),
    const SizedBox(width: 0),
    Expanded(
      child: MyText(
        content,
        size: contentsize,
        isOverflow: true,
        maxLines: 2,
        color: contentColor ?? const Color(0xff666666),
      ),
    ),
  ]);
}

///默认文字样式
Widget buildDefText([text = '暂无回复']) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    color: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    alignment: Alignment.center,
    child: MyText(text, size: 16, color: Colors.black26),
  );
}

RichText buildRow4(String title, var content,
    {Color? titleColor,
    Color? contentColor,
    double? titlesize,
    double? contentsize}) {
  return RichText(
    text: TextSpan(
        text: title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: titleColor ?? const Color(0xff333333),
            fontSize: titlesize ?? 12),
        children: <InlineSpan>[
          TextSpan(
              text: content,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: contentColor ?? const Color(0xff666666),
                  fontSize: contentsize ?? 12)),
        ]),
  );
}

Row buildRow2(String title, var content,
    {Color? titleColor,
    Color? contentColor,
    double titlesize = 12,
    double contentsize = 12}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        padding: const EdgeInsets.only(bottom: 3),
        child: MyText(
          title,
          size: titlesize,
          color: titleColor ?? const Color(0xff333333),
        ),
      ),
      const SizedBox(width: 0),
      Expanded(
        child: MyText(
          content,
          size: contentsize,
          isOverflow: true,
          maxLines: 50,
          color: contentColor ?? const Color(0xff666666),
        ),
      ),
    ],
  );
}

EdgeInsets onlyEdgeInset([
  double left = 0,
  double top = 0,
  double right = 0,
  double bottom = 0,
]) =>
    EdgeInsets.only(left: left, right: right, top: top, bottom: bottom);

BorderRadius onlyRadius([
  double topLeft = 8,
  double topRight = 8,
  double bottomLeft = 8,
  double bottomRight = 8,
]) =>
    BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );

BorderRadius allRadius([double radius = 8]) => BorderRadius.circular(radius);

// 显示加载框的方法
@protected
Future<void> showLoad(VoidFutureCallBack fn) async {
  buildShowDialog(context);
  fn.call().then((value) => pop(context)).catchError((v) => pop(context));
}
