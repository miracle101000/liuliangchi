import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const double _kMinCircularProgressIndicatorWidgetSize = 36.0;
const int _kIndeterminateCircularDuration = 1333 * 2222;

enum _ActivityIndicatorType { material, adaptive }

abstract class ProgressIndicator extends StatefulWidget {
  const ProgressIndicator({
    Key? key,
    this.value,
    this.backgroundColor,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
  }) : super(key: key);

  final double? value;

  final Color? backgroundColor;

  final Animation<Color>? valueColor;

  final String? semanticsLabel;

  final String? semanticsValue;

  Color _getValueColor(BuildContext context) =>
      valueColor?.value ?? Theme.of(context).colorScheme.secondary;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(PercentProperty('value', value,
        showName: false, ifNull: '<indeterminate>'));
  }

  Widget _buildSemanticsWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    String? expandedSemanticsValue = semanticsValue;
    if (value != null) {
      expandedSemanticsValue ??= '${(value! * 100).round()}%';
    }
    return Semantics(
      label: semanticsLabel,
      value: expandedSemanticsValue,
      child: child,
    );
  }
}

class _CircularProgressIndicatorWidgetPainter extends CustomPainter {
  _CircularProgressIndicatorWidgetPainter({
    this.backgroundColor,
    @required this.valueColor,
    @required this.value,
    @required this.headValue,
    @required this.tailValue,
    @required this.offsetValue,
    @required this.rotationValue,
    @required this.strokeWidth,
  })  : arcStart = value != null
            ? _startAngle
            : _startAngle +
                tailValue! * 3 / 2 * math.pi +
                rotationValue! * math.pi * 2.0 +
                offsetValue! * 0.5 * math.pi,
        arcSweep = value != null
            ? value.clamp(0.0, 1.0) * _sweep
            : math.max(
                headValue! * 3 / 2 * math.pi - tailValue! * 3 / 2 * math.pi,
                _epsilon);

  final Color? backgroundColor;
  final Color? valueColor;
  final double? value;
  final double? headValue;
  final double? tailValue;
  final double? offsetValue;
  final double? rotationValue;
  final double? strokeWidth;
  final double arcStart;
  final double arcSweep;

  static const double _twoPi = math.pi * 2.0;
  static const double _epsilon = .001;
  static const double _sweep = _twoPi - _epsilon;
  static const double _startAngle = -math.pi / 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = valueColor!
      ..strokeWidth = strokeWidth!
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    if (backgroundColor != null) {
      final Paint backgroundPaint = Paint()
        ..color = backgroundColor!
        ..strokeWidth = strokeWidth!
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawArc(Offset.zero & size, 0, _sweep, false, backgroundPaint);
    }

    // if (value == null)
    // paint.strokeCap = StrokeCap.round;

    canvas.drawArc(Offset.zero & size, arcStart, arcSweep, false, paint);
  }

  @override
  bool shouldRepaint(_CircularProgressIndicatorWidgetPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value ||
        oldPainter.headValue != headValue ||
        oldPainter.tailValue != tailValue ||
        oldPainter.offsetValue != offsetValue ||
        oldPainter.rotationValue != rotationValue ||
        oldPainter.strokeWidth != strokeWidth;
  }
}

class CircularProgressIndicatorWidget extends ProgressIndicator {
  const CircularProgressIndicatorWidget({
    Key? key,
    double? value,
    Color? backgroundColor,
    Animation<Color>? valueColor,
    this.strokeWidth = 4.0,
    String? semanticsLabel,
    String? semanticsValue,
  })  : _indicatorType = _ActivityIndicatorType.material,
        super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
          semanticsLabel: semanticsLabel,
          semanticsValue: semanticsValue,
        );

  const CircularProgressIndicatorWidget.adaptive({
    Key? key,
    double? value,
    Color? backgroundColor,
    Animation<Color>? valueColor,
    this.strokeWidth = 4.0,
    String? semanticsLabel,
    String? semanticsValue,
  })  : _indicatorType = _ActivityIndicatorType.adaptive,
        super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
          semanticsLabel: semanticsLabel,
          semanticsValue: semanticsValue,
        );

  final _ActivityIndicatorType _indicatorType;

  final double strokeWidth;

  @override
  _CircularProgressIndicatorWidgetState createState() =>
      _CircularProgressIndicatorWidgetState();
}

class _CircularProgressIndicatorWidgetState
    extends State<CircularProgressIndicatorWidget>
    with SingleTickerProviderStateMixin {
  static const int _pathCount = _kIndeterminateCircularDuration ~/ 1333;
  static const int _rotationCount = _kIndeterminateCircularDuration ~/ 2222;

  static final Animatable<double> _strokeHeadTween = CurveTween(
    curve: const Interval(0.0, 0.5, curve: Curves.fastOutSlowIn),
  ).chain(CurveTween(
    curve: const SawTooth(_pathCount),
  ));
  static final Animatable<double> _strokeTailTween = CurveTween(
    curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
  ).chain(CurveTween(
    curve: const SawTooth(_pathCount),
  ));
  static final Animatable<double> _offsetTween =
      CurveTween(curve: const SawTooth(_pathCount));
  static final Animatable<double> _rotationTween =
      CurveTween(curve: const SawTooth(_rotationCount));

  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateCircularDuration),
      vsync: this,
    );
    if (widget.value == null) _controller!.repeat();
  }

  @override
  void didUpdateWidget(CircularProgressIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller!.isAnimating)
      _controller!.repeat();
    else if (widget.value != null && _controller!.isAnimating)
      _controller!.stop();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Widget _buildCupertinoIndicator(BuildContext context) {
    return CupertinoActivityIndicator(key: widget.key);
  }

  Widget _buildMaterialIndicator(BuildContext context, double headValue,
      double tailValue, double offsetValue, double rotationValue) {
    return widget._buildSemanticsWrapper(
      context: context,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: _kMinCircularProgressIndicatorWidgetSize,
          minHeight: _kMinCircularProgressIndicatorWidgetSize,
        ),
        child: CustomPaint(
          painter: _CircularProgressIndicatorWidgetPainter(
            backgroundColor: widget.backgroundColor,
            valueColor: widget._getValueColor(context),
            value: widget.value,
            headValue: headValue,
            tailValue: tailValue,
            offsetValue: offsetValue,
            rotationValue: rotationValue,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    return AnimatedBuilder(
      animation: _controller!,
      builder: (BuildContext context, Widget? child) {
        return _buildMaterialIndicator(
          context,
          _strokeHeadTween.evaluate(_controller!),
          _strokeTailTween.evaluate(_controller!),
          _offsetTween.evaluate(_controller!),
          _rotationTween.evaluate(_controller!),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (widget._indicatorType) {
      case _ActivityIndicatorType.material:
        if (widget.value != null)
          return _buildMaterialIndicator(context, 0.0, 0.0, 0, 0.0);
        return _buildAnimation();
      case _ActivityIndicatorType.adaptive:
        final ThemeData theme = Theme.of(context);
        assert(theme.platform != null);
        switch (theme.platform) {
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            return _buildCupertinoIndicator(context);
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            if (widget.value != null)
              return _buildMaterialIndicator(context, 0.0, 0.0, 0, 0.0);
            return _buildAnimation();
        }
    }
  }
}
