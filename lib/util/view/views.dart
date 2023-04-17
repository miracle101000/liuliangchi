// ignore_for_file: unnecessary_null_in_if_null_operators, prefer_final_fields, constant_identifier_names

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/image.dart';
import 'package:paixs_utils/widget/my_bouncing_scroll_physics.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/photo_widget.dart';
import 'package:paixs_utils/widget/refresher_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/tween_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';
import 'package:html/parser.dart' as dom;

import '../config/common_config.dart';
import '../paxis_fun.dart';

Widget htmlView(data) {
  return Html(
    data: data,
    customImageRenders: {
      networkSourceMatcher(): (context, attributes, element) {
        var v = attributes;
        return GestureDetector(
          onTap: () {
            var list = dom.parse(data).querySelectorAll('img');
            var imgs = list.map((m) => m.attributes['src']).toList();
            jumpPage(PhotoView(
              images: imgs,
              isUrl: true,
              index: imgs.indexWhere((iw) => iw == v['src']),
            ));
          },
          child: WrapperImage(url: v['src']),
        );
      }
    },
  );
}

Widget btnView(
  text, {
  Function? fun,
  double redius = 16,
  isAnima = true,
  bool isExp = false,
  double? height,
  double textSize = 16.0,
  Color? bgColor,
}) {
  Widget view = TweenWidget(
    axis: Axis.vertical,
    delayed: 200,
    isOnlyTransparent: !isAnima,
    alphaTime: !isAnima ? 0 : 400,
    // key: ValueKey(!isAnima ? 1 : Random.secure()),
    child: PWidget.container(
      PWidget.text(text ?? '文本', [Colors.white, textSize ?? 18], {'ct': true}),
      [null, height ?? 48, pColor],
      {
        'mg': !isAnima ? null : PFun.lg(10, pmPadd.bottom + 10, 15, 15),
        // 'gd': (bgColor != null) ? PFun.cl2crGd(bgColor, bgColor) : gdFun(),
        'fun': fun,
        'crr': redius * 2,
      },
    ),
  );
  if (isExp) view = Expanded(child: view);
  return view;
}

///搜索视图
Widget sousuoView() {
  return Container(
    padding: const EdgeInsets.only(left: 12, right: 8, top: 8, bottom: 8),
    child: SvgPicture.asset(
      'assets/svg/搜索.svg',
      width: 16,
      height: 16,
      color: aColor.withOpacity(0.5),
    ),
  );
}

///渐变色
List<dynamic> gdFun() =>
    PFun.cl2crGd(const Color(0xffFB8931), const Color(0xffF95A22));

///右箭头
Widget rightJtView([size]) {
  return PWidget.icon(
    Icons.arrow_forward_ios_rounded,
    [aColor.withOpacity(0.25), size ?? 16],
  );
}

///底部箭头
Widget bottomJtView([size, double? angle, Color? color]) {
  return Transform.rotate(
    angle: angle ?? (pi / 2),
    child: PWidget.icon(
      Icons.arrow_forward_ios_rounded,
      [color ?? aColor.withOpacity(0.25), size ?? 12],
    ),
  );
}

///向上箭头
Widget topJtView([size]) {
  return Transform.rotate(
    angle: pi / -2,
    child: PWidget.icon(
      Icons.arrow_forward_ios_rounded,
      [aColor.withOpacity(0.25), size ?? 16],
    ),
  );
}

