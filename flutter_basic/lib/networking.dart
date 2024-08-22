import 'package:dio/dio.dart';
import 'dart:async';

import 'package:flutter_printer/flutter_printer.dart';


BaseOptions options = BaseOptions(
  baseUrl: NetWorkingConfig.getBaseUrl(),
  headers: NetWorkingConfig.getHeader(),
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
);

Dio dio = Dio(options);

typedef SuccessCallBack = void Function(dynamic data);
typedef FailureCallBack = void Function(dynamic error);

class NetWorking {

  static Future get(String url,Map<String,dynamic>? params,SuccessCallBack successBack,FailureCallBack failBack) async{
    try {
      var response = await dio.get(url,queryParameters: params);
      successBack(response.data);
    }catch (e){
      failBack(e);
    }
  }

  static Future post(String url,Map<String,dynamic>? params ,SuccessCallBack successBack,FailureCallBack failBack) async {
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
      if (e is DioException) {
        // 退出登录
        if (e.response?.statusCode == 401) {
          // EasyLoading.showToast('认证有误,请重新登录');
          // UserManager.instance.logout();
        }
      }
    }
  }

  static Future delete(String url, Map<String, dynamic>? dic, SuccessCallBack successBack, FailureCallBack failBack) async {
    try {
      var response = await dio.delete(url, data: dic);
      successBack(response.data);
    }catch(e) {
      failBack(e);
    }
  }

  static Future put(String url, Map<String, dynamic>? dic, SuccessCallBack successBack, FailureCallBack failBack) async {
    try {
      var response = await dio.put(url, data: dic);
      successBack(response.data);
    }catch(e) {
      failBack(e);
    }
  }

  static Future patch(String url, Map<String, dynamic>? dic, SuccessCallBack successBack, FailureCallBack failBack) async {
    try {
      var response = await dio.patch(url, data: dic);
      successBack(response.data);
    }catch(e) {
      failBack(e);
    }
  }
}


enum UrlConfig {
  formal,
  test,
  local
}

class NetWorkingConfig {
  static UrlConfig urlConfig = UrlConfig.test;
  static String formalUrl = '';
  static String testUrl = '';
  static String localUrl = '';
  static Map<String, dynamic>? header;
  static String imgBaseUrl = '';

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

  static Map<String, dynamic>? getHeader() {
    return NetWorkingConfig.header;
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

  static void setImgBaseUrl(String imgBaseUrl) {
    NetWorkingConfig.imgBaseUrl = imgBaseUrl;
  }

  static void setHeader(Map<String, dynamic>? header) {
    options.headers = header;
  }
}

