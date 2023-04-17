import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paixs_utils/widget/CPicker_widget.dart';
import 'dart:convert';

import 'package:paixs_utils/widget/views.dart';

typedef void ChangeData(Map<String, dynamic> map);
typedef List<Widget> CreateWidgetList();

class CityPicker {
  static void showCityPicker(
    BuildContext context, {
    ChangeData? selectProvince,
    ChangeData? selectCity,
    ChangeData? selectArea,
    ChangeData? selectAll,
    bool isProvince = true,
    bool isCity = true,
    bool isArea = true,
    int provinceIndex = 0,
    int cityIndex = 0,
    int areaIndex = 0,
  }) {
    rootBundle.loadString('data/province.json').then((v) {
      List data = json.decode(v);
      showSheet(builder: (_) {
        return _CityPickerWidget(
          data: data,
          selectProvince: selectProvince!,
          selectCity: selectCity!,
          selectArea: selectArea!,
          selectAll: selectAll!,
          isProvince: isProvince,
          isCity: isCity,
          isArea: isArea,
          provinceIndex: provinceIndex,
          cityIndex: cityIndex,
          areaIndex: areaIndex,
        );
      });
      // Navigator.push(
      //   context,
      //   _CityPickerRoute(
      //     data: data,
      //     selectProvince: selectProvince,
      //     selectCity: selectCity,
      //     selectArea: selectArea,
      //     selectAll: selectAll,
      //     theme: Theme.of(context),
      //     barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      //     isProvince: isProvince,
      //     isCity: isCity,
      //     isArea: isArea,
      //     provinceIndex: provinceIndex,
      //     cityIndex: cityIndex,
      //     areaIndex: areaIndex,
      //   ),
      // );
    });
  }
}

// class _CityPickerRoute<T> extends PopupRoute<T> {
//   final ThemeData theme;
//   final String barrierLabel;
//   final List data;
//   final ChangeData selectProvince;
//   final ChangeData selectCity;
//   final ChangeData selectArea;
//   final ChangeData selectAll;
//   final bool isProvince;
//   final bool isCity;
//   final bool isArea;
//   final int provinceIndex;
//   final int cityIndex;
//   final int areaIndex;
//   _CityPickerRoute({
//     this.theme,
//     this.barrierLabel,
//     this.data,
//     this.selectProvince,
//     this.selectCity,
//     this.selectArea,
//     this.selectAll,
//     this.isProvince,
//     this.isCity,
//     this.isArea,
//     this.provinceIndex,
//     this.cityIndex,
//     this.areaIndex,
//   });

//   @override
//   Duration get transitionDuration => Duration(milliseconds: 2000);

//   @override
//   @override
//   Color get barrierColor => Colors.black54;

//   @override
//   bool get barrierDismissible => true;

//   AnimationController _animationController;

//   @override
//   AnimationController createAnimationController() {
//     assert(_animationController == null);
//     _animationController = BottomSheet.createAnimationController(navigator.overlay);
//     return _animationController;
//   }

//   @override
//   Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
//     Widget bottomSheet = MediaQuery.removePadding(
//       removeTop: true,
//       context: context,
//       child: _CityPickerWidget(
//         data: data,
//         selectProvince: selectProvince,
//         selectCity: selectCity,
//         selectArea: selectArea,
//         selectAll: selectAll,
//         isProvince: isProvince,
//         isCity: isCity,
//         isArea: isArea,
//         provinceIndex: provinceIndex,
//         cityIndex: cityIndex,
//         areaIndex: areaIndex,
//       ),
//     );
//     if (theme != null) {
//       bottomSheet = Theme(data: theme, child: bottomSheet);
//     }
//     return bottomSheet;
//   }
// }

class _CityPickerWidget extends StatefulWidget {
  final List? data;
  final ChangeData? selectProvince;
  final ChangeData? selectCity;
  final ChangeData? selectArea;
  final ChangeData? selectAll;
  final bool? isProvince;
  final bool? isCity;
  final bool? isArea;
  final int? provinceIndex;
  final int? cityIndex;
  final int? areaIndex;

