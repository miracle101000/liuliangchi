import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:liuliangchi/main.dart';

import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/http.dart';

import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';
import 'package:provider/provider.dart';

import 'config/common_config.dart';
import 'page/web_page.dart';
import 'paxis_fun.dart';
import 'provider/app_provider.dart';
import 'provider/provider_config.dart';
import 'view/views.dart';

///验证码组件
class CodeWidget extends StatefulWidget {
  final Widget Function(String, Color?)? childBuilder;
  final String? text;
  final Color? successColor;
  final Color errorColor;
  final String successText;
  final String errorText;
  final TextEditingController? phoneCon;
  final String? tips;
  final int time;
  final AlignmentGeometry alignment;
  final Future<bool> Function(String phone)? callApi;
  const CodeWidget({
    Key? key,
    this.childBuilder,
    this.phoneCon,
    this.text,
    this.tips,
    this.alignment = Alignment.centerRight,
    this.time = 30,
    this.successColor,
    this.errorColor = Colors.grey,
    this.callApi,
    this.successText = '已发送验证码，请注意查收！',
    this.errorText = '发送失败，请检查网络设置！',
  }) : super(key: key);

  @override
  State<CodeWidget> createState() => _CodeWidgetState();
}

class _CodeWidgetState extends State<CodeWidget> {
  ///显示文本
  var text;

  ///定时器
  Timer? timer;

  ///是否显示倒计时
  bool isShowCode = false;

  bool isSend = false;

  @override
  void initState() {
    text = widget.text;
    verificationMobileNumber();
    widget.phoneCon!.addListener(() => verificationMobileNumber());
    super.initState();
  }

  ///验证码手机号
  void verificationMobileNumber() {
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool matched = exp.hasMatch(widget.phoneCon!.text);
    flog(matched);
    if (!matched) {
      if (mounted) setState(() => isSend = false);
    } else {
      if (mounted) setState(() => isSend = true);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: PWidget.container(
        // Container(),
        widget.childBuilder!(
          isShowCode ? '${widget.time - timer!.tick}${widget.tips}' : text,
          isSend
              ? (isShowCode ? widget.errorColor : widget.successColor)
              : widget.errorColor,
        ),
        {
          if (isSend)
            'fun': () async {
              if (isShowCode) return showCustomToast(widget.successText);
              if (await widget.callApi!(widget.phoneCon!.text)) {
                showCustomToast(widget.successText);
                setState(() => isShowCode = true);
                timer = Timer.periodic(Duration(seconds: 1), (v) {
                  setState(() {
                    if (v.tick == widget.time) {
                      isShowCode = false;
                      timer?.cancel();
                    }
                  });
                });
              } else {
                showCustomToast(widget.errorText);
              }
            },
        },
      ),
    );
  }
}

///登录/注册/验证登录
class PhoneLogin extends StatefulWidget {
  final bool isClose;

  const PhoneLogin({Key? key, this.isClose = false}) : super(key: key);
  @override
  PhoneLoginState createState() => PhoneLoginState();
}

class PhoneLoginState extends State<PhoneLogin> {
  var phoneCon = TextEditingController();
  var codeCon = TextEditingController();

  ///验证码登录
  bool isCode = false;

  ///是否阅读
  bool isYuedu = false;

  ///是否显示密码
  bool isShowPass = false;

  @override
  void initState() {
    initData();
    super.initState();
  }

  // @override
  // void wechatResp(res) {
  //   if (res is AuthResp) {
  //     if (res.errorCode == 0) {
  //       flog(res.code);
  //       weixinLoginFun(res.code);
  //     } else {
  //       showCustomToast('微信登录失败，请稍后再试！');
  //     }
  //   }
  //   super.wechatResp(res);
  // }

  ///初始化函数
  Future initData() async {
    isYuedu = kDebugMode;
    app.getZhanghaoList();
    app.changeisShowZhanghaoList(false);
    // app.isJumpLogin = true;
    // lis = Wechat.instance.respStream().listen((res) {
    //   if (res is AuthResp) {
    //     if (res.errorCode == 0) {
    //       flog(res.code);
    //       weixinLoginFun(res.code);
    //     } else {
    //       showCustomToast('微信登录失败，请稍后再试！');
    //     }
    //   }
    // });
  }

