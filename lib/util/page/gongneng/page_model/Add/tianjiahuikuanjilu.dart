import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/config/common_config.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:uuid/uuid.dart';

import '../../../../provider/provider_config.dart';

class TianHuiKuanJiLu extends StatefulWidget {
  const TianHuiKuanJiLu({Key? key}) : super(key: key);

  @override
  State<TianHuiKuanJiLu> createState() => _TianHuiKuanJiLuState();
}

class _TianHuiKuanJiLuState extends State<TianHuiKuanJiLu> {
  List firstDropDown = [],
      secondDropDown = [],
      thirdDropDown = [],
      fifthDropDown = [],
      sixthDropDown = [],
      fourthDropDown = [];
  var important = ['回款金额', '对应客户', '合同标题', '回款计划'];

  String? selectedValue;
  List address = [], errorForms = [];
  String? time, time1, time2;
  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();
  final formKey5 = GlobalKey<FormState>();

  String? firmName,
      phone,
      mobile,
      title,
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

  int? nextTrackDate;
  bool isValidateError = false;
  bool hasDate = true;

  String? planPrice;

  List<String> urls = [
    '/app/customer/getCustomerList',
    '/app/contract/getContractList',
    '/app/user/getUserList'
  ];

  var customerName;

  var paymentPlan;

  var name;

  @override
  void initState() {
    super.initState();
    _getAllDropDowns();
  }

  _getAllDropDowns() async {
    await Request.postAll(urls,
        isToken: false,
        isLoading: true,
        context: context,
        dialogText: '正在...',
        data: {
          "qj_userId": userPro.qj_userId,
          "qj_companyId": userPro.qj_companyId
        }, success: (results) {
      int i = 0;
      for (var res in results) {
        if (res != null) {
          if (res.statusCode == 200) {
            // flog(json.encode(res.data), '${res.realUri}：成功');
            if (i == 0) {
              setState(() {
                firstDropDown = res.data['result']['data'];
              });
              print('Customer list $firstDropDown');
            } else if (i == 1) {
              setState(() {
                thirdDropDown = res.data['result']['data'];
              });

              print('Contract list $firstDropDown');
            } else {
              setState(() {
                fourthDropDown = res.data['result']['data'];
              });
            }
            i++;
          } else {
            //add empty list
          }
        }
      }

      // setState(() {
      //   fourthDropDown = _['result']['data'];
      // });
    }, catchError: (_) {
      print('Error $_');
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ScaffoldWidget(
      appBar: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 32),
        child: buildTitleRight(
            text: '新增回款记录', onTap: () {}, rightChild: const SizedBox()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                await _selectDate(context);
              },
              child: SizedBox(
                width: width * 0.9,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: isValidateError && !hasDate ? 30.0 : 0),
                      child: Text.rich(
                        TextSpan(
                          text: '*',
                          children: const <InlineSpan>[
                            TextSpan(
                              text: '回款日期',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                          style: TextStyle(color: pColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.087,
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
                                      Icons.calendar_month_outlined,
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
            textField('回款金额', width, height, (t) {
              setState(() {
                planPrice = t;
              });
            }),
            _dropdown('对应客户', width, firstDropDown, (t) {
              setState(() {
                customerName = t;
              });
            }),
            textField('合同标题', width, height, (t) {
              setState(() {
                sales = t;
              });
            }),
            _dropdown('回款计划', width, thirdDropDown, (t) {
              setState(() {
                paymentPlan = t;
              });
            }),
            _dropdown('付款方式', width, [], (p0) {}),
            _dropdown('回款类型', width, [], (p0) {}),
            _dropdown('收款人', width, fourthDropDown, (t) {
              setState(() {
                name = t;
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
                  formKey4.currentState!.save();
                  formKey5.currentState!.save();

                  if (time == null) {
                    hasDate = false;
                  }

                  if (formKey.currentState!.validate() &&
                      formKey2.currentState!.validate() &&
                      formKey3.currentState!.validate() &&
                      formKey4.currentState!.validate() &&
                      formKey5.currentState!.validate()) {
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

  Future<Null> _selectDate(BuildContext context) async {
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
      if (context.mounted) await _selectTime(picked, context);
    }
  }

  Future<Null> _selectTime(DateTime date, BuildContext context) async {
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
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = '${_hour!} : ${_minute!}';
        _time;
        var t = DateTime(date.year, date.month, date.day, selectedTime.hour,
            selectedTime.minute);
        hasDate = true;
        time = formatDate(t, [yyyy, '-', mm, '-', dd, ' '],
                locale: const SimplifiedChineseDateLocale())
            .toString();
        nextTrackDate = t.millisecondsSinceEpoch;
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
                        key: title == '回款金额'
                            ? formKey
                            : title == '合同标题'
                                ? formKey3
                                : null,
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
    List list,
    void Function(Map<String, dynamic>?)? onChanged,
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
                    text: title == '收款人' || title == '对应客户' || title == '回款计划'
                        ? '*'
                        : '',
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
              child: title == '收款人' || title == '对应客户' || title == '回款计划'
                  ? Form(
                      key: title == '对应客户'
                          ? formKey2
                          : title == '回款计划'
                              ? formKey4
                              : formKey5,
                      child: DropdownButtonFormField2(
                        dropdownStyleData: const DropdownStyleData(
                            maxHeight: 150, offset: Offset(0, -10)),
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
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
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
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade500),
                        ),
                        items: list
                            .map<DropdownMenuItem<Map<String, dynamic>>>(
                                (item) =>
                                    DropdownMenuItem<Map<String, dynamic>>(
                                      value: item,
                                      child: Text(
                                        title == '对应客户'
                                            ? item['firmName'].toString()
                                            : title == '回款计划'
                                                ? item['product'].toString()
                                                : title == '收款人'
                                                    ? item['realName']
                                                        .toString()
                                                    : item['firmName']
                                                        .toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            setState(() {
                              errorForms.add(title);
                            });
                            return '请做出选择';
                          }
                          return null;
                        },
                        onChanged: onChanged,
                        onSaved: (value) {
                          selectedValue = value.toString();
                        },
                      ),
                    )
                  : DropdownButtonFormField2(
                      dropdownStyleData: const DropdownStyleData(
                          maxHeight: 150, offset: Offset(0, -10)),
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
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
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
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade500),
                      ),
                      items: list
                          .map<DropdownMenuItem<Map<String, dynamic>>>(
                              (item) => DropdownMenuItem<Map<String, dynamic>>(
                                    value: item,
                                    child: Text(
                                      title == '对应客户'
                                          ? item['firmName'].toString()
                                          : title == '回款计划'
                                              ? item['product'].toString()
                                              : item['firmName'].toString(),
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
            )),
      ],
    );
  }

  _submitData() async {
    var payload = {
      "planDate": nextTrackDate,
      "planPrice": int.tryParse(planPrice!),
      "customerId": customerName['id'],
      "contractId": paymentPlan['id'],
      "paymentPlanId": const Uuid().v1(),
      "headUserId": name['id'],
      "payStatus": "1",
      "planType": "1",
      "remark": "88",
      "qj_userId": userPro.qj_userId,
      "qj_companyId": userPro.qj_companyId
    };

    await Request.post('/app/payment/addPaymentHistory',
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
