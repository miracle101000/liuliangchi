import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:liuliangchi/util/page/gongneng/page_model/Add/data.dart';
import 'package:liuliangchi/util/provider/provider_config.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../common_util.dart';
import '../../../../config/common_config.dart';
import 'package:date_format/date_format.dart';
import 'package:uuid/uuid.dart';

import 'adress.dart';

class HeTong extends StatefulWidget {
  const HeTong({Key? key});

  @override
  State<HeTong> createState() => _HeTongState();
}

class _HeTongState extends State<HeTong> {
  List firstDropDown = [],
      secondDropDown = [],
      thirdDropDown = [],
      fifthDropDown = [],
      sixthDropDown = [],
      fourthDropDown = [];
  var important = [
    '合同标题',
    '合同状态',
    '请选择',
    '对应客户',
    '左俊华',
    '关联产品',
    '请选择',
    '合同总金额',
    '签约日期',
    '合同开始日期',
    '合同结束日期'
  ];

  String? selectedValue;
  List address = [], errorForms = [];
  String? time;
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();
  final formKey5 = GlobalKey<FormState>();

  String? firmName,
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
      nextTrackDate,
      date,
      date1,
      date2;

  int? mDate, mDate1, mDate2;
  bool isValidateError = false;
  bool hasDate1 = true, hasDate2 = true, hasDate = true;

  String? customerSignUser;

  String? title;

  var customerName;
  var name;
  var product;

  String? contactPrice;

  var opportunities;

  var department;

