import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:liuliangchi/util/config/common_config.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import 'data.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  Map<String, dynamic>? selectedValue, selectedValue1, selectedValue2;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 32),
        child: buildTitleRight(
            text: '地区', onTap: () {}, rightChild: const SizedBox()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            DropdownButtonFormField2<Map<String, dynamic>>(
                value: selectedValue,
                iconStyleData: const IconStyleData(
                    icon: RotatedBox(
                        quarterTurns: 3,
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 18,
                          color: Colors.grey,
                        ))),
                style: const TextStyle(color: Colors.grey),
                dropdownStyleData:
                    const DropdownStyleData(offset: Offset(0, -10)),
                items: address['children']
                    .map<DropdownMenuItem<Map<String, dynamic>>>(
                        (Map<String, dynamic> e) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: e,
                    child: Text('${e['name']}'),
                  );
                }).toList(),
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
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                }),
            const SizedBox(
              height: 10,
            ),
            if (selectedValue != null)
              DropdownButtonFormField2<Map<String, dynamic>>(
                  value: selectedValue1,
                  iconStyleData: const IconStyleData(
                      icon: RotatedBox(
                          quarterTurns: 3,
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 18,
                            color: Colors.grey,
                          ))),
                  style: const TextStyle(color: Colors.grey),
                  dropdownStyleData:
                      const DropdownStyleData(offset: Offset(0, -10)),
                  items: (selectedValue!['children'] ?? [])
                      .map<DropdownMenuItem<Map<String, dynamic>>>(
                          (Map<String, dynamic> e) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: e,
                      child: Text('${e['name']}'),
                    );
                  }).toList(),
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
                  onChanged: (val) {
                    setState(() {
                      selectedValue1 = val;
                    });
                  }),
            const SizedBox(
              height: 10,
            ),
            if (selectedValue1 != null &&
                selectedValue1!['children'].isNotEmpty)
              DropdownButtonFormField2<Map<String, dynamic>>(
                  value: selectedValue2,
                  iconStyleData: const IconStyleData(
                      icon: RotatedBox(
                          quarterTurns: 3,
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 18,
                            color: Colors.grey,
                          ))),
                  style: const TextStyle(color: Colors.grey),
                  dropdownStyleData:
                      const DropdownStyleData(offset: Offset(0, -10)),
                  items: selectedValue1!['children']
                      .map<DropdownMenuItem<Map<String, dynamic>>>(
                          (Map<String, dynamic> e) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: e,
                      child: Text('${e['name']}'),
                    );
                  }).toList(),
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
                  onChanged: (val) {
                    setState(() {
                      selectedValue2 = val;
                    });
                  }),
            const SizedBox(
              height: 32,
            ),
            Row(
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
                  onPressed: () {
                    Navigator.pop(context,
                        [selectedValue, selectedValue1, selectedValue2]);
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
            //
          ],
        ),
      ),
    );
  }
}
