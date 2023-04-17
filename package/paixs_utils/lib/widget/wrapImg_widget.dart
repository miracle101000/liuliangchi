import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paixs_utils/config/net/Config.dart';
import 'package:paixs_utils/config/net/api.dart';
import 'package:paixs_utils/src/model.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/route.dart';
import '../src/client.dart';
import '../util/utils.dart';
import '../widget/photo_widget.dart';
import '../widget/views.dart';

import 'image.dart';

class WrapImgWidget extends StatefulWidget {
  final List<String> imgs;
  final double spacing;
  final double remove;
  final EdgeInsets margin;
  final double? radius;
  final double? height;
  final int count;
  final int w;
  final bool isUpload;
  final String? uploadTips;
  final Widget? uploadView;
  final Color? bgColor;
  final int maxCount;
  final void Function(List<String>)? callback;

  const WrapImgWidget({
    Key? key,
    required this.imgs,
    this.spacing = 8,
    this.count = 3,
    required this.remove,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.w = 100,
    this.isUpload = false,
    this.uploadTips,
    this.uploadView,
    this.maxCount = 1,
    this.callback,
    this.radius,
    this.height,
    this.bgColor,
  }) : super(key: key);

  @override
  WrapImgWidgetState createState() => WrapImgWidgetState();
}

class WrapImgWidgetState extends State<WrapImgWidget> {
  var imgs = <String>[];

  @override
  void initState() {
    super.initState();
    initData();
  }

  ///初始化函数
  Future initData() async {
    imgs = widget.imgs.sublist(0);
  }