  ///登录
  void weixinLoginFun(code) {
    Request.post(
      '/weixin/wx/appLogin',
      data: {"code": code},
      isLoading: true,
      catchError: (v) => showCustomToast(v.toString()),
      success: (v) {
        if (v['result']['status'] == 2) {
          showCustomToast('非法用户，禁止登录');
        } else {
          userPro.token = v['token'];
          userPro.tokenTime = DateTime.now().millisecondsSinceEpoch;
          userPro.setUserModel(v['result']);
          if (v['result']['mobile'] == '' || v['result']['mobile'] == null) {
            jumpPage(BindPhone(user['id']));
            // jumpPage(PhoneBind(id: v['result']['id']));
            // jumpPage(App(), isClose: true, isMove: false);
          } else {
            // jumpPage(PhoneBind(id: v['result']['id']));
            // showCustomToast('登录成功');
            jumpPage(const App(), isClose: true, isMove: false);
          }
        }
      },
    );
  }

  @override
  void dispose() {
    app.isJumpLogin = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context,
          title: '助销云', isWhiteBg: true, isNoShowLeft: true),
      bgColor: Colors.white,
      brightness: Brightness.dark,

      ///[error]
      btnBar: PWidget.container(
          gouxuanView(), {'pd': 24}, null, ObjectKey({'pd': 24}.toString())),

