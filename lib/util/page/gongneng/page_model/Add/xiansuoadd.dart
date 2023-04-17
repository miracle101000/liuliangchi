import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:liuliangchi/util/page/gongneng/page_model/Add/data.dart';
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

class XianSuoAdd extends StatefulWidget {
  const XianSuoAdd({Key? key});

  @override
  State<XianSuoAdd> createState() => _XianSuoAddState();
}

class _XianSuoAddState extends State<XianSuoAdd> {
  List firstDropDown = [],
      thirdDropDown = [],
      fifthDropDown = [],
      fourthDropDown = [];

  String? selectedValue;
  List address = [];
  String? time;
  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController(),
      controller1 = TextEditingController();

  var name = {}, clueSource = {}, departmentName = {};
  String? firmName,
      firmPhone,
      firmMobile,
      remark,
      firmDepartment,
      firmPosition,
      firmWeixinhao,
      firmQq,
      firmEmail,
      firmWebsite,
      firmProvince,
      firmCity,
      firmArea,
      firmAddress,
      nextTrackDate;
  bool isValidateError = false;

  List<String> errorForms = [];

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    controller1.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getAllDropDowns();
  }

  List<String> urls = ["/app/user/getUserList", "/app/user/getDepartmentList"];
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
                fourthDropDown = res.data['result']['data'];
              });
              print('userlist $fourthDropDown');
            } else {
              setState(() {
                fifthDropDown = res.data['result']['data'];
              });
              print('Departmentlist $fifthDropDown');
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
            text: '新增线索', onTap: () {}, rightChild: const SizedBox()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            textField('手机', width, height, (t) {
              setState(() {
                firmPhone = t;
              });
            }),
            textField('公司', width, height, (t) {
              setState(() {
                firmName = t;
              });
            }),
            _dropdown('线索来源', width, firstDropDown, (t) {
              setState(() {
                clueSource = t!;
              });
            }, formKey2),
            textField('备注', width, height, (t) {
              setState(() {
                remark = t;
              });
            }),
            textField('部门', width, height, (t) {
              setState(() {
                firmDepartment = t;
              });
            }),
            textField('职务', width, height, (t) {
              setState(() {
                firmPosition = t;
              });
            }),
            textField('微信号', width, height, (t) {
              setState(() {
                firmWeixinhao = t;
              });
            }),
            textField('QQ号', width, height, (t) {
              setState(() {
                firmQq = t;
              });
            }),
            textField('邮箱', width, height, (t) {
              setState(() {
                firmEmail = t;
              });
            }),
            textField('网址', width, height, (t) {
              setState(() {
                firmWebsite = t;
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
                firmAddress = t;
              });
            }),
            _dropdown('跟进状态', width, thirdDropDown, (t) {}),
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
                name = t!;
              });
            }),
            _dropdown('所属部门', width, fifthDropDown, (t) {
              departmentName = t!;
            }),
            const SizedBox(
              height: 32,
            ),

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
                    await _submitData();
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

  textField(String title, double width, double height,
      void Function(String)? onChanged,
      [TextEditingController? controller]) {
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
                        text: title == '手机' || title == '公司' || title == '线索来源'
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
                child: (title == '手机' || title == '公司')
                    ? Form(
                        key: title == '手机'
                            ? formKey
                            : title == '公司'
                                ? formKey1
                                : null,
                        child: TextFormField(
                          controller: controller,
                          maxLines: title == '备注' ? 5 : null,
                          keyboardType: title == '手机' || title == 'QQ号'
                              ? TextInputType.number
                              : null,
                          onChanged: onChanged,
                          validator: (title == '手机' || title == '公司')
                              ? (text) {
                                  if (title == '手机') {
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
                            title == '手机' ? TextInputType.number : null,
                        onChanged: onChanged,
                        validator: (title == '手机' || title == '公司')
                            ? (text) {
                                if (title == '手机') {
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

  _dropdown(String title, double width, List list,
      void Function(Map<String, dynamic>?)? onChanged,
      [formKey]) {
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
                        ? 24.0
                        : 0),
                child: Text.rich(
                  TextSpan(
                    text: title == '线索来源' ? '*' : '',
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
            child: title == '线索来源'
                ? Form(
                    key: formKey,
                    child: DropdownButtonFormField2(
                      dropdownStyleData: DropdownStyleData(
                          maxHeight: 150, offset: const Offset(0, -10)),
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
                                      item['departmentName'],
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
                    dropdownStyleData: DropdownStyleData(
                        maxHeight: 150, offset: const Offset(0, -10)),
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
                    items: list
                        .map<DropdownMenuItem<Map<String, dynamic>>>(
                            (item) => DropdownMenuItem<Map<String, dynamic>>(
                                  value: item,
                                  child: Text(
                                    title == '所属部门'
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
      "name": name,
      "firmName": firmName,
      "firmPhone": firmPhone != null ? int.tryParse(firmPhone!) : firmPhone,
      "firmMobile": firmMobile != null ? int.tryParse(firmPhone!) : firmMobile,
      "clueSource": null, // should be this: clueSource['source'],
      "remark": remark,
      "firmDepartment": firmDepartment,
      "firmPosition": firmPosition,
      "firmWeixinhao": firmWeixinhao,
      "firmQq": firmQq == null ? null : int.tryParse(firmQq!),
      "firmEmail": firmEmail,
      "firmWebSite": firmWebsite,
      "firmProvince": firmProvince,
      "firmCity": firmCity,
      "firmArea": firmArea,
      "firmAddress": firmAddress,
      "nextTrackDate":
          nextTrackDate == null ? null : int.tryParse(nextTrackDate!),
      "trackStatus": 0,
      "head": name['realName'].toString(),
      "headUserId": name['id'].toString(),
      "departmentId": departmentName['id'].toString(),
      "departmentName": departmentName['name'].toString(),
      "visible": false,
      "qj_userId": userPro.qj_userId,
      "qj_companyId": userPro.qj_companyId
    };

    await Request.post('/app/clue/addClue',
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
