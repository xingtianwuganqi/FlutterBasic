import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basic/web_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_printer/flutter_printer.dart';
import 'base_model.dart';
import 'base_tools.dart';
import 'networking.dart';

class BaseTabBar extends StatefulWidget {
  List<Widget> pages = [];
  List<BottomNavigationModel> items = [];
  ValueChanged? changed;
  BaseTabBar({super.key, required this.pages, required this.items, this.changed});


  @override
  BaseTabBarState createState() {
    // TODO: implement createState
    return BaseTabBarState();
  }
}

class BaseTabBarState extends State<BaseTabBar> {
  int _selectedIndex = 0;

  final TapGestureRecognizer _tgr1 = TapGestureRecognizer();
  final TapGestureRecognizer _tgr2 = TapGestureRecognizer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadConfig();
    getUserAgreeStatus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tgr1.dispose();
    _tgr2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: IndexedStack(index: _selectedIndex,children: widget.pages),
      bottomNavigationBar: bottomTabBars()
    );
  }

  Widget bottomTabBars() {

    List<BottomNavigationBarItem> bars = [];
    for (int i = 0; i < widget.items.length; i ++) {
      var item = widget.items[i];
      var iconWidget = unreadSelectIcon(_selectedIndex == i, item);
      bars.add(BottomNavigationBarItem(icon: iconWidget,label: item.title));
    }

    return BottomNavigationBar(
      items: bars,
      currentIndex: _selectedIndex,
      fixedColor: ColorsUtil.fromEnum(ColorEnum.system),
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: ColorsUtil.hexColor('#707070'),
      selectedFontSize: 12,
      unselectedFontSize: 12,
      iconSize: 25,
      elevation: 2.0,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget unreadSelectIcon(bool isSelect, BottomNavigationModel model) {
    return Stack(
      children: [
        isSelect ?
        Image.asset(model.selectIcon, width: 25,height: 25):
        Image.asset(model.unSelectIcon, width: 25, height: 25,),
        Positioned(
          top: 0,
          right: 0,
          child: model.unreadNum > 0 ? Container(
            height: 16,
            width: 16,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.redAccent,
            ),
            child: Text('${model.unreadNum}',style: const TextStyle(color: Colors.white,fontSize: 10),),
          ) : Container(color: Colors.transparent,width: 2,height: 2,),
        )
      ],
    );
  }

  // 更新某个tab下的未读
  void uploadUnreadNum(int index, int value) {
    for (int i = 0; i < widget.items.length; i ++) {
      var item = widget.items[i];
      if (i == index) {
        item.unreadNum = value;
      }
    }
    setState(() {

    });
  }

  void _loadConfig() {

    if (NetWorkingConfig.urlConfig == UrlConfig.formal) {
      Printer.enable = false;
    }else{
      Printer.enable = true;
    }

    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 1500)
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..indicatorColor = ColorsUtil.fromEnum(ColorEnum.system)
      ..indicatorSize = 40.0
      ..radius = 10.0
      ..progressColor = ColorsUtil.fromEnum(ColorEnum.system)
      ..backgroundColor = Colors.black54
      ..textColor = Colors.white
      ..lineWidth = 3
      ..toastPosition = EasyLoadingToastPosition.center
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
    // ..customAnimation = CustomAnimation();
  }

  void getUserAgreeStatus() {
    ToolConfig.getUserGreenStatus().then((value) {
      if (value == 1) {
        if (widget.changed != null) {
          widget.changed!(1);
        }
      }else{
        userAgreenDialog();
      }
    });
  }

  void userAgreenDialog() {
    String userPrivateProtocol = '''，帮助您了解我们为您提供的服务，我们将如何处理个人信息以及您享有的权利。我们将会严格按照相关法律法规要求，采取各种安全措施来保护您的个人信息。\n点击"同意"按钮，表示您已知情并同意以下协议和以下约定：\n1.为了保障软件的安全运行和账号安全，我们会申请收集您的设备信息。\n2.上传图片需要申请您的相册或存储权限。\n3.申请设备信息，方便为您推荐个性化广告。\n4.我们尊重您的选择权，您可以访问修改，删除您的个人信息并管理您的授权。''';
    var alert = AlertDialog(
      title: const Text("个人隐私保护提示"),
      titlePadding: const EdgeInsets.all(10),
      //标题文本样式
      titleTextStyle: TextStyle(color: ColorsUtil.fromEnum(ColorEnum.title), fontSize: 16,fontWeight: FontWeight.bold),
      //中间显示的内容
      content:
       Container(
         height: 200,
         width: double.infinity,
         child: SingleChildScrollView(
           child: RichText(
             text: TextSpan(
                 text: '欢迎使用真命天喵！我们将通过',style:TextStyle(
                 color: ColorsUtil.fromEnum(ColorEnum.content),
                 fontSize: 16,
                 height: 1.5
             ),
                 children: [
                   TextSpan(
                     text: '《用户协议》',style:TextStyle(
                       color: ColorsUtil.fromEnum(ColorEnum.urlColor),
                       fontSize: 16,
                       height: 1.5
                   ),
                     recognizer: _tgr1..onTap = () {
                       Navigator.push(context, MaterialPageRoute(builder: (context){
                         return WebViewPage(url: NetWorkingConfig.path(NetPath.userAgreen));
                       }));
                   }
                   ),
                   TextSpan(text: '和',style:TextStyle(
                       color: ColorsUtil.fromEnum(ColorEnum.content),
                       fontSize: 16,
                       height: 1.5
                   )),
                   TextSpan(text: '《隐私协议》',style:TextStyle(
                       color: ColorsUtil.fromEnum(ColorEnum.urlColor),
                       fontSize: FontUtil.from(FontSizeEnum.content),
                       height: 1.5
                   ),recognizer: _tgr2..onTap = () {
                     Navigator.push(context, MaterialPageRoute(builder: (context){
                       // return WebViewPage(url: NetWorkingConfig.path(NetPath.pravicy));
                       String filePath = 'assets/files/privacyPolicy.html';
                       return WebViewPage(filePath: filePath);
                     }));                   }
                   ),
                   TextSpan(text: userPrivateProtocol,style:TextStyle(
                       color: ColorsUtil.fromEnum(ColorEnum.content),
                       fontSize: 16,
                       height: 1.5
                   )),
                 ]
             ),
           ),
         )
         // child: ,
       ),
      //中间显示的内容边距
      //默认 EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0)
      contentPadding: const EdgeInsets.all(10),
      //中间显示内容的文本样式
      contentTextStyle: const TextStyle(color: Colors.black54, fontSize: 14),
      scrollable: true,
      //底部按钮区域
      actions: <Widget>[
        TextButton(
          child: Text("不同意",
            style: TextStyle(
              color: ColorsUtil.fromEnum(ColorEnum.title),
              fontSize: FontUtil.from(FontSizeEnum.content),
              fontWeight: FontWeight.bold
            ),
          ),
          onPressed: () {
            // Navigator.of(context).pop(false);
            exit(0);
            // ToolConfig.setUserAgreenStatus(0);
          },
        ),
        TextButton(
          child: Text("同意",
            style: TextStyle(
              color: ColorsUtil.fromEnum(ColorEnum.title),
              fontSize: FontUtil.from(FontSizeEnum.content),
                fontWeight: FontWeight.bold
            ),
          ),
          onPressed: () {
            //关闭 返回true
            Navigator.of(context).pop(true);
            ToolConfig.setUserAgreenStatus(1);
          },
        ),
      ],
    );

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: alert,
        );
      },
    );
  }

}