  List<String> urls = [
    '/app/customer/getCustomerList',
    '/app/opportunity/getOpportunityList',
    "/app/user/getUserList",
    "/app/user/getDepartmentList"
  ];

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
              print('Customer list: $firstDropDown');
            } else if (i == 1) {
              setState(() {
                thirdDropDown = res.data['result']['data'];
              });
              print('Opportunity list: $thirdDropDown');
            } else if (i == 2) {
              fourthDropDown = res.data['result']['data'];
            } else {
              fifthDropDown = res.data['result']['data'];
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
            text: '新增合同', onTap: () {}, rightChild: const SizedBox()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            textField('合同标题', width, height, (t) {
              setState(() {
                title = t;
              });
            }),
            _dropdown('合同状态', width, [], (t) {
              setState(() {
                // firmName = t;
              });
            }),
            _dropdown('对应客户', width, firstDropDown, (t) {
              setState(() {
                customerName = t;
              });
            }),
            _dropdown('关联产品', width, thirdDropDown, (t) {
              setState(() {
                // firmName = t;
                product = t;
              });
            }),
            textField('合同总金额', width, height, (t) {
              setState(() {
                contactPrice = t;
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
                    Text.rich(TextSpan(
                      text: important.contains('签约日期') ? '*' : '',
                      children: const <InlineSpan>[
                        TextSpan(
                          text: '签约日期',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                      style: TextStyle(color: pColor),
                    )),
                    SizedBox(
                      width: width * 0.090,
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
                                    date ?? '选择日期时间',
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
            GestureDetector(
              onTap: () async {
                await _selectDate(context, 1);
              },
              child: SizedBox(
                width: width * 0.9,
                child: Row(
                  children: [
                    Text.rich(TextSpan(
                      text: important.contains('合同开始日期') ? '*' : '',
                      children: const <InlineSpan>[
                        TextSpan(
                          text: '合同开始日期',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                      style: TextStyle(color: pColor),
                    )),
                    SizedBox(
                      width: width * 0.020,
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
                                    color: !hasDate1
                                        ? Colors.red.shade900
                                        : Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
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
                                        date1 ?? '选择日期时间',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    )
                                  ],
                                ),
                                if (!hasDate1)
                                  const SizedBox(
                                    height: 8,
                                  ),
                                if (!hasDate1)
                                  Text(
                                    '该字段不能为空',
                                    style:
                                        TextStyle(color: Colors.red.shade900),
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await _selectDate(context, 2);
              },
              child: SizedBox(
                width: width * 0.9,
                child: Row(
                  children: [
                    Text.rich(TextSpan(
                      text: important.contains('合同结束日期') ? '*' : '',
                      children: const <InlineSpan>[
                        TextSpan(
                          text: '合同结束日期',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                      style: TextStyle(color: pColor),
                    )),
                    SizedBox(
                      width: width * 0.020,
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
                                    color: !hasDate2
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
                                    date2 ?? '选择日期时间',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (!hasDate2)
                            const SizedBox(
                              height: 8,
                            ),
                          if (!hasDate2)
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
            _dropdown('对应商机', width, thirdDropDown, (t) {
              setState(() {
                opportunities = t;
              });
            }),
            _dropdown('合同类型', width, [], (t) {
              setState(() {});
            }),
            _dropdown('客户方签约人', width, firstDropDown, (t) {
              setState(() {
                // weixinhao = t;
              });
            }),
            textField('我方签约人', width, height, (t) {
              setState(() {
                customerSignUser = t;
              });
            }),
            SizedBox(
              width: width * 0.9,
              child: Row(
                children: [
                  Text(
                    '合同附件',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  SizedBox(
                    width: width * 0.11,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: pColor),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);

                        if (image != null) {
                          PickedFile file = PickedFile(image.path);
                          buildShowDialog(context, text: '正在...');
                          var data = await uploadFile(file);
                          print(data);
                          close();
                        } else {
                          // User canceled the picker
                        }
                      },
                      child: const Text('+ 选择文件'))
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                await _selectDate(context);
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
                                time ?? '选择日期时间',
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
            _dropdown('负责人', width, fourthDropDown, (t) {
              setState(() {
                name = t;
              });
            }),
            _dropdown('所属部门', width, fifthDropDown, (t) {
              setState(() {
                department = t;
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
                  setState(() {
                    if (date == null) {
                      hasDate = false;
                    } else if (date1 == null) {
                      hasDate1 = false;
                    } else if (date2 == null) {
                      hasDate2 = false;
                    }
                  });

                  if (formKey.currentState!.validate() &&
                      formKey2.currentState!.validate() &&
                      formKey3.currentState!.validate() &&
                      formKey4.currentState!.validate() &&
                      formKey5.currentState!.validate()) {
                    if (hasDate && hasDate1 && hasDate2) {
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

  Future<Null> _selectDate(BuildContext context, [int? i]) async {
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
      if (i == 0) {
        setState(() {
          date = formatDate(picked, [yyyy, '-', mm, '-', dd],
                  locale: const SimplifiedChineseDateLocale())
              .toString();
          mDate = picked.millisecondsSinceEpoch;
          hasDate = true;
        });
      } else if (i == 1) {
        setState(() {
          date1 = formatDate(picked, [yyyy, '-', mm, '-', dd],
                  locale: const SimplifiedChineseDateLocale())
              .toString();
          mDate1 = picked.millisecondsSinceEpoch;
          hasDate1 = true;
        });
      } else if (i == 2) {
        setState(() {
          date2 = formatDate(picked, [yyyy, '-', mm, '-', dd],
                  locale: const SimplifiedChineseDateLocale())
              .toString();
          mDate2 = picked.millisecondsSinceEpoch;
          hasDate2 = true;
        });
      } else {
        if (context.mounted) await _selectTime(picked, context);
      }
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
        setState(() {
          var t = DateTime(date.year, date.month, date.day, selectedTime.hour,
              selectedTime.minute);
          time = formatDate(
                  t, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, " ", am],
                  locale: const SimplifiedChineseDateLocale())
              .toString();
          nextTrackDate = t.millisecondsSinceEpoch.toString();
        });
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
                        key: title == '合同标题' ? formKey : formKey5,
                        child: TextFormField(
                          maxLines: title == '备注' ? 5 : null,
                          keyboardType:
                              title == '合同总金额' ? TextInputType.number : null,
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
            child: title == '合同状态' || title == '关联产品' || title == '对应客户'
                ? Form(
                    key: title == '合同状态'
                        ? formKey2
                        : title == '关联产品'
                            ? formKey3
                            : title == '对应客户'
                                ? formKey4
                                : null,
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
                              (item) => DropdownMenuItem<Map<String, dynamic>>(
                                    value: item,
                                    child: Text(
                                      title == '对应客户'
                                          ? item['firmName'].toString()
                                          : title == '关联产品'
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
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    ),
                    //firmName,product

                    items: list
                        .map<DropdownMenuItem<Map<String, dynamic>>>((item) =>
                            DropdownMenuItem<Map<String, dynamic>>(
                              value: item,
                              child: Text(
                                title == '客户方签约人'
                                    ? item['firmName'].toString()
                                    : title == '对应商机'
                                        ? item['product'].toString()
                                        : title == '所属部门'
                                            ? item['name'].toString()
                                            : title == '负责人'
                                                ? item['realName'].toString()
                                                : item['name'].toString(),
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
      "customerId": customerName['id'],
      "customerName": '',
      "opportunityId": opportunities['id'],
      "opportunityName": '',
      "contractPrice": int.tryParse(contactPrice!),
      "signDate": mDate,
      "startDate": mDate1,
      "endDate": mDate2,
      "remindDate": "",
      "remark": remark,
      "contractStatus": "1",
      "product": product, //pending
      "productId": '',
      "contractType": "1",
      "customerSignUser": customerName['id'].toString(),
      "mySignUser": name['id'].toString(),
      "nextTrackDate": nextTrackDate,
      "head": name['realName'].toString(),
      "headUserId": name['id'].toString(),
      "departmentId": department['id'].toString(),
      "departmentName": department['name'].toString(),
      "attachmentList": null,
      "qj_userId": userPro.qj_userId,
      "qj_companyId": userPro.qj_companyId
    };

    await Request.post('/app/contract/addContract',
        data: payload,
        isLoading: true,
        dialogText: '正在...',
        isToken: false,
        catchError: (v) => showCustomToast(v),
        success: (v) {
          showToast(v.toString());
          Navigator.pop(context);
        },
        context: context);
  }
}
