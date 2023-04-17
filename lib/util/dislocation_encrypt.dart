import 'dart:convert';
import 'package:paixs_utils/util/utils.dart';

class Dislocation {
  static String _convertChineseToEnglishPunctuation(String input) {
    input = input.replaceAll("，", ",");
    input = input.replaceAll("。", ".");
    input = input.replaceAll("！", "!");
    input = input.replaceAll("？", "?");
    input = input.replaceAll("：", ":");
    input = input.replaceAll("；", ";");
    input = input.replaceAll("‘", "'");
    input = input.replaceAll("’", "'");
    input = input.replaceAll("“", "\"");
    input = input.replaceAll("”", "\"");
    input = input.replaceAll("——", "—");
    input = input.replaceAll("……", "......");
    input = input.replaceAll("～", "~");
    input = input.replaceAll("〈", "<");
    input = input.replaceAll("〉", ">");
    input = input.replaceAll("—", "-");
    input = input.replaceAll("《", "<");
    input = input.replaceAll("》", ">");
    input = input.replaceAll("［", "[");
    input = input.replaceAll("］", "]");
    input = input.replaceAll("｛", "{");
    input = input.replaceAll("｝", "}");
    return input;
  }

  ///加密
  static String encrypt(String text, {int digit = 3}) {
    var _text = _convertChineseToEnglishPunctuation(text);
    var textList = _text.split('');
    var codec = AsciiCodec();
    var textRes = [];
    textList.forEach((str) {
      if (_isChinese(str)) {
        // var list = codec.encode(PinyinHelper.getPinyin(str)).toList();
        var list = codec.encode(Uri.encodeComponent(str)).toList();
        var res = codec.decode(list.map((m) => m - digit).toList());
        textRes.add(res);
        flog(res, '中文');
      } else if (_isAlphabetic(str)) {
        var first = codec.encode(str).first;
        var res = codec.decode([first - digit]);
        textRes.add(res);
        flog(res, '字母');
      } else if (_isNumeric(str)) {
        var first = codec.encode(str).first;
        var res = codec.decode([first - digit]);
        textRes.add(res);
        flog(res, '数字');
      } else {
        var first = codec.encode(str).first;
        var res = codec.decode([first - digit]);
        textRes.add(res);
        flog(res, '字符');
      }
    });
    return textRes.join();
  }

  ///解密
  static String decrypt(String text, {int digit = 3}) {
    var _text = _convertChineseToEnglishPunctuation(text);
    var textList = _text.split('');
    var codec = AsciiCodec();
    var textRes = [];
    textList.forEach((str) {
      if (_isChinese(str)) {
        var list = codec.encode(Uri.encodeComponent(str)).toList();
        var res = codec.decode(list.map((m) => m + digit).toList());
        // var first = codec.encode(PinyinHelper.getPinyin(str)).first;
        // var res = codec.decode([first + digit]);
        textRes.add(res);
        flog(res, '中文');
      } else if (_isAlphabetic(str)) {
        var first = codec.encode(str).first;
        var res = codec.decode([first + digit]);
        textRes.add(res);
        flog(res, '字母');
      } else if (_isNumeric(str)) {
        var first = codec.encode(str).first;
        var res = codec.decode([first + digit]);
        textRes.add(res);
        flog(res, '数字');
      } else {
        var first = codec.encode(str).first;
        var res = codec.decode([first + digit]);
        textRes.add(res);
        flog(res, '字符');
      }
    });
    return textRes.join();
  }

  static bool _isChinese(String str) {
    return RegExp(r'[\u4e00-\u9fa5]').hasMatch(str);
  }

  static bool _isAlphabetic(String str) {
    final alphabeticRegExp = RegExp(r'^[a-zA-Z]+$');
    return alphabeticRegExp.hasMatch(str);
  }

  static bool _isNumeric(String str) {
    final numericRegExp = RegExp(r'^[0-9]+$');
    return numericRegExp.hasMatch(str);
  }
}
