import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:liuliangchi/util/config/common_config.dart';
import 'package:paixs_utils/config/net/Config.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/progress_indicator.dart';

var userAgent =
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36';

class WebviewValue extends ValueNotifier {
  WebviewValue() : super(0);
  int progress = 0;
  void changeProgress(int v) {
    progress = v;
    Future(() => notifyListeners());
  }
}

class WebPage extends StatefulWidget {
  final String? title;

  const WebPage({Key? key, this.title}) : super(key: key);
  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> with TickerProviderStateMixin {
  ///外部传入的url
  var url;

  ///控制cookie回调只响应一次
  var flag = false;
  WebviewValue webviewValue = WebviewValue();
  InAppWebViewController? webViewController;
  var userAgent =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36';

  bool isJumpPage = false;

  ///cookie实例
  var cookie = CookieManager.instance();

  bool isOk = false;

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) web.WebView.platform = web.SurfaceAndroidWebView();
    switch (widget.title) {
      case '用户手册':
        // url = '${Config.ShareUrl}/help/yhxy.html';
        url = '${Config.ShareUrl}/help/yhxy.html';
        break;
      case '隐私协议':
        url = '${Config.ShareUrl}/help/ysxy.html';
        break;
      case '用户帮助':
        // url = '${Config.BaseUrl}:9003/maxmoneycloud-users/maxMoneyUserManual';
        break;
      case '关于我们':
        url = '${Config.ShareUrl}/help/about.html';
        // url = 'https://www.douyin.com/user/MS4wLjABAAAANZMoaFjhsEK-ibBetf8YGGhQt0QLOYbNHbNCYVJxgM2DwJheCq2EvbYuYHqKH2SM';
        break;
      default:
        url = widget.title;
        break;
    }
    flog(url);
  }

  ///回退方法
  Future goBack() async {
    if (!Platform.isMacOS) if (await webViewController!.canGoBack())
      return await webViewController!.goBack();
    close();
  }

  @override
  Widget build(BuildContext context) {
    flog(pmSize, 'scheme');
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: widget.title!,
        leftCallback: () => goBack(),
        isWhiteBg: true,
        // rigthWidget: PWidget.icon(Icons.close_rounded, [Colors.white], {'pd': 8}),
        // rightCallback: () => close(),
      ),
      body: Stack(
        children: [
          if (Platform.isAndroid || Platform.isIOS)
            InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(url)),
              onWebViewCreated: (v) {
                flog('开始抓取', DateTime.now().toString());
                webViewController = v;
              },
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(userAgent: userAgent),
              ),
              // initialOptions: InAppWebViewGroupOptions(
              //   crossPlatform: InAppWebViewOptions(userAgent: userAgent, useShouldOverrideUrlLoading: true),
              // ),
              // shouldOverrideUrlLoading: shouldOverrideUrlLoading,
              // onProgressChanged: (c, v) => webviewValue.changeProgress(v),
              onProgressChanged: (c, v) async {
                webviewValue.changeProgress(v);

                ///抖音数据模型
                // try {
                //   var douyinDm = DataModel(flag: 10);
                //   var body = await c.getHtml();
                //   var match = '<script id="RENDER_DATA" type="application/json">(.*?)</script>';
                //   if (!RegExp(match).hasMatch(body)) return;
                //   var firstMatch = RegExp(match).firstMatch(body);
                //   var jsonData = json.decode(Uri.decodeComponent(firstMatch.group(1)));
                //   var user = jsonData['36']['user']['user'];
                //   var list = douyinDm.list.where((w) => w['uid'] == user['uid']).toList();
                //   if (list.isNotEmpty) douyinDm.list.removeWhere((w) => w['uid'] == user['uid']);
                //   douyinDm.list.add(user);
                //   douyinDm.setTime();
                //   isOk = true;
                //   flog(douyinDm.toJson(), DateTime.now().toString());
                // } catch (e) {}
              },
              // onLoadStop: (con, url) async {
              //   if (isJumpPage) return;
              //   var cookies = await CookieManager.instance().getCookies(url: url);
              //   // // flog(cookies);
              //   // cookies.forEach((f) {
              //   //   flog(f.toJson(), 'scheme_cookie');
              //   // });
              //   var cookie = cookies.map((m) => '${m.name}=${m.value}').join(';');
              //   flog(cookie, 'scheme_cookie');
              //   if (cookie.contains('__ac_signature') && !flag) {
              //     flag = true;
              //     flog('获取到了', 'scheme_cookie');
              //   }
              //   if (flag) {
              //     flag = false;
              //     app.douyinCookie = cookie;
              //     isJumpPage = true;
              //     jumpPage(DouyinDataPage(), isMoveBtm: true, callback: (_) => isJumpPage = false);
              //     flog('我来了', 'scheme_cookie');
              //   }
              // },
            ),
          if (Platform.isWindows || Platform.isMacOS) textView(),
          if (Platform.isAndroid || Platform.isIOS)
            buildValueListenableBuilder1(),
          if (Platform.isAndroid || Platform.isIOS)
            buildValueListenableBuilder2(),
        ],
      ),
    );
  }

  ///跳转第三方app
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      controller, nav) async {
    if (!['http', 'https'].contains(nav.request.url.scheme)) {
      flog(nav.request.url.toString(), 'scheme');
      lunTelURL(nav.request.url.toString(), msg: '打开第三方应用失败');
      return NavigationActionPolicy.CANCEL;
    }
    return NavigationActionPolicy.ALLOW;
  }

  ValueListenableBuilder<dynamic> buildValueListenableBuilder2() {
    return ValueListenableBuilder(
      valueListenable: webviewValue,
      builder: (_, __, w) {
        var v = webviewValue.progress;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: v / 100),
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          // key: ValueKey(Random.secure()),
          builder: (_, v, w) {
            var sizedBox = SizedBox();
            var container = Container(
              alignment: Alignment.center,
              color: Colors.white.withOpacity(1.0 - v),
              child: Container(
                width: 24,
                height: 24,
                child: CircularProgressIndicatorWidget(
                  value: v,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ),
            );
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 250),
              child: (v == 1.0) ? sizedBox : container,
            );
          },
        );
      },
    );
  }

  ValueListenableBuilder<dynamic> buildValueListenableBuilder1() {
    return ValueListenableBuilder(
      valueListenable: webviewValue,
      builder: (_, __, w) {
        var v = webviewValue.progress;
        return AnimatedContainer(
          duration: Duration(milliseconds: 250),
          height: v >= 100 ? 0 : 2,
          width: size(context).width * (v / 100),
          color: Theme.of(context).primaryColor,
        );
      },
    );
  }

  Widget textView() {
    return PWidget.text(
      '暂不支持${Platform.operatingSystem}平台',
      [aColor.withOpacity(0.5), 16],
      {'ct': true},
    );
  }
}
