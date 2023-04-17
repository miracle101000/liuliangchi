import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:paixs_utils/config/net/api.dart';
import 'package:paixs_utils/config/net/pgyer_api.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/views.dart';

import 'provider/provider_config.dart';

/// await Request.post('url',
///  data: {},
///  success:(data){},
///  fail:(data){},
///  catchError:(e){}
/// );

class Request {
  static Future<void> postAll(
    List<String> urls, {
    dynamic data,
    bool isToken = true,
    bool isLoading = false,
    Function(dynamic)? success,
    Function(dynamic)? fail,
    Function(dynamic)? catchError,
    String? dialogText,
    Options? option,
    BuildContext? context,
  }) async {
    await Future(() async {
      if (isLoading) buildShowDialog(context, text: dialogText);
      var options;
      if (Platform.isAndroid) {
        options = Options(headers: {
          'ACCESS-DEVICE':
              '${app.androidInfo!.manufacturer}-${app.androidInfo!.model}-${app.androidInfo!.version.sdkInt}-${app.androidInfo!.version.incremental}',
        });
      }
      // flog(options.headers);
      // var res = await http.post(url, data: data, options: option ?? options).catchError((e) {
      // flog('${(user)['id']}', '$url：UserId');
      // await Future.delayed(Duration(milliseconds: 100));
      var epoch = DateTime.now().millisecondsSinceEpoch;
      // flog(userPro.tokenTime);
      if (isToken &&
          Duration(milliseconds: epoch - (userPro.tokenTime)).inHours >= 2) {
        await userPro.getToken();
      }
      var token =
          'TOKEN=${userPro.token ?? ''}&VERSION=${app.packageInfo?.version}';
      // await Future.delayed(Duration(milliseconds: 2000000));
      List<Future<Response>> futures = [];
      for (int i = 0; i < urls.length; i++) {
        futures.add(http.post(
            'https://appapi.gongkecrm.com${urls[i]}${urls[i].contains('?') ? '&$token' : '?$token'}',
            data: data,
            options: Platform.isAndroid ? null : options));
      }
      var responses = await Future.wait(futures);
      if (isLoading) close();
      var results = [];
      for (var res in responses) {
        results.add(res);
      }

      success!(results);
    });
  }

  static Future<void> post(
    String url, {
    dynamic data,
    bool isToken = true,
    bool isLoading = false,
    Function(dynamic)? success,
    Function(dynamic)? fail,
    Function(dynamic)? catchError,
    String? dialogText,
    Options? option,
    BuildContext? context,
  }) async {
    await Future(() async {
      if (isLoading) buildShowDialog(context, text: dialogText);
      var options;
      if (Platform.isAndroid) {
        options = Options(headers: {
          'ACCESS-DEVICE':
              '${app.androidInfo!.manufacturer}-${app.androidInfo!.model}-${app.androidInfo!.version.sdkInt}-${app.androidInfo!.version.incremental}',
        });
      }
      // flog(options.headers);
      // var res = await http.post(url, data: data, options: option ?? options).catchError((e) {
      // flog('${(user)['id']}', '$url：UserId');
      // await Future.delayed(Duration(milliseconds: 100));
      var epoch = DateTime.now().millisecondsSinceEpoch;
      // flog(userPro.tokenTime);
      if (isToken &&
          Duration(milliseconds: epoch - (userPro.tokenTime)).inHours >= 2) {
        await userPro.getToken();
      }
      var token =
          'TOKEN=${userPro.token ?? ''}&VERSION=${app.packageInfo?.version}';
      // await Future.delayed(Duration(milliseconds: 2000000));
      print(
          'https://appapi.gongkecrm.com${url}${url.contains('?') ? '&$token' : '?$token'}');
      var res = await http.post(
          'https://appapi.gongkecrm.com${url}${url.contains('?') ? '&$token' : '?$token'}',
          data: data,
          options: Platform.isAndroid ? null : options);
      if (isLoading) close();
      if (res != null) {
        if (res.statusCode == 200) {
          if (res.data['resultCode'] == 'success') {
            flog(json.encode(res.data), '$url：成功');
            if (success != null) {
              try {
                success(res.data);
              } catch (e) {
                flog(e);
                if (catchError != null) catchError('网络连接失败～');
              }
            }
          } else {
            flog(json.encode(res.data), '$url：失败');
            if (catchError != null) {
              catchError(res.data['resultMsg'] ?? res.data['resultMsg']);
            }
            if ((res.data['resultMsg'] ?? res.data['resultMsg'])
                .toString()
                .contains('登录信息已过期')) {
              // jumpPage(PhoneLogin('验证码登录'));
            }
          }
        } else {
          flog(res.data, '$url：失败');
          if (catchError != null) catchError(res.statusMessage);
          // if (fail != null) fail(res.statusMessage);
        }
      }
      // if (res != null) {
      //   if (res.statusCode == 200) {
      //     success == null ? flog(res.data, '成功') : success(res.data);
      //   } else {
      //     fail == null ? flog(res.data, '失败') : fail(res.statusMessage);
      //   }
      // }
    });
  }

