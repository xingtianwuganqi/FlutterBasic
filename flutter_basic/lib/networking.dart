import 'package:dio/dio.dart';
import 'dart:async';

import 'package:flutter_printer/flutter_printer.dart';


BaseOptions options = BaseOptions(
  baseUrl: NetWorkingConfig.getBaseUrl(),
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
);

Dio dio = Dio(options);

typedef SuccessCallBack = void Function(dynamic data);
typedef FailureCallBack = void Function(dynamic error);

class NetWorking {

  static Future get(String url,SuccessCallBack successBack,FailureCallBack failBack,{Map<String,dynamic>? params}) async{
    try {
      var response = await dio.get(url,queryParameters: params);
      successBack(response.data);
    }catch (e){
      failBack(e);
    }
  }

  static Future post(String url,SuccessCallBack successBack,FailureCallBack failBack,{Map<String,dynamic>? params}) async {
    try {
      var response = await dio.post(url,data:params);
      successBack(response.data);
    }catch(e) {
      failBack(e);
    }
  }

  static Future formDataPost(String url, Map<String,dynamic> dic,SuccessCallBack successBack,FailureCallBack failBack) async {
    Printer.printMapJsonLog('😁😁😁');
    Printer.printMapJsonLog(url);
    Printer.printMapJsonLog(dic);

    try {
      FormData formData = FormData.fromMap(dic);
      var response = await dio.post(url,data: formData);
      Printer.printMapJsonLog('++++++++++');
      Printer.printMapJsonLog(response.data);
      successBack(response.data);
    }catch(e){
      failBack(e);
      Printer.printMapJsonLog("----======-----");
      Printer.printMapJsonLog(e);
      if (e is DioError) {
        // 退出登录
        if (e.response?.statusCode == 403) {
          // EasyLoading.showToast('认证有误,请重新登录');
          // UserManager.instance.logout();
        }
      }
    }
  }
}


enum UrlConfig {
  formal,
  test,
  local
}

enum ThumbType {
  thumbNail,
  thumbFour,
  thumbSeven,
}

class NetWorkingConfig {
  static UrlConfig urlConfig = UrlConfig.test;
  static String formalUrl = '';
  static String testUrl = '';
  static String localUrl = '';

  static String getBaseUrl() {
    switch (NetWorkingConfig.urlConfig) {
      case UrlConfig.formal:
        return NetWorkingConfig.formalUrl;
      case UrlConfig.test:
        return NetWorkingConfig.testUrl;
      case UrlConfig.local:
        return NetWorkingConfig.localUrl;
      default:
        return "";
    }
  }

  static void setFormalUrl(String formalUrl) {
    NetWorkingConfig.formalUrl = formalUrl;
  }

  static void setTestUrl(String testUrl) {
    NetWorkingConfig.testUrl = testUrl;
  }

  static void setLocalUrl(String localUrl) {
    NetWorkingConfig.localUrl = localUrl;
  }

  static void setConfig(UrlConfig config) {
    NetWorkingConfig.urlConfig = config;
  }
}

