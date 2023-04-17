import 'package:flutter/material.dart';
import '../util/utils.dart';
import 'net/Config.dart';

class ImageHelper {
  // static const String baseUrl = Config.ImgBaseUrl;
  // static const String imagePrefix = '$baseUrl/';

  static String wrapUrl(String url, {int w = 0, String? imgUrl}) {
    if (url.startsWith('http')) {
      return url + (w == 0 ? '' : '?x-oss-process=image/resize,w_$w');
    }
    if (url.trim().isEmpty) {
      return randomUrl(); //默认
    }
    String path =
        '${imgUrl ?? Config.ImgBaseUrl}$url${w == 0 ? '' : '?x-oss-process=image/resize,w_$w'}';
    flog(path, 'path');
    return path;
  }

  static String wrapAssets(String url) {
    return url;
  }

  static Widget placeHolder(v, {double? width, double? height}) {
    // return Container(width: width, height: height, color: Colors.white);
    // return ColoredBox(
    //   color: Colors.black.withOpacity(0.05),
    //   child: Center(
    //     child: SizedBox(
    //       width: 16,
    //       height: 16,
    //       child: LoadingIndicator(
    //         color: Colors.black26,
    //         indicatorType: Indicator.lineSpinFadeLoader,
    //       ),
    //     ),
    //   ),
    // );
    return Container(
      width: width,
      height: height,
      color: HSVColor.fromAHSV(1, (v.hashCode) % 360.0, 0.1, 1).toColor(),
    );
  }

  static Widget error({
    double? width,
    double? height,
    double? size,
    Color? color,
  }) {
    // return SizedBox(
    //   width: width,
    //   height: height,
    //   child: Icon(
    //     Icons.error_outline,
    //     size: size,
    //     color: color,
    //   ),
    // );
    return ColoredBox(
      color: Colors.black.withOpacity(0.05),
      child: Center(
        child: Icon(
          Icons.error_outline,
          size: size,
          color: color,
        ),
      ),
    );
  }

  static String randomUrl(
      {int width = 100, int height = 100, Object key = ''}) {
    return 'http://placeimg.com/$width/$height/${key.hashCode.toString() + key.toString()}';
  }
}

class IconFonts {
  IconFonts._();

  /// iconfont:flutter base
  static const String fontFamily = 'iconfont';

  static const IconData pageEmpty = IconData(0xe63c, fontFamily: fontFamily);
  static const IconData pageError = IconData(0xe600, fontFamily: fontFamily);
  static const IconData pageNetworkError =
      IconData(0xe678, fontFamily: fontFamily);
  static const IconData pageUnAuth = IconData(0xe65f, fontFamily: fontFamily);
}
