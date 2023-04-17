// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/paixs_widget.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';

import '../paxis_fun.dart';

// 分享模型
class ShareData {
  final String? title;
  final String? miaoshu;
  final String? url;
  final String? cover;
  ShareData({this.title, this.miaoshu, this.url, this.cover});
}

///分享组件
class ShareWidget extends StatefulWidget {
  final Widget? child;
  final ShareData? data;

  const ShareWidget({Key? key, this.data, this.child}) : super(key: key);
  @override
  _ShareWidgetState createState() => _ShareWidgetState();
}

class _ShareWidgetState extends State<ShareWidget> {
  @override
  Widget build(BuildContext context) {
    return WidgetTap(
      child: widget.child,
      onTap: () => showSheet(builder: (_) {
        return PWidget.container(
          PWidget.row(List.generate(2, (i) {
            return Expanded(
              child: WidgetTap(
                isElastic: true,
                // onTap: () async {
                //   Uint8List bodyBytes;
                //   if (isNotNull(widget.data.cover)) {
                //     buildShowDialog(context);
                //     var parse = Uri.parse('${Config.ImgBaseUrl}${widget.data.cover}?x-oss-process=image/resize,w_100');
                //     var res = await http.get(parse).catchError((v) {
                //       showCustomToast('网络连接失败');
                //     });
                //     close();
                //     if (res == null) return false;
                //     bodyBytes = res.bodyBytes;
                //     flog(bodyBytes.lengthInBytes);
                //     if (bodyBytes.lengthInBytes >= 32 * 1024) {
                //       bodyBytes = await FlutterImageCompress.compressWithList(bodyBytes, quality: 50);
                //       flog(bodyBytes.lengthInBytes);
                //     }
                //   }
                //   var description = widget.data.miaoshu.toString().replaceAll(RegExp('<[^>]+>'), '');
                //   await Wechat.instance.shareWebpage(
                //     webpageUrl: widget.data.url,
                //     scene: [WechatScene.SESSION, WechatScene.TIMELINE][i],
                //     thumbData: bodyBytes == null ? null : bodyBytes,
                //     description: description.substring(0, (description.length > 100) ? 100 : description.length),
                //     title: widget.data.title.substring(0, (widget.data.title.length > 50) ? 50 : widget.data.title.length),
                //   );
                //   close();
                // },
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(height: 16),
                  Image.asset(
                      [
                        'assets/img/share/yaoqing_wx.png',
                        'assets/img/share/yapqing_pyq.png'
                      ][i],
                      width: 42,
                      height: 42),
                  SizedBox(height: 8),
                  MyText(['微信', '朋友圈'][i], size: 12),
                  SizedBox(height: 16),
                ]),
              ),
            );
          })),
          [null, null, Colors.white],
          {'br': PFun.lg(12, 12), 'pd': PFun.lg(16, 16)},
        );
      }),
    );
  }
}
