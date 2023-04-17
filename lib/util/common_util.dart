import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:paixs_utils/config/net/api.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'config/common_config.dart';
import 'http.dart';
import 'paxis_fun.dart';
import 'provider/provider_config.dart';
import 'widget/progress_dialog.dart';

bool isNotNull(data) => data != null && data != '' && data != 'null';

///千位符
String format(number, [i]) {
  // flog(number);
  number = number ?? '0';
  var formatter = NumberFormat.simpleCurrency(name: '', decimalDigits: i ?? 4);
  var s = double.parse('$number').toStringAsFixed(4);
  return formatter.format(double.parse(s));
}

///double转换
String toStrAsFixed(data, {int digits = 2, bool isBfb = true}) {
  var s = (double.parse('${data ?? 0}') * (isBfb ? 100 : 1))
      .toStringAsFixed(digits);
  return s;
}

///手机号转星号
String toAsterisk({String v = ''}) {
  RegExp reg = RegExp(
      r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
  if (!reg.hasMatch(v)) return v;
  return '${v.substring(0, 3)}*****${v.substring(8)}';
}

String isNullStr(TextEditingController con,
    [String s = '', bool isBfb = false]) {
  if (con.text.isEmpty) {
    return s;
  } else {
    if (isBfb) {
      return (double.parse(con.text) / 100).toString();
    } else {
      return con.text;
    }
  }
}

///展示定制吐司
ToastFuture showCustomToast(msg) {
  ///键盘是否弹出
  var isKeyboardPopup = MediaQuery.of(context).viewInsets.bottom != 0.0;
  return showToast(
    msg.toString().replaceAll(',', '，'),
    position:
        isKeyboardPopup ? StyledToastPosition.top : StyledToastPosition.bottom,
    startOffset: Offset(0, isKeyboardPopup ? 1.8 : -1.8),
    backgroundColor: Colors.black.withOpacity(0.8),
    endOffset: Offset(0, isKeyboardPopup ? 2 : -2),
    reverseEndOffset: Offset(0, isKeyboardPopup ? 0.8 : -0.8),
    reverseStartOffset: Offset(0, isKeyboardPopup ? 1 : -1),
    animation: StyledToastAnimation.slideFromBottomFade,
  );
}

///是否登录
void isLoginFun(fun) {
  // if (user == null) return jumpPage(PhoneLogin('验证码登录'));
  fun();
}

class ComonUtil {
  ///获取包信息
  static Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    app.packageInfo = packageInfo;
    flog(app.packageInfo!.appName, '获取包信息appName');
    flog(app.packageInfo!.buildNumber, '获取包信息buildNumber');
    flog(app.packageInfo!.packageName, '获取包信息packageName');
    flog(app.packageInfo!.version, '获取包信息version');
  }

  ///获取安卓设备信息
  static Future<void> getAndroidInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo;
    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
      app.androidInfo = androidInfo;
      flog(jsonEncode(app.androidInfo!.toMap()), '获取设备信息');
    }
  }

  ///检测app更新
  static Future<void> checkUpdateApp([bool isToast = false]) async {
    if (Platform.isIOS || app.packageInfo == null) return;
    // if (!isToast) await Future.delayed(Duration(milliseconds: 3000));
    await Request.post(
      '/app/common/getAppVersion',
      data: {'platform': Platform.isAndroid ? 2 : 1},
      isLoading: isToast,
      dialogText: '正在检查更新...',
      isToken: false,
      catchError: (v) => showCustomToast(v),
      success: (v) {
        v = v['result'];
        if (v == null) return isToast ? showToast('当前版本是最新的') : null;
        if (int.parse(v['versionNum']) >
            int.parse(app.packageInfo!.buildNumber)) {
          showTcWidget(
            isNormal: true,
            isClose: v['isForcedUpdate'] == 0,
            horizontal: 32,
            child: UpdatePopup(
              v['description'],
              v['updateUrl'],
              v['version'],
              app.packageInfo!.version,
              data: v,
            ),
          );
        } else {
          if (isToast) showToast('已是最新版');
        }
        // v['isUpdate'] = 1;
        // showTc(
        //   onPressed: () => executeDownload(context, v['url'], v['version']),
        //   isDark: true,
        //   isCenter: false,
        //   isAutoClose: false,
        //   isClose: v['isUpdate'] == 0,
        //   lineH: 1.5,
        //   titleWidget: PWidget.ccolumn([
        //     MyText('版本更新说明', size: 18, color: Colors.white),
        //     MyText('V${v['version']}', isOverflow: false, color: Colors.white),
        //   ]),
        //   content: v['content'],
        //   okText: '更新',
        //   isTips: v['isUpdate'] == 1,
        // );
      },
    );
  }
}

