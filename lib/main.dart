// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:liuliangchi/util/login_page.dart';

import 'package:liuliangchi/util/page/wode_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:liuliangchi/util/common_util.dart';
import 'package:liuliangchi/util/paxis_fun.dart';
import 'package:liuliangchi/util/widget/bnb_widget.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/tween_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:provider/provider.dart';

import 'util/config/common_config.dart';
import 'util/page/daiban_page.dart';
import 'util/page/gongneng_page.dart';
import 'util/page/work_page.dart';
import 'util/provider/provider_config.dart';

Future<void> getSvg(assets, c) => precacheImage(AssetImage(assets), c);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: pros, child: const MyApp()));
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1000 << 20;
  // SystemChrome.setEnabledSystemUIOverlays([]);
  RouteState.isMove = true;
  // RouteState.isHm = true;
  // RouteState.isHmMove = false;
  // RouteState.isMask = false;
  RouteState.setOffsetState(false);
  RouteState.animationTime = 250;
  RouteState.routeAnimationTime = 400;
  RouteState.animationCurve = const Cubic(0.35, 1.0, 0.04, 1.0);
  // Cubic(0.18, 1.0, 0.04, 1.0);
  RouteState.animationReverseCurve = const Cubic(0.65, 0.0, 0.96, 0.0);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {
  //   initData();
  //   super.initState();
  // }

  // ///初始化函数
  // Future initData() async {
  //   await ComonUtil.getPackageInfo();
  //   // setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return StyledToast(
      duration: const Duration(seconds: 3),
      locale: const Locale('zh'),
      backgroundColor: Colors.black,
      startOffset: const Offset(0, 0),
      endOffset: const Offset(0, -2),
      textStyle: const TextStyle(color: Colors.white),
      toastAnimation: StyledToastAnimation.slideFromBottomFade,
      reverseAnimation: StyledToastAnimation.slideToBottomFade,
      toastPositions: StyledToastPosition.bottom,
      animDuration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild!.unfocus();
          }
        },
        child: MaterialApp(
          title: '助销云',
          navigatorKey: navigatorKey,
          localizationsDelegates: [GlobalMaterialLocalizations.delegate],
          supportedLocales: [
            const Locale('zh'),
          ],
          // showPerformanceOverlay: true,
          debugShowCheckedModeBanner: false,
          scrollBehavior: MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
              PointerDeviceKind.unknown
            },
          ),
          theme: ThemeData(
            scaffoldBackgroundColor: Color(0xfff5f5f5),
            primaryColor: const Color(0xFFff9050),
            // accentColor: Color(0xFF000000),
            colorScheme: const ColorScheme.light()
                .copyWith(secondary: const Color(0xFF363636)),
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            splashFactory: InkRipple.splashFactory,
          ),
          builder: (context, widget) {
            return MediaQuery(
              //设置文字大小不随系统设置改变
              data: MediaQuery.of(context)
                  .copyWith(textScaleFactor: 1.0, boldText: true),
              child: widget!,
            );
          },
          home: const FlashPage(),
        ),
      ),
    );
  }
}

class FlashPage extends StatefulWidget {
  const FlashPage({Key? key}) : super(key: key);

  @override
  _FlashPageState createState() => _FlashPageState();
}

class _FlashPageState extends State<FlashPage> {
  Timer? timer;

  @override
  void initState() {
    ///判断是否第一次进入app
    super.initState();
    // userPro.isFirstTimeOpenApp().then((isFirst) {
    //   if (isFirst && Platform.isAndroid) {
    //     Future.delayed(Duration(seconds: 1)).then((_) => showGeneralDialog(
    //           context: context,
    //           barrierColor: Colors.transparent,
    //           pageBuilder: (_, __, ___) => UserXiayi(),
    //         ).then((v) => initData(v != null)));
    //   } else {
    initData();
    //   }
    // });
  }

