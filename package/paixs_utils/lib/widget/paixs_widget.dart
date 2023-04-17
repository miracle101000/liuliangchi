import 'package:flutter/material.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/scrollbar.dart';

import 'image.dart';
import 'widget_tap.dart';

class PWidget {
  ///PaixsContainer(
  ///child: MyText('text', color: Colors.white),
  ///data: {
  ///'cs': Colors.red,
  ///'wh': [100, 100],
  ///'mg': [0, 0, 0, 0],
  ///'pd': [0, 0, 0, 0],
  ///'br': [0, 0, 0, 0],
  ///'sd': [Colors.transparent, 16, 0, 8, -8],
  ///'gd': [Colors.red, Colors.red.withOpacity(0.5), 0, -1, 0, 1]
  ///},
  ///),
  static PaixsContainer container(
    Widget? child, [
    dynamic list1,
    dynamic data1,
    Key? key,
  ]) {
    var list, data;
    if (list1.toString().contains('{')) {
      list = data1 ?? [];
      data = list1 ?? {};
    } else {
      list = list1 ?? [];
      data = data1 ?? {};
    }
    return PaixsContainer(key: key, data: data, child: child, list: list);
  }

  ///[2,0,1,1,[0,0,0,0]]内边距
  ///
  ///data = [
  ///
  ///CrossAxisAlignment.center.index,
  ///
  ///MainAxisAlignment.start.index,
  ///
  ///MainAxisSize.max.index,
  ///
  ///Expanded,
  ///
  ///SingleChildScrollView
  ///
  ///];
  static Widget column([
    List<Widget> children = const <Widget>[],
    dynamic data1,
    dynamic map1,
    Key? key,
  ]) {
    var data, map;
    if (data1.toString().contains('{')) {
      data = map1 ?? [];
      map = data1 ?? {};
    } else {
      data = data1 ?? [];
      map = map1 ?? {};
    }
    if (data.isEmpty) {
      data = [
        CrossAxisAlignment.start.index.toString(),
        MainAxisAlignment.start.index.toString(),
        MainAxisSize.max.index.toString(),
      ];
    }
    Widget view = Column(
      key: key,
      children: children,
      crossAxisAlignment: CrossAxisAlignment.values[int.parse(data[0])],
      mainAxisAlignment: MainAxisAlignment.values[int.parse(data[1])],
      mainAxisSize: MainAxisSize.values[int.parse(data[2])],
    );
    if (map['pd'] != null) {
      if (map['pd'].toString().contains('[')) {
        view = Align(
          alignment: Alignment.topCenter,
          child: CupertinoScrollbarWidget(
            radius: Radius.circular(6),
            thickness: 6,
            child: SingleChildScrollView(
              child: view,
              padding: EdgeInsets.only(
                top: isDataNull(() => map['pd'][0]),
                bottom: isDataNull(() => map['pd'][1]),
                left: isDataNull(() => map['pd'][2]),
                right: isDataNull(() => map['pd'][3]),
              ),
              physics: ClampingScrollPhysics(),
            ),
          ),
        );
      } else {
        view = Align(
          alignment: Alignment.topCenter,
          child: CupertinoScrollbarWidget(
            radius: Radius.circular(6),
            thickness: 6,
            child: SingleChildScrollView(
              child: view,
              padding: EdgeInsets.all(map['pd'].toDouble()),
              physics: ClampingScrollPhysics(),
            ),
          ),
        );
      }
    }
    if (map['cs'] != null) view = Container(color: map['cs'], child: view);
    if (map['fun'] != null)
      view = WidgetTap(
          isElastic: map['tap'] ?? false, child: view, onTap: map['fun']);
    if (map['exp'] != null) {
      view = Expanded(child: view, flex: map['exp']);
    }
    return view;
  }

