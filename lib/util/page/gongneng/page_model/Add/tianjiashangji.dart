import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:liuliangchi/util/page/gongneng/page_model/Add/data.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../common_util.dart';
import '../../../../config/common_config.dart';
import 'package:date_format/date_format.dart';
import 'package:uuid/uuid.dart';

import '../../../../provider/provider_config.dart';
import 'adress.dart';

class TianjiaShangji extends StatefulWidget {
  const TianjiaShangji({Key? key});

  @override
  State<TianjiaShangji> createState() => _TianjiaShangjiState();
}

class _TianjiaShangjiState extends State<TianjiaShangji> {
  final List<String> firstDropDown = [
        '广告',
        '客户介绍',
        '独立资源',
        '搜客宝',
        '机器人',
      ],
      secondDropDown = [
        'A(重要客户)',
        'B(普通客户)',
        'C(低价值客户)',
      ],
      thirdDropDown = [
        '未处理',
        '已加微信',
        '已发资料',
        '暂时不需要',
        '未接电话',
        '挂断',
        '同行',
        'A类（准客户)',
        'B类（意向较强）',
        'C类（后期后需要）',
        'D类（完全无意向）',
        '(空白)'
      ],
      fifthDropDown = ['无数据'],
      sixthDropDown = ['初访', '意向', '报价', '成交', '暂时搁置', '未成交'],
      fourthDropDown = ['杨海涛'];
  var important = ['商机标题', '对应客户', '预计销售金额'];

  String? selectedValue;
  List address = [], errorForms = [];
  String? time, time1, time2;
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  String? name,
      firmName,
      phone,
      mobile,
      remark,
      firmDepartment,
      firmPosition,
      weixinhao,
      qq,
      email,
      website,
      firmProvince,
      firmCity,
      firmArea,
      maddress,
      sales;

  int? nextTrackDate, nextTrackDate1, nextTrackDate2;
  int? mDate, mDate1, mDate2;
  bool isValidateError = false;
  bool hasDate = true;

  String? customerSignUser;

  String? title;

  String? customerName;

  String? product;

  String? contactPrice;

  String? opportunities;

