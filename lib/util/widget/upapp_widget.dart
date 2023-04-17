import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:paixs_utils/config/net/api.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/tween_widget.dart';
import 'package:paixs_utils/widget/widget_tap.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'progress_dialog.dart';

class UpappWidget extends StatefulWidget {
  final String content;
  final String url;
  final String banben;
  final String pgkVer;
  final Map? data;

  const UpappWidget(this.content, this.url, this.banben, this.pgkVer,
      {Key? key, this.data})
      : super(key: key);
  @override
  _UpappWidgetState createState() => _UpappWidgetState();
}

class _UpappWidgetState extends State<UpappWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: TweenWidget(
        axis: Axis.vertical,
        // isOpen: true,
        curve: ElasticOutCurve(2),
        value: 50,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      // Transform.translate(
                      //   offset: Offset(0, -2),
                      //   child: Image.asset(
                      //     'assets/djs2/更新_03.png',
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 24, right: 24, bottom: 24, top: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              '更新内容：',
                              size: 16,
                              isBold: true,
                              isOverflow: false,
                            ),
                            SizedBox(height: 8),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(widget.content, color: Colors.black54),
                                Divider(height: 16, color: Colors.transparent),
                                PWidget.container(
                                  MyText('立即更新', size: 16, color: Colors.white),
                                  {
                                    'gd': [
                                      Color(0xfff52c4b),
                                      Theme.of(context).primaryColor,
                                      -1,
                                      -1,
                                      1,
                                      1
                                    ],
                                    'pd': 12,
                                    'br': 56,
                                    'ali': [0, 0],
                                    'tap': true,
                                    'fun': () => executeDownload(
                                        context, widget.url, widget.banben),
                                  },
                                ),
                                if (widget.data!['isUpdate'] != 1)
                                  Divider(
                                      height: 16, color: Colors.transparent),
                                if (widget.data!['isUpdate'] != 1)
                                  WidgetTap(
                                    onTap: () => close(),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: MyText('取消', size: 16),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String appPath = '';
ProgressDialog? pr;

/// 下载最新apk包
Future<void> executeDownload(BuildContext context, url, v) async {
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
    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Download,
      isDismissible: false,
      showLogs: true,
    );
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
          progress:
              double.parse((currentProgress * 100.0).toStringAsExponential(1)),
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
Future<Null> _installApk(v) async {
  await OpenFile.open(appPath + '/' + '$v.apk');
}

/// 获取apk存储位置
Future<String> get _apkLocalPath async {
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
