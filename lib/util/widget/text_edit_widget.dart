import 'package:flutter/material.dart';
import 'package:liuliangchi/util/view/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';

class TextEditWidget extends StatefulWidget {
  final String? hint;
  final Function(String)? onSubmitted;

  const TextEditWidget({Key? key, this.hint, this.onSubmitted})
      : super(key: key);

  @override
  _TextEditWidgetState createState() => _TextEditWidgetState();
}

class _TextEditWidgetState extends State<TextEditWidget> {
  TextEditingController textCon = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 40,
      duration: Duration(milliseconds: 200),
      padding: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color:
            focusNode.hasFocus ? Colors.white : Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.black.withOpacity(focusNode.hasFocus ? 0.25 : 0.0),
        ),
      ),
      margin: EdgeInsets.all(12),
      child: Row(
        children: [
          buildTFView(
            context,
            hintText: widget.hint ?? '请输入变电站名',
            isExp: true,
            focusNode: focusNode,
            onChanged: (v) => setState(() {}),
            con: textCon,
            textInputAction: TextInputAction.search,
            onSubmitted: (v) => widget.onSubmitted!(v),
          ),
          WidgetTap(
            isElastic: textCon.text != '',
            onTap: () {
              if (textCon.text != '') {
                setState(() => textCon.clear());
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 100),
              opacity: textCon.text == '' ? 0.0 : 1.0,
              child: Container(
                  width: 40,
                  height: 40,
                  child: Icon(Icons.clear_rounded, size: 20)),
            ),
          ),
          WidgetTap(
            isElastic: textCon.text != '',
            onTap: () {
              if (textCon.text != '') {
                FocusScope.of(context).requestFocus(FocusNode());
                widget.onSubmitted!(textCon.text);
              }
            },
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 100),
              opacity: textCon.text == '' ? 0.25 : 1.0,
              child: Container(
                  width: 40, height: 40, child: Icon(Icons.search, size: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