  // static Future<void> delete(
  //   String url, {
  //   dynamic data,
  //   bool isToken = true,
  //   bool isLoading = false,
  //   Function(dynamic) success,
  //   Function(dynamic) fail,
  //   Function(dynamic) catchError,
  //   String dialogText,
  // }) async {
  //   await Future(() async {
  //     if (isLoading) buildShowDialog(context, text: dialogText);
  //     // var options = Options(headers: {'Authorization': isToken ? SpUtil.getString(Constant.token) : ''});
  //     // var res = await http.delete(url, data: data, options: options).catchError((e) {
  //     var res = await http.delete(url, data: data).catchError((e) {
  //       catchError == null ? flog(e, '异常') : catchError(e);
  //     });
  //     if (isLoading) close();
  //     if (res != null) {
  //       if (res.statusCode == 204) {
  //         success == null ? flog(res.data, '成功') : success(res.data);
  //       } else {
  //         fail == null ? flog(res.data, '失败') : fail(res.statusMessage);
  //       }
  //     }
  //   });
  // }

  // static Future<void> put(
  //   String url, {
  //   dynamic data,
  //   bool isToken = true,
  //   bool isLoading = false,
  //   Function(dynamic) success,
  //   Function(dynamic) fail,
  //   Function(dynamic) catchError,
  //   String dialogText,
  // }) async {
  //   await Future(() async {
  //     if (isLoading) buildShowDialog(context, text: dialogText);
  //     var options = Options(headers: {'Authorization': isToken ? getUserToken : ''});
  //     var res = await http.put(url, data: data, options: options).catchError((e) {
  //       error(e, (v, type, code) async {
  //         flog(v, '异常');
  //         switch (type) {
  //           case 1:
  //             if (code == 401) {
  //               await userPro.refreshToken();
  //               await put(
  //                 url,
  //                 data: data,
  //                 catchError: (v) {
  //                   if (catchError != null) catchError(v);
  //                 },
  //                 success: (v) {
  //                   if (success != null) success(v);
  //                 },
  //               );
  //             } else {
  //               if (catchError != null) catchError(v);
  //             }
  //             break;
  //           default:
  //             if (catchError != null) catchError(v);
  //             break;
  //         }
  //       });
  //     });
  //     if (isLoading) close();
  //     if (res != null) {
  //       if (res.statusCode == 200) {
  //         if (res.data['tag'] == 1) {
  //           flog(json.encode(res.data), '成功');
  //           if (success != null) success(res.data);
  //         } else {
  //           flog(res.data, '失败');
  //           if (fail != null) fail(res.data['message']);
  //         }
  //       } else {
  //         flog(res.data, '失败');
  //         fail == null ? flog(res.data, '失败') : fail(res.statusMessage);
  //       }
  //     }
  //   });
  // }

