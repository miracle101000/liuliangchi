import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../model/data_model.dart';
import 'my_bouncing_scroll_physics.dart';
import 'mylistview.dart';
import 'mytext.dart';
import 'refresher_widget.dart';
import 'scrollbar.dart';
import 'shimmer_widget.dart';
import 'tween_widget.dart';
import 'views.dart';

///动画类型
enum AnimationType {
  ///打开动画
  open,

  ///关闭动画
  close,

  ///垂直
  vertical,
}

class MyCustomScroll extends StatefulWidget {
  final List<Widget> headers;
  final Widget Function(int, dynamic)? itemModelBuilder;
  final int? itemCount;
  final DataModel? itemModel;
  final int? crossAxisCount;
  final int? expandedCount;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final double? cacheExtent;
  final Divider? divider;
  final EdgeInsetsGeometry? headPadding;
  final EdgeInsetsGeometry? itemPadding;
  final Widget? btmWidget;
  final bool isGengduo;
  final bool isShuaxin;
  final Widget? refFooter;
  final Widget? refHeader;
  final Future<int> Function(int)? onLoading;
  final Future<int> Function() onRefresh;
  final Widget Function(double)? onTapWidget;
  final String? btmText;
  final String? noDataText;
  final Widget? noDataView;
  final ScrollController? controller;
  final Widget Function()? maskWidget;
  final double? maskHeight;
  final void Function(bool, double)? onScrollToList;
  final bool shrinkWrap;
  final AnimationType animationType;
  final Alignment animationDirection;
  final int? animationDelayed;
  final int? animationTime;
  final bool isCloseTouchBottomAnimation;
  final bool isCloseOpacity;
  final bool isCloseTopTouchBottomAnimation;
  final double touchBottomAnimationValue;
  final double touchBottomAnimationOpacity;
  final int touchBottomAnimationAnimaTime;
  final Color? initColor;
  final Color? btmWidgetColor;

  ///异常的点击事件
  final void Function()? errorOnTap;

  const MyCustomScroll({
    Key? key,
    this.headers = const <Widget>[],
    this.itemModelBuilder,
    this.itemCount,
    this.itemModel,
    this.crossAxisCount,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.divider,
    this.headPadding,
    this.itemPadding,
    this.btmWidget,
    required this.isGengduo,
    required this.isShuaxin,
    this.refFooter,
    this.refHeader,
    this.onLoading,
    required this.onRefresh,
    this.expandedCount,
    this.btmText,
    this.controller,
    this.onTapWidget,
    this.cacheExtent,
    this.maskWidget,
    this.onScrollToList,
    this.maskHeight,
    this.shrinkWrap = false,
    this.noDataText = '暂无数据',
    this.noDataView,
    this.errorOnTap,
    this.animationType = AnimationType.open,
    this.animationDelayed,
    this.animationDirection = Alignment.centerRight,
    this.animationTime,
    this.isCloseTouchBottomAnimation = false,
    this.isCloseOpacity = false,
    this.touchBottomAnimationValue = 0.25,
    this.touchBottomAnimationOpacity = 25.0,
    this.isCloseTopTouchBottomAnimation = false,
    this.touchBottomAnimationAnimaTime = 100,
    this.initColor,
    this.btmWidgetColor,
  }) : super(key: key);
  @override
  _MyCustomScrollState createState() => _MyCustomScrollState();
}

class _MyCustomScrollState extends State<MyCustomScroll> {
  ///首页列表头key
  GlobalKey homeListViewHeadKey = GlobalKey();

  bool isShowMask = false;

  ScrollController? con;

  ///是否靠近顶部
  // var isNearTheTop = false;