  _CityPickerWidget({
    // ignore: unused_element
    Key? key,
    this.data,
    this.selectProvince,
    this.selectCity,
    this.selectArea,
    this.selectAll,
    this.isProvince,
    this.isCity,
    this.isArea,
    this.provinceIndex,
    this.cityIndex,
    this.areaIndex,
  });

  @override
  State createState() {
    return _CityPickerState();
  }
}

class _CityPickerState extends State<_CityPickerWidget> {
  FixedExtentScrollController? provinceController;
  FixedExtentScrollController? cityController;
  FixedExtentScrollController? areaController;
  int provinceIndex = 0, cityIndex = 0, areaIndex = 0;
  List province = [];
  List city = [];
  List area = [];

  @override
  void initState() {
    super.initState();
    provinceIndex = widget.provinceIndex!;
    cityIndex = widget.cityIndex!;
    areaIndex = widget.areaIndex!;
    provinceController = FixedExtentScrollController();
    cityController = FixedExtentScrollController();
    areaController = FixedExtentScrollController();
    if (mounted)
      setState(() {
        province = widget.data!;
        city = widget.data![provinceIndex]['cities'];
        area = widget.data![provinceIndex]['cities'][cityIndex]['district'];
      });
    // if(widget.isCity){
    //   city = widget.data[widget.provinceIndex]['cities'];
    // }
  }

  Widget _bottomView() {
    return Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Colors.black.withOpacity(0.05)),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    foregroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('取消', style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor.withOpacity(0.05)),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    foregroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    Map<String, dynamic> provinceMap = {
                      "code": province[provinceIndex]['provinceid'],
                      "name": province[provinceIndex]['province'],
                      "index": provinceIndex,
                    };
                    Map<String, dynamic> cityMap = {
                      "code": province[provinceIndex]['cities'][cityIndex]
                          ['cityid'],
                      "name": province[provinceIndex]['cities'][cityIndex]
                          ['city'],
                      "index": cityIndex,
                    };
                    Map<String, dynamic> areaMap = {
                      "code": province[provinceIndex]['cities'][cityIndex]
                          ['district'][areaIndex]['areaid'],
                      "name": province[provinceIndex]['cities'][cityIndex]
                          ['district'][areaIndex]['area'],
                      "index": areaIndex,
                    };
                    Map<String, dynamic> allMap = {
                      "name": province[provinceIndex]['province'] +
                          province[provinceIndex]['cities'][cityIndex]['city'] +
                          province[provinceIndex]['cities'][cityIndex]
                              ['district'][areaIndex]['area'],
                    };

                    if (widget.selectProvince != null) {
                      widget.selectProvince!(provinceMap);
                    }
                    if (widget.selectCity != null) {
                      widget.selectCity!(cityMap);
                    }
                    if (widget.selectArea != null) {
                      widget.selectArea!(areaMap);
                    }

                    if (widget.selectAll != null) {
                      widget.selectAll!(allMap);
                    }