      ///[error]
      body: MyListView(
        isShuaxin: false,
        flag: false,
        item: (i) => item[i],
        itemCount: item.length,
        touchBottomAnimationOpacity: 10,
        padding: const EdgeInsets.all(24),
      ),
    );
  }

  ///登录
  List<Widget> get item {
    return [
      // PWidget.image('assets/new_img/logo.png', [pmSize.width / 2, pmSize.width / 3]),
      // PWidget.boxh(24),
      ...List.generate(2, (i) {
        var isShowExpande = !isCode && i == 0;
        return PWidget.container(
          PWidget.column([
            PWidget.text(['用户名', isCode ? '验证码' : '密码'][i], [aColor, 16]),
            PWidget.boxh(10),
            PWidget.container(
              PWidget.row([
                // PWidget.image(['assets/img/登陆_13.png', 'assets/img/登陆_18.png'][i], [24, 24]),
                // PWidget.boxw(8),
                buildTFView(
                  context,
                  hintText: ['请输入用户名', isCode ? '请输入验证码' : '请输入密码'][i],
                  isExp: true,
                  con: [phoneCon, codeCon][i],
                  obscureText: isCode ? false : i == 1 && !isShowPass,
                ),
                if (isShowExpande)
                  Selector<AppProvider, bool>(
                    selector: (_, k) => k.isShowZhanghaoList,
                    builder: (_, v, view) {
                      return PWidget.icon(
                        v
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        [aColor.withOpacity(0.5)],
                        {
                          'pd': 8,
                          'fun': () => app.changeisShowZhanghaoList(!v)
                        },
                      );
                    },
                  ),
                if (i == 1 && !isCode)
                  PWidget.icon(
                      isShowPass
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      [aColor.withOpacity(0.25)],
                      {'fun': () => setState(() => isShowPass = !isShowPass)}),
                if (isCode && i == 1)
                  CodeWidget(
                    text: '验证码',
                    tips: '秒后重新发送',
                    phoneCon: phoneCon,
                    time: 60,
                    successColor: pColor,
                    errorColor: Colors.black26,
                    callApi: (v) async {
                      bool isSuccess = false;
                      await Request.post(
                        '/app/common/sendCode',
                        isLoading: true,
                        data: {"mobile": v},
                        catchError: (v) => isSuccess = false,
                        success: (v) => isSuccess = true,
                      );
                      return isSuccess;
                    },
                    childBuilder: (v, c) => PWidget.container(
                      PWidget.text(v, [Colors.white]),
                      [null, null, c],
                      {'br': 4, 'pd': PFun.lg(6, 6, 12, 12)},
                    ),
                  ),
              ]),
              [null, null, aColor.withOpacity(0.05)],
              {
                'crr': 8 * 2.5,
                'pd': PFun.lg(isShowExpande ? 8 : 12, isShowExpande ? 8 : 12,
                    16, isCode ? 8 : (isShowExpande ? 8 : 16))
              },
            ),
            if (isShowExpande)
              Selector<AppProvider, bool>(
                selector: (_, k) => k.isShowZhanghaoList,
                builder: (_, v, view) {
                  return PWidget.container(
                    app.zhanghaoList.isEmpty
                        ? PWidget.text(
                            '暂无帐号', [aColor.withOpacity(0.5)], {'ct': true})
                        : MyListView(
                            isShuaxin: false,
                            flag: false,
                            animationDelayed: 0,
                            item: (i) {
                              var list = app.zhanghaoList[i].split('|');
                              return PWidget.container(
                                PWidget.row([
                                  PWidget.text(
                                    '${list.first}',
                                    [aColor.withOpacity(0.5)],
                                    {'exp': true},
                                  ),
                                  PWidget.icon(
                                    Icons.close,
                                    [aColor.withOpacity(0.25), 20],
                                    {
                                      'pd': 12,
                                      'fun': () {
                                        showTc(
                                          onPressed: () {
                                            app.zhanghaoList
                                                .remove(app.zhanghaoList[i]);
                                            app.addZhanghaoListItem();
                                            setState(() {});
                                          },
                                          title: '确定删除帐号吗？',
                                        );
                                      }
                                    },
                                  ),
                                ]),
                                {
                                  'pd': [0, 0, 16, 5],
                                  'fun': () {
                                    phoneCon.text = list.first;
                                    codeCon.text = list.last;
                                    app.changeisShowZhanghaoList(false);
                                  }
                                },
                              );
                            },
                            itemCount: app.zhanghaoList.length,
                            listViewType: ListViewType.Separated,
                            divider: Divider(color: Colors.white10, height: 0),
                            animationType: AnimationType.close,
                          ),
                    [
                      null,
                      v ? (app.zhanghaoList.length > 5 ? 200 : 100) : 0,
                      aColor.withOpacity(0.05)
                    ],
                    {'mg': PFun.lg(8), 'br': 8},
                  );
                },
              ),
          ]),
          {'pd': PFun.lg(10, 10)},
        );
      }),
      PWidget.boxh(10),
      btnView(
        '登录',
        isAnima: false,
        fun: () {
          if (!isYuedu) {
            setState(() => isYuedu = true);
            return showCustomToast('请阅读服务协议与隐私政策!');
          }
          if (phoneCon.text.isEmpty) return showCustomToast('请输入用户名!');
          // RegExp reg = new RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
          // if (!reg.hasMatch(phoneCon.text)) return showCustomToast('请输入11位手机号码');
          //// if (codeCon.text.isEmpty) return showCustomToast('请输入验证码!');
          if (codeCon.text.isEmpty) {
            return showCustomToast(isCode ? '请输入验证码' : '请输入密码!');
          }
          Request.post(
            '/app/user/login',
            isLoading: true,
            context: context,
            isToken: false,
            data: isCode
                ? {
                    "mobile": phoneCon.text,
                    "code": codeCon.text,
                    "version": app.packageInfo!.version
                  }
                : {
                    "userName": phoneCon.text,
                    "password": generateMd5(codeCon.text),
                    // "mobile": phoneCon.text,
                    // "passWord": generateMd5(codeCon.text),
                    // "version": app.packageInfo.version,
                  },
            catchError: (v) => showCustomToast(v),
            success: (v) async {
              // await userPro.setToken(
              //   v['data']['token'],
              //   DateTime.now().millisecondsSinceEpoch,
              //   v['data']['refreshToken'],
              // );
              // Request.post(
              //   '/maxmoneycloud-users/user/me',
              //   isLoading: true,
              //   catchError: (v) => showToast(v),
              //   success: (v) {
              if (v['result']['user']['status'] != 1) {
                showCustomToast('账户异常！');
              } else {
                userPro.token = v['token'];
                userPro.tokenTime = DateTime.now().millisecondsSinceEpoch;
                userPro.setUserModel(v['result']);
                app.addZhanghaoListItem('${phoneCon.text}|${codeCon.text}');
                // showCustomToast('登录成功');
                jumpPage(const App(), isClose: true, isMove: false);
              }
              //   },
              // );
            },
          );
        },
      ),
      // PWidget.boxh(10),
      // GestureDetector(
      //   onTap: () {
      //     setState(() => isCode = !isCode);
      //     codeCon.clear();
      //   },
      //   child: PWidget.text(isCode ? '密码登录' : '验证码登录', [pColor], {'ali': 1, 'pd': 8}),
      // ),
    ];
  }

  ///勾选已阅读
  Widget gouxuanView() {
    return PWidget.row([
      // WidgetTap(
      //   onTap: () => setState(() => isYuedu = !isYuedu),
      //   child: Container(
      //     child: TweenAnimationBuilder(
      //       // key: ValueKey(Random().nextInt(99)),
      //       tween: ColorTween(
      //         begin: !isYuedu ? Theme.of(context).primaryColor : Colors.grey,
      //         end: !isYuedu ? Colors.grey : Theme.of(context).primaryColor,
      //       ),
      //       duration: Duration(milliseconds: 100),
      //       builder: (_, v, vv) {
      //         return Icon(
      //             isYuedu ? Icons.radio_button_on : Icons.radio_button_off,
      //             color: v,
      //             size: 18);
      //       },
      //     ),
      //   ),
      // ),
      // Expanded(
      //   child: Html(
      //     data: '<p>我已认真阅读并同意<a href="11">服务协议</a>和<a href="12">隐私政策</a></p>',
      //     style: {
      //       'a': Style(
      //           color: Theme.of(context).primaryColor, fontSize: FontSize(14)),
      //       'p': Style(color: Colors.grey, fontSize: FontSize(14))
      //     },
      //     onLinkTap: (v, _, __, ___) =>
      //         jumpPage(WebPage(title: {'11': '服务协议', '12': '隐私政策'}[v]!)),
      //   ),
      // ),
    ]);
  }
}

