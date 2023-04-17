import 'package:flutter/material.dart';

class MyText extends StatefulWidget {
  final dynamic text;
  final String nullValue;
  final Color color;
  final bool isBold;
  final double? size;
  final int? maxLines;
  final bool isOverflow;
  final TextAlign? textAlign;
  final List<InlineSpan> children;
  final TextDecoration? decoration;
  final double? height;

  const MyText(
    this.text, {
    Key? key,
    this.color = Colors.black,
    this.isBold = false,
    this.size,
    this.maxLines,
    this.isOverflow = true,
    this.textAlign,
    this.children = const [],
    this.nullValue = '暂无',
    this.decoration,
    this.height,
  }) : super(key: key);
  @override
  _MyTextState createState() => _MyTextState();

  ///textspan的构建
  static TextSpan ts(
    dynamic text, {
    String nullValue = '暂无',
    Color? color,
    double? size,
    double? height,
    bool isBold = false,
    TextDecoration? decoration,
  }) {
    return TextSpan(
      text: text.toString() == 'null' ? nullValue : text,
      style: TextStyle(
        color: color,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontSize: size,
        height: height ?? 1.3,
        decoration: decoration,
      ),
    );
  }
}

class _MyTextState extends State<MyText> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: widget.children.isEmpty ? buildText() : buildTextRich(),
    );
  }

  ///纯文本组件
  Text buildText() {
    return Text(
      widget.text.toString() == 'null'
          ? widget.nullValue
          : widget.text.toString(),
      maxLines: widget.maxLines,
      overflow: widget.isOverflow ? TextOverflow.ellipsis : null,
      textAlign: widget.textAlign,
      style: TextStyle(
        color: widget.color,
        decoration: widget.decoration,
        height: widget.height ?? 1.3,
        // fontWeight: widget.isBold ? FontWeight.bold : FontWeight.w600,
        fontWeight: widget.isBold ? FontWeight.bold : FontWeight.normal,
        fontSize: widget.size,
      ),
    );
  }

  ///TextRich组件
  Text buildTextRich() {
    return Text.rich(
      TextSpan(
        text: widget.text.toString() == 'null'
            ? widget.nullValue
            : widget.text.toString(),
        children: widget.children,
      ),
      maxLines: widget.maxLines,
      overflow: widget.isOverflow ? TextOverflow.ellipsis : null,
      textAlign: widget.textAlign,
      style: TextStyle(
        color: widget.color,
        height: 1.3,
        decoration: widget.decoration,
        fontWeight: widget.isBold ? FontWeight.bold : null,
        fontSize: widget.size,
      ),
    );
  }
}