  @override
  Widget build(BuildContext context) {
    var random = Random().nextInt(9999);
    var wh = size(context).width / widget.count -
        (widget.remove + (widget.spacing * (widget.count - 1))) / widget.count;
    if ((widget.imgs == null || widget.imgs.isEmpty) && !widget.isUpload) {
      return SizedBox();
    } else {
      return Container(
        margin: widget.margin,
        child: Wrap(
          spacing: widget.spacing,
          runSpacing: widget.spacing,
          children: List.generate(
              widget.imgs.length +
                  (widget.imgs.length == widget.maxCount
                      ? 0
                      : (widget.isUpload ? 1 : 0)), (i) {
            if (i == widget.imgs.length) {
              return GestureDetector(
                onTap: () async {
                  if (imgs.length < widget.maxCount) {
                    // Navigator.pop(context);
                    // await Future.delayed(Duration(milliseconds: 500));
                    var pickedFile = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      buildShowDialog(context, isClose: false);
                      try {
                        var dir = await this.initOss();
                        if (dir != '') {
                          var data = await uploadImageNew(dir, pickedFile.path);
                          if (data != null)
                            setState(() => imgs.insert(0, data));
                        }
                      } catch (e) {
                      } finally {
                        widget.callback!(imgs);
                        Navigator.of(context).pop();
                      }
                    }
                    await pickImages(
                      maxImages: 1,
                      isCrop: true,
                      cropFun: (v) async {
                        if (v != null) {
                          buildShowDialog(context, isClose: false);
                          try {
                            var data = await uploadImage(await v.path);
                            setState(() => imgs.insert(0, data));
                          } catch (e) {
                          } finally {
                            widget.callback!(imgs);
                            Navigator.pop(context);
                          }
                        }
                      },
                    );
                    if (1 != 1)
                      showSheet(builder: (v) {
                        return Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                // ignore: deprecated_member_use
                                child: TextButton(
                                  // padding: EdgeInsets.all(
                                  //     Platform.isMacOS ? 24 : 16),
                                  child: Text('拍照',
                                      style: TextStyle(fontSize: 16)),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    var pickImage2 = ImagePicker().getImage(
                                      source: ImageSource.camera,
                                    );
                                    var pickImage = pickImage2;
                                    var file = await pickImage;
                                    if (file == null) {
                                    } else {
                                      buildShowDialog(context, isClose: false);
                                      var data = await uploadImage(file.path);
                                      Navigator.pop(context);
                                      setState(() => imgs.insert(0, data));
                                      widget.callback!(imgs);
                                    }
                                  },
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Colors.black.withOpacity(0.05),
                              ),
                              Container(
                                width: double.infinity,
                                // ignore: deprecated_member_use
                                child: TextButton(
                                  // padding: EdgeInsets.all(
                                  //     Platform.isMacOS ? 24 : 16),
                                  child: Text('从相册选择',
                                      style: TextStyle(fontSize: 16)),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await pickImages(
                                      maxImages: 1,
                                      isCrop: true,
                                      cropFun: (v) async {
                                        if (v != null) {
                                          buildShowDialog(context,
                                              isClose: false);
                                          try {
                                            var data =
                                                await uploadImage(await v.path);
                                            setState(
                                                () => imgs.insert(0, data));
                                          } catch (e) {
                                          } finally {
                                            widget.callback!(imgs);
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                              Container(
                                height: 8,
                                color: Colors.black.withOpacity(0.05),
                              ),
                              Container(
                                width: double.infinity,
                                // ignore: deprecated_member_use
                                child: TextButton(
                                  // padding: EdgeInsets.all(
                                  //     Platform.isMacOS ? 24 : 16),
                                  child: Text('取消',
                                      style: TextStyle(fontSize: 16)),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                  } else {
                    showToast('最多只能上传${widget.maxCount}张');
                  }
                  return;
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.radius ?? 8),
                  child: Container(
                    height: widget.height ?? wh,
                    width: wh,
                    color: widget.bgColor ?? Colors.black.withOpacity(0.05),
                    alignment: Alignment.center,
                    child: widget.uploadView ??
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_rounded, color: Colors.black45),
                            MyText(
                              widget.uploadTips ?? '照片/视频',
                              color: Colors.black45,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  jumpPage(
                    PhotoView(
                        images: imgs,
                        index: i,
                        flag: widget.isUpload ? 1.0 : 0.0),
                    isMoveBtm: true,
                    callback: !widget.isUpload
                        ? (v) {}
                        : (v) {
                            setState(() {});
                            widget.callback!(imgs);
                          },
                  );
                  // push(
                  //   context,
                  //   PhotoView(images: widget.imgs, index: i),
                  //   // isMove: false,
                  //   isMoveBtm: true
                  // );
                },
                child: Hero(
                  tag: '${widget.imgs[i]}$random',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.radius ?? 8),
                    child: WrapperImage(
                      url: widget.imgs[i],
                      width: wh,
                      height: widget.height ?? wh,
                      w: widget.w,
                    ),
                  ),
                ),
              );
            }
          }),
        ),
      );
    }
  }

  ///上传图片
  Future<String?> uploadImageNew(fileName, String path) async {
    flog(path, 'path');
    String? url;
    var file = File(path);
    // var uint8list = await file.readAsBytes();
    try {
      var ossObject = await OSSClient().putObject(
        object: OSSImageObject.fromFile(file: file, uuid: ''),
        path: fileName,
      );
      // var response = await OSSClient().putObject(uint8list.toList(), fileName);
      // flog(ossObject.uuid, 'response.data');
      url = ossObject.url.split('/').last;
      flog(url, 'url');
    } catch (e) {
      flog(e, '错误');
      showToast('上传失败');
    }
    return url;
  }

  ///初始化阿里云oss
  String? tokenGetter;
  Future<String> initOss() async {
    // 初始化OSSClient
    var key = '';
    var res = await Dio()
        .post(Config.BaseUrl + '/app/oss/getPolicy')
        .catchError((e) {});
    if (res != null) {
      flog(jsonEncode(res.data));
      var ossRes = res.data['result'];
      if (ossRes == null) return key;
      tokenGetter = jsonEncode({
        'AccessKeyId': ossRes['accessid'],
        'AccessKeySecret': ossRes['accessSecret'],
        'SecurityToken': ossRes['policy'],
        'Expiration': DateTime.fromMillisecondsSinceEpoch(
                int.parse(ossRes['expire']) * 1000)
            .toIso8601String(),
      });
      flog(tokenGetter, 'stsCertificate');
      // OSSClient.init(
      //   endpoint: ossRes['host_mobile'],
      //   bucket: ossRes['bucketName'],
      //   credentials: () => Future.value(Credentials(
      //     accessKeyId: ossRes['accessid'],
      //     accessKeySecret: ossRes['accessSecret'],
      //   )),
      // );
      OSSClient.init(
        endpoint: ossRes['host_mobile'],
        bucket: ossRes['bucketName'],
        credentials: () => Future.value(Credentials(
          accessKeyId: ossRes['accessid'],
          accessKeySecret: ossRes['accessSecret'],
        )),
      );
      // aliyun.Client.init(
      //   ossEndpoint: ossRes['host_mobile'],
      //   bucketName: ossRes['bucketName'],
      //   tokenGetter: () async => tokenGetter,
      // );
      var dirRes = await Dio()
          .post(Config.BaseUrl + '/app/oss/getDir')
          .catchError((e) {});
      if (dirRes != null) {
        key = dirRes.data['result']['dir'];
      }
    }
    flog(key, 'key');
    return key;
  }
}