  ///底部条
  Widget get btmWidget {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 1,
            width: 56,
            color: widget.btmWidgetColor ?? Colors.black26,
          ),
          const SizedBox(width: 8),
          MyText(widget.btmText ?? '我是有底线的',
              color: widget.btmWidgetColor ?? Colors.black54),
          const SizedBox(width: 8),
          Container(
            height: 1,
            width: 56,
            color: widget.btmWidgetColor ?? Colors.black26,
          ),
        ],
      ),
    );
  }

  ///用户滑动方向
  ScrollDirection userScrollDirection = ScrollDirection.reverse;

  ///列表创建时间
  DateTime listViewBuildTime = DateTime.now();

  @override
  void initState() {
    listViewBuildTime = DateTime.now();
    con = widget.controller ?? ScrollController();
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    // isNearTheTop = widget.isShuaxin;
    con!.addListener(() {
      userScrollDirection = con!.position.userScrollDirection;
      // if (widget.isShuaxin) {
      //   if (con.offset <= 100) {
      //     if (!isNearTheTop) setState(() => isNearTheTop = true);
      //   } else {
      //     if (!widget.isGengduo) {
      //       if (isNearTheTop) setState(() => isNearTheTop = false);
      //     } else {
      //       if (con.position.extentAfter <= 100) {
      //         if (!isNearTheTop) setState(() => isNearTheTop = true);
      //       } else {
      //         if (isNearTheTop) setState(() => isNearTheTop = false);
      //       }
      //     }
      //   }
      // }
      if (widget.maskWidget == null) return;
      var s = homeListViewHeadKey.currentContext!
          .findRenderObject()!
          .parentData
          .toString();
      double group;
      var firstMatch = RegExp('\\(.*?, (.*?)\\)').firstMatch(s);
      if (widget.isShuaxin) {
        group = double.parse(firstMatch!.group(1)!);
      } else {
        group = double.parse(s
            .split('=')[1]
            .replaceAll('Offset', '')
            .replaceAll('(', '')
            .replaceAll(')', '')
            .split(',')
            .last);
      }
      if (group <= (widget.maskHeight ?? 0.0)) {
        // if (!isShowMask) {
        //   if (widget.onScrollToList == null) {
        //     setState(() {});
        //   } else {
        widget.onScrollToList!(true, group);
        //   }
        // }
        // isShowMask = true;
      } else {
        // if (isShowMask) {
        //   if (widget.onScrollToList == null) {
        //     setState(() {});
        //   } else {
        widget.onScrollToList!(false, group);
        //   }
        // }
        // isShowMask = false;
      }
    });
  }

  var view;

  // Helper method to compute the actual child count for the separated constructor.
  static int _computeActualChildCount(int itemCount) {
    return max(0, itemCount * 2 - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (_) {
      switch (widget.itemModel!.flag) {
        case 0:
          view = SliverToBoxAdapter(
            key: homeListViewHeadKey,
            child: BottomTouchAnimation(
              index: widget.headers.length,
              length: widget.itemModel!.list.length + widget.headers.length,
              scrollController: con!,
              isRef: widget.isShuaxin,
              isMore: widget.isGengduo,
              isClose: widget.isCloseTouchBottomAnimation,
              isCloseTop: widget.isCloseTopTouchBottomAnimation,
              value: widget.touchBottomAnimationValue,
              opacity: widget.touchBottomAnimationOpacity,
              isCloseOpacity: widget.isCloseOpacity,
              animaTime:
                  !widget.isShuaxin ? 10 : widget.touchBottomAnimationAnimaTime,
              child: TweenWidget(
                axis: Axis.vertical,
                value: -50,
                key: const ValueKey(10),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: buildLoad(color: widget.initColor),
                ),
              ),
            ),
          );
          break;
        case 1:
          view = SliverToBoxAdapter(
            key: homeListViewHeadKey,
            child: BottomTouchAnimation(
              index: widget.headers.length,
              length: widget.itemModel!.list.length + widget.headers.length,
              scrollController: con!,
              isRef: widget.isShuaxin,
              isMore: widget.isGengduo,
              isClose: widget.isCloseTouchBottomAnimation,
              isCloseTop: widget.isCloseTopTouchBottomAnimation,
              value: widget.touchBottomAnimationValue,
              opacity: widget.touchBottomAnimationOpacity,
              isCloseOpacity: widget.isCloseOpacity,
              animaTime:
                  !widget.isShuaxin ? 10 : widget.touchBottomAnimationAnimaTime,
              child: TweenWidget(
                axis: Axis.vertical,
                value: 50,
                key: const ValueKey(11),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: ShimmerWidget(
                    text: widget.itemModel!.msg,
                    key: const ValueKey(1),
                    color: Colors.transparent,
                    callBack: () {
                      setState(() => widget.itemModel!.flag = 0);
                      widget.onRefresh();
                    },
                  ),
                ),
              ),
            ),
          );
          break;
        case 2:
          view = SliverToBoxAdapter(
            key: homeListViewHeadKey,
            child: BottomTouchAnimation(
              index: widget.headers.length,
              length: widget.itemModel!.list.length + widget.headers.length,
              scrollController: con!,
              isRef: widget.isShuaxin,
              isMore: widget.isGengduo,
              isClose: widget.isCloseTouchBottomAnimation,
              isCloseTop: widget.isCloseTopTouchBottomAnimation,
              value: widget.touchBottomAnimationValue,
              opacity: widget.touchBottomAnimationOpacity,
              isCloseOpacity: widget.isCloseOpacity,
              animaTime:
                  !widget.isShuaxin ? 10 : widget.touchBottomAnimationAnimaTime,
              child: widget.noDataView ??
                  TweenWidget(
                    axis: Axis.vertical,
                    value: 50,
                    key: const ValueKey(12),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: ShimmerWidget(
                        key: const ValueKey(2),
                        text: widget.noDataText!,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
            ),
          );
          break;
        default:
          view = SliverPadding(
            key: homeListViewHeadKey,
            padding: widget.itemPadding ?? EdgeInsets.zero,
            sliver: SliverWaterfallFlow(
              delegate: SliverChildBuilderDelegate(
                (_, i) => tweenView(i),
                // (BuildContext context, int index) {
                //   final int i = index ~/ 2;
                //   Widget view;
                //   if (index.isEven) {
                //     view = (widget.divider == null
                //         ? tweenView(i)
                //         : widget.crossAxisCount != null
                //             ? tweenView(i)
                //             : Column(
                //                 children: [
                //                   tweenView(i),
                //                   if (i != widget.itemModel.list.length - 1) widget.divider,
                //                 ],
                //               ));
                //   } else {
                //     view = SizedBox();
                //   }
                //   return view;
                // },
                childCount: widget.itemModel!.list.length,
              ),
              gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount ?? 1,
                crossAxisSpacing: widget.crossAxisSpacing ?? 0.0,
                mainAxisSpacing: widget.mainAxisSpacing ?? 0.0,
              ),
            ),
          );
          break;
      }

      if (widget.isShuaxin) {
        return Stack(
          children: [
            ClipRect(
              child: CupertinoScrollbarWidget(
                thickness: 6,
                controller: con,
                radius: const Radius.circular(6),
                child: RefresherWidget(
                  isShuaxin: widget.isShuaxin,
                  isGengduo: widget.isGengduo,
                  footer: widget.refFooter ??
                      buildCustomFooter(text: widget.itemModel?.msg),
                  header: widget.refHeader ??
                      buildClassicHeader(text: widget.itemModel?.msg),
                  onLoading: () => widget.onLoading!(widget.itemModel!.page!),
                  onRefresh: widget.onRefresh,
                  child: CustomScrollView(
                    controller: con,
                    // physics: MyBouncingScrollPhysics(),
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: MyBouncingScrollPhysics()),
                    cacheExtent: widget.cacheExtent,
                    shrinkWrap: widget.shrinkWrap,
                    slivers: <Widget>[
                      SliverPadding(
                        padding: widget.headPadding ?? EdgeInsets.zero,
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, i) {
                              // flog('=======$i');
                              return BottomTouchAnimation(
                                index: i,
                                length: widget.headers.length,
                                scrollController: con!,
                                isRef: widget.isShuaxin,
                                isMore: widget.isGengduo,
                                isClose: widget.isCloseTouchBottomAnimation,
                                isCloseTop:
                                    widget.isCloseTopTouchBottomAnimation,
                                value: widget.touchBottomAnimationValue,
                                opacity: widget.touchBottomAnimationOpacity,
                                isCloseOpacity: widget.isCloseOpacity,
                                animaTime: !widget.isShuaxin
                                    ? 10
                                    : widget.touchBottomAnimationAnimaTime,
                                child: widget.headers[i],
                              );
                            },
                            childCount: widget.headers.length,
                          ),
                        ),
                      ),
                      view,
                      // if (widget.itemModel.flag == 0)
                      //   SliverToBoxAdapter(
                      //     child: Container(
                      //       padding: EdgeInsets.all(16),
                      //       alignment: Alignment.center,
                      //       child: buildLoad(),
                      //     ),
                      //   ),
                      // if (widget.itemModel.flag == 0)
                      //   SliverToBoxAdapter(
                      //     child: widget.noDataView ??
                      //         Container(
                      //           padding: EdgeInsets.all(8),
                      //           alignment: Alignment.center,
                      //           child: TweenWidget(
                      //             key: ValueKey(widget.noDataText),
                      //             axis: Axis.vertical,
                      //             child: MyText(widget.noDataText, color: Colors.grey),
                      //           ),
                      //         ),
                      //   )
                      // else
                      //   SliverPadding(
                      //     key: homeListViewHeadKey,
                      //     padding: widget.itemPadding ?? EdgeInsets.zero,
                      //     sliver: SliverWaterfallFlow(
                      //       delegate: SliverChildBuilderDelegate(
                      //         (_, i) {
                      //           return widget.divider == null
                      //               ? widget.itemModelBuilder(i, widget.itemModel.list[i])
                      //               : widget.crossAxisCount != null
                      //                   ? widget.itemModelBuilder(i, widget.itemModel.list[i])
                      //                   : Column(
                      //                       children: [
                      //                         widget.itemModelBuilder(i, widget.itemModel.list[i]),
                      //                         if (i != widget.itemModel.list.length - 1) widget.divider,
                      //                       ],
                      //                     );
                      //         },
                      //         childCount: widget.itemModel.list.length,
                      //       ),
                      //       gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                      //         crossAxisCount: widget.crossAxisCount ?? 1,
                      //         crossAxisSpacing: widget.crossAxisSpacing ?? 0.0,
                      //         mainAxisSpacing: widget.mainAxisSpacing ?? 0.0,
                      //       ),
                      //     ),
                      //   ),
                      if (!widget.itemModel!.hasNext!)
                        if (widget.itemModel!.list.length >
                            (widget.expandedCount ?? 10))
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (_, i) {
                                return BottomTouchAnimation(
                                  index: widget.itemModel!.list.length +
                                      widget.headers.length,
                                  length: widget.itemModel!.list.length +
                                      widget.headers.length,
                                  scrollController: con!,
                                  isRef: widget.isShuaxin,
                                  isMore: widget.isGengduo,
                                  isClose: widget.isCloseTouchBottomAnimation,
                                  isCloseTop:
                                      widget.isCloseTopTouchBottomAnimation,
                                  value: widget.touchBottomAnimationValue,
                                  opacity: widget.touchBottomAnimationOpacity,
                                  isCloseOpacity: widget.isCloseOpacity,
                                  animaTime: !widget.isShuaxin
                                      ? 10
                                      : widget.touchBottomAnimationAnimaTime,
                                  child: i != 0
                                      ? widget.btmWidget ?? btmWidget
                                      : const SizedBox(),
                                );
                              },
                              childCount: 2,
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.maskWidget != null)
              if (widget.onScrollToList == null)
                isShowMask ? widget.maskWidget!() : const SizedBox()
              else
                widget.maskWidget!(),
          ],
        );
      } else {
        return Stack(
          children: [
            ClipRect(
              child: CupertinoScrollbarWidget(
                thickness: 6,
                controller: con!,
                radius: const Radius.circular(6),
                child: CustomScrollView(
                  controller: con,
                  // physics: MyBouncingScrollPhysics(),
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: MyBouncingScrollPhysics()),
                  cacheExtent: widget.cacheExtent,
                  shrinkWrap: widget.shrinkWrap,
                  slivers: <Widget>[
                    SliverPadding(
                      padding: widget.headPadding ?? EdgeInsets.zero,
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) {
                            // flog('=======$i');
                            return BottomTouchAnimation(
                              index: i,
                              length: widget.headers.length,
                              scrollController: con!,
                              isRef: widget.isShuaxin,
                              isMore: widget.isGengduo,
                              isClose: widget.isCloseTouchBottomAnimation,
                              isCloseTop: widget.isCloseTopTouchBottomAnimation,
                              value: widget.touchBottomAnimationValue,
                              opacity: widget.touchBottomAnimationOpacity,
                              isCloseOpacity: widget.isCloseOpacity,
                              animaTime: !widget.isShuaxin
                                  ? 10
                                  : widget.touchBottomAnimationAnimaTime,
                              child: widget.headers[i],
                            );
                          },
                          childCount: widget.headers.length,
                        ),
                      ),
                    ),
                    SliverPadding(
                      key: homeListViewHeadKey,
                      padding: widget.itemPadding ?? EdgeInsets.zero,
                      sliver: SliverWaterfallFlow(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final int i = index ~/ 2;
                            Widget view;
                            if (index.isEven) {
                              view = (widget.divider == null
                                  ? tweenView(i)
                                  : widget.crossAxisCount != null
                                      ? tweenView(i)
                                      : Column(
                                          children: [
                                            tweenView(i),
                                            if (i !=
                                                widget.itemModel!.list.length -
                                                    1)
                                              widget.divider!,
                                          ],
                                        ));
                            } else {
                              view = const SizedBox();
                            }
                            return view;
                          },
                          childCount: _computeActualChildCount(
                              widget.itemModel!.list.length),
                        ),
                        gridDelegate:
                            SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widget.crossAxisCount ?? 1,
                          crossAxisSpacing: widget.crossAxisSpacing ?? 0.0,
                          mainAxisSpacing: widget.mainAxisSpacing ?? 0.0,
                        ),
                      ),
                    ),
                    if (!widget.itemModel!.hasNext!)
                      if (widget.itemModel!.list.length >
                          (widget.expandedCount ?? 10))
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, i) {
                              return BottomTouchAnimation(
                                index: widget.itemModel!.list.length +
                                    widget.headers.length,
                                length: widget.itemModel!.list.length +
                                    widget.headers.length,
                                scrollController: con!,
                                isRef: widget.isShuaxin,
                                isMore: widget.isGengduo,
                                isClose: widget.isCloseTouchBottomAnimation,
                                isCloseTop:
                                    widget.isCloseTopTouchBottomAnimation,
                                value: widget.touchBottomAnimationValue,
                                opacity: widget.touchBottomAnimationOpacity,
                                isCloseOpacity: widget.isCloseOpacity,
                                animaTime: !widget.isShuaxin
                                    ? 10
                                    : widget.touchBottomAnimationAnimaTime,
                                child: i != 0
                                    ? widget.btmWidget ?? btmWidget
                                    : const SizedBox(),
                              );
                            },
                            childCount: 2,
                          ),
                        ),
                  ],
                ),
              ),
            ),
            if (widget.maskWidget != null)
              if (widget.onScrollToList == null)
                isShowMask ? widget.maskWidget!() : const SizedBox()
              else
                widget.maskWidget!(),
          ],
        );
      }
    });
  }

  Widget tweenView(int i) {
    return BottomTouchAnimation(
      index: i + widget.headers.length,
      length: widget.itemModel!.list.length + widget.headers.length,
      scrollController: con!,
      isRef: widget.isShuaxin,
      isMore: widget.isGengduo,
      isClose: widget.isCloseTouchBottomAnimation,
      isCloseTop: widget.isCloseTopTouchBottomAnimation,
      value: widget.touchBottomAnimationValue,
      opacity: widget.touchBottomAnimationOpacity,
      isCloseOpacity: widget.isCloseOpacity,
      animaTime: !widget.isShuaxin ? 10 : widget.touchBottomAnimationAnimaTime,
      child: Builder(
        builder: (_) {
          var value = {
            Alignment.centerLeft: -50.0,
            Alignment.centerRight: 50.0,
            Alignment.bottomCenter: 50.0,
            Alignment.topCenter: -50.0,
          }[widget.animationDirection];
          // if ((Platform.isWindows)) {
          if ((true)) {
            return widget.itemModelBuilder!(i, widget.itemModel!.list[i]);
          } 
          
          // else if (DateTime.now().difference(listViewBuildTime).inSeconds >=
          //     5) {
          //   return widget.itemModelBuilder(i, widget.itemModel.list[i]);
          // } else {
          //   switch (widget.animationType) {
          //     case AnimationType.open:
          //       return TweenWidget(
          //         axis: RouteState.isFromDown ? Axis.vertical : Axis.horizontal,
          //         delayed: (con.offset > 0)
          //             ? 0
          //             : (widget.animationDelayed == null
          //                     ? (RouteState.isFromDown
          //                         ? RouteState.listFromToDownAnimationTime
          //                         : RouteState.listRightToLeftAnimationTime)
          //                     : widget.animationDelayed) +
          //                 (RouteState.isFromDown
          //                         ? 20
          //                         : (widget.itemModel.list.length <= 5
          //                             ? 20
          //                             : 10)) *
          //                     i,
          //         value: (con.offset > 0) ? 1 : value,
          //         isScale: (con.offset > 0),
          //         isReverseScale: true,
          //         scaleX: -0.25,
          //         scaleY: -0.25,
          //         curve: Curves.easeOutCubic,
          //         time: widget.animationTime ?? RouteState.listAnimationTime,
          //         alphaTime:
          //             widget.animationTime ?? RouteState.listAnimationTime,
          //         child: widget.itemModelBuilder(i, widget.itemModel.list[i]),
          //       );
          //       break;
          //     case AnimationType.close:
          //       return widget.itemModelBuilder(i, widget.itemModel.list[i]);
          //       break;
          //     case AnimationType.vertical:
          //       return TweenWidget(
          //         delayed: (con.offset > 0)
          //             ? 0
          //             : (widget.animationDelayed ??
          //                     RouteState.listVerticalAnimationTime) +
          //                 (widget.itemModel.list.length <= 5 ? 30 : 20) * i,
          //         axis: Axis.vertical,
          //         value: (con.offset > 0) ? 1 : value,
          //         isScale: (con.offset > 0),
          //         isReverseScale: true,
          //         scaleX: -0.25,
          //         scaleY: -0.25,
          //         time: widget.animationTime ?? RouteState.listAnimationTime,
          //         alphaTime:
          //             widget.animationTime ?? RouteState.listAnimationTime,
          //         curve: Curves.easeOutCubic,
          //         child: widget.itemModelBuilder(i, widget.itemModel.list[i]),
          //       );
          //       break;
          //   }
          // }
          // return null;
        },
      ),
    );
  }
}
