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
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:uuid/uuid.dart';

import '../../../../provider/provider_config.dart';
import 'adress.dart';

class TianJiaKehu extends StatefulWidget {
  const TianJiaKehu({Key? key});

  @override
  State<TianJiaKehu> createState() => _TianJiaKehuState();
}

class _TianJiaKehuState extends State<TianJiaKehu> {
  final List<String> firstDropDown = [
        '广告',
        '客户介绍',
        '独立资源',
        '搜客宝',
        '机器人',
      ],
      secondDropDown = ['A(重要客户)', 'B(普通客户)', 'C(低价值客户)'],
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

  String? selectedValue;
  List address = [], errorForms = [];
  String? time;
  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
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
      nextTrackDate;
  bool isValidateError = false;

  var important = ['电话', '公司名称', '客户名称'];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ScaffoldWidget(
      appBar: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 32),
        child: buildTitleRight(
            text: '添加客户', onTap: () {}, rightChild: const SizedBox()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            textField('客户名称', width, height, (t) {
              setState(() {
                name = t;
              });
            }),
            _dropdown('客户类型', width, secondDropDown, (t) {
              setState(() {
                // firmName = t;
              });
            }),

            textField('电话', width, height, (t) {
              setState(() {
                phone = t;
              });
            }),
            textField('公司名称', width, height, (t) {
              setState(() {
                // firmName = t;
              });
            }),
            _dropdown('线索来源', width, firstDropDown, (t) {
              setState(() {
                remark = t;
              });
            }),
            textField('备注', width, height, (t) {
              setState(() {
                remark = t;
              });
            }),
            textField('上级客户', width, height, (t) {
              setState(() {
                // firmDepartment = t;
              });
            }),
            textField('手机', width, height, (t) {
              setState(() {
                mobile = t;
              });
            }),
            textField('微信号', width, height, (t) {
              setState(() {
                weixinhao = t;
              });
            }),
            textField('QQ号', width, height, (t) {
              setState(() {
                qq = t;
              });
            }),
            textField('邮箱', width, height, (t) {
              setState(() {
                email = t;
              });
            }),
            textField('网址', width, height, (t) {
              setState(() {
                website = t;
              });
            }),
            // _dropdown('地区', width),//address
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const AddressPage()))
                    .then((value) {
                  setState(() {
                    address = value;
                    firmProvince = value[0];
                    firmCity = value[1];
                    firmArea = value[2];
                  });
                });
              },
              child: Container(
                width: width * 0.9,
                child: Row(
                  children: [
                    Text(
                      '地区',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    SizedBox(
                      width: width * 0.185,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: width * 0.6,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: address.isEmpty ? 8.0 : 11,
                              ),
                              child: Text(
                                address.isEmpty
                                    ? '请选择'
                                    : '${address[0]['name']} / ${address[1] != null ? '${address[1]['name']} / ' : ''} ${address[2] != null ? '${address[2]['name']}' : ''}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: address.isEmpty ? null : 12),
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
            textField('地址', width, height, (t) {
              setState(() {
                maddress = t;
              });
            }),
            textField('邮编', width, height, (t) {}),
            _dropdown('跟进状态', width, sixthDropDown, (t) {}),
            _dropdown('客户来源', width, firstDropDown, (t) {}),
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
                  formKey1.currentState!.save();
                  formKey2.currentState!.save();
                  if (formKey.currentState!.validate() &&
                      formKey1.currentState!.validate() &&
                      formKey2.currentState!.validate()) {
                    await _submitData(
                        name,
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
                        address,
                        nextTrackDate);
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
      await _selectTime(picked, context);
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
                        text:
                            title == '电话' || title == '客户名称' || title == '公司名称'
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
            SizedBox(
                width: width * 0.6,
                height: title == '备注'
                    ? 100
                    : isValidateError && errorForms.contains(title)
                        ? 60
                        : 35,
                child: important.contains(title)
                    ? Form(
                        key: title == '客户名称'
                            ? formKey
                            : title == '电话'
                                ? formKey1
                                : formKey2,
                        child: TextFormField(
                          maxLines: title == '备注' ? 5 : null,
                          keyboardType: title == '电话' ||
                                  title == 'QQ号' ||
                                  title == '邮编' ||
                                  title == '电话'
                              ? TextInputType.number
                              : null,
                          onChanged: onChanged,
                          validator: (title == '电话' ||
                                  title == '公司名称' ||
                                  title == '客户名称')
                              ? (text) {
                                  if (title == '电话') {
                                    if (text!.isEmpty) {
                                      setState(() {
                                        errorForms.add(title);
                                      });
                                      return '该字段不能为空';
                                    } else if (text.length < 11 ||
                                        text.length > 11) {
                                      setState(() {
                                        errorForms.add(title);
                                      });
                                      return '无效的电话号码';
                                    }
                                  } else {
                                    if (text!.isEmpty) {
                                      setState(() {
                                        errorForms.add(title);
                                      });
                                      return '该字段不能为空';
                                    }
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
                        keyboardType:
                            title == '电话' ? TextInputType.number : null,
                        onChanged: onChanged,
                        validator: (title == '电话' ||
                                title == '公司名称' ||
                                title == '客户名称')
                            ? (text) {
                                if (title == '电话') {
                                  if (text!.isEmpty) {
                                    return '该字段不能为空';
                                  } else if (text.length < 11 ||
                                      text.length > 11) {
                                    return '无效的电话号码';
                                  }
                                } else {
                                  if (text!.isEmpty) {
                                    return '该字段不能为空';
                                  }
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
            height: isValidateError && title == '线索来源' ? 60 : 38,
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

  _submitData(
      name,
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
      province,
      city,
      area,
      firmAddress,
      nextTrackDate) async {
    var payload = {
      "name": name,
      "clueId": const Uuid().v1(),
      "firmName": "",
      "phone": phone,
      "mobile": mobile != null ? int.tryParse(mobile) : null,
      "clueSource": 1,
      "remark": remark,
      "weixinhao": weixinhao,
      "qq": qq != null ? int.tryParse(qq) : null,
      "email": email,
      "webSite": website,
      "province": province,
      "city": city,
      "area": area,
      "staffSize": "",
      "nextTrackDate": nextTrackDate,
      "trackStatus": "",
      "head": "",
      "headUserId": const Uuid().v1(),
      "departmentId": const Uuid().v1(),
      "departmentName": "",
      "superCustomerId": const Uuid().v1(),
      "superCustomerName": "",
      "customerType": 1,
      "address": maddress,
      "zipCode": 5444,
      "customerTrackStatus": 1,
      "qj_userId": userPro.qj_userId,
      "qj_companyId": userPro.qj_companyId
    };

    await Request.post('/app/customer/addCustomer',
        data: payload,
        isLoading: true,
        dialogText: '正在...',
        isToken: false,
        catchError: (v) => showCustomToast(v),
        success: (v) {
          showToast("成功");
          Navigator.pop(context);
        },
        context: context);
  }
}