///构建文本框
Widget buildTFView(
  BuildContext context, {
  bool isExp = false,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  required String hintText,
  void Function(String)? onChanged,
  void Function()? onTap,
  void Function(String)? onSubmitted,
  TextStyle? textStyle,
  TextStyle? hintStyle,
  FocusNode? focusNode,
  TextInputAction? textInputAction,
  double hintSize = 14,
  Color? hintColor,
  Color? cursorColor,
  double? textSize = 14,
  Color? textColor,
  EdgeInsetsGeometry? padding,
  TextEditingController? con,
  TextAlign? textAlign,
  bool isInt = false,
  bool isDouble = false,
  bool isAz = false,
  bool isEdit = true,
  bool autofocus = false,
  int maxLines = 1,
  double? height = 20,
  int? maxLength,
  int doubleCount = 10000,
}) {
  return [
    Expanded(
      child: WidgetTap(
        onTap: onTap,
        child: Container(
          padding: padding ?? EdgeInsets.zero,
          height: height,
          child: TextField(
            focusNode: focusNode,
            controller: con,
            maxLines: maxLines,
            enabled: isEdit,
            maxLength: maxLength,
            inputFormatters: [
              // ignore: deprecated_member_use
              if (isAz)
                FilteringTextInputFormatter(RegExp("[a-zA-Z]"),
                    allow: true), //只允许输入字母
              // ignore: deprecated_member_use
              if (isInt) FilteringTextInputFormatter.digitsOnly, //只允许输入数字
              // ignore: deprecated_member_use
              if (isDouble)
                FilteringTextInputFormatter(RegExp("[0-9.0-9]"),
                    allow: true), //只允许输入小数
              if (isDouble) PrecisionLimitFormatter(doubleCount)
            ],
            style:
                (textStyle ?? TextStyle(fontSize: textSize, color: textColor))
                    .copyWith(height: 1.5),
            cursorColor: cursorColor ?? Theme.of(context).primaryColor,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            obscureText: obscureText,
            textAlign: textAlign ?? TextAlign.start,
            autofocus: autofocus,
            decoration: InputDecoration(
              hintStyle: TextStyle(
                  fontSize: hintSize,
                  color: hintColor ?? const Color(0x80666666),
                  height: 1.5),
              counterText: '',
              hintText: hintText,
              border: const OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: onChanged,
            onTap: onTap,
            onSubmitted: onSubmitted,
          ),
        ),
      ),
    ),
    WidgetTap(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.zero,
        height: height,
        child: TextField(
          focusNode: focusNode ?? null,
          style: (textStyle ?? TextStyle(fontSize: textSize, color: textColor))
              .copyWith(height: 1.5),
          cursorColor: cursorColor ?? Theme.of(context).primaryColor,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          maxLength: maxLength,
          controller: con,
          enabled: isEdit,
          autofocus: autofocus,
          inputFormatters: [
            // ignore: deprecated_member_use
            if (isAz)
              FilteringTextInputFormatter(RegExp("[a-zA-Z]"),
                  allow: true), //只允许输入字母
            // ignore: deprecated_member_use
            if (isInt) FilteringTextInputFormatter.digitsOnly, //只允许输入数字
            // ignore: deprecated_member_use
            if (isDouble)
              FilteringTextInputFormatter(RegExp("[0-9.0-9]"),
                  allow: true), //只允许输入小数
            if (isDouble) PrecisionLimitFormatter(doubleCount)
          ],
          textAlign: textAlign ?? TextAlign.start,
          decoration: InputDecoration(
            counterText: '',
            hintStyle: (hintStyle ??
                    TextStyle(
                      fontSize: hintSize,
                      color: hintColor ?? const Color(0x80666666),
                    ))
                .copyWith(height: 1.5),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            hintText: hintText,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: onChanged,
          onTap: onTap,
          onSubmitted: onSubmitted,
        ),
      ),
    )
  ][isExp ? 0 : 1];
}

///自定义按钮
class CustomButton extends StatelessWidget {
  final String? title;
  final Color? bgColor;
  final Color? tColor;
  final bool? isExp;
  final bool isTbold;
  final double? height;
  final double tSize;
  final Function? fun;
  final List? mg;
  final List? pd;

  const CustomButton({
    Key? key,
    this.title,
    this.bgColor,
    this.tColor,
    this.isExp,
    this.fun,
    this.height,
    this.mg,
    this.tSize = 15,
    this.isTbold = true,
    this.pd,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PWidget.container(
      PWidget.text(title ?? "取消",
          [(tColor ?? aColor.withOpacity(0.5)), tSize, isTbold], {'ct': true}),
      [null, height, (bgColor ?? const Color(0xFF787878).withOpacity(0.3))],
      {
        if (isExp ?? true) 'exp': true,
        'pd': pd ?? [10, 10, 0, 0],
        'mg': mg,
        'br': 5,
        'fun': fun ?? () => close(),
      },
    );
  }
}

///单选框组件
class RadioWidget extends StatefulWidget {
  final List? value;
  final int? index;
  final Function(int)? fun;
  final bool isExp;
  final Color? tColor;
  final double? spacing;
  final double? runSpacing;

  const RadioWidget({
    Key? key,
    this.value,
    this.index,
    this.fun,
    this.isExp = false,
    this.tColor,
    this.spacing,
    this.runSpacing,
  }) : super(key: key);
  @override
  _RadioWidgetState createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<RadioWidget> {
  @override
  Widget build(BuildContext context) {
    var wrap = Wrap(
      spacing: widget.runSpacing ?? 16,
      runSpacing: widget.runSpacing ?? 8,
      children: List.generate(widget.value!.length, (i) {
        return PWidget.row(
          [
            PWidget.icon(
              widget.index == i
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off_outlined,
              [widget.index == i ? pColor : aColor.withOpacity(0.25), 16],
            ),
            PWidget.boxw(4),
            PWidget.text(widget.value![i],
                [widget.index == i ? pColor : widget.tColor ?? aColor, 12])
          ],
          ['2', '0', '1'],
          {
            'fun': () {
              // setState(() => widget.index = i);
              widget.fun!(i);
            }
          },
        );
      }),
    );
    if (widget.isExp) return Expanded(child: wrap);
    return wrap;
  }
}

///小问号提示
class TipsWidget extends StatelessWidget {
  final void Function()? fun;

  const TipsWidget({Key? key, this.fun}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: WidgetTap(
        isElastic: true,
        onTap: fun ?? () {},
        child: SvgPicture.asset(
          'assets/svg/wenhao.svg',
          width: 12,
          height: 12,
          color: aColor.withOpacity(0.5),
        ),
      ),
    );
  }
}

///无数据小部件
class NoDataWidget extends StatelessWidget {
  final String text;
  final int? animationDelayed;
  final Color? color;
  final Color? bgColor;
  final double? height;
  final bool isText;
  final bool isScroll;
  final bool isNative;
  final Widget? header;
  final Widget? footer;
  final bool isShuaxin;
  final bool isGengduo;
  final int? flag;
  final Future<int> Function()? onLoading;
  final Future<int> Function()? onRefresh;
  const NoDataWidget(
    this.text, {
    Key? key,
    this.animationDelayed,
    this.color,
    this.height,
    this.bgColor,
    this.isText = false,
    this.isScroll = false,
    this.isNative = true,
    this.header,
    this.footer,
    this.isShuaxin = true,
    this.isGengduo = false,
    this.flag,
    this.onLoading,
    this.onRefresh,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget view1 = ListView.builder(
      itemCount: isText ? 1 : 2,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
          horizontal: 40, vertical: height ?? pmSize.width / 3),
      physics: isScroll
          ? MyBouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemBuilder: (_, i) => [
        if (!isText)
          Image.asset('assets/no_data.png', height: pmSize.width / 3),
        PWidget.text(
          text ?? '您还没有可用的交易策略，请点击页面右 上角按钮，进入策略超市选购',
          [color ?? aColor.withOpacity(0.25)],
          {'isOf': false, 'ali': 2, 'pd': PFun.lg(24)},
        ),
      ][i],
    );
    Widget view = MyListView(
      itemCount: isText ? 1 : 2,
      isShuaxin: false,
      flag: !isScroll,
      animationDelayed: animationDelayed ?? 0,
      animationType: AnimationType.vertical,
      padding: EdgeInsets.symmetric(
          horizontal: 40, vertical: height ?? pmSize.width / 2),
      physics: isScroll ? null : const NeverScrollableScrollPhysics(),
      touchBottomAnimationValue: 5,
      item: (i) => [
        if (!isText)
          Image.asset('assets/no_data.png', height: pmSize.width / 3),
        PWidget.text(
          text ?? '您还没有可用的交易策略，请点击页面右 上角按钮，进入策略超市选购',
          [color ?? aColor.withOpacity(0.25)],
          {'isOf': false, 'ali': 2, 'pd': PFun.lg(24)},
        ),
      ][i],
    );
    if (bgColor != null) view = Container(child: view, color: bgColor);
    return isNative ? view1 : view;
    return RefresherWidget(
      child: isNative ? view1 : view,
      isShuaxin: isShuaxin,
      isGengduo: isGengduo,
      footer: footer,
      header: header,
      onLoading: onLoading,
      onRefresh: onRefresh,
    );
  }
}

class ItemEditWidget extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final String? title;
  final Color? titleColor;
  final Color? color;
  final Color? selectoColor;
  final double? titleWidth;
  final TextEditingController? textCon;
  final String? hint;
  final bool isInt;
  final bool isDouble;
  final bool isAz;
  final bool isEditText;
  final bool isSelecto;
  final bool isShowDivider;
  final String? selectoText;
  final void Function()? selectoOnTap;
  final Function(bool)? othrOntap;
  final bool isText;
  final dynamic text;
  final bool isNoShowTitle;
  final bool isCheck;
  final bool isBoldTitle;
  final bool isShowJt;
  final MainAxisAlignment? selectoMainAxisAlignment;
  final Widget? rightChild;
  final String? subtitle;
  final Color? subtitleColor;
  final int? maxLength;

  const ItemEditWidget({
    Key? key,
    this.padding,
    this.title,
    this.titleWidth,
    this.textCon,
    this.hint,
    this.isInt = false,
    this.isDouble = false,
    this.isAz = false,
    this.isEditText = false,
    this.isSelecto = false,
    this.selectoOnTap,
    this.selectoText,
    this.isShowDivider = true,
    this.isText = false,
    this.text,
    this.titleColor,
    this.isNoShowTitle = false,
    this.isCheck = false,
    this.isBoldTitle = false,
    this.color,
    this.selectoColor,
    this.rightChild,
    this.isShowJt = true,
    this.selectoMainAxisAlignment,
    this.othrOntap,
    this.subtitle,
    this.subtitleColor,
    this.maxLength,
  }) : super(key: key);
  @override
  _ItemEditWidgetState createState() => _ItemEditWidgetState();
}

class _ItemEditWidgetState extends State<ItemEditWidget> {
  bool isBenren = false;

  @override
  Widget build(BuildContext context) {
    return WidgetTap(
      onTap: widget.selectoOnTap ?? () {},
      child: Container(
        padding: widget.padding ?? const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            if (!widget.isNoShowTitle)
              if (widget.isShowDivider)
                if (widget.title!.contains('*'))
                  SizedBox(
                    width: widget.titleWidth ?? 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          '',
                          isOverflow: false,
                          color: Colors.red,
                          children: [
                            MyText.ts(
                              (widget.title ?? 'text').replaceAll('*', ''),
                              isBold: widget.isBoldTitle,
                              color:
                                  widget.titleColor ?? const Color(0xFF000000),
                            ),
                            MyText.ts(
                              '*',
                              isBold: widget.isBoldTitle,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        if (widget.subtitle != null) const SizedBox(height: 4),
                        if (widget.subtitle != null)
                          MyText(
                            widget.subtitle,
                            isOverflow: false,
                            size: 12,
                            color: widget.subtitleColor ?? Colors.black26,
                          ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    width: widget.titleWidth ?? 100,
                    child: MyText(
                      (widget.title ?? 'text').replaceAll('*', ''),
                      isBold: widget.isBoldTitle,
                      isOverflow: false,
                      color: widget.titleColor ?? const Color(0xFF000000),
                    ),
                  )
              else
                Expanded(
                  child: MyText(
                    (widget.title ?? 'text').replaceAll('*', ''),
                    isBold: widget.isBoldTitle,
                    color: widget.titleColor ?? const Color(0xff999999),
                  ),
                ),
            if (!widget.isNoShowTitle)
              if (widget.isShowDivider)
                Container(
                  height: 19,
                  width: 1,
                  // color: Colors.black12,
                ),
            if (widget.isEditText)
              buildTFView(
                context,
                hintText:
                    widget.hint ?? '请输入${widget.title!.replaceAll('*', '')}',
                hintColor: aColor.withOpacity(0.25),
                textColor: aColor,
                isExp: true,
                maxLength: widget.maxLength,
                isInt: widget.isInt,
                isDouble: widget.isDouble,
                isAz: widget.isAz,
                textAlign: TextAlign.right,
                onChanged: (v) => setState(() {}),
                con: widget.textCon,
                textInputAction: TextInputAction.search,
                // onSubmitted: (v) => widget.onSubmitted(v),
              ),
            if (widget.isSelecto)
              Expanded(
                child: Row(
                  mainAxisAlignment:
                      widget.selectoMainAxisAlignment ?? MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: MyText(
                        widget.selectoText ?? '请选择',
                        color: widget.selectoText == null
                            ? aColor.withOpacity(0.25)
                            : widget.selectoColor ?? aColor.withOpacity(0.25),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    if (widget.isShowJt) rightJtView(16),
                    // PWidget.image(
                    //   '/assets/img/',
                    //   [9, 12],
                    //   {'pd': PFun.lg(0, 0, 8, 0)},
                    // ),
                  ],
                ),
              ),
            if (widget.isText && widget.text != null)
              Expanded(
                child: MyText(
                  widget.text,
                  isOverflow: false,
                  color: widget.selectoColor!,
                  textAlign: TextAlign.end,
                ),
              ),
            if (widget.isCheck)
              Expanded(
                child: WidgetTap(
                  onTap: () {
                    setState(() {
                      isBenren = !isBenren;
                    });
                    widget.othrOntap!(isBenren);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.check_box_outlined,
                        color: isBenren ?? false
                            ? Theme.of(context).primaryColor
                            : const Color(0xff999999),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      const MyText('本人看房', color: const Color(0xff999999)),
                    ],
                  ),
                ),
              ),
            if (widget.rightChild != null) widget.rightChild!,
          ],
        ),
      ),
    );
  }
}

class PrecisionLimitFormatter extends TextInputFormatter {
  int _scale;

  PrecisionLimitFormatter(this._scale);

  RegExp exp = RegExp("[0-9.]");
  static const String POINTER = ".";
  static const String DOUBLE_ZERO = "00";

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.startsWith(POINTER) && newValue.text.length == 1) {
      //第一个不能输入小数点
      return oldValue;
    }

    ///输入完全删除
    if (newValue.text.isEmpty) {
      return const TextEditingValue();
    }

    ///只允许输入小数
    if (!exp.hasMatch(newValue.text)) {
      return oldValue;
    }

    ///包含小数点的情况
    if (newValue.text.contains(POINTER)) {
      ///包含多个小数
      if (newValue.text.indexOf(POINTER) !=
          newValue.text.lastIndexOf(POINTER)) {
        return oldValue;
      }
      String input = newValue.text;
      int index = input.indexOf(POINTER);

      ///小数点后位数
      int lengthAfterPointer = input.substring(index, input.length).length - 1;

      ///小数位大于精度
      if (lengthAfterPointer > _scale) {
        return oldValue;
      }
    } else if (newValue.text.startsWith(POINTER) ||
        newValue.text.startsWith(DOUBLE_ZERO)) {
      ///不包含小数点,不能以“00”开头
      return oldValue;
    }
    return newValue;
  }
}