  ///[2,0,1,1,[0,0,0,0]]内边距
  ///
  ///data = [
  ///
  ///CrossAxisAlignment.center.index,
  ///
  ///MainAxisAlignment.start.index,
  ///
  ///MainAxisSize.max.index,
  ///
  ///Expanded,
  ///
  ///SingleChildScrollView
  ///
  ///];
  static Widget ccolumn([
    List<Widget> children = const <Widget>[],
    dynamic data1,
    dynamic map1,
    Key? key,
  ]) {
    var data, map;
    if (data1.toString().contains('{')) {
      data = map1 ?? [];
      map = data1 ?? {};
    } else {
      data = data1 ?? [];
      map = map1 ?? {};
    }
    if (data.isEmpty) {
      data = [
        CrossAxisAlignment.center.index.toString(),
        MainAxisAlignment.start.index.toString(),
        MainAxisSize.max.index.toString(),
      ];
    }
    Widget view = Column(
      key: key,
      children: children,
      crossAxisAlignment: CrossAxisAlignment.values[int.parse(data[0])],
      mainAxisAlignment: MainAxisAlignment.values[int.parse(data[1])],
      mainAxisSize: MainAxisSize.values[int.parse(data[2])],
    );
    if (map['pd'] != null) {
      if (map['pd'].toString().contains('[')) {
        view = Align(
          alignment: Alignment.topCenter,
          child: CupertinoScrollbarWidget(
            radius: Radius.circular(6),
            thickness: 6,
            child: SingleChildScrollView(
              child: view,
              padding: EdgeInsets.only(
                top: isDataNull(() => map['pd'][0]),
                bottom: isDataNull(() => map['pd'][1]),
                left: isDataNull(() => map['pd'][2]),
                right: isDataNull(() => map['pd'][3]),
              ),
              physics: ClampingScrollPhysics(),
            ),
          ),
        );
      } else {
        view = Align(
          alignment: Alignment.topCenter,
          child: CupertinoScrollbarWidget(
            radius: Radius.circular(6),
            thickness: 6,
            child: SingleChildScrollView(
              child: view,
              padding: EdgeInsets.all(map['pd'].toDouble()),
              physics: ClampingScrollPhysics(),
            ),
          ),
        );
      }
    }
    if (map['cs'] != null) view = Container(color: map['cs'], child: view);
    if (map['fun'] != null)
      view = WidgetTap(
          isElastic: map['tap'] ?? false, child: view, onTap: map['fun']);
    if (map['exp'] != null) {
      view = Expanded(child: view, flex: map['exp']);
    }
    return view;
  }

  ///[2,0,1]
  ///
  ///data = [
  ///CrossAxisAlignment.center.index,
  ///
  ///MainAxisAlignment.start.index,
  ///
  ///MainAxisSize.max.index,
  ///
  ///];
  static Widget row([
    List<Widget> children = const <Widget>[],
    dynamic data1,
    dynamic map1,
    Key? key,
  ]) {
    var data, map;
    if (data1.toString().contains('{')) {
      data = map1 ?? [];
      map = data1 ?? {};
    } else {
      data = data1 ?? [];
      map = map1 ?? {};
    }
    if (data.isEmpty) {
      data = [
        CrossAxisAlignment.center.index.toString(),
        MainAxisAlignment.start.index.toString(),
        MainAxisSize.max.index.toString(),
      ];
    }
    Widget view = Row(
      key: key,
      children: children,
      crossAxisAlignment: CrossAxisAlignment.values[int.parse(data[0])],
      mainAxisAlignment: MainAxisAlignment.values[int.parse(data[1])],
      mainAxisSize: MainAxisSize.values[int.parse(data[2])],
    );
    // if (map['pd'] != null)
    //   view = SingleChildScrollView(
    //     child: view,
    //     padding: EdgeInsets.only(
    //       top: isDataNull(() => map['pd'][0]),
    //       bottom: isDataNull(() => map['pd'][1]),
    //       left: isDataNull(() => map['pd'][2]),
    //       right: isDataNull(() => map['pd'][3]),
    //     ),
    //     physics: ClampingScrollPhysics(),
    //     scrollDirection: Axis.horizontal,
    //   );
    if (map['pd'] != null) {
      if (map['pd'].toString().contains('[')) {
        view = SingleChildScrollView(
          child: view,
          padding: EdgeInsets.only(
            top: isDataNull(() => map['pd'][0]),
            bottom: isDataNull(() => map['pd'][1]),
            left: isDataNull(() => map['pd'][2]),
            right: isDataNull(() => map['pd'][3]),
          ),
          physics: ClampingScrollPhysics(),
        );
      } else {
        view = SingleChildScrollView(
          child: view,
          padding: EdgeInsets.all(map['pd'].toDouble()),
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
        );
      }
    }
    if (map['fun'] != null)
      view = WidgetTap(
          isElastic: map['tap'] ?? false, child: view, onTap: map['fun']);
    if (map['cs'] != null) view = Container(color: map['cs'], child: view);
    if (map['fill'] != null) view = IntrinsicHeight(child: view);
    if (map['exp'] != null) view = Expanded(child: view, flex: map['exp']);

    return view;
  }

