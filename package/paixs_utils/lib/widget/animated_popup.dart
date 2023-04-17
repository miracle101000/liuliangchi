// import 'package:flutter/material.dart';
// import 'package:paixs_utils/util/utils.dart';
// import 'package:paixs_utils/widget/button.dart';
// import 'package:paixs_utils/widget/mytext.dart';
// import 'package:paixs_utils/widget/paixs_widget.dart';
// import 'package:paixs_utils/widget/route.dart';
// import 'package:paixs_utils/widget/views.dart';

// enum AnimatedType {
//   ///移动
//   Slide,

//   ///缩放
//   Scale
// }

// ///动画控制器全局
// AnimatedPopupValue animaPopupPro = AnimatedPopupValue();

// class AnimatedPopupValue extends ValueNotifier {
//   AnimatedPopupValue() : super(null);

//   ///动画类型
//   AnimatedType mAnimatedType = AnimatedType.Slide;

//   ///动画区间值
//   Offset mSlideBegin = Offset(0, 1);
//   double mScaleBegin = 0.9;

//   ///动画控制器
//   Animation animation;
//   AnimationController animationCon;

//   Widget mChild;
//   String mTitle;
//   String mContent;
//   String mCancelText = '取消';
//   String mOkText = '确定';
//   Color mOkColor;
//   bool mIsDark = false;
//   bool mIsClose = true;
//   bool mIsTips = false;
//   bool mIsCenter = true;
//   bool mIsReverse = false;
//   bool mIsAlign = false;
//   double mLineH;
//   bool mIsAutoClose = true;
//   Function() mOnSuccess;
//   Function() mOnError;
//   Alignment mAlignment;
//   Color mBgColor = Colors.black.withOpacity(0.7);

//   ///开始动画
//   TickerFuture open({
//     String title,
//     String content,
//     String cancelText = '取消',
//     String okText = '确定',
//     Color okColor,
//     bool isDark = false,
//     bool isClose = true,
//     bool isTips = false,
//     bool isCenter = true,
//     double lineH,
//     Widget child,
//     bool isAutoClose = true,
//     Function() onSuccess,
//     Function() onError,
//     Alignment alignment,
//     AnimatedType animatedType,
//     Offset slideBegin,
//     double scaleBegin,
//     bool isReverse,
//     bool isAlign,
//     Color bgColor,
//   }) {
//     FocusScope.of(context).requestFocus(FocusNode());
//     mChild = child;
//     mTitle = title;
//     mContent = content;
//     mCancelText = cancelText;
//     mOkText = okText;
//     mOkColor = okColor;
//     mIsDark = isDark;
//     mIsClose = isClose;
//     mIsTips = isTips;
//     mIsCenter = isCenter;
//     mLineH = lineH;
//     mIsAutoClose = isAutoClose;
//     mOnSuccess = onSuccess;
//     mOnError = onError;
//     mAlignment = alignment;
//     mAnimatedType = animatedType ?? AnimatedType.Scale;
//     mSlideBegin = slideBegin ?? Offset(0, -0.025);
//     mScaleBegin = scaleBegin ?? 0.9;
//     mIsReverse = isReverse ?? false;
//     mBgColor = bgColor ?? Colors.black54.withOpacity(0.7);
//     mIsAlign = isAlign ?? false;
//     return animationCon.forward();
//   }

//   ///关闭动画
//   TickerFuture close() {
//     FocusScope.of(context).requestFocus(FocusNode());
//     return animationCon.reverse();
//   }
// }

// ///动画弹出窗口
// class AnimatedPopup extends StatefulWidget {
//   const AnimatedPopup({Key key}) : super(key: key);
//   @override
//   _AnimatedPopupState createState() => _AnimatedPopupState();
// }

// class _AnimatedPopupState extends State<AnimatedPopup> with TickerProviderStateMixin {
//   @override
//   void initState() {
//     this.initData();
//     super.initState();
//   }