  // static Future<void> patch(
  //   String url, {
  //   dynamic data,
  //   bool isToken = true,
  //   bool isLoading = false,
  //   Function(dynamic) success,
  //   Function(dynamic) fail,
  //   Function(dynamic) catchError,
  //   String dialogText,
  // }) async {
  //   await Future(() async {
  //     if (isLoading) buildShowDialog(context, text: dialogText);
  //     // var options = Options(headers: {'Authorization': isToken ? SpUtil.getString(Constant.token) : ''});
  //     // var res = await http.patch(url, data: data, options: options).catchError((e) {
  //     var res = await http.patch(url, data: data).catchError((e) {
  //       if (catchError == null) {
  //         flog(e, '异常');
  //         flog(e);
  //       } else {
  //         catchError(e);
  //       }
  //     });
  //     if (isLoading) close();
  //     if (res != null) {
  //       if (res.statusCode == 200) {
  //         success == null ? flog(res.data, '成功') : success(res.data);
  //       } else {
  //         fail == null ? flog(res.data, '失败') : fail(res.statusMessage);
  //       }
  //     }
  //   });
  // }

  static Future<void> get(
    String url, {
    dynamic data,
    bool isToken = true,
    bool isLoading = false,
    Function(dynamic)? success,
    Function(dynamic)? fail,
    Function(dynamic)? catchError,
    String? dialogText,
  }) async {
    await Future(() async {
      if (isLoading) buildShowDialog(context, text: dialogText);
      // var options = Options(headers: {'Authorization': isToken ? getUserToken : ''});
      // var res = await http.get(url, queryParameters: data, options: options).catchError((e) {
      var res = await http.get(url, queryParameters: data).catchError((e) {
        error(e, (v, type, code) async {
          flog(v, '$url：异常');
          if (catchError != null) catchError(v);
          // switch (type) {
          //   case 1:
          //     if (code == 401) {
          //       await userPro.refreshToken();
          //       await get(
          //         url,
          //         data: data,
          //         catchError: (v) {
          //           if (catchError != null) catchError(v);
          //         },
          //         success: (v) {
          //           if (success != null) success(v);
          //         },
          //       );
          //     } else {
          //       if (catchError != null) catchError(v);
          //     }
          //     break;
          //   default:
          //     if (catchError != null) catchError(v);
          //     break;
          // }
        });

        return e;
      });
      if (isLoading) close();
      if (res != null) {
        if (res.statusCode == 200) {
          if (res.data['resultCode'] == 'success') {
            flog(json.encode(res.data), '$url：成功');
            if (success != null) success(res.data);
          } else {
            flog(json.encode(res.data), '$url：失败');
            if (catchError != null) {
              catchError(res.data['resultMsg'] ?? res.data['resultMsg']);
            }
          }
        } else {
          flog(res.data, '$url：失败');
          if (catchError != null) catchError(res.statusMessage);
        }
      }
      await Future.delayed(const Duration(milliseconds: 250));
    });
  }

  // ///返回用户token
  // static String get getUserToken {
  //   if (user == null) return '';
  //   return user.token;
  // }
}

// class Http {
//   static Future<int> requestList(
//     String url, {
//     DataModel dataModel,
//     dynamic data,
//     bool isLoading,
//     String dialogText,
//     bool isRef = false,
//     Function(dynamic) listFun,
//     Function(dynamic) totalFun,
//     Function() then,
//   }) async {
//     await Request.post(
//       url,
//       data: data,
//       catchError: (v) => dataModel.toError(v),
//       isLoading: isLoading ?? false,
//       dialogText: dialogText,
//       success: (v) => dataModel.addList(
//         listFun != null ? listFun(v) : v['data']['list'],
//         isRef,
//         totalFun != null ? totalFun(v) : v['data']['totalSize'],
//       ),
//     ).then((value) => then());
//     return dataModel.flag;
//   }
// }
