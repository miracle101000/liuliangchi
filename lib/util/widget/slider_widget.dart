import 'package:flutter/material.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';

import '../config/common_config.dart';

class SliderWidget extends StatefulWidget {
  final double? value;
  final Function(double)? valueFun;
  final bool isStage;
  final int? initValue;
  final int fixedValues;
  const SliderWidget(
      {Key? key,
      this.value,
      this.valueFun,
      this.isStage = false,
      this.initValue,
      this.fixedValues = 5})
      : super(key: key);

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  var _lowerValue = 0.0;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    _lowerValue = widget.value!;
    fixedValues = widget.fixedValues;
  }

  Widget xText(v) => PWidget.text(v ?? '1x', [aColor.withOpacity(0.5), 12],
      {'pd': List.generate(1, (_) => 32)});

  int? fixedValues;
  var hatchMark = [];

  @override
  Widget build(BuildContext context) {
    if (widget.isStage) {
      // return FlutterSlider(
      //   values: [_lowerValue],
      //   trackBar: FlutterSliderTrackBar(
      //     activeTrackBar: BoxDecoration(
      //       color: pColor,
      //       borderRadius: BorderRadius.circular(8),
      //     ),
      //     inactiveTrackBar: BoxDecoration(
      //       color: aColor.withOpacity(0.25),
      //       borderRadius: BorderRadius.circular(8),
      //     ),
      //   ),
      //   onDragCompleted: (_, value, __) {
      //     setState(() => _lowerValue = double.parse(value.toString()));
      //     widget.valueFun(_lowerValue);
      //   },
      //   tooltip: FlutterSliderTooltip(disabled: true),
      //   handler: FlutterSliderHandler(child: ClipOval(child: Container(height: 8, width: 8, color: pColor)), decoration: BoxDecoration()),
      //   fixedValues: List.generate(fixedValues, (i) {
      //     // return FlutterSliderHatchMarkLabel(percent: i * 100 / 9, label: xText('${(i + 1) * (fixedValues / 10)}X'));
      //     return FlutterSliderFixedValue(percent: (i+1) * 100 ~/ fixedValues, value: (i+1) * 100 ~/ fixedValues);
      //   }),
      //   hatchMark: FlutterSliderHatchMark(
      //     labels: List.generate(fixedValues, (i) {
      //       if (i == 0) return FlutterSliderHatchMarkLabel(percent: 1, label: xText('1'));
      //       if (i == fixedValues-1) return FlutterSliderHatchMarkLabel(percent: 100, label: xText('$fixedValues'));
      //       return FlutterSliderHatchMarkLabel(percent: (i+1) * 100 / fixedValues, label: xText(''));
      //     }),
      //   ),
      // );
      return Column(
        children: [
          // FlutterSlider(
          //   values: [_lowerValue],
          //   trackBar: FlutterSliderTrackBar(
          //     activeTrackBar: BoxDecoration(
          //       color: pColor,
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     inactiveTrackBar: BoxDecoration(
          //       color: aColor.withOpacity(0.25),
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          //   tooltip: FlutterSliderTooltip(disabled: true),
          //   handler: FlutterSliderHandler(
          //     child: ClipOval(child: Container(height: 8, width: 8, color: pColor)),
          //     decoration: BoxDecoration(),
          //   ),
          //   max: fixedValues.toDouble(),
          //   min: 0,
          //   // disabled: true,
          //   onDragging: (handlerIndex, lowerValue, upperValue) {
          //     // setState(() => _lowerValue = lowerValue);
          //     // widget.valueFun(_lowerValue);
          //   },
          // ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 2,
                thumbColor: pColor,
                activeTrackColor: pColor,
                inactiveTrackColor: aColor.withOpacity(0.25),
                overlayShape: SliderComponentShape.noOverlay,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
              ),
              child: Slider(
                value: widget.value!,
                max: widget.fixedValues.toDouble(),
                onChanged: (v) {},
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PWidget.text(
                  widget.initValue ?? '1', [aColor.withOpacity(0.5), 12]),
              PWidget.text(fixedValues, [aColor.withOpacity(0.5), 12]),
            ],
          )
        ],
      );
    } else {
      return Column(
        children: [
          // FlutterSlider(
          //   values: [_lowerValue],
          //   trackBar: FlutterSliderTrackBar(
          //     activeTrackBar: BoxDecoration(
          //       color: pColor,
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     inactiveTrackBar: BoxDecoration(
          //       color: aColor.withOpacity(0.25),
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          //   tooltip: FlutterSliderTooltip(disabled: true),
          //   handler: FlutterSliderHandler(
          //     child: ClipOval(child: Container(height: 8, width: 8, color: pColor)),
          //     decoration: BoxDecoration(),
          //   ),
          //   max: 100,
          //   min: 0,
          //   // disabled: true,
          //   onDragging: (handlerIndex, lowerValue, upperValue) {
          //     // setState(() => _lowerValue = lowerValue);
          //     // widget.valueFun(_lowerValue);
          //   },
          // ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 2,
                thumbColor: pColor,
                activeTrackColor: pColor,
                inactiveTrackColor: aColor.withOpacity(0.25),
                overlayShape: SliderComponentShape.noOverlay,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
              ),
              child: Slider(
                value: 0.0,
                onChanged: (v) {},
              ),
            ),
          ),
          PWidget.text(
              '$_lowerValue%', [aColor.withOpacity(0.5), 12], {'ct': true})
        ],
      );
    }
  }
}
