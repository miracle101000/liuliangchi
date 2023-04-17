import 'package:flutter/material.dart';

import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

import '../../../provider/provider_config.dart';
import '../../../view/views.dart';
import '../../../view/xiansuo_view.dart';
import '../chanpin/chanpin_page.dart';
import '../kehu/kehu_page.dart';

class AddHetongPage extends StatefulWidget {
  @override
  _AddHetongPageState createState() => _AddHetongPageState();
}

class _AddHetongPageState extends State<AddHetongPage> {
  var titleCtrl = TextEditingController(); //合同标题
  var htZongJinECtrl = TextEditingController(); //合同总金额
  var remarksCtrl = TextEditingController(); //备注
  var kehu, shangji, chanpin; //对应客户，商机，产品
  var qianyueDate, startDate, endDate; //签约日期，开始日期，结束日期
  // 合同状态
  var selectContractStatus = []; //选择的合同状态
  Map<int, String> contractStatusMap = {
    1: '未开始',
    2: '执行中',
    3: '成功结束',
    4: '意外终止'
  };
  // 合同类型
  var selectContractType = []; //选择的合同类型
  Map<int, String> contractTypeMap = {
    1: '直销合同',
    2: '代理合同',
    3: '采购合同',
    4: '服务合同',
    5: '其他'
  };

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: '新增合同'),
      btnBar: btnBarView(),
      body: MyListView(
        isShuaxin: false,
        flag: false,
        item: (i) => item[i],
        itemCount: item.length,
        divider: Divider(height: 0),
      ),
    );
  }

  ///保存
  Widget btnBarView() {
    return btnView('保存', isAnima: false, redius: 0, fun: () {
      if (titleCtrl.text.isEmpty) return showCustomToast('合同标题未填写');
      if (kehu == null) return showCustomToast('未选择对应客户');
      if (shangji == null) return showCustomToast('未选择对应商机');
      if (htZongJinECtrl.text.isEmpty) return showCustomToast('合同总金额未填写');
      if (qianyueDate == null) return showCustomToast('未选择签约日期');
      Request.post(
        '/app/contract/getContractList',
        data: {
          "qj_companyId": userPro.qj_companyId,
          "qj_userId": userPro.qj_userId,
          ...{
            "companyId": "客户公司 ID",
            "clueId": "线索 ID",
            "clueName": "线索名称",
            "customerId": "客户 ID",
            "customerName": "客户名称",
            "opportunityId": "商机 ID",
            "opportunityName": "商机名称",
            "collaborativePeople": "协作人",
            "collaborativePeopleUserId": "协作人用户 ID",
            "head": "负责人",
            "headUserId": "负责人 ID",
            "beforeHead": "前负责人",
            "beforeHeadUserId": "前负责人 ID",
            "departmentId": "部门 ID",
            "departmentName": "部门名称",
            "beforeDepartmentId": "前部门 ID",
            "beforeDepartmentName": "前部门名称",
            "title": "合同标题",
            "product": "关联产品",
            "productId": "关联产品 ID",
            "contractPrice": "合同金额",
            "signDate": "签约日期",
            "startDate": "合同开始时间",
            "endDate": "合同结束时间",
            "contractStatus": "合同状态(1:未开始 2：执行中 3：成功结束 4：意外终止 )",
            "contractType": "合同类型(1:直销合同 2：代理合同 3：采购合同 4：服务合同 5：其他 )",
            "customerSignUser": "客户方签约人",
            "mySignUser": "我方签约人",
            "attachmentList": "附件",
            "nextTrackDate": "下次跟进时间",
            "remindDate": "提前到期提醒时间",
            "remark": "备注",
            "operateUserId": "操作者 ID",
            "operateRealName": "操作者",
          }
        },
        catchError: (v) => showCustomToast(v),
        success: (v) {},
      );
    });
  }

  List<Widget> get item {
    return [
      itemView('合同标题',
          hint: '请输入',
          isInput: true,
          isSelect: false,
          isRequired: true,
          inputCon: titleCtrl),
      itemView('对应客户',
          isInput: false,
          isSelect: true,
          isRequired: true,
          hint: '请选择',
          selectValue: kehu == null ? null : kehu[''], callback: () {
        jumpPage(KehuPage(isSelect: true), callback: (v) {
          if (v != null) flog(v, '对应客户');
        });
      }),
      itemView('对应商机',
          isInput: false,
          isSelect: true,
          isRequired: true,
          hint: '请选择',
          selectValue: shangji == null ? null : shangji[''], callback: () {
        jumpPage(KehuPage(isSelect: true), callback: (v) {
          if (v != null) ;
        });
      }),
      itemView('合同总金额',
          isInput: true,
          isSelect: false,
          isRequired: true,
          hint: '请输入',
          inputCon: htZongJinECtrl),
      itemTimeView('签约日期', qianyueDate,
          callback: (v) => setState(() => qianyueDate = v)),
      itemTimeView('合同开始日期', startDate,
          callback: (v) => setState(() => startDate = v), isRequired: false),
      itemTimeView('合同结束日期', endDate,
          callback: (v) => setState(() => endDate = v), isRequired: false),
      itemView('备注',
          hint: '请输入', isInput: true, isSelect: false, inputCon: remarksCtrl),
      itemView('关联产品',
          isInput: false,
          isSelect: true,
          hint: '请选择',
          selectValue: chanpin == null ? null : chanpin[''], callback: () {
        jumpPage(ChanpinPage(isSelect: true), callback: (v) {
          if (v != null) flog(v);
        });
      }),
      itemTypeView(
          '合同状态', selectContractStatus, contractStatusMap.values.toList(),
          isRequired: false, callback: (v) {
        setState(() => selectContractStatus = v);
      }),
    ];
  }
}
