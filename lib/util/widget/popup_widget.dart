import 'dart:async';
import 'dart:math' as m;
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:liuliangchi/util/paxis_fun.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/image.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/tween_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:provider/provider.dart';

import '../config/common_config.dart';
import '../provider/lianghua_provider.dart';
import '../provider/provider_config.dart';
import '../view/views.dart';

///佣金列表
var duihuanYongjinList = ['50', '100', '150', '200', '500', '1000'];

class PopupWidget extends StatefulWidget {
  final ScrollController? controller;
  final Map? data;
  final void Function(int)? onFun;
  const PopupWidget({Key? key, this.data, this.controller, this.onFun})
      : super(key: key);
  @override
  _PopupWidgetState createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> with WidgetsBindingObserver {
  Map data = {};

  var jianjuIndex = 0;

  ///智能解套
  var zhinengjietao = 1;
  var zhiyingzhisun = 0;

  var payPass = [];

  var duihuanYongjinIndex;

  ///键盘是否弹出
  double bottom = 0.0;

  TextEditingController textConChufayaoqiu1 = TextEditingController();
  TextEditingController textConChufayaoqiu2 = TextEditingController();
  TextEditingController textConChufayaoqiu3 = TextEditingController();

  ///兑换佣金
  TextEditingController duihuanYongjinTextCon = TextEditingController();

  ///加仓方式文本输入框控制器
  var jiacangFangshiTextConList = <List<TextEditingController>>[];

  ///即时止盈文本输入框控制器
  var jishiZhiyingTextConList = <List>[];

  ///平仓设置文本输入框控制器
  var pingcangShezhiTextConList = <List<TextEditingController>>[];

  ///止盈止损文本输入框控制器
  var zhiyingzhisunTextConList = <TextEditingController>[];

  ///提币
  TextEditingController tibiTextCon1 = TextEditingController();
  TextEditingController tibiTextCon2 = TextEditingController();
  TextEditingController tibiTextCon3 = TextEditingController();
  TextEditingController tibiTextCon4 = TextEditingController();

  ///即时止盈文本输入框控制器
  // var jishiZhiyingTextCon1 = TextEditingController(text: '3');
  // var jishiZhiyingTextCon2 = TextEditingController(text: '0.5');
  // var jishiZhiyingTextCon3 = TextEditingController(text: '6');
  // var jishiZhiyingTextCon4 = TextEditingController(text: '0.8');
  // ///即时止盈文本输入框控制器
  var jishiZhiyingTextCon1 = TextEditingController(text: '7');
  var jishiZhiyingTextCon2 = TextEditingController(text: '0.9');
  var jishiZhiyingTextCon3 = TextEditingController(text: '4');
  var jishiZhiyingTextCon4 = TextEditingController(text: '0.7');
  // ///即时止盈文本输入框控制器
  // var jishiZhiyingTextCon1 = TextEditingController(text: '3');
  // var jishiZhiyingTextCon2 = TextEditingController(text: '0.5');
  // var jishiZhiyingTextCon3 = TextEditingController(text: '0');
  // var jishiZhiyingTextCon4 = TextEditingController(text: '0');
  // ///即时止盈文本输入框控制器
  // var jishiZhiyingTextCon1 = TextEditingController(text: '0');
  // var jishiZhiyingTextCon2 = TextEditingController(text: '0');
  // var jishiZhiyingTextCon3 = TextEditingController(text: '5');
  // var jishiZhiyingTextCon4 = TextEditingController(text: '0.7');

  ///钱包
  Map qbao = {};

  ///是否显示警告:0不显示、1超出、2小于
  int isShowWarning = 0;

  ///提币验证码是否已发送
  bool isTbSendCode = false;

  bool isSend = false;

  @override
  void initState() {
    initData();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  Timer? timer;

  ///防抖
  void debounce(
    Function func, [
    Duration delay = const Duration(milliseconds: 1000),
  ]) {
    timer!.cancel();
    timer = Timer(delay, () => func());
  }

  ///获取期望使用
  var expectUsedDm = DataModel<Map>(object: {});
  Future<int> expectUsed(
      {int page = 1, bool isRef = false, bool isLoading = false}) async {
    var listJson = [];
    var textCon = jiacangFangshiTextConList;
    for (var i = 0; i < textCon.length; i++) {
      var v1 = textCon[i].first.text;
      var v2 = textCon[i].last.text;
      listJson.add({
        "addMode": jianjuIndex + 1,
        "difference": Decimal.parse((double.parse(v2.isEmpty ? '0.0' : v2) /
                    (jianjuIndex == 1 ? 100 : 1))
                .toString())
            .toString(),
        "multiple": v1.isEmpty ? data['sdCount'] : v1,
        "times": i + 1,
      });
    }
    await Request.post(
      '/maxmoneycloud-quantstrategy/userStrategy/expectUsed',
      data: {
        "userAccountId": data['value1']['accountId'],
        "currency": data['value1']['currency'], // "CRV-USDT",
        "contract": data['value1']['contract'], // "SWAP",
        "accountType": data['isHeyue'] ? 0 : 1,
        "firstQuantity": data['sdCount'],
        "leverage": data['leverage'],
        "addRuleList": listJson,
      },
      isLoading: isLoading,
      catchError: (v) => expectUsedDm.toError(v),
      success: (v) {
        expectUsedDm.object = v['data'];
        expectUsedDm.setTime();
        if (v['data']['errorMsg'] != '' && v['data']['errorMsg'] != null)
          showToast(v['data']['errorMsg']);
      },
    );
    setState(() {});
    return expectUsedDm.flag!;
  }

  List? jcFangshi;
  List? jsZhiying;

  ///是否是合约
  bool isHeyue = true;

  FocusNode focusNode = FocusNode();

  ///初始化函数
  Future initData() async {
    qbao = shouyi.qianbaoDm.object!;
    data = widget.data!;
    isHeyue = data['isHeyue'];
    jcFangshi = (data['jcFangshi'] ?? []) as List;
    jsZhiying = (data['instanTakeProfitList'] ?? []) as List;
    flog(jsZhiying, '即时止盈');
    var pcShezhi = (data['pcShezhi'] ?? []) as List;

    ///加仓方式动态取值
    if (jcFangshi!.isNotEmpty) {
      jianjuIndex = jcFangshi![0]['addMode'] - 1;
      jiacangFangshiTextConList = List.generate(data['jcCount'] ?? 0, (i) {
        if (i < jcFangshi!.length) {
          var fangshi = jcFangshi![i] ?? {};
          var difference = double.parse('${fangshi['difference']}');
          flog(difference * 1, 'difference1');
          flog(difference * 100, 'difference100');
          var d = difference * ([1, 100][jianjuIndex]);
          return [
            TextEditingController(text: '${fangshi['multiple']}'),
            // TextEditingController(text: '${double.parse((fangshi['difference'] * ([1, 100][jianjuIndex])).toString())}'),
            TextEditingController(
                text:
                    '${Decimal.parse(jianjuIndex == 1 ? d.toStringAsFixed(2) : d.toString())}'),
            // TextEditingController(text: '123'),
          ];
        } else {
          return [TextEditingController(), TextEditingController()];
        }
      });
    } else {
      jiacangFangshiTextConList = List.generate(data['jcCount'] ?? 0, (i) {
        return [TextEditingController(), TextEditingController()];
      });
    }

    ///即时止盈动态取值
    if (jsZhiying!.isNotEmpty) {
      // jianjuIndex = 1;
      jishiZhiyingTextConList = List.generate(data['jcCount'] ?? 0, (i) {
        var fangshi = jsZhiying![i] ?? {};
        var difference = double.parse('${fangshi['stopPercent']}');
        flog(difference * 1, 'difference1');
        flog(difference * 100, 'difference100');
        var d = difference * ([1, 100][1]);
        return [
          fangshi['inTimeTp'],
          fangshi['reAdd'],
          // TextEditingController(text: '${double.parse((fangshi['difference'] * ([1, 100][jianjuIndex])).toString())}'),
          TextEditingController(
              text:
                  '${Decimal.parse(1 == 1 ? d.toStringAsFixed(2) : d.toString())}'),
          // TextEditingController(text: '123'),
        ];
      });
    } else {
      jishiZhiyingTextConList = List.generate(data['jcCount'] ?? 0, (i) {
        return [false, false, TextEditingController()];
      });
    }

    ///平仓设置动态取值
    if (pcShezhi.isNotEmpty) {
      pingcangShezhiTextConList =
          List.generate((data['jcCount'] ?? 0) + 1, (i) {
        if (i < pcShezhi.length) {
          var shezhi = pcShezhi[i];
          flog(shezhi);
          return [
            TextEditingController(
                text:
                    '${double.parse(((shezhi['stopPercent'] ?? 0) * 100).toString()).toStringAsFixed(2)}'),
            TextEditingController(
                text:
                    '${double.parse(((shezhi['stopLossPercent'] ?? 0) * 100).toString()).toStringAsFixed(2)}'),
          ];
        } else {
          return [
            TextEditingController(text: '0.5'),
            TextEditingController(),
          ];
        }
      });
    } else {
      pingcangShezhiTextConList =
          List.generate((data['jcCount'] ?? 0) + 1, (i) {
        return [TextEditingController(text: '0.5'), TextEditingController()];
      });
    }
    var zyzs = (data['zyzs'] ?? []) as List;
    zhiyingzhisunTextConList = List.generate(zyzs.length, (i) {
      var v = zyzs[i];
      if (i > 1 && v != '') v = (double.parse(v) * 100).toStringAsFixed(2);
      return TextEditingController(text: '$v');
    });

    textConChufayaoqiu1.text = '${data['buyLimit'] ?? ''}';
    textConChufayaoqiu2.text = '${data['sellLimit'] ?? ''}';

    zhinengjietao = data['smartSolution'] == 0 ? 1 : 0;
    if (data['title'] == '加仓方式') this.expectUsed(isRef: true);
    lhPro.changeStartLianghuaFlag(0);
    await Future.delayed(Duration(milliseconds: 500));
    focusNode.requestFocus();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() => bottom = MediaQuery.of(context).viewInsets.bottom);
      await Future.delayed(Duration(milliseconds: 200));
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var view;
    switch (data['title']) {
      case '触发要求':
        view = buildChufaYaoqiuView();
        break;
      case '加仓方式':
        view = buildJiaCangFangShiView();
        break;
      case '平仓设置':
        view = buildPingCangSetupView(isJishiZY: false);
        break;
      case '即时止盈':
        view = buildJiShiZYView();
        break;
      case '购买策略':
        view = buildPurchaseStrategyView();
        break;
      case '支付':
        view = buildPayView();
        break;
      case '兑换佣金':
        view = buildCommissionExchangeView();
        break;
      case '提币':
        view = buildWithdrawMoneyView();
        break;
      case '转账':
        view = buildTransferAccountsView();
        break;
      case '分享海报':
        view = buildPosterView();
        break;
      case '执行量化方案':
        view = buildPerformQuantificationView();
        break;
      case '智能解套':
        view = buildIntelligentUnravelingView();
        break;
      default:
        view = buildZhiYingZhiSunView();
        break;
    }
    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: 0),
      duration: Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      child: PWidget.container(
        data['title'] == '提币'
            ? Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                    Positioned(
                      top: -25 - 18.0,
                      child: TweenWidget(
                        child: PWidget.image('assets/img/cbicon.png', [50, 50]),
                        delayed: 300,
                        time: 750,
                        curve: ElasticOutCurve(1),
                        isScale: true,
                        value: 1,
                        // key: ValueKey(Random.secure()),
                      ),
                    ),
                    view,
                  ])
            : view,
        [
          null,
          null,
          if (data['title'] != '支付' && data['title'] != '分享海报')
            Color(0xFF484848)
        ],
        {
          'br': PFun.lg(5, 5),
          if (data['title'] != '分享海报') 'pd': PFun.lg(18, 24, 24, 24),
        },
      ),
    );
  }

  ///智能解套
  Widget buildIntelligentUnravelingView() {
    var item = [
      PWidget.text(data['title'], [aColor, 16], {'ct': true}),
      PWidget.boxh(16),
      PWidget.column([
        PWidget.text(
          '1.如选中智能解套，最后一轮加仓成交后，将自动触发\n2.智能解套将按照特定算法持续交易，直到全部平仓\n3.当行情反向大幅度波动时，智能解套可能会导致亏损\n4.交易有风险，请审慎选择',
          [Color(0xffECECEC), 12],
          {'ct': true, 'h': 1.75},
        ),
        PWidget.boxh(4),
      ], '020'.split('')),
      PWidget.boxh(16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RadioWidget(
            value: ['确认选择智能解套并自愿接受可能导致的全部亏损'],
            index: zhinengjietao,
            tColor: Colors.white70,
            key: ValueKey(m.Random.secure()),
            fun: (i) =>
                setState(() => zhinengjietao = zhinengjietao == i ? 1 : i),
          ),
        ],
      ),
      PWidget.container(
        PWidget.row([
          PWidget.container(
            PWidget.text("取消", [aColor.withOpacity(0.5), 15], {'ct': true}),
            [null, null, Color(0xFF787878).withOpacity(0.3)],
            {'exp': true, 'pd': PFun.lg(10, 10), 'br': 5, 'fun': () => close()},
          ),
          PWidget.boxw(12),
          PWidget.container(
            PWidget.text("确认", [aColor, 15], {'ct': true}),
            [null, null, Color(0xffC78904)],
            {
              'exp': true,
              'pd': PFun.lg(10, 10),
              'br': 5,
              'fun': () => close(zhinengjietao)
            },
          )
        ]),
        {'mg': PFun.lg(24)},
      ),
    ];
    return MyListView(
      isShuaxin: false,
      itemCount: item.length,
      animationType: AnimationType.vertical,
      animationTime: 250,
      animationDelayed: 0,
      item: (i) => item[i],
    );
  }

  ///海报
  Widget buildPosterView() {
    var item = [
      Padding(
        padding: EdgeInsets.only(left: 38, right: 38),
        child: Image.asset('assets/img/海报-中@2x.png'),
      ),
      PWidget.boxh(8),
      PWidget.boxh(10),
      PWidget.boxh(10),
      PWidget.boxh(10),
      PWidget.container(
        PWidget.column([
          PWidget.container(
            PWidget.ccolumn([
              PWidget.image('assets/img/保存到相册@2x.png', [32, 32]),
              PWidget.boxh(12),
              PWidget.text('保存到相册', [aColor, 13], {'ct': true}),
            ], '220'.split('')),
            {'mg': PFun.lg(18, 8), 'fun': () {}},
          ),
          Divider(color: aColor, height: 26),
          PWidget.text('取消', [aColor, 17],
              {'pd': PFun.lg(6, 16), 'ct': true, 'fun': () => close()}),
        ]),
        [null, null, Color(0xFF484848)],
        {'br': PFun.lg(5, 5)},
      ),
    ];
    return MyListView(
      isShuaxin: false,
      itemCount: item.length,
      animationType: AnimationType.vertical,
      animationTime: 250,
      physics: ClampingScrollPhysics(),
      animationDelayed: 0,
      item: (i) => item[i],
    );
  }

  ///执行量化方案
  Widget buildPerformQuantificationView() {
    // ignore: unused_element
    Widget tfView(title, hint, text,
        {TextEditingController? con, List? mg, Color? tColor}) {
      return PWidget.container(
        PWidget.row([
          PWidget.text(
              title ?? '对方昵称', [aColor, 13], {'pd': PFun.lg(0, 0, 0, 12)}),
          PWidget.container(
            PWidget.row([
              buildTFView(
                context,
                hintText: hint ?? '盈利',
                hintColor: aColor.withOpacity(0.25),
                textColor: aColor,
                isExp: true,
              ),
              PWidget.row([
                PWidget.text(text ?? '1,234.5678USDT', [tColor ?? aColor, 12]),
                if (text == '选择地址')
                  PWidget.image('assets/img/sanjiao.png', [12, 9],
                      {'pd': PFun.lg(0, 0, 4, 2)}),
              ], {
                'fun': () {
                  switch (text) {
                    case '选择地址':
                      showToast('1');
                      break;
                    case '忘记密码？':
                      showToast('2');
                      break;
                    case '获取验证码':
                      showToast('3');
                      break;
                  }
                }
              }),
            ]),
            [null, 43, Colors.black26],
            {'exp': true, 'br': 8, 'pd': PFun.lg(0, 0, 12, 12)},
          ),
        ]),
        {'mg': mg ?? PFun.lg(8, 8)},
      );
    }

    var item = [
      PWidget.text(data['title'], [aColor, 16], {'ct': true}),
      PWidget.text(
        '''您的量化方案，执行后，将自动、高频交易！请确保账户权益充足，各项参数合理，尽量避免人为干预！
交易需审慎！点击执行，代表您全面知悉并自愿承担量化交易过程中可能发生的止损、强平等全部风险！
''',
        [aColor.withOpacity(0.7), 12],
        {'pd': PFun.lg(12, 16), 'isOf': false},
      ),
      PWidget.row([
        CustomButton(
          title: '返回',
          tColor: aColor.withOpacity(0.5),
          bgColor: Colors.white10,
          mg: PFun.lg(16),
          pd: PFun.lg(8, 8),
          fun: () => close(1),
        ),
        if ((data['value'] == 0 || data['value'] == 2) && data['isHeyue'])
          PWidget.boxw(24),
        if ((data['value'] == 0 || data['value'] == 2) && data['isHeyue'])
          Selector<LianghuaPro, int>(
            selector: (_, k) => k.startLianghuaFlags.length,
            builder: (_, v, view) {
              var flags = lhPro.startLianghuaFlags;
              return CustomButton(
                title: '买多',
                tColor: aColor.withOpacity(flags.contains(2) ? 0.1 : 1),
                bgColor: flags.contains(2) ? Colors.black12 : Color(0xFF47A020),
                mg: PFun.lg(16),
                pd: PFun.lg(8, 8),
                fun: flags.contains(2)
                    ? () {}
                    : () {
                        if (data['value'] == 2) {
                          widget.onFun!(2);
                        } else {
                          close(2);
                        }
                      },
              );
            },
          ),
        if ((data['value'] == 1 || data['value'] == 2) && data['isHeyue'])
          PWidget.boxw(24),
        if ((data['value'] == 1 || data['value'] == 2) && data['isHeyue'])
          Selector<LianghuaPro, int>(
            selector: (_, k) => k.startLianghuaFlags.length,
            builder: (_, v, view) {
              var flags = lhPro.startLianghuaFlags;
              return CustomButton(
                title: '卖空',
                tColor: aColor.withOpacity(flags.contains(3) ? 0.1 : 1),
                bgColor: flags.contains(3) ? Colors.black12 : Color(0xFFFF3B2F),
                mg: PFun.lg(16),
                pd: PFun.lg(8, 8),
                fun: flags.contains(3)
                    ? () {}
                    : () {
                        if (data['value'] == 2) {
                          widget.onFun!(3);
                        } else {
                          close(3);
                        }
                      },
              );
            },
          ),
        if (!data['isHeyue']) PWidget.boxw(24),
        if (!data['isHeyue'])
          CustomButton(
            title: '买入',
            tColor: aColor,
            bgColor: pColor,
            mg: PFun.lg(16),
            pd: PFun.lg(8, 8),
            fun: () => close(4),
          ),
      ]),
    ];
    return MyListView(
      isShuaxin: false,
      itemCount: item.length,
      animationType: AnimationType.vertical,
      animationTime: 250,
      physics: ClampingScrollPhysics(),
      animationDelayed: 0,
      item: (i) => item[i],
    );
  }

  ///转账
  Widget buildTransferAccountsView() {
    Widget tfView(
      title,
      hint,
      text, {
      bool isDouble = false,
      TextEditingController? con,
      List? mg,
      Color? tColor,
      bool isSend = false,
      Function? fun,
    }) {
      return PWidget.container(
        PWidget.row([
          PWidget.text(
              title ?? '对方昵称', [aColor, 13], {'pd': PFun.lg(0, 0, 0, 12)}),
          PWidget.container(
            PWidget.row([
              buildTFView(
                context,
                con: con!,
                isDouble: isDouble,
                maxLength: '$hint'.contains('资产密码') ? 6 : null,
                hintText: hint ?? '盈利',
                obscureText: '$hint'.contains('资产密码') ? !isSend : false,
                hintColor: aColor.withOpacity(0.25),
                textColor: aColor,
                isExp: true,
              ),
              if ('$hint'.contains('资产密码'))
                PWidget.image(
                  'assets/img/隐藏@2x.png',
                  [15, 8, aColor.withOpacity(isSend ? 1 : 0.25)],
                  {'pd': 4, 'fun': fun},
                ),
              PWidget.row([
                PWidget.text(text ?? '1,234.5678USDT', [tColor ?? aColor, 12]),
                if (text == '选择地址')
                  PWidget.image('assets/img/sanjiao.png', [12, 9],
                      {'pd': PFun.lg(0, 0, 4, 2)}),
              ], {
                'fun': () {
                  switch (text) {
                    case '选择地址':
                      showToast('1');
                      break;
                    case '忘记密码？':
                      showToast('2');
                      break;
                    case '获取验证码':
                      if (isTbSendCode) return showCustomToast('验证码已发送!');
                      Request.get(
                        '/maxmoneycloud-users/verify-code',
                        isLoading: true,
                        isToken: false,
                        data: {
                          "mobile": user['mobile'],
                          "zoneCode": user['zoneCode'],
                        },
                        catchError: (v) => showToast(v),
                        success: (v) async {
                          showCustomToast('发送成功，请注意接收！');
                          setState(() => isTbSendCode = true);
                        },
                      );
                      break;
                    case '已发送':
                      showCustomToast('验证码已发送!');
                      break;
                  }
                }
              }),
            ]),
            [null, 43, Colors.black26],
            {'exp': true, 'br': 8, 'pd': PFun.lg(0, 0, 12, 12)},
          ),
        ]),
        {'mg': mg ?? PFun.lg(8, 8)},
      );
    }

    var item = [
      PWidget.text(data['title'], [aColor, 16], {'ct': true}),
      Divider(color: aColor, height: 26),
      tfView('对方手机号', '请输入对方手机号', '', con: tibiTextCon1),
      tfView('转账资产', '请输入转账资产', '', con: tibiTextCon2),
      tfView('资产密码', '请输入资产密码', '',
          con: tibiTextCon3,
          isSend: isSend,
          fun: () => setState(() => isSend = !isSend)),
      PWidget.text(
        '安全验证\t\t\t',
        [aColor, 13],
        {
          // 'exp': true,
          'pd': [12, 12],
          'ts': PFun.lg1<InlineSpan>(PWidget.textIs(
              '向手机号${toAsterisk(v: user['mobile'])}发送验证码',
              [Color(0xFFB7B7B7), 10]))
        },
      ),
      tfView('验证码', '请输入验证码', '获取验证码', tColor: pColor, con: tibiTextCon4),
      PWidget.text(
        '*请认真核对地址！如有错误，资产将无法找回！所有损失平台完全免责！',
        [aColor.withOpacity(0.5), 10],
        {'pd': PFun.lg(16, 8), 'isOf': false},
      ),
      PWidget.container(
        CustomButton(
          title: '确定',
          tColor: aColor,
          isExp: false,
          bgColor: Color(0xffC78904),
          fun: () {
            if (tibiTextCon1.text.isEmpty) return showCustomToast('请输入对方手机号');
            if (tibiTextCon1.text.length < 11)
              return showCustomToast('请输入正确的手机号');
            if (tibiTextCon2.text.isEmpty) return showCustomToast('请输入转账资产');
            // if (isShowWarning != 0) return showCustomToast({1: '提币数量不能超过钱包余额', 2: '提币数量不能小于10'}[isShowWarning]);
            if (tibiTextCon3.text.isEmpty) return showCustomToast('请输入资产密码');
            if (tibiTextCon3.text.length < 6)
              return showCustomToast('资产密码必须为6位');
            if (tibiTextCon4.text.isEmpty) return showCustomToast('请输入验证码');
            Request.post(
              '/maxmoneycloud-funds/api/wallet/withdraw',
              data: {
                "toaddress": tibiTextCon1.text, //转账到地址
                "quantity": tibiTextCon2.text, //转账数量
                "payPassword": tibiTextCon3.text, //支付密码
                "verificationCode": tibiTextCon4.text, //验证码
                "zoneCode": "86", //国际地区号
                "userId": user['id'], //用户id号
                "mobile": user['mobile'],
              },
              isLoading: true,
              catchError: (v) {
                setState(() => isTbSendCode = false);
                showCustomToast(v);
              },
              success: (v) {
                shouyi.userWallet();
                showCustomToast('转账成功');
                close(true);
              },
            );
          },
        ),
        {'mg': PFun.lg(16)},
      ),
    ];
    return MyListView(
      isShuaxin: false,
      itemCount: item.length,
      animationType: AnimationType.vertical,
      animationTime: 250,
      physics: ClampingScrollPhysics(),
      animationDelayed: 0,
      item: (i) => item[i],
    );
  }

  ///提币
  Widget buildWithdrawMoneyView() {
    Widget tfView(
      hint,
      text, {
      TextEditingController? con,
      List? mg,
      Color? tColor,
      Function(String)? onChanged,
      bool isDouble = false,
    }) {
      return PWidget.container(
        PWidget.row([
          buildTFView(
            context,
            hintText: hint ?? '盈利',
            con: con,
            isDouble: isDouble,
            maxLength: '$hint'.contains('资产密码') ? 6 : null,
            hintColor: aColor.withOpacity(0.25),
            textColor: aColor,
            isExp: true,
            onChanged: onChanged,
          ),
          PWidget.row([
            PWidget.boxw(8),
            PWidget.text((text ?? '1,234.5678USDT'), [tColor ?? aColor, 12]),
            if (text == '选择地址')
              PWidget.image('assets/img/sanjiao.png', [12, 9],
                  {'pd': PFun.lg(0, 0, 4, 2)}),
          ], {
            'fun': () {
              switch (text) {
                case '选择地址':
                  if (shouyi.qianbaoDm.object!['address'] == null) {
                    return showCustomToast('暂无地址可选择');
                  }
                  showSelecto(
                    context,
                    texts: [shouyi.qianbaoDm.object!['address']],
                    callback: (v, i) => tibiTextCon1.text = v,
                  );
                  break;
                case '忘记密码？':
                  showToast('2');
                  break;
                case '获取验证码':
                  if (isTbSendCode) return showCustomToast('验证码已发送!');
                  Request.get(
                    '/maxmoneycloud-users/verify-code',
                    isLoading: true,
                    isToken: false,
                    data: {
                      "mobile": user['mobile'],
                      "zoneCode": user['zoneCode'],
                    },
                    catchError: (v) => showToast(v),
                    success: (v) async {
                      showCustomToast('发送成功，请注意接收！');
                      setState(() => isTbSendCode = true);
                    },
                  );
                  break;
                case '已发送':
                  showCustomToast('验证码已发送!');
                  break;
              }
            }
          }),
        ]),
        [null, 43, Colors.black26],
        {
          'br': 8,
          'mg': mg ?? PFun.lg(12, 12),
          'pd': PFun.lg(0, 0, 12, 12),
          if ('$hint'.contains('提币数量') && isShowWarning != 0)
            'bd': PFun.bdAllLg(Colors.red, 1.5),
        },
      );
    }

    var item = [
      PWidget.row([
        PWidget.text('提币地址', [aColor, 13], {'exp': true}),
        PWidget.row([
          PWidget.text('设为默认地址', [aColor.withOpacity(0.5), 13]),
          PWidget.boxw(6),
          PWidget.icon(
              Icons.check_box_outline_blank, [aColor.withOpacity(0.5), 20])
        ], {
          'fun': () {}
        }),
      ]),
      tfView('请手动输入提币地址', '选择地址', con: tibiTextCon1),
      PWidget.text(
        '*请认真核对地址！如有错误，资产将无法找回！所有损失平台完全免责！',
        [aColor.withOpacity(0.5), 10],
        {'pd': PFun.lg(0, 19), 'isOf': false},
      ),
      PWidget.text('提币数量', [aColor, 13]),
      tfView(
        '请输入数量，最小提币数量 10 USDT',
        '',
        con: tibiTextCon2,
        isDouble: true,
        onChanged: (v) {
          if (double.parse(v) >
              double.parse(qbao['usdtbalance']) -
                  double.parse(qbao['tronWithdrawFee'])) {
            setState(() => isShowWarning = 1);
            showCustomToast('提币数量不能超过钱包余额');
          } else {
            if (double.parse(v) < 10) {
              showCustomToast('提币数量不能小于10');
              setState(() => isShowWarning = 2);
            } else {
              setState(() => isShowWarning = 0);
            }
          }
        },
      ),
      PWidget.column([
        PWidget.row(
          [
            PWidget.text(
                '当前可提${double.parse(qbao['usdtbalance'] ?? '0') - double.parse(qbao['tronWithdrawFee'] ?? '0')}USDT',
                [aColor, 10],
                {'exp': true}),
            PWidget.text('USDT', [aColor.withOpacity(0.5), 10], {'pd': 4}),
            PWidget.container(null, [1, 12, aColor.withOpacity(0.5)],
                {'mg': PFun.lg(0, 0, 12, 12)}),
            PWidget.text('全部', [aColor.withOpacity(0.5), 10], {'pd': 4}),
          ],
          {'pd': PFun.lg(0, 16)},
        ),
        PWidget.row([
          PWidget.text('提币手续费', [aColor, 13], {'exp': true}),
          PWidget.text('${format(qbao['tronWithdrawFee'])}USDT', [aColor, 13]),
        ]),
        Divider(color: aColor, height: 26),
        PWidget.row([
          PWidget.text('实际到账数量', [aColor, 13], {'exp': true}),
          PWidget.text(
            tibiTextCon2.text.isEmpty
                ? '0.0000USDT'
                : '${format(double.parse(isNullStr(tibiTextCon2, '0')) - double.parse(qbao['tronWithdrawFee']))}USDT',
            [aColor, 13],
          ),
        ]),
        PWidget.text(
          '*实际到账数量=用户提币数量-提币手续费',
          [aColor.withOpacity(0.5), 10],
          {'pd': PFun.lg(12, 19), 'isOf': false},
        ),
      ]),
      PWidget.text('资产密码', [aColor, 13]),
      tfView('请输入资产密码', '忘记密码？', tColor: pColor, con: tibiTextCon3),
      PWidget.text(
        '安全验证\t\t',
        [aColor, 13],
        {
          // 'exp': true,
          'ts': PFun.lg1<InlineSpan>(PWidget.textIs(
              '向手机号${toAsterisk(v: user['mobile'])}发送验证码',
              [Color(0xFFB7B7B7), 10]))
        },
      ),
      tfView('请输入请输入验证码', isTbSendCode ? '已发送' : '获取验证码',
          tColor: pColor, con: tibiTextCon4),
      PWidget.container(
        CustomButton(
          title: '提币',
          tColor: aColor,
          isExp: false,
          bgColor: Color(0xffC78904),
          fun: () {
            if (tibiTextCon1.text.isEmpty) return showCustomToast('请输入提币地址');
            if (tibiTextCon2.text.isEmpty) return showCustomToast('请输入提币数量');
            if (isShowWarning != 0)
              return showCustomToast(
                  {1: '提币数量不能超过钱包余额', 2: '提币数量不能小于10'}[isShowWarning]);
            if (tibiTextCon3.text.isEmpty) return showCustomToast('请输入资产密码');
            if (tibiTextCon3.text.length < 6)
              return showCustomToast('资产密码必须为6位');
            if (tibiTextCon4.text.isEmpty) return showCustomToast('请输入验证码');
            Request.post(
              '/maxmoneycloud-funds/api/wallet/withdraw',
              data: {
                "toaddress": tibiTextCon1.text, //转账到地址
                "quantity": tibiTextCon2.text, //转账数量
                "payPassword": tibiTextCon3.text, //支付密码
                "verificationCode": tibiTextCon4.text, //验证码
                "zoneCode": "86", //国际地区号
                "userId": user['id'], //用户id号
                "mobile": user['mobile'],
              },
              isLoading: true,
              catchError: (v) {
                setState(() => isTbSendCode = false);
                showCustomToast(v);
              },
              success: (v) {
                showCustomToast('提交成功');
                close(true);
                shouyi.userWallet();
              },
            );
            // close(true);
          },
        ),
        {'mg': PFun.lg(16)},
      ),
    ];
    return MyListView(
      isShuaxin: false,
      itemCount: item.length,
      animationType: AnimationType.vertical,
      animationTime: 250,
      padding: EdgeInsets.only(top: 24),
      physics: ClampingScrollPhysics(),
      animationDelayed: 0,
      item: (i) => item[i],
    );
  }

  ///兑换佣金
  Widget buildCommissionExchangeView() {
    var item = [
      PWidget.text(data['title'], [aColor, 16], {'ct': true}),
      PWidget.container(
        buildTFView(
          context,
          hintText: '请录入拟兑换的数量，与USDT按1:1兑换',
          hintColor: aColor.withOpacity(0.25),
          textColor: aColor,
          hintSize: 13,
          textSize: 13,
          con: duihuanYongjinTextCon,
          isInt: true,
          onChanged: (v) => setState(() => duihuanYongjinIndex = null),
        ),
        [null, 36, Colors.black26],
        {'br': 5, 'mg': 18, 'pd': PFun.lg(0, 0, 8, 8)},
      ),
      GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 35,
          mainAxisSpacing: 15,
          childAspectRatio: 90 / 40,
        ),
        itemCount: duihuanYongjinList.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (_, i) {
          var s = duihuanYongjinList[i];
          var isDy = duihuanYongjinIndex == i;
          return PWidget.container(
            PWidget.stack([
              Image.asset('assets/img/圆角矩形 1@2x.png'),
              if (isDy) Image.asset('assets/img/组 3@2x.png'),
              PWidget.text('$s', [aColor, 15], {'ct': true}),
            ]),
            {
              'fun': () {
                setState(() => duihuanYongjinIndex = isDy ? null : i);
                duihuanYongjinTextCon.text =
                    duihuanYongjinList[duihuanYongjinIndex];
              }
            },
          );
        },
      ),
      PWidget.text(
        '''1.执行量化或策略交易任务，委托成交后，平台将收取佣金
2.佣金标准为：现货（币币）0.1%，合约0.05%
3.仅开仓或买入成交后，单向收取佣金，平仓或卖出不收
4.兑换后，佣金不能提现，也不能退回钱包，请按需兑换''',
        [aColor.withOpacity(0.3), 11],
        {'isOf': false, 'pd': PFun.lg(24), 'h': 2.0},
      ),
      PWidget.container(
        PWidget.row([
          CustomButton(title: '取消'),
          PWidget.boxw(12),
          CustomButton(
            title: '确认',
            tColor: duihuanYongjinIndex == null &&
                    duihuanYongjinTextCon.text.isEmpty
                ? aColor.withOpacity(0.5)
                : aColor,
            bgColor: Color(0xffC78904).withOpacity(
                duihuanYongjinIndex == null &&
                        duihuanYongjinTextCon.text.isEmpty
                    ? 0.25
                    : 1),
            fun: () {
              if (duihuanYongjinIndex != null ||
                  duihuanYongjinTextCon.text.isNotEmpty) {
                close({
                  'type': duihuanYongjinIndex == null ? 'text' : 'selecto',
                  'value': duihuanYongjinIndex == null
                      ? duihuanYongjinTextCon.text
                      : duihuanYongjinIndex,
                });
              }
            },
          ),
        ]),
        {'mg': PFun.lg(24)},
      ),
    ];
    return MyListView(
      isShuaxin: false,
      itemCount: item.length,
      animationType: AnimationType.vertical,
      animationTime: 250,
      physics: ClampingScrollPhysics(),
      animationDelayed: 0,
      item: (i) => item[i],
    );
  }

  ///支付
  Widget buildPayView() {
    // ignore: unused_local_variable
    var digitalButton = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '.',
      '0',
      'd'
    ];
    var item = [
      PWidget.container(
        PWidget.column([
          PWidget.icon(
              Icons.close_rounded, [aColor], {'pd': 12, 'fun': () => close()}),
          PWidget.text('输入资产密码', [aColor, 15], {'ct': true}),
          PWidget.boxh(18),
          PWidget.row([
            PWidget.text("支付\t", [aColor, 13]),
            PWidget.image('assets/img/USDT符号@2x.png', [8, 16]),
            PWidget.boxw(3),
            PWidget.text(
                format(data['amount']), [aColor, 13], {'pd': PFun.lg(0, 2)}),
          ], '221'.split('')),
          PWidget.container(
            buildTFView(
              context,
              hintText: '请输入资产密码',
              padding: EdgeInsets.only(left: 8),
              // autofocus: true,
              focusNode: focusNode,
              maxLength: 6,
              hintColor: Colors.white24,
              textColor: Colors.white,
              // textAlign: TextAlign.center,
              onChanged: (v) {
                if (v.length == 6) {
                  if (data['name'] == '增加策略') {
                    data['data']['payPassword'] = v;
                    Request.post(
                      '/maxmoneycloud-quantstrategy/userStrategyMarket/buyMultipleStrategy',
                      data: data['data'],
                      isLoading: true,
                      dialogText: '正在支付...',
                      catchError: (v) => showCustomToast(v),
                      success: (v) {
                        showCustomToast('支付成功');
                        close(true);
                        shouyi.userWallet();
                      },
                    );
                  } else if (data['name'] == '策略超市') {
                    Request.post(
                      '/maxmoneycloud-quantstrategy/userStrategyMarket/payStrategyMoney',
                      data: {
                        "productId": data['data']['id'],
                        "userId": user['id'],
                        "strategyId": data['data']['strategyId'],
                        "strategyPrice": data['data']['strategyPrice'],
                        // "projectId": Config.ProjectId,
                        "payPassword": v,
                      },
                      isLoading: true,
                      dialogText: '正在支付...',
                      catchError: (v) => showCustomToast(v),
                      success: (v) {
                        showCustomToast('支付成功');
                        close(true);
                        shouyi.userWallet();
                      },
                    );
                  } else {
                    Request.post(
                      '/maxmoneycloud-funds/api/wallet/exchangeCommission',
                      data: {
                        "userId": user['id'], //用户ID
                        "amount": data['amount'], //兑换金额
                        "payPassword": v,
                      },
                      isLoading: true,
                      dialogText: '正在支付...',
                      catchError: (v) => showCustomToast(v),
                      success: (v) {
                        showCustomToast('支付成功');
                        close(true);
                        shouyi.userWallet();
                      },
                    );
                  }
                }
              },
            ),
            // PWidget.row(List.generate(6, (i) {
            //   var isXy = payPass.length < i + 1;
            //   return PWidget.container(
            //     PWidget.container(
            //       null,
            //       [6, 6, Colors.white.withOpacity(isXy ? 0 : 1)],
            //       {'br': 6, 'wali': PFun.lg(0, 0)},
            //     ),
            //     {
            //       'exp': true,
            //       if (i != 5) 'bd': PFun.bdLg(aColor.withOpacity(0.25), 0, 0, 0, 1),
            //     },
            //   );
            // })),
            [null, 36],
            {
              'bd': PFun.bdAllLg(aColor.withOpacity(0.25)),
              'mg': PFun.lg(24, 24, 30, 30),
              'br': 5,
            },
          ),
        ]),
        [null, null, Color(0xFF545454)],
        {'br': 5},
      ),
      // PWidget.boxh(56),
      // PWidget.boxh(12.5),
      // PWidget.boxh(12.5),
      // PWidget.boxh(12.5),
      // PWidget.container(
      //   GridView.builder(
      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //       crossAxisCount: 3,
      //       crossAxisSpacing: 1,
      //       mainAxisSpacing: 1,
      //       childAspectRatio: pmSize.width / 3 / 60,
      //     ),
      //     itemCount: digitalButton.length,
      //     physics: NeverScrollableScrollPhysics(),
      //     shrinkWrap: true,
      //     itemBuilder: (_, i) {
      //       var s = digitalButton[i];
      //       return GestureDetector(
      //         onLongPress: () {
      //           setState(() => payPass.clear());
      //         },
      //         child: PWidget.container(
      //           [
      //             PWidget.container(null, [6, 6, Colors.white], {'br': 6}),
      //             PWidget.text(s, [aColor, 30, true]),
      //             PWidget.image('assets/img/del.png', [41, 24]),
      //           ][s == '.' ? 0 : (s == 'd' ? 2 : 1)],
      //           [null, null, Color(0xFF484848)],
      //           {
      //             'ali': PFun.lg(0, 0),
      //             'fun': () async {
      //               if (s == '.') return;
      //               if (s == 'd') {
      //                 if (payPass.isNotEmpty) setState(() => payPass.removeLast());
      //               } else {
      //                 if (payPass.length < 6) setState(() => payPass.add(s));
      //               }
      //               if (payPass.length == 6) {
      //                 // await Future.delayed(Duration(milliseconds: 250));
      //                 Request.post(
      //                   '/maxmoneycloud-funds/api/wallet/exchangeCommission',
      //                   data: {
      //                     "userId": user['id'], //用户ID
      //                     "amount": data['amount'], //兑换金额
      //                     "payPassword": payPass.join(''),
      //                   },
      //                   isLoading: true,
      //                   catchError: (v) => showToast(v),
      //                   success: (v) {
      //                     showToast('支付成功');
      //                     close(true);
      //                   },
      //                 );
      //                 // showToast('密码错误');
      //                 // setState(() => payPass.clear());
      //               }
      //             }
      //           },
      //         ),
      //       );
      //     },
      //   ),
      //   [null, null, Color(0xFF707070)],
      // ),
    ];
    return MyListView(
      isShuaxin: false,
      itemCount: item.length,
      animationType: AnimationType.vertical,
      animationTime: 250,
      physics: ClampingScrollPhysics(),
      animationDelayed: 0,
      // key: ValueKey(Random.secure()),
      item: (i) => item[i],
    );
  }

  Widget childBuild(List list, {width, color}) {
    return Wrap(
      runSpacing: 4,
      children: List.generate(list.length, (i) {
        var lg = PFun.lg(0, 0, i % 3 == 2 ? 24 : 0, i % 3 == 0 ? 24 : 0);
        return PWidget.container(
          PWidget.ccolumn([
            PWidget.text(
              list[i]['value'],
              [color ?? Color(0xffC78904)],
              {'pd': PFun.lg2(8, 4)},
            ),
            // PWidget.boxh(4),
            PWidget.text(list[i]['name'],
                [Color(0xffB7B7B7).withOpacity(0.75), 12, true])
          ]),
          [width ?? (pmSize.width - 24 - 24 - 16 - 16) / 3],
          {'pd': lg},
        );
      }),
    );
  }

  ///购买策略
  Widget buildPurchaseStrategyView() {
    var data = widget.data!['celueData'];
    var wrapList = [
      {'text': '${data['tradeTimes']}次', 'color': Color(0xffC78904)},
      {'text': '${data['leverage'] ?? 0}X', 'color': Color(0xffC78904)},
      {
        'text': '${{
          'long': '开多',
          'short': '开空',
          'double': '双开',
          null: '开多',
        }[data['side']]}',
        'color': Color(0xFFFF3B30)
      },
      {
        'text': {1: '自动循环', 2: '单次有效'}[data['execWay'] ?? 1],
        'color': Color(0xffC78904)
      },
    ];
    var item = [
      PWidget.container(
        PWidget.column([
          PWidget.row(
            [
              PWidget.wrapperImage(
                  '1', [20, 20], {'br': 24, 'type': ImageType.random}),
              PWidget.boxw(8),
              // PWidget.icon(Icons.insert_emoticon_rounded),
              PWidget.text(
                "",
                [Color(0xff2878ff)],
                {'exp': true},
                [
                  PWidget.textIs("${data['house']}", [Color(0xff2878ff), 14]),
                  PWidget.textIs(
                      "\t\t${data['currencyCn']}\t\t", [Color(0xffC78904), 10]),
                  PWidget.textIs(data['currency'], [aColor, 10])
                ],
              ),
              PWidget.text({1: '自动循环', 2: '单次有效'}[data['execWay'] ?? 1],
                  [Color(0xFFC78904), 10]),
            ],
            ['2', '0', '1'],
          ),
          PWidget.container(null, [null, 8]),
          PWidget.row(
            [
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: List.generate(wrapList.length, (i) {
                    return PWidget.container(
                      PWidget.text(
                        wrapList[i]['text'],
                        [wrapList[i]['color'], 10],
                      ),
                      {
                        'pd': PFun.lg(1, 1, 8, 8),
                        'br': 2,
                        'bd': PFun.bdAllLg(wrapList[i]['color'], 0.5),
                      },
                    );
                  }),
                ),
              ),
              PWidget.text("累计盈利：${format(data['totalProfits'], 2)}",
                  [Color(0xffC78904), 10]),
            ],
            PFun.lg('2', '0', '1'),
            {'fill': true},
          ),
        ]),
        {'pd': PFun.lg(12, 0, 16, 16)},
      ),
      PWidget.container(
        PWidget.column([
          // PWidget.row([
          //   PWidget.text("2021-09-26", [Color(0xffffffff).withOpacity(0.7), 10]),
          //   PWidget.text("6天", [Color(0xffffffff).withOpacity(0.75), 10])
          // ], PFun.lg('2', '3', '1')),
          childBuild(
            List.generate(3, (i) {
              return {
                'name': ["盈利", "胜率", "回撤"][i],
                'value': [
                  "${(double.parse('${(data['yieldRate'] ?? 0)}') * 100).toStringAsFixed(4)}%",
                  "${(double.parse('${(data['winRate'] ?? 0)}') * 100).toStringAsFixed(2)}%",
                  "${(double.parse('${(data['retracementRate'] ?? 0)}') * 100).toStringAsFixed(4)}%",
                ][i]
              };
            }),
            color: Color(0xffC78904),
          ),
        ]),
        {'pd': PFun.lg(8, 24, 16, 16)},
      ),
      PWidget.row([
        PWidget.text("该策略定价：", [Color(0xFFD7D7D7), 10]),
        PWidget.image('assets/img/USDT符号@2x.png', [11, 18]),
        PWidget.boxw(3),
        PWidget.text(
            format(data['strategyPrice']), [aColor, 18], {'pd': PFun.lg(0, 2)}),
      ], '221'.split('')),
      PWidget.text(
        "购买后可终身免费使用",
        [Color(0xFFD7D7D7), 10],
        {'ct': true, 'pd': PFun.lg(24)},
      ),
      PWidget.container(
        PWidget.row([
          CustomButton(title: '取消下单'),
          PWidget.boxw(12),
          CustomButton(
            title: '确认购买',
            tColor: aColor,
            bgColor: Color(0xffC78904),
            fun: () => close(true),
          ),
        ]),
        {'mg': PFun.lg(24)},
      ),
    ];
    return MyListView(
      isShuaxin: false,
      itemCount: item.length,
      animationType: AnimationType.vertical,
      animationTime: 250,
      physics: ClampingScrollPhysics(),
      animationDelayed: 0,
      item: (i) => item[i],
    );
  }

  ///触发要求
  Widget buildChufaYaoqiuView() {
    var view1 = [
      PWidget.text('高于限价时，除平仓外，首单不再买多', [aColor, 12], {'ct': true}),
      PWidget.container(
        buildTFView(
          context,
          hintText: '买多限价',
          hintColor: aColor.withOpacity(0.25),
          textColor: aColor,
          con: textConChufayaoqiu1,
        ),
        [null, 36, Colors.black26],
        {'br': 5, 'mg': 12, 'pd': PFun.lg(0, 0, 8, 8)},
      ),
    ];
    var view2 = [
      PWidget.text('低于限价时，除平仓外，首单不再卖空', [aColor, 12], {'ct': true}),
      PWidget.container(
        buildTFView(
          context,
          hintText: '卖空限价',
          hintColor: aColor.withOpacity(0.25),
          textColor: aColor,
          con: textConChufayaoqiu2,
        ),
        [null, 36, Colors.black26],
        {'br': 5, 'mg': 12, 'pd': PFun.lg(0, 0, 8, 8)},
      ),
    ];
    var view3 = [
      PWidget.text('高于限价时，除平仓外，首单不再买多', [aColor, 12], {'ct': true}),
      PWidget.container(
        buildTFView(
          context,
          hintText: '买多限价',
          hintColor: aColor.withOpacity(0.25),
          textColor: aColor,
          con: textConChufayaoqiu1,
        ),
        [null, 36, Colors.black26],
        {'br': 5, 'mg': 12, 'pd': PFun.lg(0, 0, 8, 8)},
      ),
      PWidget.text('低于限价时，除平仓外，首单不再卖空', [aColor, 12], {'ct': true}),
      PWidget.container(
        buildTFView(
          context,
          hintText: '卖空限价',
          hintColor: aColor.withOpacity(0.25),
          textColor: aColor,
          con: textConChufayaoqiu2,
        ),
        [null, 36, Colors.black26],
        {'br': 5, 'mg': 12, 'pd': PFun.lg(0, 0, 8, 8)},
      ),
    ];
    var view4 = [
      PWidget.text('高于限价时，除平仓外，首单不再开仓', [aColor, 12], {'ct': true}),
      PWidget.container(
        buildTFView(
          context,
          hintText: '限价',
          hintColor: aColor.withOpacity(0.25),
          textColor: aColor,
          con: textConChufayaoqiu3,
        ),
        [null, 36, Colors.black26],
        {'br': 5, 'mg': 12, 'pd': PFun.lg(0, 0, 8, 8)},
      ),
    ];
    var item = [
      PWidget.text(data['title'], [aColor, 16], {'ct': true}),
      PWidget.boxh(24),
      if (data['isHeyue'])
        ...[view1, view2, view3][data['value']]
      else
        ...view4,
      PWidget.text('如限价为空，则按市价自动执行', [aColor, 10], {'ct': true}),
      PWidget.container(
        PWidget.row([
          PWidget.container(
            PWidget.text("取消", [aColor.withOpacity(0.5), 15], {'ct': true}),
            [null, null, Color(0xFF787878).withOpacity(0.3)],
            {'exp': true, 'pd': PFun.lg(10, 10), 'br': 5, 'fun': () => close()},
          ),
          PWidget.boxw(12),
          PWidget.container(
            PWidget.text("确认", [aColor, 15], {'ct': true}),
            [null, null, Color(0xffC78904)],
            {
              'exp': true,
              'pd': PFun.lg(10, 10),
              'br': 5,
              'fun': () {
                flog(textConChufayaoqiu1.text);
                return close(
                    [textConChufayaoqiu1.text, textConChufayaoqiu2.text]);
              },
            },
          )
        ]),
        {'mg': PFun.lg(24)},
      ),
    ];
    return MyListView(
      isShuaxin: false,
      itemCount: item.length,
      animationType: AnimationType.vertical,
      animationTime: 250,
      animationDelayed: 0,
      item: (i) => item[i],
    );
  }

  ///加仓方式
  Widget buildJiaCangFangShiView() {
    var item = [
      PWidget.text(data['title'], [aColor, 16], {'ct': true}),
      PWidget.boxh(16),
      PWidget.row([
        PWidget.text('间距为', [aColor.withOpacity(0.5), 12]),
        TipsWidget(fun: () {
          showTc(
            onPressed: () {},
            isDark: true,
            isTips: true,
            title: '间距',
            content: '价格差额，是指行情价与持仓价或成本价相差的绝对值\n涨跌幅度，是指行情价与持仓价或成本价相差的百分比',
          );
        }),
        PWidget.spacer(),
        RadioWidget(
          value: ['价格差额', '涨跌幅度'],
          index: jianjuIndex,
          key: ValueKey(m.Random.secure()),
          fun: (i) {
            showTc(
              isDark: true,
              title: '温馨提示',
              content: '仅允许使用一种间距模式！切换后，需重新设定加仓间距',
              onPressed: () {
                jiacangFangshiTextConList.forEach((f) => f.last.clear());
                setState(() => jianjuIndex = i);
              },
            );
          },
        ),
      ]),
      PWidget.boxh(6),
      PWidget.container(
        PWidget.column([
          PWidget.container(
            PWidget.row([
              text('加仓委托'),
              text(data['isHeyue'] ? '张数' : '倍数'),
              PWidget.text(
                '间距',
                [aColor.withOpacity(0.75), 12],
                {'exp': true, 'ali': 1},
              ),
              // text('间距'),
            ]),
            [null, null, Colors.black.withOpacity(0.1)],
            {'pd': 16},
          ),
          MyListView(
            isShuaxin: false,
            // itemCount: data['jcCount'],
            itemCount: jiacangFangshiTextConList.length,
            physics: NeverScrollableScrollPhysics(),
            listViewType: ListViewType.Separated,
            animationType: AnimationType.close,
            divider: Divider(color: Colors.white10, height: 0),
            item: (i) {
              return PWidget.container(
                PWidget.row([
                  text('第${i + 1}次'),
                  buildTFView(
                    context,
                    // hintText: '${(data['sdCount'] * i) + data['sdCount'] * (i + 1)}',
                    hintText:
                        !data['isHeyue'] ? '0.0' : data['sdCount'].toString(),
                    isExp: true,
                    isInt: isHeyue,
                    isDouble: !isHeyue,
                    doubleCount: 1,
                    con: jiacangFangshiTextConList[i].first,
                    textAlign: TextAlign.center,
                    hintColor: aColor.withOpacity(0.25),
                    textColor: aColor,
                    onChanged: (v) {
                      if (isHeyue) {
                        var zhangshu = 0;
                        var textCon = jiacangFangshiTextConList;
                        for (var i = 0; i < textCon.length; i++) {
                          var v1 = textCon[i].first.text;
                          zhangshu = zhangshu +
                              int.parse(
                                  '${(v1.isEmpty ? data['sdCount'] : v1)}');
                        }
                        if (zhangshu > data['zuidakeyong']) {
                          showCustomToast(
                              '${data['isHeyue'] ? '张数' : '倍数'}不能大于最大可用数${data['zuidakeyong']}');
                        }
                        this.debounce(() => this.expectUsed(isRef: true));
                      } else {
                        this.debounce(() => this.expectUsed(isRef: true));
                        // if (v.contains('.')) {
                        //   if (v.split('.').last.length > 1) {
                        //     return showCustomToast('只允许输入一位小数');
                        //   }
                        // }
                      }
                    },
                  ),
                  PWidget.row([
                    buildTFView(
                      context,
                      hintText: '0.0',
                      isExp: true,
                      isDouble: true,
                      doubleCount: [
                        2,
                        double.maxFinite.toInt()
                      ][jianjuIndex == 1 ? 0 : 1],
                      con: jiacangFangshiTextConList[i].last,
                      textAlign: TextAlign.end,
                      hintColor: aColor.withOpacity(0.25),
                      textColor: aColor,
                      onChanged: (v) {
                        if (isHeyue) {
                          this.debounce(() => this.expectUsed(isRef: true));
                        } else {
                          this.debounce(() => this.expectUsed(isRef: true));
                          // if (jianjuIndex == 1) {
                          //   ///涨跌
                          //   if (v.contains('.')) {
                          //     if (v.split('.').last.length > 2) {
                          //       return showCustomToast('只允许输入两位小数');
                          //     }
                          //   }
                          // }
                        }
                      },
                    ),
                    if (jianjuIndex == 1)
                      PWidget.text('%', [aColor.withOpacity(0.75), 12],
                          {'pd': PFun.lg3(0, 0, 4)}),
                  ], {
                    'exp': 1
                  }),
                ]),
                {'pd': 16},
              );
            },
          ),
        ]),
        [null, null, Colors.black.withOpacity(0.2)],
        {'br': 5},
      ),
      PWidget.boxh(13),
      AnimatedSwitchBuilder(
        value: expectUsedDm,
        errorOnTap: () => this.expectUsed(isRef: true),
        initialState: SizedBox(),
        isAnimatedSize: true,
        animationTime: 250,
        objectBuilder: (Map<dynamic, dynamic> v) {
          var text1 = '${format(v['expectMargin'] ?? 0)}USDT';
          var text2 =
              '${format(v['expectMargin'] ?? 0)}${widget.data!['value2'].split('-').first}';
          return PWidget.row([
            PWidget.text('预计涨跌：', [
              aColor.withOpacity(0.5),
              10
            ], {}, [
              PWidget.textIs('${v['expectRate'] ?? 0}', [null, 12])
            ]),
            PWidget.spacer(),
            PWidget.text('预计占用：', [
              aColor,
              10
            ], {}, [
              PWidget.textIs(isHeyue ? text1 : text2, [null, 12])
            ]),
          ]);
        },
      ),
      PWidget.container(
        PWidget.row([
          CustomButton(title: '取消'),
          PWidget.boxw(12),
          CustomButton(
            title: '确认',
            tColor: aColor,
            bgColor: Color(0xffC78904),
            fun: () {
              var list = jiacangFangshiTextConList.where((w) {
                var s = w.last.text;
                return double.parse(s.isEmpty ? '0' : s) <= 0;
              }).toList();
              if (list.isNotEmpty) {
                showCustomToast('间距必须大于0');
              } else {
                if (isHeyue) {
                  var zhangshu = 0;
                  var textCon = jiacangFangshiTextConList;
                  for (var i = 0; i < textCon.length; i++) {
                    var v1 = textCon[i].first.text;
                    zhangshu = zhangshu +
                        int.parse('${(v1.isEmpty ? data['sdCount'] : v1)}');
                  }
                  if (zhangshu > data['zuidakeyong']) {
                    return showCustomToast(
                        '${data['isHeyue'] ? '张数' : '倍数'}不能大于最大可用数${data['zuidakeyong']}');
                  } else {
                    var listJson = [];
                    var textCon = jiacangFangshiTextConList;
                    for (var i = 0; i < textCon.length; i++) {
                      var v1 = textCon[i].first.text;
                      var v2 = textCon[i].last.text;
                      listJson.add({
                        "addMode": jianjuIndex + 1,
                        "difference": Decimal.parse(
                                (double.parse(v2.isEmpty ? '0.0' : v2) /
                                        (jianjuIndex == 1 ? 100 : 1))
                                    .toString())
                            .toString(),
                        "multiple": v1.isEmpty ? data['sdCount'] : v1,
                        "times": i + 1,
                      });
                    }
                    close([listJson, expectUsedDm.object]);
                  }
                } else {
                  if ((double.parse(
                          expectUsedDm.object!['expectMargin'] ?? '0.0')) >=
                      double.parse(data['value1']['accountRights'] ?? '0')) {
                    return showCustomToast('您的账户权益不足，请修改加仓方式');
                  } else {
                    var listJson = [];
                    var textCon = jiacangFangshiTextConList;
                    for (var i = 0; i < textCon.length; i++) {
                      var v1 = textCon[i].first.text;
                      var v2 = textCon[i].last.text;
                      listJson.add({
                        "addMode": jianjuIndex + 1,
                        "difference": Decimal.parse(
                                (double.parse(v2.isEmpty ? '0.0' : v2) /
                                        (jianjuIndex == 1 ? 100 : 1))
                                    .toString())
                            .toString(),
                        "multiple": v1.isEmpty ? '0.0' : v1,
                        "times": i + 1,
                      });
                    }
                    close([listJson, expectUsedDm.object]);
                  }
                }
              }
            },
          ),
        ]),
        {'mg': PFun.lg(24)},
      ),
    ];
    return MyListView(
      isShuaxin: false,
      itemCount: item.length,
      animationType: AnimationType.vertical,
      animationTime: 250,
      physics: ClampingScrollPhysics(),
      animationDelayed: 0,
      item: (i) => item[i],
    );
  }

  ///即时止盈
  Widget buildJiShiZYView({bool isJishiZY = true}) {
    var item = [
      PWidget.text(data['title'], [aColor, 16], {'ct': true}),
      PWidget.boxh(16),
      PWidget.container(
        PWidget.column([
          PWidget.container(
            PWidget.row([
              text('加仓轮次'),
              text('即时止盈'),
              text('重复加仓'),
              text('止盈幅度'),
            ]),
            [null, null, Colors.black.withOpacity(0.1)],
            {'pd': PFun.lg(16, 16)},
          ),
          MyListView(
            isShuaxin: false,
            // itemCount: data['jcCount'],
            itemCount: jishiZhiyingTextConList.length,
            physics: NeverScrollableScrollPhysics(),
            listViewType: ListViewType.Separated,
            animationType: AnimationType.close,
            divider: Divider(color: Colors.white10, height: 0),
            item: (i) {
              return PWidget.container(
                PWidget.row([
                  text('第${i + 1}次'),
                  PWidget.container(
                    PWidget.image(
                        jishiZhiyingTextConList[i][0]
                            ? 'assets/img/duigou@2x.png'
                            : 'assets/img/duigou2.png',
                        [12, 12]),
                    [16, 16],
                    {
                      'exp': true,
                      'fun': () => setState(() => jishiZhiyingTextConList[i]
                          [0] = !jishiZhiyingTextConList[i][0])
                    },
                  ),
                  PWidget.container(
                    PWidget.image(
                        jishiZhiyingTextConList[i][1]
                            ? 'assets/img/duigou@2x.png'
                            : 'assets/img/duigou2.png',
                        [12, 12]),
                    [16, 16],
                    {
                      'exp': true,
                      'fun': () => setState(() => jishiZhiyingTextConList[i]
                          [1] = !jishiZhiyingTextConList[i][1])
                    },
                  ),
                  PWidget.row(
                    [
                      Container(
                        width: 24,
                        child: buildTFView(
                          context,
                          hintText: '0.0',
                          // isExp: true,
                          isDouble: true,
                          doubleCount: [
                            2,
                            double.maxFinite.toInt()
                          ][jianjuIndex == 1 ? 0 : 1],
                          con: jishiZhiyingTextConList[i].last,
                          textAlign: TextAlign.center,
                          hintColor: aColor.withOpacity(0.25),
                          textColor: aColor,
                          onChanged: (v) {
                            // if (isHeyue) {
                            //   this.debounce(() => this.expectUsed(isRef: true));
                            // } else {
                            //   this.debounce(() => this.expectUsed(isRef: true));
                            //   // if (jianjuIndex == 1) {
                            //   //   ///涨跌
                            //   //   if (v.contains('.')) {
                            //   //     if (v.split('.').last.length > 2) {
                            //   //       return showCustomToast('只允许输入两位小数');
                            //   //     }
                            //   //   }
                            //   // }
                            // }
                          },
                        ),
                      ),
                      PWidget.text('%', [aColor.withOpacity(0.75), 12],
                          {'pd': PFun.lg3(0, 0, 4)}),
                    ],
                    '221'.split(''),
                    {'exp': 1},
                  ),
                  // buildTFView(
                  //   context,
                  //   // hintText: '${(data['sdCount'] * i) + data['sdCount'] * (i + 1)}',
                  //   hintText: !data['isHeyue'] ? '0.0' : data['sdCount'].toString(),
                  //   isExp: true,
                  //   isInt: isHeyue,
                  //   isDouble: !isHeyue,
                  //   doubleCount: 1,
                  //   con: jishiZhiyingTextConList[i][2],
                  //   textAlign: TextAlign.center,
                  //   hintColor: aColor.withOpacity(0.25),
                  //   textColor: aColor,
                  //   onChanged: (v) {},
                  // ),
                ]),
                {'pd': PFun.lg(16, 16)},
              );
            },
          ),
        ]),
        [null, null, Colors.black.withOpacity(0.2)],
        {'br': 5},
      ),
      // PWidget.column([
      //   PWidget.row([
      //     PWidget.text('从第', [aColor], {'ct': true}),
      //     PWidget.container(
      //       buildTFView(
      //         context,
      //         hintText: '0',
      //         textAlign: TextAlign.center,
      //         doubleCount: 2,
      //         isInt: true,
      //         con: jishiZhiyingTextCon1,
      //       ),
      //       [40],
      //       {'bd': PFun.bdAllLg(Colors.white54), 'br': 6, 'mg': PFun.lg(0, 0, 8, 8)},
      //     ),
      //     PWidget.text('轮开始，止盈幅度', [aColor], {'ct': true}),
      //     PWidget.container(
      //       buildTFView(
      //         context,
      //         hintText: '0',
      //         textAlign: TextAlign.center,
      //         doubleCount: 2,
      //         isDouble: true,
      //         con: jishiZhiyingTextCon2,
      //       ),
      //       [40],
      //       {'bd': PFun.bdAllLg(Colors.white54), 'br': 6, 'mg': PFun.lg(0, 0, 8, 8)},
      //     ),
      //   ], '221'.split('')),
      //   PWidget.text('止盈成交后，继续下一轮次加仓', [aColor.withOpacity(0.75)], {'ct': true, 'pd': PFun.lg(12, 12)}),
      // ]),
      // PWidget.column([
      //   PWidget.row([
      //     PWidget.text('从第', [aColor], {'ct': true}),
      //     PWidget.container(
      //       buildTFView(
      //         context,
      //         hintText: '0',
      //         textAlign: TextAlign.center,
      //         doubleCount: 2,
      //         isInt: true,
      //         con: jishiZhiyingTextCon3,
      //       ),
      //       [40],
      //       {'bd': PFun.bdAllLg(Colors.white54), 'br': 6, 'mg': PFun.lg(0, 0, 8, 8)},
      //     ),
      //     PWidget.text('轮开始，止盈幅度', [aColor], {'ct': true}),
      //     PWidget.container(
      //       buildTFView(
      //         context,
      //         hintText: '0',
      //         textAlign: TextAlign.center,
      //         doubleCount: 2,
      //         isDouble: true,
      //         con: jishiZhiyingTextCon4,
      //       ),
      //       [40],
      //       {'bd': PFun.bdAllLg(Colors.white54), 'br': 6, 'mg': PFun.lg(0, 0, 8, 8)},
      //     ),
      //   ], '221'.split('')),
      //   PWidget.text('止盈成交后，重复当前轮次加仓', [aColor.withOpacity(0.75)], {'ct': true, 'pd': PFun.lg(12, 12)}),
      // ]),
      // PWidget.text('按照轮次不为0的设置，执行即时止盈', [aColor.withOpacity(0.5), 10], {'ct': true, 'pd': PFun.lg(4, 4)}),
      // PWidget.text('轮次均不为0，同时执行两种方式的即时止盈', [aColor.withOpacity(0.5), 10], {'ct': true, 'pd': PFun.lg(4, 4)}),
      // PWidget.text('如轮次全部为0时，则不执行即时止盈', [aColor.withOpacity(0.5), 10], {'ct': true, 'pd': PFun.lg(4, 4)}),
      // PWidget.text('当止盈幅度为0时，将按默认算法自动止盈', [aColor.withOpacity(0.5), 10], {'ct': true, 'pd': PFun.lg(4, 4)}),
      // PWidget.text('止盈幅度不为0，按加仓价格和所设参数止盈', [aColor.withOpacity(0.5), 10], {'ct': true, 'pd': PFun.lg(4, 4)}),
      // PWidget.text('即时止盈仅止盈最新加仓部分仓位', [aColor.withOpacity(0.5), 10], {'ct': true, 'pd': PFun.lg(4, 4)}),

      PWidget.container(
        PWidget.row([
          CustomButton(title: '取消'),
          PWidget.boxw(12),
          CustomButton(
            title: '确认',
            tColor: aColor,
            bgColor: Color(0xffC78904),
            fun: () {
              jianjuIndex = 1;
              var listJson = [];
              var textCon = jishiZhiyingTextConList;
              for (var i = 0; i < textCon.length; i++) {
                var v2 = textCon[i].last.text;
                listJson.add({
                  ///轮次
                  "times": i + 1,

                  ///是否需要及时止盈
                  "inTimeTp": textCon[i].first,

                  ///是否重复当前加仓
                  "reAdd": textCon[i][1],

                  ///止盈百分比
                  "stopPercent": Decimal.parse(
                          (double.parse(v2.isEmpty ? '0.0' : v2) /
                                  (jianjuIndex == 1 ? 100 : 1))
                              .toString())
                      .toString(),
                });
              }
              close(listJson);
              // listJson.forEach((f) {
              // flog(f);

              // });
              // var jszyConText1 = int.parse(jishiZhiyingTextCon1.text);
              // var jszyConText2 = double.parse(jishiZhiyingTextCon2.text);
              // var jszyConText3 = int.parse(jishiZhiyingTextCon3.text);
              // var jszyConText4 = double.parse(jishiZhiyingTextCon4.text);
              // var listJson = [];
              // var textCon = jishiZhiyingTextConList;
              // var value1 = jszyConText1 > jszyConText3 ? jszyConText3 : jszyConText1;
              // var value2 = jszyConText1 > jszyConText3 ? jszyConText1 : jszyConText3;
              // for (var i = 0; i < textCon.length; i++) {
              //   var stopPercent;
              //   if (i < value1 - 1) {
              //     stopPercent = '0';
              //   } else if (i >= value1 - 1 && i < value2 - 1) {
              //     stopPercent = value1 == jszyConText1 ? jszyConText2 : jszyConText4;
              //   } else {
              //     stopPercent = value1 == jszyConText1 ? jszyConText4 : jszyConText2;
              //   }
              //   var inTimeTpFlag = i < jszyConText1 - 1;
              //   var reAddFlag = i < jszyConText3 - 1;
              //   listJson.add({
              //     // "addMode": jianjuIndex + 1,
              //     // "stopLossPercent": Decimal.parse(((double.parse(v1.isEmpty ? '0.0' : v1) / (jianjuIndex == 1 ? 100 : 1)).toStringAsPrecision(2))).toString(),
              //     // "multiple": v1.isEmpty ? '0.0' : v1,
              //     // "stopPercent": jcFangshi.length <= i ? '0' : jcFangshi[i]['multiple'],
              //     // "stopPercent": (i < jszyConText1 - 1) ? 0 : ((i >= jszyConText1 - 1 && i < jszyConText3 - 1) ? jszyConText2 : jszyConText4),
              //     ///平仓轮次
              //     "times": i + 1,

              //     ///是否需要及时止盈
              //     "inTimeTp": jszyConText1 == 0
              //         ? (jszyConText3 == 0
              //             ? '不'
              //             : reAddFlag
              //                 ? '不'
              //                 : '是')
              //         : inTimeTpFlag
              //             ? (jszyConText3 == 0
              //                 ? '不'
              //                 : reAddFlag
              //                     ? '不'
              //                     : '是')
              //             : '是',

              //     ///是否重复当前加仓
              //     "reAdd": jszyConText3 == 0
              //         ? '不'
              //         : reAddFlag
              //             ? '不'
              //             : inTimeTpFlag
              //                 ? '是'
              //                 : '不',

              //     ///止盈百分比
              //     "stopPercent": stopPercent,
              //   });
              // }
              // listJson.forEach((f) {
              //   flog(f);
              // });
              // return;
              // if (isJishiZY) {
              //   jianjuIndex = 1;
              //   var listJson = [];
              //   var textCon = jishiZhiyingTextConList;
              //   for (var i = 0; i < textCon.length; i++) {
              //     var v1 = textCon[i].last.text;
              //     listJson.add({
              //       // "addMode": jianjuIndex + 1,
              //       // "stopLossPercent": Decimal.parse(((double.parse(v1.isEmpty ? '0.0' : v1) / (jianjuIndex == 1 ? 100 : 1)).toStringAsPrecision(2))).toString(),
              //       // "multiple": v1.isEmpty ? '0.0' : v1,
              //       // "stopPercent": jcFangshi.length <= i ? '0' : jcFangshi[i]['multiple'],
              //       "stopPercent": Decimal.parse(((double.parse(v1.isEmpty ? '0.0' : v1) / (jianjuIndex == 1 ? 100 : 1)).toStringAsPrecision(2))).toString(),
              //       "times": i + 1,
              //     });
              //   }
              //   close(listJson);
              // }
            },
          ),
        ]),
        {'mg': PFun.lg(16)},
      ),
    ];
    return MyListView(
      isShuaxin: false,
      itemCount: item.length,
      animationType: AnimationType.vertical,
      animationTime: 250,
      physics: ClampingScrollPhysics(),
      animationDelayed: 0,
      item: (i) => item[i],
    );
  }

  ///平仓设置
  Widget buildPingCangSetupView({bool? isJishiZY}) {
    var item = [
      PWidget.text(data['title'], [aColor, 16], {'ct': true}),
      PWidget.boxh(16),
      PWidget.container(
        PWidget.column([
          PWidget.container(
            ///即时止盈
            (isJishiZY!)
                ? PWidget.row([
                    text('加仓委托'),
                    PWidget.text(
                      '加仓数量',
                      [aColor.withOpacity(0.75), 12],
                      {'exp': true, 'ali': 2},
                    ),
                    PWidget.text(
                      '止盈幅度',
                      [aColor.withOpacity(0.75), 12],
                      {'exp': true, 'ali': 1},
                    ),
                  ])
                : PWidget.row([
                    text('委托轮次'),
                    PWidget.text(
                      '止盈平仓',
                      [aColor.withOpacity(0.75), 12],
                      {'exp': true, 'ali': 1},
                    ),
                    PWidget.text(
                      '止损平仓',
                      [aColor.withOpacity(0.75), 12],
                      {'exp': true, 'ali': 1},
                    ),
                  ]),
            [null, null, Colors.black.withOpacity(0.1)],
            {'pd': 16},
          ),
          MyListView(
            isShuaxin: false,
            itemCount: isJishiZY
                ? jishiZhiyingTextConList.length
                : pingcangShezhiTextConList.length,
            physics: NeverScrollableScrollPhysics(),
            listViewType: ListViewType.Separated,
            animationType: AnimationType.close,
            divider: Divider(color: Colors.white10, height: 0),
            item: (i) {
              return PWidget.container(
                PWidget.row([
                  if (isJishiZY)
                    text('第${i + 1}次')
                  else
                    i == 0 ? text('首单') : text('第$i次'),
                  PWidget.row([
                    if (isJishiZY)
                      buildTFView(
                        context,
                        // hintText: '${(data['sdCount'] * i) + data['sdCount'] * (i + 1)}',
                        // hintText: !data['isHeyue'] ? '0.0' :  data['sdCount'].toString(),
                        hintText: jcFangshi!.length <= i
                            ? '0'
                            : jcFangshi![i]['multiple'].toString(),
                        isExp: true,
                        isEdit: false,
                        isDouble: true,
                        doubleCount: 2,
                        // con: pingcangShezhiTextConList[i][0],
                        textAlign: TextAlign.center,
                        hintColor: aColor,
                        textColor: aColor,
                      ),
                    if (!isJishiZY)
                      buildTFView(
                        context,
                        // hintText: '${(data['sdCount'] * i) + data['sdCount'] * (i + 1)}',
                        hintText: '0.5',
                        isExp: true,
                        isDouble: true,
                        doubleCount: 2,
                        con: pingcangShezhiTextConList[i][0],
                        textAlign: TextAlign.right,
                        hintColor: aColor.withOpacity(0.25),
                        textColor: aColor,
                      ),
                    if (!isJishiZY)
                      PWidget.text('%', [aColor.withOpacity(0.75), 12],
                          {'pd': PFun.lg3(0, 0, 4)}),
                  ], {
                    'exp': 1
                  }),
                  PWidget.row([
                    if (isJishiZY)
                      buildTFView(
                        context,
                        hintText: '0.0',
                        isExp: true,
                        isDouble: true,
                        doubleCount: 2,
                        con: jishiZhiyingTextConList[i][1],
                        textAlign: TextAlign.end,
                        hintColor: aColor.withOpacity(0.25),
                        textColor: aColor,
                      ),
                    if (!isJishiZY)
                      buildTFView(
                        context,
                        hintText: i == pingcangShezhiTextConList.length - 1
                            ? '0.0'
                            : '0.0',
                        isExp: true,
                        isDouble: true,
                        doubleCount: 2,
                        con: pingcangShezhiTextConList[i][1],
                        textAlign: TextAlign.end,
                        hintColor: aColor.withOpacity(0.25),
                        textColor: aColor,
                      ),
                    PWidget.text('%', [aColor.withOpacity(0.75), 12],
                        {'pd': PFun.lg3(0, 0, 4)}),
                  ], {
                    'exp': 1
                  }),
                ]),
                {'pd': 16},
              );
            },
          ),
        ]),
        [null, null, Colors.black.withOpacity(0.2)],
        {'br': 5},
      ),
      if (isJishiZY) PWidget.boxh(16),
      if (isJishiZY)
        PWidget.text('即时止盈将按加仓成交价格的止盈幅度止盈并产生亏损', [aColor, 12], {'ct': true}),
      PWidget.container(
        PWidget.row([
          CustomButton(title: '取消'),
          PWidget.boxw(12),
          CustomButton(
            title: '确认',
            tColor: aColor,
            bgColor: Color(0xffC78904),
            fun: () {
              if (isJishiZY) {
                jianjuIndex = 1;
                var listJson = [];
                var textCon = jishiZhiyingTextConList;
                for (var i = 0; i < textCon.length; i++) {
                  var v1 = textCon[i].last.text;
                  listJson.add({
                    // "addMode": jianjuIndex + 1,
                    // "stopLossPercent": Decimal.parse(((double.parse(v1.isEmpty ? '0.0' : v1) / (jianjuIndex == 1 ? 100 : 1)).toStringAsPrecision(2))).toString(),
                    // "multiple": v1.isEmpty ? '0.0' : v1,
                    // "stopPercent": jcFangshi.length <= i ? '0' : jcFangshi[i]['multiple'],
                    "stopPercent": Decimal.parse(
                            ((double.parse(v1.isEmpty ? '0.0' : v1) /
                                    (jianjuIndex == 1 ? 100 : 1))
                                .toStringAsPrecision(2)))
                        .toString(),
                    "times": i + 1,
                  });
                }
                close(listJson);
              } else {
                if (pingcangShezhiTextConList.last.last.text.isEmpty) {
                  return showTc(
                    isDark: true,
                    title: '温馨提示',
                    content: '交易需审慎！您未设置止损，有可能面临亏损、强平等多种风险！确认代表您清晰了解并自愿承担一切后果',
                    onPressed: () {
                      var listJson = [];
                      var textCon = pingcangShezhiTextConList;
                      for (var i = 0; i < textCon.length; i++) {
                        var v1 = textCon[i].last.text;
                        var v2 = textCon[i].first.text;
                        listJson.add({
                          "stopLossPercent": double.parse((v1.isEmpty
                                  ? (i == textCon.length - 1 ? '0' : '0')
                                  : v1)) /
                              100,
                          "stopPercent":
                              double.parse((v2.isEmpty ? '0.5' : v2)) / 100,
                          "times": i + 1,
                        });
                      }
                      close(listJson);
                    },
                  );
                }
                var listJson = [];
                var textCon = pingcangShezhiTextConList;
                for (var i = 0; i < textCon.length; i++) {
                  var v1 = textCon[i].last.text;
                  var v2 = textCon[i].first.text;
                  listJson.add({
                    "stopLossPercent": double.parse((v1.isEmpty
                            ? (i == textCon.length - 1 ? '0' : '0')
                            : v1)) /
                        100,
                    "stopPercent":
                        double.parse((v2.isEmpty ? '0.5' : v2)) / 100,
                    "times": i + 1,
                  });
                }
                close(listJson);
                // pingcangShezhiTextConList.forEach((f) {
                //   flog(f[0].text);
                // });
              }
            },
          ),
        ]),
        {'mg': PFun.lg(16)},
      ),
    ];
    return MyListView(
      isShuaxin: false,
      itemCount: item.length,
      animationType: AnimationType.vertical,
      animationTime: 250,
      physics: ClampingScrollPhysics(),
      animationDelayed: 0,
      item: (i) => item[i],
    );
  }

  ///止盈止损
  Widget buildZhiYingZhiSunView() {
    Widget tfView(hint, text, tag, {TextEditingController? con, List? mg}) {
      return PWidget.container(
        PWidget.row([
          PWidget.text(text ?? '1,234.5678USDT', [aColor, 12]),
          buildTFView(
            context,
            hintText: hint ?? '盈利',
            hintColor: aColor.withOpacity(0.25),
            textColor: aColor,
            con: con,
            isDouble: true,
            doubleCount: tag == '%' ? 2 : 99999,
            textAlign: TextAlign.end,
            isExp: true,
          ),
          PWidget.boxw(4),
          PWidget.text(tag ?? 'USDT', [aColor.withOpacity(0.25), 12]),
        ]),
        [null, 43, Colors.black26],
        {'br': 8, 'mg': mg ?? PFun.lg(12, 6), 'pd': PFun.lg(0, 0, 8, 8)},
      );
    }

    var item = [
      PWidget.text(data['title'], [aColor, 16], {'ct': true}),
      PWidget.boxh(16),
      RadioWidget(
        value: ['当盈亏达到设定额度时，立即平仓'],
        index: zhiyingzhisun == 0 ? 0 : 1,
        key: ValueKey(m.Random.secure()),
        fun: (i) => setState(() => zhiyingzhisun = i == 0 ? 0 : 1),
      ),
      tfView('0', '盈利', 'USDT', mg: [12, 6], con: zhiyingzhisunTextConList[0]),
      tfView('0', '亏损', 'USDT', mg: [6, 12], con: zhiyingzhisunTextConList[1]),
      RadioWidget(
        value: ['当盈亏达到设定比例时，立即平仓'],
        index: zhiyingzhisun == 1 ? 0 : 1,
        key: ValueKey(m.Random.secure()),
        fun: (i) => setState(() => zhiyingzhisun = i == 0 ? 1 : 0),
      ),
      tfView('1.5', '盈利', '%', mg: [12, 6], con: zhiyingzhisunTextConList[2]),
      tfView('1.5', '亏损', '%', mg: [6, 0], con: zhiyingzhisunTextConList[3]),
      PWidget.container(
        PWidget.row([
          CustomButton(title: '取消'),
          PWidget.boxw(12),
          CustomButton(
            title: '确认',
            tColor: aColor,
            bgColor: Color(0xffC78904),
            fun: () => close([
              isNullStr(zhiyingzhisunTextConList[0]),
              isNullStr(zhiyingzhisunTextConList[1]),
              isNullStr(zhiyingzhisunTextConList[2], '', true),
              isNullStr(zhiyingzhisunTextConList[3], '', true),
            ]),
          ),
        ]),
        {'mg': PFun.lg(24)},
      ),
    ];
    return MyListView(
      isShuaxin: false,
      itemCount: item.length,
      animationType: AnimationType.vertical,
      animationTime: 250,
      physics: ClampingScrollPhysics(),
      animationDelayed: 0,
      item: (i) => item[i],
    );
  }

  ///表格文字
  Widget text(text) => PWidget.text(
      text ?? '间距', [aColor.withOpacity(0.75), 12], {'exp': true, 'ct': true});
}
