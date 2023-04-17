import 'package:flutter/material.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/tween_widget.dart';

class ExpandedTileController extends ChangeNotifier {
  bool _isExpanded;

  bool get isExpanded => _isExpanded;
  set _setExpanded(bool ex) {
    _isExpanded = ex;
    notifyListeners();
  }

  ExpandedTileController copyWith({
    bool? isExpanded,
  }) {
    return ExpandedTileController(
      isExpanded: isExpanded ?? _isExpanded,
    );
  }

  ExpandedTileController({
    int? key,
    bool isExpanded = false,
  }) : _isExpanded = isExpanded;

  void expand() {
    _setExpanded = true;
    notifyListeners();
  }

  void collapse() {
    _setExpanded = false;
    notifyListeners();
  }

  void toggle() {
    _setExpanded = !isExpanded;
    notifyListeners();
  }
}

class ExpandedTileThemeData {
  final Color headerColor;
  final Color headerSplashColor;
  final EdgeInsetsGeometry headerPadding;
  final double headerRadius;
  // leading
  final EdgeInsetsGeometry leadingPadding;
  // title
  final EdgeInsetsGeometry titlePadding;
  // trailing
  final EdgeInsetsGeometry trailingPadding;
  final Color contentBackgroundColor;
  final EdgeInsetsGeometry contentPadding;
  final double contentRadius;
  const ExpandedTileThemeData({
    key,
    this.headerColor = const Color(0xfffafafa),
    this.headerSplashColor = const Color(0xffeeeeee),
    this.headerPadding = const EdgeInsets.all(16.0),
    this.headerRadius = 8.0,
    this.leadingPadding = const EdgeInsets.symmetric(horizontal: 4.0),
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 12.0),
    this.trailingPadding = const EdgeInsets.symmetric(horizontal: 4.0),
    this.contentBackgroundColor = const Color(0xffeeeeee),
    this.contentPadding = const EdgeInsets.all(16.0),
    this.contentRadius = 8.0,
  });
}

class ExpandedTile extends StatefulWidget {
  final Widget title; // required
  final Widget trailing; // default is chevron icon
  final double trailingRotation; // default is 90
  final Widget content; // required
  final bool enabled;
  final ExpandedTileController controller; // required
  final Curve expansionAnimationCurve;
  final Duration expansionDuration;
  final VoidCallback? onTap;
  final Color? bgColor;
  final EdgeInsets? padding;
  final double? redius;
  const ExpandedTile({
    key,
// Title
    required this.title,
// Trailing
    this.trailing = const Icon(Icons.chevron_right),
    this.trailingRotation = 90,
    required this.content,
    required this.controller,
    this.enabled = true,
    this.expansionDuration = const Duration(milliseconds: 250),
    this.expansionAnimationCurve = Curves.easeInOutCubic,
    this.onTap,
    this.bgColor,
    this.padding,
    this.redius,
  }) : super(key: key);

  ExpandedTile copyWith({
// Leading
    final Widget? leading, // default is none
// Title
    final Widget? title, // required
// Trailing
    final Widget? trailing, // default is chevron icon
    final double? trailingRotation, // default is 90
    final Widget? content, // required
    final double? contentSeperator, // default is 6.0
    final bool? enabled,
    final ExpandedTileThemeData? theme, // default themedata
    final ExpandedTileController? controller, // required
    final Curve? expansionAnimationCurve, // default is ease
    final Duration? expansionDuration, // default is 200ms
    final VoidCallback? onTap,
    final Color? bgColor,
    final EdgeInsets? padding,
    final double? redius,
  }) {
    return ExpandedTile(
      key: key,
      title: title ?? this.title,
      trailing: trailing ?? this.trailing,
      trailingRotation: trailingRotation ?? this.trailingRotation,
      content: content ?? this.content,
      enabled: enabled ?? this.enabled,
      controller: controller ?? this.controller,
      expansionDuration: expansionDuration ?? this.expansionDuration,
      expansionAnimationCurve:
          expansionAnimationCurve ?? this.expansionAnimationCurve,
      onTap: onTap ?? this.onTap,
      bgColor: bgColor ?? this.bgColor,
      padding: padding ?? this.padding,
      redius: redius ?? this.redius,
    );
  }