                    Navigator.pop(context);
                  },
                  child: Text(
                    '确定',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Row(
              children: <Widget>[
                if (widget.isProvince!)
                  _MyCityPicker(
                    key: Key('province'),
                    controller: provinceController!,
                    createWidgetList: () {
                      return province.map((v) {
                        return Align(
                          child: Text(
                            v['province'],
                            textScaleFactor: 1.2,
                            maxLines: 1,
                            style: TextStyle(fontSize: 14),
                          ),
                          alignment: Alignment.center,
                        );
                      }).toList();
                    },
                    changed: (index) {
                      if (mounted)
                        setState(() {
                          provinceIndex = index;
                          cityIndex = 0;
                          areaIndex = 0;
                          cityController!.jumpToItem(0);
                          areaController!.jumpToItem(0);
                          city = widget.data![provinceIndex]['cities'];
                          area = widget.data![provinceIndex]['cities']
                              [cityIndex]['district'];
                        });
                    },
                  ),
                if (widget.isCity!)
                  _MyCityPicker(
                    key: Key('city'),
                    controller: cityController!,
                    createWidgetList: () {
                      return city.map((v) {
                        return Align(
                          child: Text(
                            v['city'],
                            textScaleFactor: 1.2,
                            maxLines: 1,
                            style: TextStyle(fontSize: 14),
                          ),
                          alignment: Alignment.center,
                        );
                      }).toList();
                    },
                    changed: (index) {
                      if (mounted)
                        setState(() {
                          cityIndex = index;
                          areaIndex = 0;
                          areaController!.jumpToItem(0);
                          area = widget.data![provinceIndex]['cities']
                              [cityIndex]['district'];
                        });
                    },
                  ),
                if (widget.isArea!)
                  _MyCityPicker(
                    key: Key('area'),
                    controller: areaController!,
                    createWidgetList: () {
                      return area.map((v) {
                        return Align(
                          child: Text(
                            v['area'],
                            maxLines: 1,
                            textScaleFactor: 1.2,
                            style: TextStyle(fontSize: 14),
                          ),
                          alignment: Alignment.center,
                        );
                      }).toList();
                    },
                    changed: (index) {
                      if (mounted)
                        setState(() {
                          areaIndex = index;
                        });
                    },
                  ),
              ],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      child: _bottomView(),
    );
    // return GestureDetector(
    //   child: AnimatedBuilder(
    //     animation: widget.route.animation,
    //     builder: (BuildContext context, Widget child) {
    //       return ClipRect(
    //         child: CustomSingleChildLayout(
    //           delegate: _BottomPickerLayout(widget.route.animation.value),
    //           child: GestureDetector(
    //             child: Material(
    //               color: Colors.transparent,
    //               child: Container(
    //                 width: double.infinity,
    //                 height: 260.0,
    //                 child: _bottomView(),
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}

class _MyCityPicker extends StatefulWidget {
  final CreateWidgetList? createWidgetList;
  final Key? key;
  final FixedExtentScrollController? controller;
  final ValueChanged<int>? changed;

  _MyCityPicker(
      {this.createWidgetList, this.key, this.controller, this.changed});

  @override
  State createState() {
    return _MyCityPickerState();
  }
}

class _MyCityPickerState extends State<_MyCityPicker> {
  List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6.0),
        alignment: Alignment.center,
        height: 220.0,
        child: CPickerWidget(
          backgroundColor: Colors.white,
          scrollController: widget.controller,
          key: widget.key,
          itemExtent: 30.0,
          squeeze: 1,
          onSelectedItemChanged: (index) {
            if (widget.changed != null) {
              widget.changed!(index);
            }
          },
          children: widget.createWidgetList!().length > 0
              ? widget.createWidgetList!()
              : [Text('')],
        ),
      ),
      flex: 1,
    );
  }
}

// class _BottomPickerLayout extends SingleChildLayoutDelegate {
//   _BottomPickerLayout(this.progress, {this.itemCount, this.showTitleActions});

//   final double progress;
//   final int itemCount;
//   final bool showTitleActions;

//   @override
//   BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
//     double maxHeight = 300.0;

//     return BoxConstraints(
//       minWidth: constraints.maxWidth,
//       maxWidth: constraints.maxWidth,
//       minHeight: 0.0,
//       maxHeight: maxHeight,
//     );
//   }

//   @override
//   Offset getPositionForChild(Size size, Size childSize) {
//     double height = size.height - childSize.height * progress;
//     return Offset(0.0, height);
//   }

//   @override
//   bool shouldRelayout(_BottomPickerLayout oldDelegate) {
//     return progress != oldDelegate.progress;
//   }
// }