///忘记密码
class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  var phoneCon = TextEditingController();
  var codeCon = TextEditingController();
  var pass1Con = TextEditingController();
  var pass2Con = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      appBar: buildTitle(context, title: '找回密码'),
      brightness: Brightness.light,
      body: MyListView(
        isShuaxin: false,
        flag: false,
        item: (i) => item[i],
        itemCount: item.length,
        padding: EdgeInsets.all(30),
        divider: Divider(color: Colors.transparent),
      ),
    );
  }

  List<Widget> get item {
    return [
      PWidget.container(
        buildTFView(context, hintText: '请输入手机号', con: phoneCon),
        {
          'bd': PFun.bdAllLg(Colors.black12),
          'br': 56,
          'pd': PFun.lg(12, 12, 16, 8)
        },
      ),
      PWidget.container(sendCodeView(), {
        'bd': PFun.bdAllLg(Colors.black12),
        'br': 56,
        'pd': PFun.lg(8, 8, 16, 8),
      }),
      PWidget.container(
        buildTFView(context, hintText: '请输入新密码', con: pass1Con),
        {
          'bd': PFun.bdAllLg(Colors.black12),
          'br': 56,
          'pd': PFun.lg(12, 12, 16, 8)
        },
      ),
      PWidget.container(
        buildTFView(context, hintText: '请再次新输入密码', con: pass2Con),
        {
          'bd': PFun.bdAllLg(Colors.black12),
          'br': 56,
          'pd': PFun.lg(12, 12, 16, 8)
        },
      ),
      btnView(
        '修改密码',
        isAnima: false,
        redius: 56,
        fun: () {
          if (phoneCon.text.isEmpty) return showCustomToast('请输入手机号!');
          RegExp reg = new RegExp(
              r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
          if (!reg.hasMatch(phoneCon.text)) {
            return showCustomToast('请输入11位手机号码');
          }
          if (codeCon.text.isEmpty) return showCustomToast('请输入验证码!');
          if (pass1Con.text.isEmpty) return showCustomToast('请输入新密码!');
          if (pass2Con.text.isEmpty) return showCustomToast('请再次输入新密码!');
          if (pass2Con.text != pass1Con.text) {
            return showCustomToast('两次密码不一致，请重新输入!');
          }
          // if (yaoqingmaCon.text.isEmpty) return showCustomToast('请输入邀请码!');
          Request.post(
            '/app/user/forgetPassWord',
            isLoading: true,
            data: {
              "mobile": phoneCon.text,
              "code": codeCon.text,
              "password": generateMd5(pass2Con.text),
            },
            catchError: (v) => showCustomToast(v),
            success: (v) {
              showCustomToast('修改成功！');
              close();
            },
          );
        },
      ),
    ];
  }

  ///发送验证码
  Widget sendCodeView() {
    return PWidget.row([
      buildTFView(context, hintText: '请输入验证码', isExp: true, con: codeCon),
      CodeWidget(
        text: '获取验证码',
        tips: '秒后重新发送',
        phoneCon: phoneCon,
        successColor: pColor,
        errorColor: Colors.red,
        callApi: (v) async {
          bool isSuccess = false;
          await Request.post(
            '/app/common/sendCode',
            isLoading: true,
            data: {"mobile": v},
            catchError: (v) => isSuccess = false,
            success: (v) => isSuccess = true,
          );
          return isSuccess;
        },
        childBuilder: (v, c) {
          return PWidget.container(PWidget.text(v, [c]), {
            'pd': PFun.lg(4, 4, 12, 12),
          });
        },
      ),
    ]);
  }
}