  @override
  _ExpandedTileState createState() => _ExpandedTileState();
}

class _ExpandedTileState extends State<ExpandedTile>
    with SingleTickerProviderStateMixin {
  ExpandedTileController? tileController;
  bool? _isExpanded;
  @override
  void initState() {
    tileController = widget.controller;
    _isExpanded = tileController!.isExpanded;
    tileController!.addListener(() {
      if (mounted) {
        setState(() {
          _isExpanded = widget.controller.isExpanded;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // tileController.dispose();
    super.dispose();
  }

  double angleToRad(double angle) {
    return angle * 0.0174533;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: !widget.enabled
          ? () {}
          : () {
              tileController!.toggle();
              if (widget.onTap != null) {
                return widget.onTap!();
              }
            },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.redius ?? 0),
        child: Container(
          color: widget.bgColor,
          padding: widget.padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: widget.title,
                    ),
                  ),
                  TweenAnimationBuilder(
                    tween: Tween<double>(
                      begin: 0,
                      end: widget.trailingRotation != null
                          ? _isExpanded!
                              ? angleToRad(widget.trailingRotation)
                              : 0
                          : 0,
                    ),
                    curve: widget.expansionAnimationCurve,
                    duration: widget.expansionDuration,
                    child: widget.trailing,
                    builder: (_, double v, view) {
                      return Transform.rotate(angle: v, child: view);
                    },
                  ),
                ],
              ),
              AnimatedSize(
                duration: widget.expansionDuration,
                curve: widget.expansionAnimationCurve,
                // alignment: Alignment.topCenter,
                child: _isExpanded! ? widget.content : SizedBox(),
                // child: AnimatedSwitchBuilder(
                //   value: DataModel()..flag = 10,
                //   errorOnTap: null,
                //   animationTime: 200,
                //   defaultBuilder: () {
                //     return _isExpanded ? widget.content : SizedBox();
                //   },
                // ),
              ),
              // ClipRect(
              //   child: AnimatedAlign(
              //     duration: widget.expansionDuration,
              //     curve: widget.expansionAnimationCurve,
              //     alignment: Alignment.topCenter,
              //     heightFactor: _isExpanded ? 1 : 0,
              //     child: _isExpanded ? widget.content : SizedBox(),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

enum TileListConstructor {
  builder,
  seperated,
}

typedef ExpandedTileBuilder = ExpandedTile Function(
    BuildContext context, int index, ExpandedTileController controller);

class ExpandedTileList extends StatefulWidget {
  final bool reverse;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final ExpandedTileBuilder itemBuilder;
  final IndexedWidgetBuilder? seperatorBuilder;
  final int? animationDelayed;
  final int itemCount;
  final String? restorationId;
  final int maxOpened;
  final TileListConstructor _constructor;

  const ExpandedTileList.builder({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.physics,
    this.restorationId,
    this.reverse = false,
    this.shrinkWrap = true,
    this.maxOpened = 1,
    this.animationDelayed,
  })  : assert(itemCount != 0),
        assert(maxOpened != 0),
        _constructor = TileListConstructor.builder,
        seperatorBuilder = null,
        super(key: key);

  const ExpandedTileList.seperated({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    required this.seperatorBuilder,
    this.padding,
    this.physics,
    this.restorationId,
    this.reverse = false,
    this.shrinkWrap = true,
    this.maxOpened = 1,
    this.animationDelayed,
  })  : assert(itemCount != 0),
        assert(maxOpened != 0),
        _constructor = TileListConstructor.seperated,
        super(key: key);

  @override
  _ExpandedTileListState createState() => _ExpandedTileListState();
}

class _ExpandedTileListState extends State<ExpandedTileList> {
  List<ExpandedTileController>? tileControllers;
  List<ExpandedTileController>? openedTilesControllers;
  ScrollController? scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    tileControllers = List.generate(
      widget.itemCount,
      (index) => ExpandedTileController(key: index),
    );
    openedTilesControllers = [];
  }

  @override
  Widget build(BuildContext context) {
    return widget._constructor == TileListConstructor.builder
        ? ListView.builder(
            shrinkWrap: widget.shrinkWrap,
            controller: scrollController,
            itemCount: widget.itemCount,
            reverse: widget.reverse,
            physics: widget.physics,
            padding: widget.padding,
            itemBuilder: (context, index) {
              return TweenWidget(
                delayed: (scrollController!.offset > 0)
                    ? 0
                    : (widget.animationDelayed ??
                            RouteState.listVerticalAnimationTime) +
                        (widget.itemCount <= 5 ? 30 : 20) * index,
                axis: Axis.vertical,
                value: (scrollController!.offset > 0) ? 1 : 50,
                isScale: (scrollController!.offset > 0),
                isReverseScale: true,
                scaleX: -0.25,
                scaleY: -0.25,
                time: RouteState.listAnimationTime,
                alphaTime: RouteState.listAnimationTime,
                curve: Curves.easeOutCubic,
                child: widget
                    .itemBuilder(
                      context,
                      index,
                      tileControllers![index],
                    )
                    .copyWith(
                        controller: tileControllers![index],
                        onTap: !widget
                                .itemBuilder(
                                  context,
                                  index,
                                  tileControllers![index],
                                )
                                .enabled
                            ? () {}
                            : () {
                                int openedTiles =
                                    openedTilesControllers!.length;
                                if (tileControllers![index].isExpanded) {
                                  if (openedTiles == widget.maxOpened) {
                                    openedTilesControllers!.last.collapse();
                                    openedTilesControllers!
                                        .remove(openedTilesControllers!.last);
                                  }
                                  openedTilesControllers!
                                      .add(tileControllers![index]);
                                } else {
                                  openedTilesControllers!
                                      .remove(tileControllers![index]);
                                }
                              }),
              );
            },
          )
        : ListView.separated(
            shrinkWrap: widget.shrinkWrap,
            controller: scrollController,
            itemCount: widget.itemCount,
            reverse: widget.reverse,
            physics: widget.physics,
            padding: widget.padding,
            separatorBuilder: (context, index) {
              return widget.seperatorBuilder!(
                context,
                index,
              );
            },
            itemBuilder: (context, index) {
              return TweenWidget(
                delayed: (scrollController!.offset > 0)
                    ? 0
                    : (widget.animationDelayed ??
                            RouteState.listVerticalAnimationTime) +
                        (widget.itemCount <= 5 ? 30 : 20) * index,
                axis: Axis.vertical,
                value: (scrollController!.offset > 0) ? 1 : 50,
                isScale: (scrollController!.offset > 0),
                isReverseScale: true,
                scaleX: -0.25,
                scaleY: -0.25,
                time: RouteState.listAnimationTime,
                alphaTime: RouteState.listAnimationTime,
                curve: Curves.easeOutCubic,
                child: widget
                    .itemBuilder(
                      context,
                      index,
                      tileControllers![index],
                    )
                    .copyWith(
                        controller: tileControllers![index],
                        onTap: !widget
                                .itemBuilder(
                                  context,
                                  index,
                                  tileControllers![index],
                                )
                                .enabled
                            ? () {}
                            : () {
                                int openedTiles =
                                    openedTilesControllers!.length;
                                if (tileControllers![index].isExpanded) {
                                  if (openedTiles == widget.maxOpened) {
                                    openedTilesControllers!.last.collapse();
                                    openedTilesControllers!
                                        .remove(openedTilesControllers!.last);
                                  }
                                  openedTilesControllers!
                                      .add(tileControllers![index]);
                                } else {
                                  openedTilesControllers!
                                      .remove(tileControllers![index]);
                                }
                              }),
              );
            },
          );
  }
}
