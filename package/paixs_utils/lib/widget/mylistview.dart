import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/refresher_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scrollbar.dart';
import 'package:paixs_utils/widget/tween_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import '../model/data_model.dart';
import '../util/utils.dart';
import 'my_bouncing_scroll_physics.dart';
import 'mytext.dart';
import 'refresher_widget.dart';
import 'scrollbar.dart';
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

///列表试图类型
enum ListViewType {
  Builder,
  BuilderExpanded,
  Separated,
  SeparatedExpanded,
}

class MyListView<T> extends StatefulWidget {
  ///列表属性
  final Function(int)? item;
  final int? itemCount;
  final ListViewType listViewType;
  final EdgeInsets padding;
  final ScrollPhysics? physics;
  final Widget? divider;
  final Widget Function(int)? dividerBuilder;
  final bool flag;
  final bool reverse;
  final ScrollController? controller;
  final DataModel<T>? value;
  final Widget Function(T)? itemWidget;
  final int expCount;
  final Alignment animationDirection;

  ///刷新属性
  final Widget? header;
  final Widget? footer;
  final bool isShuaxin;
  final bool isGengduo;
  final bool isOnlyMore;
  final Widget? expView;
  final Future<int> Function()? onLoading;
  final Future<int> Function()? onRefresh;
  final AnimationType animationType;
  final int? animationDelayed;
  final int? animationTime;
  final bool isFillPlatform;
  final double? fillValue;
  final double? cacheExtent;
  final bool isCloseTouchBottomAnimation;
  final bool isCloseOpacity;
  final bool isCloseTopTouchBottomAnimation;
  final bool isClipRect;
  final double touchBottomAnimationValue;
  final double touchBottomAnimationOpacity;
  final int touchBottomAnimationAnimaTime;

  const MyListView({
    Key? key,
    this.item,
    this.listViewType = ListViewType.Separated,
    this.itemCount,
    this.padding = EdgeInsets.zero,
    this.physics,
    this.divider,
    this.flag = true,
    this.controller,
    this.header,
    this.footer,
    required this.isShuaxin,
    this.isGengduo = false,
    this.onLoading,
    this.onRefresh,
    this.value,
    this.itemWidget,
    this.expCount = 10,
    this.isOnlyMore = false,
    this.expView,
    this.reverse = false,
    this.animationType = AnimationType.open,
    this.animationDelayed,
    this.animationDirection = Alignment.centerRight,
    this.animationTime,
    this.isFillPlatform = false,
    this.fillValue,
    this.cacheExtent,
    this.isCloseTouchBottomAnimation = false,
    this.isCloseOpacity = false,
    this.touchBottomAnimationValue = 0.1,
    this.touchBottomAnimationOpacity = 25.0,
    this.isCloseTopTouchBottomAnimation = false,
    this.touchBottomAnimationAnimaTime = 100,
    this.isClipRect = true,
    this.dividerBuilder,
  }) : super(key: key);
  @override
  _MyListViewState<T> createState() => _MyListViewState<T>();
}

class _MyListViewState<T> extends State<MyListView<T>> {
  ///列表map
  Map<ListViewType, Widget> listviews = {};

  ScrollController? _controller;

  ///是否靠近顶部
  var isNearTheTop = false;

