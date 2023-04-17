// ignore_for_file: unnecessary_this, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:liuliangchi/util/http.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider_config.dart';

class UserProvider extends ChangeNotifier {
  ///用户信息(全局)
  String get qj_companyId => userModel!['company']['id'];
  String get qj_userId => userModel!['user']['id'];
  Map? userModel = {};
  String? token;
  var tokenTime = DateTime.now().millisecondsSinceEpoch;
  var refreshToken;

  ///保存token到内存
  Future<void> setToken(_token, _tokenTime, _refreshToken) async {
    token = _token;
    tokenTime = _tokenTime;
    refreshToken = _refreshToken;
    await this.saveToken(token, tokenTime, refreshToken);
    notifyListeners();
  }

  ///保存用户信息到内存
  void setUserModel(data) {
    userModel = data;
    this.saveUserInfo(userModel);
    notifyListeners();
  }

  ///本地保存token
  Future<void> saveToken(dynamic _token, tokenTime, _refreshToken) async {
    var sp = await SharedPreferences.getInstance();
    await sp.setString('token', _token);
    await sp.setString('refreshToken', _refreshToken);
    await sp.setInt('tokenTime', tokenTime);
  }

  ///本地保存用户信息
  Future<void> saveUserInfo(_user) async {
    var sp = await SharedPreferences.getInstance();
    await sp.setString('user', jsonEncode(_user));
    await sp.setString('token', token ?? '');
    await sp.setInt('tokenTime', tokenTime);
  }

  ///获取本地保存用户信息
  Future<bool> getUserInfo() async {
    var sp = await SharedPreferences.getInstance();
    var info = sp.getString('user');
    token = sp.getString('token') ?? '';
    tokenTime = sp.getInt('tokenTime') ?? DateTime.now().millisecondsSinceEpoch;
    if (info == null) {
      return false;
    } else {
      userModel = jsonDecode(info);
      notifyListeners();
      return true;
    }
  }

  ///获取token
  Future<void> getToken() async {
    // if (userModel == null) return;
    // return;
    await Request.post(
      '/app/user/getToken',
      data: {
        "userName": 'lsh_zxy', //userModel!['userName'],
        "passWord": userModel!['passWord'] == null
            ? ''
            : generateMd5('123456') //userModel!['passWord'].substring(0, 32),
      },
      isToken: false,
      success: (v) {
        print(v);
        token = v['token'];
        tokenTime = DateTime.now().millisecondsSinceEpoch;
        this.saveUserInfo(userModel);
      },
    );
    notifyListeners();
  }

  ///刷新用户信息
  Future<void> refreshUserInfo([isLoading = false]) async {
    // if (token == null) return;
    await Request.post(
      '/app/user/getUserById',
      data: {"userId": userModel!['id'], "version": app.packageInfo!.version},
      isLoading: isLoading,
      // catchError: (v) => userModel = null,
      catchError: (v) {},
      success: (v) => setUserModel(v['result']),
    );
  }

  ///刷新用户token
  Future<void> refreshUserToken([isLoading = false]) async {
    if (token == null) return;
    await Request.post(
      '/maxmoneycloud-auth/oauth/token',
      data: {
        "grant_type": "refresh_token",
        "client_id": "maxmoneycloud-mobile",
        "client_secret": "123456",
        "refresh_token": refreshToken,
      },
      success: (v) async {
        await setToken(
          v['data']['token'],
          DateTime.now().millisecondsSinceEpoch,
          v['data']['refreshToken'],
        );
      },
    );
  }

  ///清除用户信息
  Future<bool> cleanUserInfo() async {
    var sp = await SharedPreferences.getInstance();
    userModel = null;
    token = null;
    await sp.remove('user');
    await sp.remove('token');
    notifyListeners();
    return true;
  }

  ///是否第一次进入app
  Future<bool> isFirstTimeOpenApp() async {
    var sp = await SharedPreferences.getInstance();
    var info = sp.getString('isFirstTimeOpenApp');
    if (info == null) {
      return true;
    } else {
      return false;
    }
  }

  ///第一次进入app创建值
  Future<bool> addFirstTimeOpenAppFlag() async {
    var sp = await SharedPreferences.getInstance();
    var info = sp.setString('isFirstTimeOpenApp', 'true');
    return info;
  }
}