  // ignore: slash_for_doc_comments
  /**
      MyText(
    
      text,

      color: list[0],
      
      size: isDataNull(() => list[1], 14),

      isBold: list.length > 2 ? list[2] : false,

      isOverflow: data['isOf'] ?? false,

      maxLines: data['max'],

      height: data['h'],

      key: key,

      nullValue: data['null'] ?? '暂无数据',

      textAlign: data['ali'] == null ? null : TextAlign.values[data['ali']],

      decoration: data['td'],

      );
   */
  static Widget text(
    text, [
    dynamic list1,
    dynamic data1,
    List<InlineSpan> children = const [],
    Key? key,
  ]) {
    var list, data;
    if (list1.toString().contains('{')) {
      list = data1 ?? [];
      data = list1 ?? {};
    } else {
      list = list1 ?? [];
      data = data1 ?? {};
    }
    if (list.isEmpty) {
      list = [Colors.black, 14, false];
    }
    Widget view = MyText(
      text,
      color: list[0],
      size: isDataNull(() => list[1], 14),
      isBold: list.length > 2 ? list[2] : false,
      isOverflow: data['isOf'] ?? true,
      maxLines: data['max'],
      height: data['h'],
      key: key,
      children: (children.isNotEmpty) ? children : (data['ts'] ?? []),
      nullValue: data['null'] ?? '暂无数据',
      textAlign: data['ali'] == null ? null : TextAlign.values[data['ali']],
      decoration: data['td'],
    );
    if (data['pd'] != null) {
      if (data['pd'].toString().contains('[')) {
        view = Padding(
          child: view,
          padding: EdgeInsets.only(
            top: isDataNull(() => data['pd'][0]),
            bottom: isDataNull(() => data['pd'][1]),
            left: isDataNull(() => data['pd'][2]),
            right: isDataNull(() => data['pd'][3]),
          ),
        );
      } else {
        view = Padding(
          child: view,
          padding: EdgeInsets.all(data['pd'].toDouble()),
        );
      }
    }
    if (data['ct'] == true) view = Center(child: view);
    if (data['fun'] != null) view = WidgetTap(child: view, onTap: data['fun']);
    if (data['exp'] == true) view = Expanded(child: view);
    return view;
  }