///绑定手机号
class BindPhone extends StatefulWidget {
  final String userId;
  final bool isHome;
  const BindPhone(this.userId, {Key? key, this.isHome = false})
      : super(key: key);
  @override
  _BindPhoneState createState() => _BindPhoneState();
}

class _BindPhoneState extends State<BindPhone> {
  var phoneCon = TextEditingController();
  var codeCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      brightness: Brightness.light,
      appBar: buildTitle(context, title: '绑定手机号', isNoShowLeft: widget.isHome),
      body: MyListView(
        isShuaxin: false,
        flag: false,
        item: (i) => item[i],
        itemCount: item.length,
        padding: EdgeInsets.all(16),
        divider: Divider(color: Colors.transparent),
      ),
    );
  }

  List<Widget> get item {
    return [
      PWidget.container(
        buildTFView(context, hintText: '请输入手机号', con: phoneCon),
        {
          'bd': PFun.bdAllLg(Colors.black12),
          'br': 56,
          'pd': PFun.lg(12, 12, 16, 8)
        },
      ),
      PWidget.container(sendCodeView(), {
        'bd': PFun.bdAllLg(Colors.black12),
        'br': 56,
        'pd': PFun.lg(8, 8, 16, 8),
      }),
      btnView(
        '确认绑定',
        isAnima: false,
        redius: 56,
        fun: () {
          if (phoneCon.text.isEmpty) return showCustomToast('请输入手机号!');
          RegExp reg = new RegExp(
              r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
          if (!reg.hasMatch(phoneCon.text)) {
            return showCustomToast('请输入11位手机号码');
          }
          if (codeCon.text.isEmpty) return showCustomToast('请输入验证码!');
          // if (pass1Con.text.isEmpty) return showCustomToast('请输入新密码!');
          // if (pass2Con.text.isEmpty) return showCustomToast('请再次输入新密码!');
          // if (pass2Con.text != pass1Con.text) return showCustomToast('两次密码不一致，请重新输入!');
          // if (yaoqingmaCon.text.isEmpty) return showCustomToast('请输入邀请码!');
          Request.post(
            '/app/user/updateWeixinMobile',
            isLoading: true,
            data: {
              "userId": widget.userId,
              "mobile": phoneCon.text,
              "code": codeCon.text,
            },
            catchError: (v) => showCustomToast(v),
            success: (v) async {
              showCustomToast('绑定成功');
              await Future.delayed(Duration(milliseconds: 500));
              // await userPro.refreshUserInfo(true);
              userPro.token = v['token'];
              userPro.tokenTime = DateTime.now().millisecondsSinceEpoch;
              userPro.setUserModel(v['result']);
              jumpPage(const App(), isClose: true, isMove: false);
            },
          );
        },
      ),
    ];
  }

  ///发送验证码
  Widget sendCodeView() {
    return PWidget.row([
      buildTFView(context, hintText: '请输入验证码', isExp: true, con: codeCon),
      CodeWidget(
        text: '获取验证码',
        tips: '秒后重新发送',
        phoneCon: phoneCon,
        successColor: pColor,
        errorColor: Colors.black26,
        callApi: (v) async {
          bool isSuccess = false;
          await Request.post(
            '/app/common/sendCode',
            isLoading: true,
            data: {"mobile": v},
            catchError: (v) => isSuccess = false,
            success: (v) => isSuccess = true,
          );
          return isSuccess;
        },
        childBuilder: (v, c) {
          return PWidget.container(PWidget.text(v, [c]), {
            'pd': PFun.lg(4, 4, 12, 12),
          });
        },
      ),
    ]);
  }
}
