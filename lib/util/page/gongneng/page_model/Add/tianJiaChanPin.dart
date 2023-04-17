import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/config/common_config.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:liuliangchi/util/provider/provider_config.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:uuid/uuid.dart';

class TianJiaChanPin extends StatefulWidget {
  const TianJiaChanPin({Key? key});

  @override
  State<TianJiaChanPin> createState() => _TianJiaChanPinState();
}

class _TianJiaChanPinState extends State<TianJiaChanPin> {
  String? planPrice;

  String? grossProfitRate;

  String? price;

  String? unit;

  String? unitCost;

  String? description;

  String? remark;

  List<String?> v = ['单价', '单位', '单位成本', '毛利率'];

  bool isYes = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ScaffoldWidget(
      appBar: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 32),
        child: buildTitleRight(
            text: '新增产品', onTap: () {}, rightChild: const SizedBox()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            textField('单价', width, height, (t) {
              setState(() {
                price = t;
              });
            }),
            textField('单位', width, height, (t) {
              setState(() {
                unit = t;
              });
            }),
            textField('单位成本', width, height, (t) {
              setState(() {
                unitCost = t;
              });
            }),
            textField('毛利率', width, height, (t) {
              setState(() {
                grossProfitRate = t;
              });
            }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 21.0),
                    child: Text(
                      '续费产品',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.10,
                  ),
                  Row(
                    children: [
                      Text(
                        '좀',
                        style: TextStyle(color: !isYes ? pColor : Colors.grey),
                      ),
                      CupertinoSwitch(
                        activeColor: pColor,
                        value: isYes,
                        onChanged: (v) => setState(() => isYes = v),
                      ),
                      Text(
                        '是',
                        style: TextStyle(color: isYes ? pColor : Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 21.0),
                    child: Text(
                      '图片',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.18,
                  ),
                  DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(5),
                    padding: const EdgeInsets.all(0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        height: 120,
                        width: 120,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.add,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            textField('描述', width, height, (t) {
              setState(() {
                description = t;
              });
            }),
            textField('备注', width, height, (t) {
              setState(() {
                remark = t;
              });
            }),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      btnBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade500),
                    backgroundColor: sbColor,
                    elevation: 0,
                  ),
                  child: Text(
                    '取消',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (planPrice != null ||
                        grossProfitRate != null ||
                        price != null ||
                        unit != null ||
                        unitCost != null) await _submitData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pColor,
                    elevation: 0,
                  ),
                  child: const Text('确定'),
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  textField(
    String title,
    double width,
    double height,
    void Function(String)? onChanged,
  ) {
    return Padding(
      key: ObjectKey(title),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: width * 0.9,
        child: Row(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 70,
                  child: Text.rich(
                    TextSpan(
                      text: '',
                      children: <InlineSpan>[
                        TextSpan(
                          text: title,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                      style: TextStyle(color: pColor),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 35,
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                    width: title == '毛利率' ? (width * 0.6) - 35 : width * 0.6,
                    height: v.contains(title) ? 35 : 100,
                    child: TextFormField(
                      maxLines: v.contains(title) ? null : 5,
                      onChanged: onChanged,
                      cursorColor: Colors.grey.shade500,
                      style: const TextStyle(color: Colors.grey),
                      keyboardType:
                          v.contains(title) ? TextInputType.number : null,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: title == '备注' ? 8 : 0),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5)),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5)),
                              borderSide:
                                  BorderSide(color: Colors.red.shade900)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5)),
                              borderSide: BorderSide(color: pColor)),
                          border: const OutlineInputBorder()),
                    )),
                if (title == '毛利率')
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    child: const Center(
                      child: Text(
                        '%',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _submitData() async {
    var payload = {
      "productName": "k20",
      "productCode": "555",
      "price": price != null ? int.tryParse(price!) : null,
      "unit": unit != null ? int.tryParse(unit!) : null,
      "unitCost": unitCost != null ? int.tryParse(unitCost!) : null,
      "grossProfitRate":
          grossProfitRate != null ? int.tryParse(grossProfitRate!) : null,
      "image": "",
      "description": description,
      "remark": remark,
      "isRenew": isYes ? '1' : '0',
      "qj_userId": userPro.qj_userId,
      "qj_companyId": userPro.qj_companyId
    };

    await Request.post('/app/product/addProduct',
        data: payload,
        isLoading: true,
        dialogText: '正在...',
        isToken: false, catchError: (v) {
      showCustomToast(v);
    }, success: (v) {
      showToast(v.toString());
      Navigator.pop(context);
    }, context: context);
  }
}
