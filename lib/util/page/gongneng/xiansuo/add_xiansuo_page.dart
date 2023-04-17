import 'package:flutter/material.dart';
import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:liuliangchi/util/view/xiansuo_view.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import '../../../config/common_config.dart';
import '../../../paxis_fun.dart';
import '../../../view/views.dart';

class AddXianSuoPage extends StatefulWidget {
  @override
  _AddXianSuoPageState createState() => _AddXianSuoPageState();
}

class _AddXianSuoPageState extends State<AddXianSuoPage> {
  ///跟进类型选择的list
  var genjinTypeSelectoList = ['电话', 'QQ', '微信', '拜访', '邮件', '短信', '其他'];
  var genjinStateSelectoList = ['初访', '意向', '报价', '成交', '暂时搁置'];
  var genjinType = [];
  var genjinState = [];
  var shiJiGenJinShiJian;
  var xiaCiGenJinShiJian;
  var genjinTextCon = TextEditingController();
  var guanlianRen;

  var nameController = TextEditingController();
  var companyController = TextEditingController();
  var departmentController = TextEditingController();
  var positionController = TextEditingController();
  var phoneController = TextEditingController();
  var mobileController = TextEditingController();
  var wechatController = TextEditingController();
  var qqController = TextEditingController();
  var wangwangController = TextEditingController();
  var emailController = TextEditingController();
  var websiteController = TextEditingController();
  var areaController = TextEditingController();
  var addressController = TextEditingController();
  var zipCodeController = TextEditingController();
  var followUpStatusController = TextEditingController();
  var leadSourceController = TextEditingController();
  var nextFollowUpTimeController = TextEditingController();
  var remarkController = TextEditingController();
  var responsiblePersonController = TextEditingController();
  var departmentBelongingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: '新增线索', isWhiteBg: true),
      resizeToAvoidBottomInset: false,
      bgColor: Colors.white,
      btnBar: btnbarView(),
      body: MyListView(
        isShuaxin: false,
        flag: false,
        padding: EdgeInsets.symmetric(vertical: 8),
        item: (i) => item[i],
        itemCount: item.length,
        touchBottomAnimationValue: 0.5,
        touchBottomAnimationOpacity: 50,
        divider: Divider(height: 0),
      ),
    );
  }

  Widget btnbarView() {
    return Builder(builder: (context) {
      var bottom = MediaQuery.of(context).viewInsets.bottom;
      var view = PWidget.row([
        PWidget.container(
          PWidget.text('保存', [Colors.white, 16]),
          [bottom > 0 ? 56 : pmSize.width, 56, pColor],
          {
            'sd': PFun.sdLg(
                Colors.black.withOpacity(bottom > 0 ? 0.24 : 0), 8, 0, 6, -4),
            'br': bottom > 0 ? 56 : 0,
            'ali': PFun.lg2(0, 0),
            'fun': () {
              if (nameController.text.isEmpty) return showCustomToast('请输入名称');
              //保存线索
              Request.post(
                '/api/Building/Subscribe',
                data: {},
                catchError: (v) => showCustomToast(v),
                success: (v) {},
              );
            },
          },
        ),
      ], '111');
      return PWidget.container(view, {
        'mg': PFun.lg(0, bottom > 0 ? bottom + 16 : 0, 0, bottom > 0 ? 16 : 0)
      });
    });
  }

  List<Widget> get item {
    return [
      itemView("姓名",
          isInput: true,
          isSelect: false,
          isRequired: true,
          textInputView:
              buildTFView(context, hintText: '请输入', con: nameController)),
      itemView("公司名称",
          isInput: true,
          isSelect: false,
          textInputView:
              buildTFView(context, hintText: '请输入', con: companyController)),
      itemView("部门",
          isInput: true,
          isSelect: false,
          textInputView:
              buildTFView(context, hintText: '请输入', con: departmentController)),
      itemView("职务",
          isInput: true,
          isSelect: false,
          textInputView:
              buildTFView(context, hintText: '请输入', con: positionController)),
      itemView("电话",
          isInput: true,
          isSelect: false,
          textInputView:
              buildTFView(context, hintText: '请输入', con: phoneController)),
      itemView("手机",
          isInput: true,
          isSelect: false,
          textInputView:
              buildTFView(context, hintText: '请输入', con: mobileController)),
      itemView("微信号",
          isInput: true,
          isSelect: false,
          textInputView:
              buildTFView(context, hintText: '请输入', con: wechatController)),
      itemView("QQ号",
          isInput: true,
          isSelect: false,
          textInputView:
              buildTFView(context, hintText: '请输入', con: qqController)),
      itemView("旺旺号",
          isInput: true,
          isSelect: false,
          textInputView:
              buildTFView(context, hintText: '请输入', con: wangwangController)),
      itemView("邮箱",
          isInput: true,
          isSelect: false,
          textInputView:
              buildTFView(context, hintText: '请输入', con: emailController)),
      itemView("网址",
          isInput: true,
          isSelect: false,
          textInputView:
              buildTFView(context, hintText: '请输入', con: websiteController)),
      itemView("地区",
          isInput: true,
          isSelect: false,
          isRequired: true,
          textInputView:
              buildTFView(context, hintText: '请输入', con: areaController)),
      itemView("地址",
          isInput: true,
          isSelect: false,
          isRequired: true,
          textInputView:
              buildTFView(context, hintText: '请输入', con: addressController)),
      itemView("邮编",
          isInput: true,
          isSelect: false,
          isRequired: true,
          textInputView:
              buildTFView(context, hintText: '请输入', con: zipCodeController)),
      itemView("跟进状态",
          isInput: true,
          isSelect: false,
          isRequired: true,
          textInputView: buildTFView(context,
              hintText: '请输入', con: followUpStatusController)),
      itemView("线索来源",
          isInput: true,
          isSelect: false,
          isRequired: true,
          textInputView:
              buildTFView(context, hintText: '请输入', con: leadSourceController)),
      itemView("下次跟进时间",
          isInput: true,
          isSelect: false,
          isRequired: true,
          textInputView: buildTFView(context,
              hintText: '请输入', con: nextFollowUpTimeController)),
      itemView("备注",
          isInput: true,
          isSelect: false,
          isRequired: true,
          textInputView:
              buildTFView(context, hintText: '请输入', con: remarkController)),
      itemView("负责人",
          isInput: true,
          isSelect: false,
          isRequired: true,
          textInputView: buildTFView(context,
              hintText: '请输入', con: responsiblePersonController)),
      itemView("所属部门",
          isInput: true,
          isSelect: false,
          isRequired: true,
          textInputView: buildTFView(context,
              hintText: '请输入', con: departmentBelongingController)),
    ];
  }
}