  String? department;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ScaffoldWidget(
      appBar: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 32),
        child: buildTitleRight(
            text: '新增商机', onTap: () {}, rightChild: const SizedBox()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            textField('商机标题', width, height, (t) {
              setState(() {
                title = t;
              });
            }),
            textField('对应客户', width, height, (t) {
              setState(() {
                // customerName = t;
              });
            }),
            textField('预计销售金额', width, height, (t) {
              setState(() {
                sales = t;
              });
            }),
            GestureDetector(
              onTap: () async {
                await _selectDate(context, 0);
              },
              child: SizedBox(
                width: width * 0.9,
                child: Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: important.contains(title) ? '*' : '',
                        children: const <InlineSpan>[
                          TextSpan(
                            text: '预计签单日期',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                        style: TextStyle(color: pColor),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.038,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width * 0.6,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: !hasDate
                                        ? Colors.red.shade900
                                        : Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 8,
                                ),
                                const SizedBox(
                                    width: 16,
                                    child: Icon(
                                      Icons.watch_later_outlined,
                                      size: 20,
                                      color: Colors.grey,
                                    )),
                                const SizedBox(
                                  width: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    time ?? '选择日期时间',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (!hasDate)
                            const SizedBox(
                              height: 8,
                            ),
                          if (!hasDate)
                            Text(
                              '该字段不能为空',
                              style: TextStyle(color: Colors.red.shade900),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            textField('备注', width, height, (t) {
              setState(() {
                remark = t;
              });
            }),
            textField('关联联系人', width, height, (t) {
              setState(() {
                // opportunities = t;
              });
            }),
            textField('关联产品', width, height, (t) {
              setState(() {
                // opportunities = t;
              });
            }),
            _dropdown('销售阶段', width,
                ['初步接洽', '需求确认', '方案/报价', '谈判/合同', '赢单', '输单', '(空白)'], (t) {
              setState(() {
                // opportunities = t;
              });
            }),
            SizedBox(
              width: width * 0.9,
              child: Row(
                children: [
                  Text(
                    '商机附件',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  SizedBox(
                    width: width * 0.11,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: pColor),
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();

                        if (result != null) {
                          File file = File(result.files.single.path!);
                        } else {
                          // User canceled the picker
                        }
                      },
                      child: const Text('+ 选择文件'))
                ],
              ),
            ),
            _dropdown('商机类型', width, ['普通商机', '重要商机', '特殊商机'], (t) {
              setState(() {
                // vv
              });
            }),
            GestureDetector(
              onTap: () async {
                await _selectDate(context, 1);
              },
              child: SizedBox(
                width: width * 0.9,
                child: Row(
                  children: [
                    Text(
                      '商机获取日期',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    SizedBox(
                      width: width * 0.038,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: width * 0.6,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            const SizedBox(
                                width: 16,
                                child: Icon(
                                  Icons.watch_later_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                )),
                            const SizedBox(
                              width: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                time1 ?? '选择日期时间',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _dropdown('商机来源', width, ['广告', '客户介绍', '独立开发', '百度', '抖音', '58同城'],
                (t) {
              setState(() {
                name = t;
              });
            }),
            GestureDetector(
              onTap: () async {
                await _selectDate(context, 2);
              },
              child: SizedBox(
                width: width * 0.9,
                child: Row(
                  children: [
                    Text(
                      '下次跟进时间',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    SizedBox(
                      width: width * 0.038,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: width * 0.6,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            const SizedBox(
                                width: 16,
                                child: Icon(
                                  Icons.watch_later_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                )),
                            const SizedBox(
                              width: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                time2 ?? '选择日期时间',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _dropdown('负责人', width, ['无数据'], (t) {}),
            _dropdown('所属部门', width, ['无数据'], (t) {}),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      btnBar: SizedBox(
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
                  formKey.currentState!.save();
                  formKey2.currentState!.save();
                  formKey3.currentState!.save();

                  if (formKey.currentState!.validate() &&
                      formKey2.currentState!.validate() &&
                      formKey3.currentState!.validate()) {
                    if (hasDate) {
                      await _submitData();
                    }
                  } else {
                    setState(() {
                      isValidateError = true;
                    });
                  }
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
    );
  }

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  String? _hour, _minute, _time;

  Future<Null> _selectDate(BuildContext context, int i) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      locale: const Locale('zh'),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: pColor, // header background color
              onPrimary: Colors.black, // header text color
              onSurface: pColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: pColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (context.mounted) await _selectTime(picked, i, context);
    }
  }

  Future<Null> _selectTime(DateTime date, int i, BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: pColor, // header background color
              onPrimary: Colors.black, // header text color
              onSurface: pColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: pColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      print(picked);
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = '${_hour!} : ${_minute!}';
        _time;
        var t = DateTime(date.year, date.month, date.day, selectedTime.hour,
            selectedTime.minute);
        if (i == 0) {
          hasDate = true;
          time = formatDate(
                  t, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, " ", am],
                  locale: const SimplifiedChineseDateLocale())
              .toString();
          nextTrackDate = t.millisecondsSinceEpoch;
        } else if (i == 1) {
          time1 = formatDate(
                  t, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, " ", am],
                  locale: const SimplifiedChineseDateLocale())
              .toString();
          nextTrackDate1 = t.millisecondsSinceEpoch;
        } else if (i == 2) {
          time2 = formatDate(
                  t, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, " ", am],
                  locale: const SimplifiedChineseDateLocale())
              .toString();
          nextTrackDate2 = t.millisecondsSinceEpoch;
        }
      });
    }
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
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: isValidateError && errorForms.contains(title)
                            ? 24.0
                            : 0),
                    child: Text.rich(
                      TextSpan(
                        text: important.contains(title) ? '*' : '',
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
                ),
                const SizedBox(
                  width: 35,
                ),
              ],
            ),
            SizedBox(
                width: width * 0.6,
                height: title == '备注'
                    ? 100
                    : isValidateError && errorForms.contains(title)
                        ? 60
                        : 35,
                child: important.contains(title)
                    ? Form(
                        key: title == '商机标题'
                            ? formKey
                            : title == '对应客户'
                                ? formKey2
                                : formKey3,
                        child: TextFormField(
                          maxLines: title == '备注' ? 5 : null,
                          keyboardType:
                              title == '预计销售金额' ? TextInputType.number : null,
                          onChanged: onChanged,
                          validator: important.contains(title)
                              ? (text) {
                                  if (text!.trim().isEmpty) {
                                    setState(() {
                                      errorForms.add(title);
                                    });
                                    return '该字段不能为空';
                                  }

                                  return null;
                                }
                              : null,
                          cursorColor: Colors.grey.shade500,
                          style: const TextStyle(color: Colors.grey),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: title == '备注' ? 8 : 0),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: pColor)),
                              border: const OutlineInputBorder()),
                        ),
                      )
                    : TextFormField(
                        maxLines: title == '备注' ? 5 : null,
                        // keyboardType:
                        //     title == '电话' ? TextInputType.number : null,
                        onChanged: onChanged,
                        validator: important.contains(title)
                            ? (text) {
                                if (text!.trim().isEmpty) {
                                  setState(() {
                                    errorForms.add(title);
                                  });
                                  return '该字段不能为空';
                                }
                                return null;
                              }
                            : null,

                        cursorColor: Colors.grey.shade500,
                        style: const TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: title == '备注' ? 8 : 0),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: pColor)),
                            border: const OutlineInputBorder()),
                      )),
          ],
        ),
      ),
    );
  }

  _dropdown(
    String title,
    double width,
    List<String> list,
    void Function(String?)? onChanged,
  ) {
    return Row(
      key: ObjectKey(title),
      children: [
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 70,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: isValidateError && errorForms.contains(title)
                        ? 30.0
                        : 0),
                child: Text.rich(
                  TextSpan(
                    text: important.contains(title) ? '*' : '',
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
            ),
            const SizedBox(
              width: 35,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            width: width * 0.6,
            height: isValidateError && errorForms.contains(title) ? 60 : 38,
            child: DropdownButtonFormField2(
              dropdownStyleData: DropdownStyleData(
                  maxHeight: 150,
                  offset: title == '跟进状态'
                      ? const Offset(0, -10)
                      : const Offset(0, -10)),
              iconStyleData: const IconStyleData(
                  icon: RotatedBox(
                      quarterTurns: 3,
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 18,
                        color: Colors.grey,
                      ))),
              style: TextStyle(color: Colors.grey.shade500),
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: pColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              isExpanded: true,
              hint: Text(
                '请选择',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
              items: list
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return '请做出选择';
                }
                return null;
              },
              onChanged: onChanged,
              onSaved: (value) {
                selectedValue = value.toString();
              },
            ),
          ),
        ),
      ],
    );
  }

  _submitData() async {
    var payload = {
      "title": title,
      "customerId": const Uuid().v1(),
      "customerName": "",
      "sales": int.tryParse(sales!),
      "signBillTime": nextTrackDate,
      "remark": remark,
      "contact": "",
      "contactId": const Uuid().v1(),
      "product": "",
      "productId": const Uuid().v1(),
      "salesPhase": "1",
      "attachmentList": [],
      "opportunityType": "1",
      "opportunityGetDate": nextTrackDate1,
      "opportunitySource": "1",
      "nextTrackDate": nextTrackDate2,
      "leading": {},
      "head": "",
      "headUserId": const Uuid().v1(),
      "branch": {},
      "departmentId": const Uuid().v1(),
      "departmentName": "",
      "visible": false,
      "qj_userId": userPro.qj_userId,
      "qj_companyId": userPro.qj_companyId
    };

    await Request.post('/app/opportunity/addOpportunity',
        data: payload,
        isLoading: true,
        dialogText: '正在...',
        isToken: false, catchError: (v) {
      print(v);
      showCustomToast(v);
    }, success: (v) {
      print(v);
      showToast(v.toString());
      Navigator.pop(context);
    }, context: context);
  }
}