  ///初始化函数
  Future initData([v = true]) async {
    if (!v) return;
    Future.wait([]);

    ///获取安卓设备信息
    ComonUtil.getAndroidInfo();

    ///获取本地用户信息
    await userPro.getUserInfo();

    await Future.delayed(const Duration(milliseconds: 1000));
    flog(user, 'user');
    if (user.isEmpty) {
      jumpPage(PhoneLogin(), isMove: false, isClose: true);
      // jumpPage(const App(), isMove: false, isClose: true);
    } else {
      // if (isNotNull(user['mobile'])) {
      jumpPage(const App(), isMove: false, isClose: true);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      brightness: Brightness.dark,
      // body: Image.asset(
      //   'assets/img/startup.png',
      //   width: double.infinity,
      //   height: double.infinity,
      //   fit: BoxFit.fill,
      // ),
      body: PWidget.column([
        buildLoad(color: Colors.black26),
        PWidget.boxh(24),
        PWidget.text('助销云', [Colors.black26, 24, true])
      ], '221'),
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  ///初始化函数
  Future initData() async {
    // await userPro.refreshUserInfo();
    // await ComonUtil.checkUpdateApp();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      btnBar: BnbWidget(callback: (i) => app.pageCon.jumpToPage(i)),
      resizeToAvoidBottomInset: false,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: app.pageCon,
        children: <Widget>[
          WorkPage(),
          DaibanPage(),
          GongnengPage(),
          WodePage()
        ],
      ),
    );
  }
}

///用户协议与隐私条款
class UserXiayi extends StatefulWidget {
  const UserXiayi({Key? key}) : super(key: key);

  @override
  _UserXiayiState createState() => _UserXiayiState();
}

class _UserXiayiState extends State<UserXiayi> with TickerProviderStateMixin {
  TextEditingController con = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ScaffoldWidget(
        bgColor: Colors.transparent,
        body: Container(
          color: Colors.black45,
          alignment: Alignment.center,
          child: TweenWidget(
            axis: Axis.vertical,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 24,
                    color: Colors.black54,
                    spreadRadius: -16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MyText('用户协议及隐私政策', size: 18, isBold: true),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 20),
                    child: MyText(
                      '平台非常重视用户的隐私和个人信息保护，并希望为您提供更好的服务。',
                      size: 13,
                      isOverflow: false,
                      textAlign: TextAlign.center,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Html(
                      data:
                          '''您在使用我们的服务前，我们将通过本<a href="11">《用户协议及隐私政策》</a>向您说明如何收集、使用、储存信息，以及我们为您提供的访问、更新等保护这些信息的方式。<br>请您仔细阅读，充分理解协议中的内容后再点击同意。''',
                      style: {
                        'a': Style(
                          color: Theme.of(context).primaryColor,
                          textDecoration: TextDecoration.none,
                        ),
                      },
                      onLinkTap: (v, _, __, ___) {
                        // jumpPage(
                        //   WebPage(title: {'11': '用户协议'}[v]),
                        //   isMove: false,
                        // );
                      },
                    ),
                  ),
                  PWidget.boxh(16),
                  PWidget.row([
                    PWidget.boxw(32),
                    PWidget.container(PWidget.text('取消', [pColor]), {
                      'bd': PFun.bdAllLg(pColor, 1.5),
                      'br': 56,
                      'ali': PFun.lg(0, 0),
                      'pd': PFun.lg(6, 6),
                      'exp': true,
                      'fun': () => exit(0),
                    }),
                    PWidget.boxw(16),
                    PWidget.container(
                      PWidget.text('确定', [Colors.white]),
                      [null, null, pColor],
                      {
                        'br': 56,
                        'ali': PFun.lg(0, 0),
                        'pd': PFun.lg(8, 8),
                        'exp': true,
                        'fun': () {
                          userPro.addFirstTimeOpenAppFlag();
                          close(true);
                        },
                      },
                    ),
                    PWidget.boxw(32),
                  ]),
                  PWidget.boxh(8),
                  // BtnWidget1(
                  //   isShowShadow: false,
                  //   titles: ['不同意并退出', '同意'],
                  //   bgColor: Colors.transparent,
                  //   btnHeight: [10, 12],
                  //   value: [50, 50],
                  //   time: [750, 750],
                  //   delayed: [0, 100],
                  //   axis: [Axis.vertical, Axis.vertical],
                  //   curve: [ElasticOutCurve(1), ElasticOutCurve(1)],
                  //   onTap: [
                  //     () => exit(0),
                  //     () {
                  //       userPro.addFirstTimeOpenAppFlag();
                  //       close(true);
                  //     },
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
