import 'package:flutter/material.dart';

class WidgetTap extends StatefulWidget {
  final Widget? child;
  final bool isElastic;
  final bool isRipple;
  final Color? rippleColor;
  final Duration jumpTime;
  final HitTestBehavior? behavior;
  final void Function()? onTap;

  const WidgetTap({
    Key? key,
    this.child,
    this.onTap,
    this.isElastic = false,
    this.isRipple = true,
    this.rippleColor,
    this.jumpTime = Duration.zero,
    this.behavior,
  }) : super(key: key);

  @override
  _WidgetTapState createState() => _WidgetTapState();
}

class _WidgetTapState extends State<WidgetTap> with TickerProviderStateMixin {
  AnimationController? animac, animac1;
  Animation? anima, anima1, anima2, anima3;
  bool flag = true;

  //var _lastPressedAdt;

  @override
  void dispose() {
    super.dispose();
    animac!.dispose();
    animac1!.dispose();
  }

  @override
  void initState() {
    animac = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animac1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    var curvedAnimation =
        CurvedAnimation(parent: animac!, curve: ElasticOutCurve(0.75));
    anima = Tween(begin: 1.0, end: 1.1).animate(curvedAnimation);
    anima1 = Tween(begin: 1.1, end: 1.0).animate(curvedAnimation);
    anima2 = Tween(begin: 0.0, end: 200.0).animate(animac1!);
    anima3 = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animac1!,
        curve: Curves.easeOutCubic,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // if (!kIsWeb)
        // AnimatedBuilder(
        //   animation: animac1,
        //   builder: (_, v) {
        //     return Opacity(
        //       opacity: anima3.value,
        //       child: Transform.scale(
        //         child: Container(
        //           height: anima3.value == 0.0 ? 0 : 2,
        //           width: anima3.value == 0.0 ? 0 : 2,
        //           decoration: BoxDecoration(
        //             // color: widget.rippleColor == null ? Colors.black.withOpacity(0.05) : widget.rippleColor,
        //             // color: Colors.pink,
        //             borderRadius: BorderRadius.circular(10),
        //             border: Border.all(
        //               width: 2 * anima3.value,
        //               color: widget.rippleColor == null ? Theme.of(context).colorScheme.secondary.withOpacity(0.25) : widget.rippleColor,
        //             ),
        //           ),
        //         ),
        //         scale: widget.isRipple ? anima2.value / 2 : 1,
        //       ),
        //     );
        //   },
        // ),
        if (animac != null && anima != null && anima1 != null)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              behavior: widget.behavior ?? HitTestBehavior.translucent,
              child: AnimatedBuilder(
                animation: animac!,
                child: widget.child,
                builder: (_, v) {
                  return Transform.scale(
                    scale: widget.isElastic
                        ? flag
                            ? anima!.value
                            : anima1!.value
                        : 1,
                    child: v,
                  );
                },
              ),
              onTapDown: (v) => animaStart(true),
              onTapCancel: () => animaStart(false),
              onTapUp: (v) async {
                animaStart(false);
                if (widget.isRipple) animac1!.forward(from: 0.0);
                if (widget.isElastic || widget.isRipple) {
                  await Future.delayed(widget.jumpTime);
                }
                if (context.mounted) {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
                widget.onTap!();
              },
            ),
          ),
      ],
    );
  }

  ///执行动画
  Future animaStart(bool f) async {
    if (widget.isElastic) {
      if (f) {
        flag = f;
        await animac!.forward(from: 0.0);
      } else {
        await Future.delayed(const Duration(milliseconds: 100));
        flag = f;
        await animac!.forward(from: 0.0);
      }
    }
  }
}