  static InlineSpan textIs(
    text, [
    dynamic list1,
    dynamic data1,
  ]) {
    var list, data;
    if (list1.toString().contains('{')) {
      list = data1 ?? [];
      data = list1 ?? {};
    } else {
      list = list1 ?? [];
      data = data1 ?? {};
    }
    if (list.isEmpty) {
      list = [Colors.black, 14, false];
    }
    if (data['ct'] == true) {
      return WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: MyText(
          text,
          color: list[0],
          size: isDataNull(() => list[1], 14),
          isBold: list.length > 2 ? list[2] : false,
          height: data['h'],
          nullValue: data['null'] ?? '暂无数据',
          decoration: data['td'],
        ),
      );
    }
    return MyText.ts(
      text,
      color: list[0],
      size: isDataNull(() => list[1], 14),
      isBold: list.length > 2 ? list[2] : false,
      height: data['h'],
      nullValue: data['null'] ?? '暂无数据',
      decoration: data['td'],
    );
  }

  // ignore: slash_for_doc_comments
  /**
      Widget view = Icon(

      Icons.ac_unit,

      color: list[0],

      size: isDataNull(() => list[1], 24),

    );
   */
  static Widget icon(
    IconData icon, [
    dynamic list1,
    dynamic data1,
  ]) {
    var list, data;
    if (list1.toString().contains('{')) {
      list = data1 ?? [];
      data = list1 ?? {};
    } else {
      list = list1 ?? [];
      data = data1 ?? {};
    }

    if (list.isEmpty) {
      list = [Colors.black, 24];
    }
    Widget view = Icon(
      icon,
      color: list[0],
      size: isDataNull(() => list[1], 24),
    );
    // if (data['pd'] != null)

    if (data['pd'] != null) {
      if (data['pd'].toString().contains('[')) {
        view = Padding(
          child: view,
          padding: EdgeInsets.only(
            top: isDataNull(() => data['pd'][0]),
            bottom: isDataNull(() => data['pd'][1]),
            left: isDataNull(() => data['pd'][2]),
            right: isDataNull(() => data['pd'][3]),
          ),
        );
      } else {
        view = Padding(
          child: view,
          padding: EdgeInsets.all(data['pd'].toDouble()),
        );
      }
    }
    if (data['fun'] != null) view = WidgetTap(child: view, onTap: data['fun']);
    return view;
  }

  // ignore: slash_for_doc_comments
  /**
      Image.asset(
        
        name,

        width: isDataNull(() => list[0]),

        height: isDataNull(() => list[1]),

        color: list.length > 2 ? list[2] : null,

        fit: list.length > 3 ? list[3] : null,
        
      );
   */
  static Widget image(
    dynamic name, [
    dynamic list1,
    dynamic data1,
  ]) {
    var list, data;
    if (list1.toString().contains('{')) {
      list = data1 ?? [];
      data = list1 ?? {};
    } else {
      list = list1 ?? [];
      data = data1 ?? {};
    }
    if (list.isEmpty) {
      list = [24, 24, null, BoxFit.cover];
    }
    Widget view;
    if (name.runtimeType.toString() == 'String') {
      view = Image.asset(
        name,
        width: isDataNull(() => list[0]),
        height: isDataNull(() => list[1]),
        color: list.length > 2 ? list[2] : null,
        fit: list.length > 3 ? list[3] : null,
      );
    } else if (name.runtimeType.toString() == 'File') {
      view = Image.file(
        name,
        width: isDataNull(() => list[0]),
        height: isDataNull(() => list[1]),
        color: list.length > 2 ? list[2] : null,
        fit: list.length > 3 ? list[3] : null,
      );
    } else {
      view = Image.memory(
        name,
        width: isDataNull(() => list[0]),
        height: isDataNull(() => list[1]),
        color: list.length > 2 ? list[2] : null,
        fit: list.length > 3 ? list[3] : null,
      );
    }
    if (data['pd'] != null) {
      if (data['pd'].toString().contains('[')) {
        view = Padding(
          child: view,
          padding: EdgeInsets.only(
            top: isDataNull(() => data['pd'][0]),
            bottom: isDataNull(() => data['pd'][1]),
            left: isDataNull(() => data['pd'][2]),
            right: isDataNull(() => data['pd'][3]),
          ),
        );
      } else {
        view = Padding(
          child: view,
          padding: EdgeInsets.all(data['pd'].toDouble()),
        );
      }
    }
    if (data['fun'] != null)
      view = WidgetTap(isElastic: true, child: view, onTap: data['fun']);
    return view;
  }

  // ignore: slash_for_doc_comments
  /**
    AnimatedPositioned(

      child: child,

      top: isDataNull(() => list[0]),

      bottom: isDataNull(() => list[1]),

      left: isDataNull(() => list[2]),

      right: isDataNull(() => list[3]),

      duration: Duration(milliseconds: data['anima'] == null ? 500 : data['anima'][0]),

      curve: data['anima'] == null ? Curves.easeOutCubic : data['anima'][1],

    );
   */
  static Widget positioned(
    child, [
    dynamic list1,
    dynamic data1,
  ]) {
    var list, data;
    if (list1.toString().contains('{')) {
      list = data1 ?? [];
      data = list1 ?? {};
    } else {
      list = list1 ?? [];
      data = data1 ?? {};
    }
    if (list.isEmpty) list = [null, null, null, null];
    return AnimatedPositioned(
      child: child,
      top: list.length > 0
          ? list[0] == null
              ? null
              : list[0].toDouble()
          : null,
      bottom: list.length > 1
          ? list[1] == null
              ? null
              : list[1].toDouble()
          : null,
      left: list.length > 2
          ? list[2] == null
              ? null
              : list[2].toDouble()
          : null,
      right: list.length > 3
          ? list[3] == null
              ? null
              : list[3].toDouble()
          : null,
      duration: Duration(
          milliseconds: data['anima'] == null ? 300 : data['anima'][0]),
      curve: data['anima'] == null ? Curves.easeOutCubic : data['anima'][1],
    );
  }

  // ignore: slash_for_doc_comments
  /**
     Stack(

      children: children,

      alignment: Alignment(list[0], list[1]),

      clipBehavior: list.length > 2 ? list[2] : Clip.none,

      fit: list.length > 3 ? list[3] : StackFit.loose,

    );
   */
  static Widget stack([
    List<Widget> children = const <Widget>[],
    dynamic list1,
    dynamic data1,
  ]) {
    var list, data;
    if (list1.toString().contains('{')) {
      list = data1 ?? [];
      data = list1 ?? {};
    } else {
      list = list1 ?? [];
      data = data1 ?? {};
    }
    // if (list.isEmpty) list = [0, 0, Clip.none, StackFit.loose];
    Widget view = Stack(
      children: children,
      alignment: list.isEmpty
          ? AlignmentDirectional.topStart
          : Alignment(list[0].toDouble(), list[1].toDouble()),
      clipBehavior: list.length > 2 ? list[2] : Clip.none,
      fit: list.length > 3 ? list[3] : StackFit.loose,
    );
    if (data['exp'] == true) view = Expanded(child: view);
    return view;
  }

  static Widget box(List list) {
    return SizedBox(
      width: isDataNull(() => list[0]),
      height: isDataNull(() => list[1]),
    );
  }

  static Widget boxw(double v) => SizedBox(width: v);
  static Widget boxh(double v) => SizedBox(height: v);

  static Widget spacer() => Spacer();

  // ignore: slash_for_doc_comments
  /**
     WrapperImage(

      urlBuilder: () => url,

      width: isDataNull(() => list[0], 24),

      height: isDataNull(() => list[1], 24),
      
      fit: map['fit'] ?? BoxFit.cover,

      imageType: map['type'] ?? ImageType.normal,

      w: map['w'] ?? 250,

    );
   */
  static Widget wrapperImage(String url, [dynamic list1, dynamic map1]) {
    var list, map;
    if (list1.toString().contains('{')) {
      list = map1 ?? [];
      map = list1 ?? {};
    } else {
      list = list1 ?? [];
      map = map1 ?? {};
    }
    Widget view = WrapperImage(
      urlBuilder: () => url,
      width: map['isNull'] == true ? null : isDataNull(() => list[0], 24),
      height: map['isNull'] == true ? null : isDataNull(() => list[1], 24),
      fit: map['fit'] ?? BoxFit.cover,
      alignment: map['ali'] == null
          ? null
          : Alignment(isDataNull(() => map['ali'][0], 1),
              isDataNull(() => map['ali'][1], 1)),
      imageType: map['type'] ?? ImageType.normal,
      w: map['w'] ?? 500,
      headers: map['headers'],
    );
    if (map['br'] != null) {
      if (map['br'].toString().contains('[')) {
        view = ClipRRect(
          child: view,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isDataNull(() => map['br'][0])),
            topRight: Radius.circular(isDataNull(() => map['br'][1])),
            bottomLeft: Radius.circular(isDataNull(() => map['br'][2])),
            bottomRight: Radius.circular(isDataNull(() => map['br'][3])),
          ),
        );
      } else {
        view = ClipRRect(
          child: view,
          borderRadius: BorderRadius.circular(map['br'].toDouble()),
        );
      }
    }

    if (map['pd'] != null) {
      if (map['pd'].toString().contains('[')) {
        view = Padding(
          child: view,
          padding: EdgeInsets.only(
            top: isDataNull(() => map['pd'][0]),
            bottom: isDataNull(() => map['pd'][1]),
            left: isDataNull(() => map['pd'][2]),
            right: isDataNull(() => map['pd'][3]),
          ),
        );
      } else {
        view = Padding(
          child: view,
          padding: EdgeInsets.all(map['pd'].toDouble()),
        );
      }
    }
    if (map['ar'] != null) {
      view = AspectRatio(
        aspectRatio: isDataNull(() => map['ar'], 1 / 1),
        child: view,
      );
    }
    if (map['fun'] != null) view = WidgetTap(child: view, onTap: map['fun']);
    if (map['exp'] == true) view = Expanded(child: view);
    return view;
  }

  static Widget align(view, [List data = const []]) {
    return Align(
      // ignore: unnecessary_null_comparison
      alignment: data.isEmpty == null
          ? Alignment.center
          : Alignment(
              isDataNull(() => data[0], 0), isDataNull(() => data[1], 0)),
      child: view,
    );
  }
}

