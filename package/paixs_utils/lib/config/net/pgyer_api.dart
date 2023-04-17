import 'dart:convert';
import 'dart:developer';
import 'dart:convert' as convert;
import 'Config.dart';
import 'api.dart';
import 'package:encrypt/encrypt.dart' as XYQ;

final Http http = Http();

///加密链接
var encryptedLink = [];

class Http extends BaseHttp {
  @override
  void init() {
    options.baseUrl = Config.BaseUrl;
    interceptors.add(PgyerApiInterceptor());
  }
}

/// App相关 API
class PgyerApiInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options, h) async {
    try {
      log('${options.method}', name: '${options.path.split('?').first}：Method');
      log('${options.baseUrl}${options.path}',
          name: '${options.path.split('?').first}：Url');
      // log('${options.path.split('?').last.split('&')}', name: '${options.path.split('?').first}：Token');
      log('${options.path.split('?').last.split('&').last.split('=').last}',
          name: '${options.path.split('?').first}：Version');
      // log('${}', name: '${options.path}：UserId');
      if (options.method == 'GET') {
        log(convert.json.encode(options.queryParameters),
            name: '${options.path.split('?').first}：发送数据');
      } else {
        log(convert.json.encode(options.data),
            name: '${options.path.split('?').first}：发送数据');
      }
      // var s = decryptedFun('jkl;POIU1234++==', 'Oa1NPBSarXrPH8wqSRhh3g==');
      // flog(s);
      var path = options.path.split('?').first.toString();
      if (encryptedLink.contains(path)) {
        // var md5 = generateMd5(path);
        String str = encryptedFun(json.encode(options.data));
        options.data = {'parameter': str};
        if (options.method == 'GET') {
          log(convert.json.encode(options.queryParameters),
              name: '${options.path.split('?').first}：发送数据-加密参数');
        } else {
          log(convert.json.encode(options.data),
              name: '${options.path.split('?').first}：发送数据-加密参数');
        }
      }
    } catch (e) {
      // var dioError = e as DioError;
      // log(dioError.response.data);
      log(e.toString() + '====');
      // var str = options.path.split('/').last;
      // log('${options.baseUrl}${options.path}', name: '接口：$str/Url');
      // log('${getNull(options.headers['Authorization'])}', name: '接口：$str/Token');
      // log(convert.json.encode(options.data), name: '接口：$str/发送数据');
      // if (!options.path.contains('upload')) log(convert.json.encode(options.data), name: '接口：$str/发送数据');
    }

    ///延时请求250毫秒
    // await Future.delayed(Duration(milliseconds: 250));
    return h.next(options);
  }

  getNull(v) => v == '' ? null : v;

  @override
  onResponse(Response response, h) {
    if (response.data['jmType'] == true) {
      var decrypted = decryptedFun(response.data['result']
          .toString()
          .replaceAll(RegExp('\r|\n|\\s'), ""));
      response.data['result'] = json.decode(decrypted);
    }

    /// 将小数点保留两位
    if (response.data['result'] is Map) {
      formatDouble(response.data['result']);
      if (response.data['result']['data'] != null) {
        (response.data['result']['data'] as List).forEach((f) {
          if (f['goods'] != null) formatDouble(f['goods']);
          return formatDouble(f);
        });
      }
    } else if (response.data['result'] is List) {
      (response.data['result'] as List).forEach((f) {
        if (f['goods'] != null) formatDouble(f['goods']);
        return formatDouble(f);
      });
    }
    // try {
    // encryptedFun('');
    // } catch (e) {
    //   flog(e);
    // }
    // var jsonStr = {'as': 'sdsd'};
    // var jsonData = json.decode(json.encode(jsonStr));
    return h.next(response);
  }
}

class ResponseData extends BaseResponseData {
  final RequestOptions options;
  bool get success => code == 'success';

  ResponseData.fromJson(Map<String, dynamic> json, this.options) {
    if (json != null) {
      code = json['resultCode'];
      message = json['resultMsg'];
      data = json['result'];
      if (data is Map) {
        formatDouble(data);
      } else if (data is List) {
        (data as List).forEach((f) => formatDouble(f));
      }
    }
    try {
      var str = options.path.split('/').last;
      log(convert.json.encode(json),
          name: '接口：${str.substring(0, str.indexOf('?'))}/请求响应');
      try {
        log(convert.json.encode(json['result']['data'][0]),
            name: '接口：${str.substring(0, str.indexOf('?'))}/序列1的对象');
      } catch (e) {
        // log('暂无序列1', name: '接口：${str.substring(0, str.indexOf('?'))}/序列1的对象');
      } finally {
        log('\n\n', name: '换行');
      }
    } catch (e) {
      var str = options.path.split('/').last;
      log(convert.json.encode(json), name: '接口：$str/请求响应');
      try {
        log(convert.json.encode(json['result']['data'][0]),
            name: '接口：$str/序列1的对象');
      } catch (e) {
        // log('暂无序列1', name: '接口：$str/序列1的对象');
      } finally {
        log('\n\n', name: '换行');
      }
    }
  }
}

formatDouble(Map data) {
  data.keys.forEach((f) {
    // flog(f, 'formatDouble ${data[f] is double}:${data[f]}');
    if (data[f] is double)
      data[f] = double.parse((data[f] as double).toStringAsFixed(2));
  });
}

/// 加密
String encryptedFun(data) {
  // aes(data)  AES加密
  final key = XYQ.Key.fromUtf8('b905b0e9b257ccba');
  final encrypter = XYQ.Encrypter(XYQ.AES(key, mode: XYQ.AESMode.ecb));
  final encrypted =
      encrypter.encrypt(data.toString(), iv: XYQ.IV.fromLength(16));
  return encrypted.base64;
}

/// 解密
String decryptedFun(data) {
  final key = XYQ.Key.fromUtf8('b905b0e9b257ccba');
  final encrypter = XYQ.Encrypter(XYQ.AES(key, mode: XYQ.AESMode.ecb));
  // final encrypted = encrypter.encrypt(data, iv: XYQ.IV.fromLength(16));
  final decrypted = encrypter.decrypt(XYQ.Encrypted.fromBase64(data),
      iv: XYQ.IV.fromLength(16));
  return decrypted;
}