//   ///初始化函数
//   Future initData() async {
//     animaPopupPro.animationCon = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
//     animaPopupPro.animation = CurvedAnimation(
//       parent: Tween(begin: 0.0, end: 1.0).animate(animaPopupPro.animationCon),
//       curve: Curves.easeOutCubic,
//       reverseCurve: Curves.easeInCubic,
//     );
//     animaPopupPro.animationCon.addListener(() => setState(() {}));
//     animaPopupPro.animationCon.addStatusListener((s) => flog(s, 'Status'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     var isReverse = animaPopupPro.mIsReverse && animaPopupPro.animationCon.status == AnimationStatus.reverse;
//     Widget view = WillPopScope(
//       onWillPop: () => Future(() {
//         if (animaPopupPro.mIsClose) {
//           animaPopupPro.close();
//           return false;
//         } else {
//           return false;
//         }
//       }),
//       child: GestureDetector(
//         onTap: () {
//           if (animaPopupPro.mIsClose) animaPopupPro.close();
//         },
//         child: Material(
//           color: Colors.transparent,
//           child: Center(
//             child: GestureDetector(
//               onTap: () {},
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : size(context).width / 3),
//                 child: Container(
//                   // width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: animaPopupPro.mIsDark ? Color(0xFF141414) : Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                     boxShadow: [
//                       BoxShadow(
//                         blurRadius: 16,
//                         // spreadRadius: -8,
//                         color: Colors.black26,
//                         offset: Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   child: AlignWHTransition(
//                     alignment: Alignment.center,
//                     wh: Tween(begin: 0.75, end: 1.0).animate(animaPopupPro.animation),
//                     isOpen: animaPopupPro.mIsAlign,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         if (animaPopupPro.mTitle != null)
//                           Padding(
//                             // padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16)
//                             padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: animaPopupPro.mContent == null ? 24 : 16),
//                             child: MyText(
//                               animaPopupPro.mTitle,
//                               size: 18,
//                               isBold: true,
//                               isOverflow: false,
//                               color: animaPopupPro.mIsDark ? Colors.white54 : Colors.black.withOpacity(0.7),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         if (animaPopupPro.mContent != null)
//                           Padding(
//                             padding: EdgeInsets.only(left: 16, right: 16, bottom: 32, top: animaPopupPro.mTitle == null ? 32 : 0),
//                             child: MyText(
//                               animaPopupPro.mContent,
//                               isBold: true,
//                               color: (animaPopupPro.mIsDark ? Colors.white54 : Colors.black.withOpacity(0.7)).withOpacity(0.5),
//                               isOverflow: false,
//                               height: animaPopupPro.mLineH,
//                               textAlign: animaPopupPro.mIsCenter ? TextAlign.center : TextAlign.left,
//                             ),
//                           ),
//                         Container(
//                           height: 1,
//                           width: double.infinity,
//                           margin: EdgeInsets.symmetric(horizontal: 16),
//                           color: animaPopupPro.mIsDark ? Colors.white.withOpacity(0.05) : Color(0x10000000),
//                         ),
//                         Row(
//                           children: <Widget>[
//                             if (!animaPopupPro.mIsTips)
//                               Expanded(
//                                 child: Button(
//                                   height: 48,
//                                   onPressed: () {
//                                     animaPopupPro.close();
//                                     if (animaPopupPro.mOnError != null) animaPopupPro.mOnError();
//                                   },
//                                   child: MyText(
//                                     animaPopupPro.mCancelText,
//                                     isBold: true,
//                                     size: 16,
//                                     color: animaPopupPro.mIsDark ? Colors.white54 : Colors.black.withOpacity(0.7),
//                                   ),
//                                 ),
//                               ),
//                             if (!animaPopupPro.mIsTips) Container(height: 32, width: 1, color: animaPopupPro.mIsDark ? Colors.white.withOpacity(0.05) : Color(0x10000000)),
//                             Expanded(
//                               child: Button(
//                                 height: 48,
//                                 onPressed: () {
//                                   if (animaPopupPro.mIsAutoClose) animaPopupPro.close();
//                                   if (animaPopupPro.mOnSuccess != null) animaPopupPro.mOnSuccess();
//                                 },
//                                 child: MyText(
//                                   animaPopupPro.mOkText,
//                                   isBold: true,
//                                   size: 16,
//                                   color: animaPopupPro.mOkColor ?? Theme.of(context).primaryColor,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//     switch (animaPopupPro.mAnimatedType) {
//       case AnimatedType.Slide:
//         view = SlideTransition(
//           position: Tween(begin: isReverse ? -animaPopupPro.mSlideBegin : animaPopupPro.mSlideBegin, end: Offset(0, 0)).animate(animaPopupPro.animation),
//           child: animaPopupPro.mChild ?? view,
//         );
//         break;
//       case AnimatedType.Scale:
//         view = ScaleTransition(
//           scale: Tween(begin: isReverse ? 1.0 + (1.0 - animaPopupPro.mScaleBegin) : animaPopupPro.mScaleBegin, end: 1.0).animate(animaPopupPro.animation),
//           child: animaPopupPro.mChild ?? view,
//         );
//         break;
//     }
//     return Visibility(
//       visible: !(animaPopupPro.animationCon.status == AnimationStatus.dismissed),
//       child: Stack(alignment: animaPopupPro.mAlignment ?? AlignmentDirectional.topStart, children: [
//         Opacity(
//           opacity: animaPopupPro.animation.value,
//           child: PWidget.container(
//             null,
//             [null, null, animaPopupPro.mBgColor],
//             {'fun': () => animaPopupPro.close()},
//           ),
//         ),
//         FadeTransition(
//           opacity: animaPopupPro.animation,
//           child: view,
//         ),
//       ]),
//     );
//   }
// }

// ///Align宽高转换
// class AlignWHTransition extends AnimatedWidget {
//   const AlignWHTransition({
//     Key key,
//     @required Animation<double> wh,
//     this.alignment = Alignment.center,
//     this.child,
//     this.isOpen = false,
//   })  : assert(wh != null),
//         super(key: key, listenable: wh);
//   Animation<double> get wh => listenable as Animation<double>;
//   final Alignment alignment;
//   final Widget child;
//   final bool isOpen;

//   @override
//   Widget build(BuildContext context) {
//     final double whValue = wh.value;
//     if (isOpen) {
//       return Align(
//         alignment: alignment,
//         heightFactor: whValue,
//         widthFactor: whValue,
//         child: child,
//       );
//     } else {
//       return child;
//     }
//   }
// }