  ///底部条
  Widget container = Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 1,
          width: 56,
          color: Colors.black.withOpacity(0.1),
        ),
        const SizedBox(width: 8),
        MyText('暂无更多', color: Colors.black.withOpacity(0.25)),
        const SizedBox(width: 8),
        Container(
          height: 1,
          width: 56,
          color: Colors.black.withOpacity(0.1),
        ),
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    initData();
  }

  ///用户滑动方向
  ScrollDirection userScrollDirection = ScrollDirection.reverse;

  ///列表创建时间
  DateTime listViewBuildTime = DateTime.now();

  bool flag = true;

  ///初始化函数
  Future initData() async {
    flag = widget.flag;
    // if (!widget.isShuaxin) if (flag && widget.physics == null) flag = false;
    listViewBuildTime = DateTime.now();
    _controller = widget.controller ?? ScrollController();
    // isNearTheTop = widget.isShuaxin;
    _controller!.addListener(() {
      userScrollDirection = _controller!.position.userScrollDirection;
      // if (widget.isShuaxin) {
      //   if (_controller.offset <= 100) {
      //     if (!isNearTheTop) setState(() => isNearTheTop = true);
      //   } else {
      //     if (!widget.isGengduo) {
      //       if (isNearTheTop) setState(() => isNearTheTop = false);
      //     } else {
      //       if (_controller.position.extentAfter <= 100) {
      //         if (!isNearTheTop) setState(() => isNearTheTop = true);
      //       } else {
      //         if (isNearTheTop) setState(() => isNearTheTop = false);
      //       }
      //     }
      //   }
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    container = widget.expView ?? container;
    listviews = {
      ListViewType.Builder: buildListViewBuilder(),
      ListViewType.BuilderExpanded: buildListViewBuilderExpanded(),
      ListViewType.Separated: buildListViewSeparated(),
      ListViewType.SeparatedExpanded: buildListViewSeparatedExpanded(),
    };
    // var isDyuYiban = RouteState.desktopLeftMenuWidth > size(context).width / 3;
    var view;
    // if ((widget.isFillPlatform && !isMobile)) {
    //   if (isDyuYiban) {
    //     view = view = AnimatedPadding(
    //       duration: Duration(milliseconds: 500),
    //       curve: Curves.easeOutCubic,
    //       padding: EdgeInsets.only(right: 0),
    //       child: listviews[widget.listViewType],
    //     );
    //   } else {
    //     view = AnimatedPadding(
    //       duration: Duration(milliseconds: 500),
    //       curve: Curves.easeOutCubic,
    //       padding: EdgeInsets.only(right: widget.fillValue ?? ((size(context).width - RouteState.desktopLeftMenuWidth) / 3)),
    //       child: listviews[widget.listViewType],
    //     );
    //   }
    // } else {
    view = listviews[widget.listViewType];
    // }

    // return NotificationListener<OverscrollIndicatorNotification>(
    //   child: view,
    //   onNotification: handleGlowNotification,
    // );
    if (widget.isClipRect) {
      return ClipRect(
        child: CupertinoScrollbarWidget(
          child: view,
          thickness: 6,
          controller: _controller!,
          radius: const Radius.circular(6),
        ),
      );
    } else {
      return CupertinoScrollbarWidget(
        child: view,
        thickness: 6,
        controller: _controller!,
        radius: const Radius.circular(6),
      );
    }
  }

  ///默认列表
  Widget buildListViewBuilder() {
    if (widget.isShuaxin) {
      return RefresherWidget(
        isShuaxin: widget.isShuaxin,
        isGengduo: widget.isGengduo,
        onRefresh: widget.onRefresh ?? () async => getTime(),
        onLoading: widget.onLoading ?? () async => getTime(),
        header: widget.header ?? buildClassicHeader(text: widget.value?.msg),
        footer: widget.footer ?? buildCustomFooter(text: widget.value?.msg),
        child: ListView.builder(
          controller: _controller,
          shrinkWrap: flag,
          // physics: widget.physics,
          physics: widget.physics ??
              AlwaysScrollableScrollPhysics(
                  parent: (isNearTheTop
                      ? const BouncingScrollPhysics()
                      : const MyBouncingScrollPhysics())),
          reverse: widget.reverse,
          padding: widget.padding,
          cacheExtent: widget.cacheExtent,
          itemCount: widget.itemCount == null
              ? widget.value!.list.length + 1
              : widget.itemCount! + 1,
          itemBuilder: (_, i) {
            if (widget.itemCount != null) {
              if (i == widget.itemCount) {
                return widget.isGengduo
                    ? const SizedBox()
                    : widget.itemCount! >= widget.expCount
                        ? container
                        : const SizedBox();
              } else {
                return tweenView(i);
              }
            } else {
              if (i == widget.value!.list.length) {
                return widget.isGengduo
                    ? const SizedBox()
                    : widget.value!.list.length >= widget.expCount
                        ? container
                        : const SizedBox();
              } else {
                return widget.itemWidget!(widget.value!.list[i]);
              }
            }
          },
        ),
      );
    } else if (widget.isOnlyMore) {
      return RefresherWidget(
        isShuaxin: widget.isShuaxin,
        isGengduo: widget.isGengduo,
        onRefresh: widget.onRefresh ?? () async => getTime(),
        onLoading: widget.onLoading ?? () async => getTime(),
        header: widget.header ?? buildClassicHeader(text: widget.value?.msg),
        footer: widget.footer ?? buildCustomFooter(text: widget.value?.msg),
        child: ListView.builder(
          controller: _controller,
          shrinkWrap: flag,
          // physics: widget.physics,
          physics: widget.physics ??
              AlwaysScrollableScrollPhysics(
                  parent: (isNearTheTop
                      ? const BouncingScrollPhysics()
                      : const MyBouncingScrollPhysics())),
          padding: widget.padding,
          reverse: widget.reverse,
          cacheExtent: widget.cacheExtent,
          itemCount: widget.itemCount == null
              ? widget.value!.list.length + 1
              : widget.itemCount! + 1,
          itemBuilder: (_, i) {
            if (widget.itemCount != null) {
              if (i == widget.itemCount) {
                return widget.isGengduo
                    ? const SizedBox()
                    : widget.itemCount! >= widget.expCount
                        ? container
                        : const SizedBox();
              } else {
                return tweenView(i);
              }
            } else {
              if (i == widget.value!.list.length) {
                return widget.isGengduo
                    ? const SizedBox()
                    : widget.value!.list.length >= widget.expCount
                        ? container
                        : const SizedBox();
              } else {
                return widget.itemWidget!(widget.value!.list[i]);
              }
            }
          },
        ),
      );
    } else {
      return ListView.builder(
        controller: _controller,
        shrinkWrap: flag,
        // physics: widget.physics,
        physics: widget.physics ??
            AlwaysScrollableScrollPhysics(
                parent: (isNearTheTop
                    ? const BouncingScrollPhysics()
                    : const MyBouncingScrollPhysics())),
        padding: widget.padding,
        cacheExtent: widget.cacheExtent,
        itemBuilder: (_, i) => tweenView(i),
        itemCount: widget.itemCount,
      );
    }
  }

  ///带有Expanded的默认列表
  Widget buildListViewBuilderExpanded() {
    return Expanded(
      child: widget.isShuaxin
          ? RefresherWidget(
              isShuaxin: widget.isShuaxin,
              isGengduo: widget.isGengduo,
              onRefresh: widget.onRefresh ?? () async => getTime(),
              onLoading: widget.onLoading ?? () async => getTime(),
              header:
                  widget.header ?? buildClassicHeader(text: widget.value?.msg),
              footer:
                  widget.footer ?? buildCustomFooter(text: widget.value?.msg),
              child: ListView.builder(
                controller: _controller,
                // physics: widget.physics,
                physics: widget.physics ??
                    AlwaysScrollableScrollPhysics(
                        parent: (isNearTheTop
                            ? const BouncingScrollPhysics()
                            : const MyBouncingScrollPhysics())),
                padding: widget.padding,
                reverse: widget.reverse,
                cacheExtent: widget.cacheExtent,
                itemCount: widget.itemCount == null
                    ? widget.value!.list.length + 1
                    : widget.itemCount! + 1,
                itemBuilder: (_, i) {
                  if (widget.itemCount != null) {
                    if (i == widget.itemCount) {
                      return widget.isGengduo
                          ? const SizedBox()
                          : widget.itemCount! >= widget.expCount
                              ? container
                              : const SizedBox();
                    } else {
                      return tweenView(i);
                    }
                  } else {
                    if (i == widget.value!.list.length) {
                      return widget.isGengduo
                          ? const SizedBox()
                          : widget.value!.list.length >= widget.expCount
                              ? container
                              : const SizedBox();
                    } else {
                      return widget.itemWidget!(widget.value!.list[i]);
                    }
                  }
                },
              ),
            )
          : ListView.builder(
              controller: _controller,
              // physics: widget.physics,
              physics: widget.physics ??
                  AlwaysScrollableScrollPhysics(
                      parent: (isNearTheTop
                          ? const BouncingScrollPhysics()
                          : const MyBouncingScrollPhysics())),
              padding: widget.padding,
              reverse: widget.reverse,
              cacheExtent: widget.cacheExtent,
              itemBuilder: (_, i) => tweenView(i),
              itemCount: widget.itemCount,
            ),
    );
  }

  ///带分割线的列表
  Widget buildListViewSeparated() {
    if (widget.isShuaxin || widget.isOnlyMore) {
      return RefresherWidget(
        isShuaxin: widget.isShuaxin,
        isGengduo: widget.isGengduo,
        onRefresh: widget.onRefresh ?? () async => getTime(),
        onLoading: widget.onLoading ?? () async => getTime(),
        header: widget.header ?? buildClassicHeader(text: widget.value?.msg),
        footer: widget.footer ?? buildCustomFooter(text: widget.value?.msg),
        child: ListView.separated(
          shrinkWrap: flag,
          padding: widget.padding,
          controller: _controller,
          // physics: widget.physics,
          physics: widget.physics ??
              AlwaysScrollableScrollPhysics(
                  parent: (isNearTheTop
                      ? const BouncingScrollPhysics()
                      : const MyBouncingScrollPhysics())),
          reverse: widget.reverse,
          cacheExtent: widget.cacheExtent,
          itemCount: widget.itemCount == null
              ? widget.value!.list.length + 1
              : widget.itemCount! + 1,
          separatorBuilder: (_, i) {
            return BottomTouchAnimation(
              index: i,
              length: widget.itemCount!,
              scrollController: _controller,
              isRef: widget.isShuaxin,
              isMore: widget.isGengduo,
              isClose: widget.isCloseTouchBottomAnimation,
              isCloseTop: widget.isCloseTopTouchBottomAnimation,
              value: widget.touchBottomAnimationValue,
              opacity: widget.touchBottomAnimationOpacity,
              isCloseOpacity: widget.isCloseOpacity,
              animaTime:
                  !widget.isShuaxin ? 10 : widget.touchBottomAnimationAnimaTime,
              child: Builder(
                builder: (_) {
                  if (widget.itemCount != null) {
                    return i == widget.itemCount! - 1
                        ? const SizedBox()
                        : widget.dividerBuilder == null
                            ? (widget.divider ?? const SizedBox())
                            : widget.dividerBuilder!(i);
                  } else {
                    return i == widget.value!.list.length - 1
                        ? const SizedBox()
                        : widget.dividerBuilder == null
                            ? (widget.divider ?? const SizedBox())
                            : widget.dividerBuilder!(i);
                  }
                },
              ),
            );
          },
          itemBuilder: (_, i) {
            if (widget.itemCount != null) {
              if (i == widget.itemCount) {
                return widget.isGengduo
                    ? const SizedBox()
                    : widget.itemCount! >= widget.expCount
                        ? container
                        : const SizedBox();
              } else {
                return tweenView(i);
              }
            } else {
              if (i == widget.value!.list.length) {
                return widget.isGengduo
                    ? const SizedBox()
                    : widget.value!.list.length >= widget.expCount
                        ? container
                        : const SizedBox();
              } else {
                return widget.itemWidget!(widget.value!.list[i]);
              }
            }
          },
        ),
      );
    } else {
      return ListView.separated(
        shrinkWrap: flag,
        padding: widget.padding,
        controller: _controller,
        // physics: widget.physics,
        physics: widget.physics ??
            AlwaysScrollableScrollPhysics(
                parent: (isNearTheTop
                    ? const BouncingScrollPhysics()
                    : const MyBouncingScrollPhysics())),
        reverse: widget.reverse,
        cacheExtent: widget.cacheExtent,
        itemBuilder: (_, i) => tweenView(i),
        separatorBuilder: (_, i) {
          return BottomTouchAnimation(
            index: i,
            length: widget.itemCount!,
            scrollController: _controller,
            isRef: widget.isShuaxin,
            isMore: widget.isGengduo,
            isClose: widget.isCloseTouchBottomAnimation,
            isCloseTop: widget.isCloseTopTouchBottomAnimation,
            value: widget.touchBottomAnimationValue,
            opacity: widget.touchBottomAnimationOpacity,
            isCloseOpacity: widget.isCloseOpacity,
            animaTime: 10,
            child: widget.dividerBuilder == null
                ? (widget.divider ?? const SizedBox())
                : widget.dividerBuilder!(i),
          );
        },
        itemCount: widget.itemCount!,
      );
    }
  }

  ///带有Expanded的分割线列表
  Widget buildListViewSeparatedExpanded() {
    return Expanded(
      child: widget.isShuaxin
          ? RefresherWidget(
              isShuaxin: widget.isShuaxin,
              isGengduo: widget.isGengduo,
              onRefresh: widget.onRefresh ?? () async => getTime(),
              onLoading: widget.onLoading ?? () async => getTime(),
              header:
                  widget.header ?? buildClassicHeader(text: widget.value?.msg),
              footer:
                  widget.footer ?? buildCustomFooter(text: widget.value?.msg),
              child: ListView.separated(
                controller: _controller,
                padding: widget.padding,
                // physics: widget.physics,
                physics: widget.physics ??
                    AlwaysScrollableScrollPhysics(
                        parent: (isNearTheTop
                            ? const BouncingScrollPhysics()
                            : const MyBouncingScrollPhysics())),
                reverse: widget.reverse,
                cacheExtent: widget.cacheExtent,
                itemCount: widget.itemCount == null
                    ? widget.value!.list.length + 1
                    : widget.itemCount! + 1,
                separatorBuilder: (_, i) {
                  if (widget.itemCount != null) {
                    return i == widget.itemCount! - 1
                        ? const SizedBox()
                        : widget.dividerBuilder == null
                            ? (widget.divider ??
                                Divider(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.1),
                                  thickness: 1,
                                  indent: 18,
                                  height: 0,
                                  endIndent: 18,
                                ))
                            : widget.dividerBuilder!(i);
                  } else {
                    return i == widget.value!.list.length - 1
                        ? const SizedBox()
                        : widget.dividerBuilder == null
                            ? (widget.divider ??
                                Divider(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.1),
                                  thickness: 1,
                                  indent: 18,
                                  height: 0,
                                  endIndent: 18,
                                ))
                            : widget.dividerBuilder!(i);
                  }
                },
                itemBuilder: (_, i) {
                  if (widget.itemCount != null) {
                    if (i == widget.itemCount) {
                      return widget.isGengduo
                          ? const SizedBox()
                          : widget.itemCount! >= widget.expCount
                              ? container
                              : const SizedBox();
                    } else {
                      return tweenView(i);
                    }
                  } else {
                    if (i == widget.value!.list.length) {
                      return widget.isGengduo
                          ? const SizedBox()
                          : widget.value!.list.length >= widget.expCount
                              ? container
                              : const SizedBox();
                    } else {
                      return widget.itemWidget!(widget.value!.list[i]);
                    }
                  }
                },
              ),
            )
          : ListView.separated(
              controller: _controller,
              padding: widget.padding,
              // physics: widget.physics,
              physics: widget.physics ??
                  AlwaysScrollableScrollPhysics(
                      parent: (isNearTheTop
                          ? const BouncingScrollPhysics()
                          : const MyBouncingScrollPhysics())),
              reverse: widget.reverse,
              cacheExtent: widget.cacheExtent,
              itemBuilder: (_, i) => tweenView(i),
              separatorBuilder: (_, i) {
                return widget.dividerBuilder == null
                    ? (widget.divider ??
                        Divider(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.1),
                          thickness: 1,
                          indent: 18,
                          height: 0,
                          endIndent: 18,
                        ))
                    : widget.dividerBuilder!(i);
              },
              itemCount: widget.itemCount!,
            ),
    );
  }

  Widget tweenView(int i) {
    return BottomTouchAnimation(
      index: i,
      length: widget.itemCount!,
      scrollController: _controller,
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
          // if ((Platform.isMacOS || Platform.isWindows)) {
          // if ((Platform.isWindows)) {
          if ((true)) {
            return widget.item!(i);
          }

          // else if (DateTime.now().difference(listViewBuildTime).inSeconds >=
          //     5) {
          //   return widget.item(i);
          // } else {
          //   switch (widget.animationType) {
          //     case AnimationType.open:
          //       return TweenWidget(
          //         axis: RouteState.isFromDown ? Axis.vertical : Axis.horizontal,
          //         delayed: (_controller.offset > 0)
          //             ? 0
          //             : (widget.animationDelayed == null
          //                     ? (RouteState.isFromDown
          //                         ? RouteState.listFromToDownAnimationTime
          //                         : RouteState.listRightToLeftAnimationTime)
          //                     : widget.animationDelayed) +
          //                 (RouteState.isFromDown
          //                         ? 20
          //                         : widget.itemCount <= 5
          //                             ? 20
          //                             : 10) *
          //                     i,
          //         value: (_controller.offset > 0) ? 1 : value,
          //         isScale: (_controller.offset > 0),
          //         isReverseScale: true,
          //         scaleX: -0.25,
          //         scaleY: -0.25,
          //         curve: Curves.easeOutCubic,
          //         time: widget.animationTime ?? RouteState.listAnimationTime,
          //         alphaTime:
          //             widget.animationTime ?? RouteState.listAnimationTime,
          //         child: widget.item(i),
          //       );
          //       break;
          //     case AnimationType.close:
          //       return widget.item(i);
          //       break;
          //     case AnimationType.vertical:
          //       return TweenWidget(
          //         delayed: (_controller.offset > 0)
          //             ? 0
          //             : (widget.animationDelayed ??
          //                     RouteState.listVerticalAnimationTime) +
          //                 (widget.itemCount <= 5 ? 30 : 20) * i,
          //         axis: Axis.vertical,
          //         value: (_controller.offset > 0) ? 1 : value,
          //         isScale: (_controller.offset > 0),
          //         isReverseScale: true,
          //         scaleX: -0.25,
          //         scaleY: -0.25,
          //         time: widget.animationTime ?? RouteState.listAnimationTime,
          //         alphaTime:
          //             widget.animationTime ?? RouteState.listAnimationTime,
          //         curve: Curves.easeOutCubic,
          //         child: widget.item(i),
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

///触底动画
class BottomTouchAnimation extends StatefulWidget {
  final Widget? child;
  final bool isRef;
  final bool isMore;
  final bool isClose;
  final bool isCloseOpacity;
  final bool isCloseTop;
  final double value;
  final double opacity;
  final ScrollController? scrollController;
  final int index;
  final int length;
  final int animaTime;
  const BottomTouchAnimation({
    Key? key,
    this.child,
    this.scrollController,
    this.isRef = false,
    this.isMore = false,
    this.isClose = false,
    this.isCloseOpacity = false,
    this.value = 0.2,
    this.isCloseTop = false,
    this.index = 0,
    this.length = 0,
    required this.animaTime,
    this.opacity = 25.0,
  }) : super(key: key);

  @override
  State<BottomTouchAnimation> createState() => _BottomTouchAnimationState();
}

class _BottomTouchAnimationState extends State<BottomTouchAnimation> {
  ScrollController? _controller;

  var _scaleY = 0.0;

  int value = 500;

  bool extentAfter = false;

  ///指针是否松开
  // int isPointerUp = 1;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    _controller = widget.scrollController;
    if (widget.isClose) {
    } else {
      _controller!.addListener(() {
        extentAfter = _controller!.offset > 0.0;
        // flog(extentAfter);
        if (!widget.isClose) {
          if (_controller!.position.extentAfter == 0.0) {
            var extentAfterValue =
                -(_controller!.position.maxScrollExtent - _controller!.offset);
            if (extentAfterValue <= value) {
              // isPointerUp = (_controller.position.activity.velocity != 0.0) ? 1 : 0;
              if (mounted) setState(() => _scaleY = (extentAfterValue / value));
            }
          } else if (_controller!.position.extentBefore == 0.0) {
            var extentBeforeValue = -(_controller!.offset);
            if (extentBeforeValue <= value) {
              // isPointerUp = (_controller.position.activity.velocity != 0.0) ? 2 : 0;
              if (mounted) {
                setState(() => _scaleY = (extentBeforeValue / value));
              }
            }
          } else {
            // isPointerUp = 0;
            if (_scaleY != 0.0) if (mounted) setState(() => _scaleY = 0.0);
          }
        } else {
          flog('还没到触发条件');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // flog(_scaleY);
    // return widget.child;
    if (widget.isClose) return widget.child!;
    bool isToEnd = true;
    if (widget.isCloseTop) {
      if (_controller!.hasClients) {
        isToEnd = (_controller?.position.extentAfter ?? 1.0) == 0.0;
      }
    }
    // flog(_controller.offset);
    return TweenAnimationBuilder(
      tween: Tween(
          begin: 1.0, end: 1.0 + (isToEnd ? (_scaleY * widget.value) : 0)),
      duration: Duration(milliseconds: widget.animaTime),
      curve: Curves.easeOutCubic,
      child: widget.child,
      builder: (_, double v, vv) {
        var y1 = ((v - 1) * 10 * (widget.index + 1)) * widget.index;
        var btmIndex = (widget.length - widget.index);
        var y2 = (-(v - 1) * 10 * (btmIndex + 1)) * btmIndex;
        var _opacity1 = y1 / widget.opacity;
        var _opacity2 = y2 / widget.opacity;
        var opacity1 =
            _opacity1 >= 1 ? 1.0 : (_opacity1 <= 0 ? 0.0 : _opacity1);
        var opacity2 = (1 + _opacity2) >= 1
            ? 1.0
            : ((1 + _opacity2) <= 0 ? 0.0 : (1 + _opacity2));
        var opacity = [1 - opacity1, opacity2][extentAfter ? (1) : (0)];
        var offset = Offset(0, [y1, y2][extentAfter ? (1) : (0)]);
        if (widget.isCloseOpacity) {
          return Transform.translate(offset: offset, child: vv);
        } else {
          return Opacity(
              opacity: opacity,
              child: Transform.translate(offset: offset, child: vv));
        }
      },
    );
  }
}
