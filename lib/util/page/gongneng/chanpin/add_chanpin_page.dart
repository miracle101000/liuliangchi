import 'package:flutter/material.dart';

import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/http.dart';

import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/wrapImg_widget.dart';

import '../../../config/common_config.dart';
import '../../../paxis_fun.dart';
import '../../../provider/provider_config.dart';
import '../../../view/views.dart';
import '../../../view/xiansuo_view.dart';

///添加产品
class AddChanpinPage extends StatefulWidget {
  final Map data;
  const AddChanpinPage({Key? key, this.data = const {}}) : super(key: key);
  @override
  _AddChanpinPageState createState() => _AddChanpinPageState();
}

class _AddChanpinPageState extends State<AddChanpinPage> {
  var nameCtrl = TextEditingController(); // 产品名称控制器
  var numberCtrl = TextEditingController(); // 产品编号控制器
  var priceCtrl = TextEditingController(); // 标准单价控制器
  var unitCtrl = TextEditingController(); // 销售单位控制器
  var costCtrl = TextEditingController(); // 单位成本控制器
  var specCtrl = TextEditingController(); // 规格控制器
  var introCtrl = TextEditingController(); // 产品介绍控制器
  var chanpinType; //产品类型
  List<String> chanpinImages = []; //产品图片

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    if (widget.data.isNotEmpty) {
      if (isNotNull(widget.data['image']))
        chanpinImages = '${widget.data['image']}'.split(',');
      if (isNotNull(widget.data['productName']))
        nameCtrl.text = '${widget.data['productName']}';
      if (isNotNull(widget.data['productCode']))
        numberCtrl.text = '${widget.data['productCode']}';
      if (isNotNull(widget.data['price']))
        priceCtrl.text = '${widget.data['price']}';
      if (isNotNull(widget.data['unit']))
        unitCtrl.text = '${widget.data['unit']}';
      if (isNotNull(widget.data['unitCost']))
        costCtrl.text = '${widget.data['unitCost']}';
      if (isNotNull(widget.data['grossProfitRate']))
        specCtrl.text = '${widget.data['grossProfitRate']}';
      if (isNotNull(widget.data['description']))
        introCtrl.text = '${widget.data['description']}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: widget.data.isEmpty ? '新增产品' : '编辑产品'),
      btnBar: btnView('保存', isAnima: false, redius: 0, fun: () {
        if (nameCtrl.text.isEmpty) return showCustomToast('产品名称不能为空');
        if (numberCtrl.text.isEmpty) return showCustomToast('产品编号不能为空');
        if (priceCtrl.text.isEmpty) return showCustomToast('标准单价不能为空');
        if (unitCtrl.text.isEmpty) return showCustomToast('销售单位不能为空');
        if (costCtrl.text.isEmpty) return showCustomToast('单位成本不能为空');
        Request.post(
          widget.data.isEmpty
              ? '/app/product/addProduct'
              : '/app/product/editProduct',
          data: {
            if (widget.data.isNotEmpty) 'id': widget.data['id'],
            'qj_companyId': userPro.qj_companyId,
            'qj_userId': userPro.qj_userId,
            "productName": nameCtrl.text,
            "productCode": numberCtrl.text,
            "price": priceCtrl.text,
            "unit": unitCtrl.text,
            "unitCost": costCtrl.text,
            "grossProfitRate": specCtrl.text,
            "image": chanpinImages.join(','),
            "description": introCtrl.text,
            "isRenew": 0,
            "remark": "",
          },
          isLoading: true,
          catchError: (v) => showCustomToast(v),
          success: (v) {
            close(true);
            showCustomToast('添加成功');
          },
        );
      }),
      body: MyListView(
        isShuaxin: false,
        flag: false,
        item: (i) => item[i],
        itemCount: item.length,
        divider: Divider(height: 1, color: Colors.transparent),
      ),
    );
  }

  List<Widget> get item {
    return [
      itemView("产品名称",
          hint: '请输入',
          isInput: true,
          inputCon: nameCtrl,
          isSelect: false,
          isRequired: true),
      itemView("产品编号",
          hint: '请输入',
          isInput: true,
          inputCon: numberCtrl,
          isSelect: false,
          isRequired: true),
      itemView("标准单价",
          hint: '请输入',
          isInput: true,
          inputCon: priceCtrl,
          isSelect: false,
          isRequired: true),
      itemView("销售单位",
          hint: '请输入',
          isInput: true,
          inputCon: unitCtrl,
          isSelect: false,
          isRequired: true),
      itemView("单位成本",
          hint: '请输入',
          isInput: true,
          inputCon: costCtrl,
          isSelect: false,
          isRequired: true),
      itemView("毛利率（%）",
          hint: '请输入', isInput: true, inputCon: specCtrl, isSelect: false),
      // itemView("产品分类", isInput: false, selectValue: chanpinType, isSelect: true, callback: () {
      //   showSheet(
      //     builder: (_) => ShaixuanPopup(
      //       valueList: [''],
      //     ),
      //   );
      // }),
      PWidget.container(
        PWidget.column([
          PWidget.text('产品图片', [aColor.withOpacity(0.5), 12]),
          PWidget.boxh(8),
          WrapImgWidget(
            imgs: chanpinImages,
            remove: 48,
            w: 100,
            maxCount: 8,
            count: 4,
            callback: (v) => setState(() => chanpinImages = v),
            uploadTips: '图片(${chanpinImages.length}/9)',
            radius: 4,
            isUpload: true,
          ),
        ]),
        [null, null, Colors.white],
        {'pd': PFun.lg(16, 16, 24, 24)},
      ),
      itemView("产品介绍",
          hint: '请输入', isInput: true, inputCon: introCtrl, isSelect: false),
    ];
  }
}