///自定义容器
class PaixsContainer extends StatefulWidget {
  final Map data;
  final Widget? child;
  final List list;
  const PaixsContainer({
    Key? key,
    this.data = const {},
    this.child,
    this.list = const [],
  }) : super(key: key);
  @override
  _PaixsContainerState createState() => _PaixsContainerState();
}

class _PaixsContainerState extends State<PaixsContainer> {
  @override
  Widget build(BuildContext context) {
    Widget view = AnimatedContainer(
      duration: Duration(
          milliseconds:
              widget.data['anima'] == null ? 250 : widget.data['anima'][0]),
      curve: widget.data['anima'] == null
          ? Curves.easeOutCubic
          : widget.data['anima'].length > 1
              ? widget.data['anima'][1]
              : Curves.easeOutCubic,
      alignment: widget.data['ali'] == null
          ? null
          : Alignment(isDataNull(() => widget.data['ali'][0], 1),
              isDataNull(() => widget.data['ali'][1], 1)),
      width: widget.list.isNotEmpty
          ? widget.list[0] == null
              ? null
              : widget.list[0]?.toDouble()
          : null,
      height: widget.list.length > 1
          ? widget.list[1] == null
              ? null
              : widget.list[1]?.toDouble()
          : null,
      // width: widget.data['wh'] == null ? null : widget.data['wh'][0].toDouble(),
      // height: widget.data['wh'] == null ? null : widget.data['wh'][1].toDouble(),
      margin: widget.data['mg'] == null
          ? null
          : widget.data['mg'].toString().contains('[')
              ? EdgeInsets.only(
                  top: isDataNull(() => widget.data['mg'][0]),
                  bottom: isDataNull(() => widget.data['mg'][1]),
                  left: isDataNull(() => widget.data['mg'][2]),
                  right: isDataNull(() => widget.data['mg'][3]),
                )
              : EdgeInsets.all(widget.data['mg'].toDouble()),
      padding: widget.data['pd'] == null
          ? null
          : widget.data['pd'].toString().contains('[')
              ? EdgeInsets.only(
                  top: isDataNull(() => widget.data['pd'][0]),
                  bottom: isDataNull(() => widget.data['pd'][1]),
                  left: isDataNull(() => widget.data['pd'][2]),
                  right: isDataNull(() => widget.data['pd'][3]),
                )
              : EdgeInsets.all(widget.data['pd'].toDouble()),
      decoration: widget.data['ph'] != null
          ? ShapeDecoration(
              color: widget.list.length > 2 ? widget.list[2] : null,
              gradient: widget.data['gd'] == null
                  ? null
                  : LinearGradient(
                      colors: [
                        widget.data['gd'][0],
                        widget.data['gd'][1],
                      ],
                      begin: Alignment(
                        isDataNull(() => widget.data['gd'][2]),
                        isDataNull(() => widget.data['gd'][3]),
                      ),
                      end: Alignment(
                        isDataNull(() => widget.data['gd'][4]),
                        isDataNull(() => widget.data['gd'][5]),
                      ),
                    ),
              shadows: widget.data['sd'] == null
                  ? []
                  : [
                      BoxShadow(
                        color: widget.data['sd'][0],
                        blurRadius: isDataNull(() => widget.data['sd'][1]),
                        offset: Offset(isDataNull(() => widget.data['sd'][2]),
                            isDataNull(() => widget.data['sd'][3])),
                        spreadRadius: isDataNull(() => widget.data['sd'][4]),
                      ),
                    ],
              shape: ContinuousRectangleBorder(
                side: widget.data['bd'] == null
                    ? BorderSide.none
                    : BorderSide(
                        color: (widget.data['bd'][0]),
                        width: widget.data['bd'][1]?.toDouble(),
                        style: widget.data['bd'][1] == 0
                            ? BorderStyle.none
                            : BorderStyle.solid,
                      ),
                // borderRadius: widget.data['br'] == null
                //     ? null
                //     : widget.data['br'].toString().contains('[')
                //         ? BorderRadius.only(
                //             topLeft: Radius.circular(isDataNull(() => widget.data['br'][0])),
                //             topRight: Radius.circular(isDataNull(() => widget.data['br'][1])),
                //             bottomLeft: Radius.circular(isDataNull(() => widget.data['br'][2])),
                //             bottomRight: Radius.circular(isDataNull(() => widget.data['br'][3])),
                //           )
                //         : BorderRadius.circular(widget.data['br'].toDouble()),
              ),
            )
          : BoxDecoration(
              // color: widget.data['cs'],
              color: widget.list.length > 2 ? widget.list[2] : null,
              borderRadius: widget.data['br'] == null
                  ? null
                  : widget.data['br'].toString().contains('[')
                      ? BorderRadius.only(
                          topLeft: Radius.circular(
                              isDataNull(() => widget.data['br'][0])),
                          topRight: Radius.circular(
                              isDataNull(() => widget.data['br'][1])),
                          bottomLeft: Radius.circular(
                              isDataNull(() => widget.data['br'][2])),
                          bottomRight: Radius.circular(
                              isDataNull(() => widget.data['br'][3])),
                        )
                      : BorderRadius.circular(widget.data['br'].toDouble()),
              border: widget.data['bd'] == null
                  ? null
                  : Border(
                      top: widget.data['bd'].length <= 1
                          ? BorderSide.none
                          : BorderSide(
                              color: (widget.data['bd'][0]),
                              width: widget.data['bd'][1]?.toDouble(),
                              style: widget.data['bd'][1] == 0
                                  ? BorderStyle.none
                                  : BorderStyle.solid,
                            ),
                      bottom: widget.data['bd'].length <= 2
                          ? BorderSide.none
                          : BorderSide(
                              color: (widget.data['bd'][0]),
                              width: widget.data['bd'][2]?.toDouble(),
                              style: widget.data['bd'][2] == 0
                                  ? BorderStyle.none
                                  : BorderStyle.solid,
                            ),
                      left: widget.data['bd'].length <= 3
                          ? BorderSide.none
                          : BorderSide(
                              color: (widget.data['bd'][0]),
                              width: widget.data['bd'][3]?.toDouble(),
                              style: widget.data['bd'][3] == 0
                                  ? BorderStyle.none
                                  : BorderStyle.solid,
                            ),
                      right: widget.data['bd'].length <= 4
                          ? BorderSide.none
                          : BorderSide(
                              color: (widget.data['bd'][0]),
                              width: widget.data['bd'][4]?.toDouble(),
                              style: widget.data['bd'][4] == 0
                                  ? BorderStyle.none
                                  : BorderStyle.solid,
                            ),
                    ),
              boxShadow: widget.data['sd'] == null
                  ? []
                  : [
                      BoxShadow(
                        color: widget.data['sd'][0],
                        blurRadius: isDataNull(() => widget.data['sd'][1]),
                        offset: Offset(isDataNull(() => widget.data['sd'][2]),
                            isDataNull(() => widget.data['sd'][3])),
                        spreadRadius: isDataNull(() => widget.data['sd'][4]),
                      ),
                    ],
              gradient: widget.data['gd'] == null
                  ? null
                  : LinearGradient(
                      colors: [
                        widget.data['gd'][0],
                        widget.data['gd'][1],
                      ],
                      begin: Alignment(
                        isDataNull(() => widget.data['gd'][2]),
                        isDataNull(() => widget.data['gd'][3]),
                      ),
                      end: Alignment(
                        isDataNull(() => widget.data['gd'][4]),
                        isDataNull(() => widget.data['gd'][5]),
                      ),
                    ),
            ),
      child: widget.child,
    );
    if (widget.data['crr'] != null) {
      if (widget.data['crr'].toString().contains('[')) {
        view = ClipPath(
          child: view,
          clipper: ShapeBorderClipper(
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft:
                    Radius.circular(isDataNull(() => widget.data['crr'][0])),
                topRight:
                    Radius.circular(isDataNull(() => widget.data['crr'][1])),
                bottomLeft:
                    Radius.circular(isDataNull(() => widget.data['crr'][2])),
                bottomRight:
                    Radius.circular(isDataNull(() => widget.data['crr'][3])),
              ),
            ),
          ),
        );
      } else {
        view = ClipPath(
          child: view,
          clipper: ShapeBorderClipper(
            shape: ContinuousRectangleBorder(
              borderRadius:
                  BorderRadius.circular(widget.data['crr'].toDouble()),
            ),
          ),
        );
      }
    }
    // if (widget.data['mg'] != null) {
    //   if (widget.data['mg'].toString().contains('[')) {
    //     view = Padding(
    //       child: view,
    //       padding: EdgeInsets.only(
    //         top: isDataNull(() => widget.data['mg'][0]),
    //         bottom: isDataNull(() => widget.data['mg'][1]),
    //         left: isDataNull(() => widget.data['mg'][2]),
    //         right: isDataNull(() => widget.data['mg'][3]),
    //       ),
    //     );
    //   } else {
    //     view = Padding(
    //       padding: EdgeInsets.all(widget.data['mg'].toDouble()),
    //       child: view,
    //     );
    //   }
    // }
    if (widget.data['wali'] != null) {
      view = Align(
        alignment: Alignment(
          isDataNull(() => widget.data['wali'][0], 0),
          isDataNull(() => widget.data['wali'][1], 0),
        ),
        child: view,
      );
    }
    if (widget.data['fun'] != null)
      view = WidgetTap(
          isElastic: widget.data['tap'] ?? false,
          onTap: widget.data['fun'],
          child: view);
    if (widget.data['exp'] == true) view = Expanded(child: view);
    return view;
  }
}

///属性是否null
dynamic isDataNull(Function fun, [v2 = 0]) {
  var value;
  try {
    value = fun.call().toDouble();
  } catch (e) {
    value = v2.toDouble();
  }
  return value;
}
