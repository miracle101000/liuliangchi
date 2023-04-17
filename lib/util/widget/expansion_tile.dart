import 'package:flutter/material.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class ExpansionTileWidget extends StatefulWidget {
  const ExpansionTileWidget({
    Key? key,
    this.leading,
    required this.title,
    this.subtitle,
    this.backgroundColor,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.tilePadding,
    this.expandedCrossAxisAlignment,
    this.expandedAlignment,
    this.childrenPadding,
    this.collapsedBackgroundColor,
    this.expandView,
    this.controller,
    this.onTap,
  })  : assert(initiallyExpanded != null),
        assert(maintainState != null),
        assert(
          expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
          'CrossAxisAlignment.baseline is not supported since the expanded children '
          'are aligned in a column, not a row. Try to use another constant.',
        ),
        super(key: key);

  final Widget? leading;

  final Widget title;

  final Widget? subtitle;

  final ValueChanged<bool>? onExpansionChanged;

  final List<Widget> children;

  final Color? backgroundColor;

  final Color? collapsedBackgroundColor;

  final Widget? trailing;

  final bool initiallyExpanded;

  final bool maintainState;

  final EdgeInsetsGeometry? tilePadding;

  final Alignment? expandedAlignment;

  final CrossAxisAlignment? expandedCrossAxisAlignment;

  final EdgeInsetsGeometry? childrenPadding;

  final Widget? expandView;

  final AnimationController? controller;
  final Function()? onTap;

  @override
  _ExpansionTileWidgetState createState() => _ExpansionTileWidgetState();
}

class _ExpansionTileWidgetState extends State<ExpansionTileWidget>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeInOutCubic);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeInOutCubic);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final Tween<Color> _borderColorTween = Tween<Color>();
  final Tween<Color> _headerColorTween = Tween<Color>();
  final Tween<Color> _iconColorTween = Tween<Color>();
  final Tween<Color> _backgroundColorTween = Tween<Color>();

  AnimationController? _controller;
  // ignore: unused_field
  Animation<double>? _iconTurns;
  Animation<double>? _heightFactor;
  Animation<Color>? _borderColor;
  // ignore: unused_field
  Animation<Color>? _headerColor;
  // ignore: unused_field
  Animation<Color>? _iconColor;
  Animation<Color>? _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller!.drive(_easeInTween);
    _iconTurns = _controller!.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller!.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller!.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller!.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller!.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.of(context).readState(context) as bool;
    if (_isExpanded) _controller!.value = 1.0;
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller!.forward();
      } else {
        _controller!.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {});
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null)
      widget.onExpansionChanged!(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    // ignore: unused_local_variable
    final Color borderSideColor = _borderColor!.value ?? Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor!.value ?? Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: widget.onTap ?? _handleTap,
            behavior: HitTestBehavior.translucent,
            child: Row(
              children: [
                Expanded(child: widget.title),
                if (widget.expandView != null)
                  RotationTransition(
                    turns: _iconTurns!,
                    child: widget.expandView,
                  ),
              ],
            ),
          ),
          // ListTileTheme.merge(
          //   iconColor: _iconColor.value,
          //   textColor: _headerColor.value,
          //   child: ListTile(
          //     onTap: _handleTap,
          //     contentPadding: widget.tilePadding,
          //     leading: widget.leading,
          //     title: widget.title,
          //     subtitle: widget.subtitle,
          //     trailing: widget.trailing ?? RotationTransition(
          //       turns: _iconTurns,
          //       child: const Icon(Icons.expand_more),
          //     ),
          //   ),
          // ),
          ClipRect(
            child: Align(
              alignment: widget.expandedAlignment ?? Alignment.center,
              heightFactor: _heightFactor!.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween.end = theme.dividerColor;
    _headerColorTween
      ..begin = theme.textTheme.subtitle1!.color
      ..end = theme.colorScheme.secondary;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.colorScheme.secondary;
    _backgroundColorTween
      ..begin = widget.collapsedBackgroundColor
      ..end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller!.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
        offstage: closed,
        child: TickerMode(
          enabled: !closed,
          child: Padding(
            padding: widget.childrenPadding ?? EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: widget.expandedCrossAxisAlignment ??
                  CrossAxisAlignment.center,
              children: widget.children,
            ),
          ),
        ));

    return AnimatedBuilder(
      animation: _controller!.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}