///更新弹窗
class UpdatePopup extends StatefulWidget {
  final String content;
  final String url;
  final String banben;
  final String pgkVer;
  final Map? data;

  const UpdatePopup(this.content, this.url, this.banben, this.pgkVer,
      {Key? key, this.data})
      : super(key: key);
  @override
  _UpdatePopupState createState() => _UpdatePopupState();
}

class _UpdatePopupState extends State<UpdatePopup> {
  static String appPath = '';
  static ProgressDialog? pr;

  /// 下载最新apk包
  static Future<void> executeDownload(BuildContext context, url, v) async {
    final directory = await getExternalStorageDirectory();
    String path = directory!.path + Platform.pathSeparator + 'Download';
    var file = File(path + Platform.pathSeparator + '$v.apk');
    var hasExists = await file.exists();
    appPath = path;
    if (hasExists) {
      if (await Permission.storage.request().isGranted) {
        _installApk(v);
      }
    } else {
      if (context.mounted) {
        pr = ProgressDialog(
          context,
          type: ProgressDialogType.Download,
          isDismissible: false,
          showLogs: true,
        );
      }
      pr!.style(message: '准备下载...');
      if (!pr!.isShowing()) {
        pr!.show();
      }
      final path = await _apkLocalPath;
      Dio dio = new Dio();
      await dio.download(url, path + '/' + '$v.apk',
          onReceiveProgress: (received, total) async {
        if (total != -1) {
          ///当前下载的百分比例
          print((received / total * 100).toStringAsFixed(0) + "%");
          double currentProgress = received / total;
          // setState(() {
          pr!.update(
            progress: double.parse(
                (currentProgress * 100.0).toStringAsExponential(1)),
            maxProgress: 100,
            message: "正在下载...",
          );
          // });
          if (currentProgress == 1.0) {
            pr!.dismiss();
            if (await Permission.storage.request().isGranted) {
              _installApk(v);
            }
          }
        }
      });
    }
  }

  /// 安装apk
  static Future<Null> _installApk(v) async {
    await OpenFile.open(appPath + '/' + '$v.apk');
  }

  /// 获取apk存储位置
  static Future<String> get _apkLocalPath async {
    final directory = await getExternalStorageDirectory();
    String path = directory!.path + Platform.pathSeparator + 'Download';
    final savedDir = Directory(path);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      await savedDir.create();
    }
    appPath = path;
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset('assets/img/home/update_bg.png'),
          PWidget.positioned(
            PWidget.text('', [], {}, [
              PWidget.textIs('发现新版本\n', [Colors.white, 16]),
              PWidget.textIs('v${widget.banben}', [Colors.white, 10])
            ]),
            [13, null, 17],
          ),
          PWidget.positioned(
            Image.asset(
              'assets/img/home/update_icon.png',
              width: 60,
              height: 120,
            ),
            [-28, null, null, 54],
          ),
          PWidget.positioned(
            PWidget.column([
              PWidget.boxh(120),
              PWidget.text(widget.content, [
                Color(0xff666666)
              ], {
                'isOf': false,
                'h': 1.5,
                'exp': true,
              }),
              PWidget.row([
                PWidget.container(PWidget.text('稍后再说', [pColor]), {
                  'bd': PFun.bdAllLg(pColor, 1.5),
                  'br': 56,
                  'ali': PFun.lg(0, 0),
                  'pd': PFun.lg(6, 6),
                  'exp': true,
                  'fun': () => close(),
                }),
                PWidget.boxw(16),
                PWidget.container(
                  PWidget.text('立即更新', [Colors.white]),
                  [null, null, pColor],
                  {
                    'br': 56,
                    'ali': PFun.lg(0, 0),
                    'pd': PFun.lg(8, 8),
                    'exp': true,
                    'fun': () =>
                        executeDownload(context, widget.url, widget.banben),
                  },
                ),
              ]),
            ]),
            [0, 26, 16, 16],
          ),
        ],
      ),
    );
  }
}
