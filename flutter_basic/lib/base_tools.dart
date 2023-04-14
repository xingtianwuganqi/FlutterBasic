import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter_720yun/Login/LoginPage.dart';
// import 'package:flutter_720yun/model/MessageModel.dart';
// import 'package:flutter_720yun/model/UserModel.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_easyrefresh/easy_refresh.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_720yun/NetWorking/NetWorking.dart';
// import '../main.dart';
// import '../tabbar.dart';


// class UserManager {
//   // 工厂模式
//   factory UserManager() =>_getInstance();
//   static UserManager get instance => _getInstance();
//   static UserManager _instance;
//
//   UserManager._internal() {
//     // 初始化
//
//   }
//
//   static UserManager _getInstance() {
//     if (_instance == null) {
//       _instance = new UserManager._internal();
//     }
//     return _instance;
//   }
//
//   UserInfoModel userInfo;
//   String get token => userInfo?.token ?? "";
//   bool get isLogin => (userInfo?.token?.length ?? 0) > 0;
//
//   Future getUserInfo() async {
//     try{
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String data = prefs.getString('userInfo');
//       if (data != null) {
//         Map json = jsonDecode(data);
//         userInfo = UserInfoModel.fromJson(json);
//       }
//     }catch(e){
//       print('error');
//       print(e);
//     }
//   }
//
//   void saveUserInfo(UserInfoModel data) async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (data != null) {
//       String jsonStringA = jsonEncode(data.toJson());
//       prefs.setString("userInfo", jsonStringA);
//       print('jsonStringA');
//       print(jsonStringA);
//       userInfo = data;
//     }else{
//       return;
//     }
//   }
//
//   void logout() async{
//     // jpush.deleteAlias().then((map) {});
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.remove('userInfo');
//     prefs.clear();
//     UserManager.instance.userInfo = null;
//     Future.delayed(Duration(seconds: 1),(){
//       BuildContext context = navigatorKey.currentState.overlay.context;
//       // 退出登录的通知
//       Provider.of<UserProviderModel>(context, listen: false).user = null;
//       // 退出到首页
//       Navigator.of(context).popUntil((route) => route.isFirst);
//     });
//   }
//
//   Future<bool> getSaveRescueRemind(String info) async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isSave = prefs.getBool(info);
//     if (isSave != null  && isSave == true) {
//       return true;
//     }else{
//       return false;
//     }
//   }
//
//   Future<Null> saveRescueRemind(String info) async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool(info, true);
//   }
// }

// void get backToRoot => Navigator.of(context).popUntil((route) => route.isFirst);

// class ProfileChangeNotifier extends ChangeNotifier {
//   UserInfoModel get _userInfo => UserManager.instance.userInfo;
//
//   @override
//   void notifyListeners() {
//     // Global.saveProfile(); //保存Profile变更
//     super.notifyListeners(); //通知依赖的Widget更新
//   }
// }

// class UserProviderModel extends ChangeNotifier  {
//   UserInfoModel _user;
//   UserProviderModel(this._user);
//   UserInfoModel get user => _user;
//   bool get isLogin => (_user?.token?.length ?? 0) > 0;
//   set user(UserInfoModel value) {
//     _user = value;
//     UserManager.instance.userInfo = _user;
//     UserManager.instance.saveUserInfo(_user);
//     print('_user');
//     print(_user);
//     notifyListeners();
//   }
//
//
// }

// class ProfileChangeNotifier extends ChangeNotifier {
//   Profile get _profile => Global.profile;
//
//   @override
//   void notifyListeners() {
//     Global.saveProfile(); //保存Profile变更
//     super.notifyListeners(); //通知依赖的Widget更新
//   }
// }

// 获取系统颜色
// Theme.of(context).backgroundColor,

// lazyAuthToDoThings(context, obj) async{
//   if (UserManager.instance.isLogin) {
//     await obj();
//   }else{
//     await Navigator.push(context, MaterialPageRoute(builder: (context){
//       return LoginWidget();
//     }));
//   }
// }
/*
static func apiBasicParameters() -> [String:Any] {
        [
            "appType": "ios",
            "token":UserManager.shared.token,
            "appVersion": GlobalConstants.AppVersion,
            "iOSVersion": GlobalConstants.iOSVersion,
        ]
    }
 */
// // 定义一些公关参数，// 定义为计算属性
// Map<String,dynamic> get paramDic => {
//   'appType': 'android',
//   'appVersion': '1.0.2',
//   'androidVersion': '6', // 与pubspec 文件中的version 相同
//   'token': UserManager.instance.token != null ? UserManager.instance.token : '',
// };

/// photo 的key
String get comPhotoKey => DateTime.now().millisecondsSinceEpoch.toString() + '/' + ToolConfig.random() + '.png';

typedef commentInfoChanged = void Function(int id,dynamic info);
typedef clickChange = void Function(int index);
/// 颜色
class ColorsUtil {
  /// 十六进制颜色，
  /// hex, 十六进制值，例如：0xffffff,
  /// alpha, 透明度 [0.0,1.0]
  static Color hexColor(String hex,{double alpha = 1}){
    if (alpha < 0){
      alpha = 0;
    }else if (alpha > 1){
      alpha = 1;
    }
    if (hex.contains("#")) {
      hex = hex.replaceFirst("#", "");
    }
    var colorInt = int.parse(hex,radix: 16);
    return Color.fromRGBO((colorInt & 0xFF0000) >> 16 ,
        (colorInt & 0x00FF00) >> 8,
        (colorInt & 0x0000FF) >> 0,
        alpha);
  }

  // ignore: missing_return
  static Color fromEnmu(ColorEnum value) {
    switch(value) {
      case ColorEnum.system:
        return ColorsUtil.hexColor('#ffa500');
      case ColorEnum.title:
        return ColorsUtil.hexColor('#333333');
      case ColorEnum.content:
        return ColorsUtil.hexColor('#444444');
      case ColorEnum.note:
        return ColorsUtil.hexColor('#666666');
      case ColorEnum.desc:
        return ColorsUtil.hexColor('#8b8b8b');
      case ColorEnum.mark:
        return ColorsUtil.hexColor('#999999');
      case ColorEnum.tableBack:
        return ColorsUtil.hexColor('#EDEDED');
      case ColorEnum.defIcon:
        return ColorsUtil.hexColor('#F5F5F5');
      case ColorEnum.tabbar:
        return ColorsUtil.hexColor('#515151');
      case ColorEnum.urlColor:
        return ColorsUtil.hexColor('#4169E1');
      case ColorEnum.iconColor:
        return ColorsUtil.hexColor('#707070');
      case ColorEnum.backColor:
        return ColorsUtil.hexColor('#FAF9FA');
      default:
        return ColorsUtil.hexColor('#000000');
    }
  }
}
enum ColorEnum {
  system,
  title,
  content,
  note,
  desc,
  mark,
  tableBack,
  defIcon,
  tabbar,
  urlColor,
  iconColor,
  backColor,
}

/// 字体大小
class FontUtil {
  static double from(FontSizeEnum value) {
    switch (value) {
      case FontSizeEnum.big:
        return 22.0;
      case FontSizeEnum.title:
        return 18.0;
      case FontSizeEnum.content:
        return 17.0;
      case FontSizeEnum.mark:
        return 16.0;
      case FontSizeEnum.desc:
        return 15.0;
      case FontSizeEnum.time:
        return 14.0;
      case FontSizeEnum.small:
        return 12.0;
      default:
        return 16.0;
    }
  }
}

enum FontSizeEnum {
  big,
  title,
  content,
  mark,
  desc,
  time,
  small,
}

// 我的页面类型
enum MyPageType {
  myPage,
  otherPage
}

var codeStr = "伍c七Alz1θVx2ψLHNpfωv九nξ捌τD六053λwGμrMνRuegsη八γ陆jOBX8ρ三E9πFS零bδοmkχ7K6PβϵϕoZ五iυU一Jq柒ydYt四QhW4玖κCIαζTaι二σ";


class ToolConfig {
  static String random({int length=8}) {
    String alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    int strlenght = length; /// 生成的字符串固定长度
    String left = '';
    for (var i = 0; i < strlenght; i++) {
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

  /*
  var d1 = new DateTime(2018, 10, 1);
var d2 = new DateTime(2018, 10, 10);
var difference = d1.difference(d2);
print([difference.inDays, difference.inHours]);//d1与d2相差的天数与小时

   */
  static String timeT(String? time) {
    if (time == null) {
      return "";
    }
    if (time.length > 19 ) {
      // var d1 = new DateTime(2021,4,10,10,17,25);
      var d1 = DateTime.now();
      var d2 = DateTime.parse(time);
      var difference = d1.difference(d2);
      var firstTime = DateTime.parse(time).toString().substring(0,19);
      if (difference.inDays > 2) {
        return firstTime;
      }else if (difference.inDays > 1) {
        return '前天${firstTime.substring(10)}';
      }else if (difference.inDays > 0) {
        return '昨天${firstTime.substring(10)}';
      }else if (difference.inHours > 0) {
        return '${difference.inHours}小时前';
      }else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}分钟前';
      }else if (difference.inSeconds > 0) {
        return '${difference.inSeconds}秒前';
      }else{
        return firstTime;
      }
    }else{
      return time;
    }
  }

  static bool isEmail(String input) {
    if (input.isEmpty) return false;
    // 邮箱正则
    String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
    return RegExp(regexEmail).hasMatch(input);
  }




  static String encryptionString(String codeStr) {
    //实例化Random类并赋值给变量rng；
    var rng = new Random();
//打印变量 rng，随机数范围(0-99);
    var index = rng.nextInt(100);
    print(index);
    // 获取当前字符
    List<String> currentList = codeStr.split('');
    print(currentList);
    var currentStr = currentList[index];
    // 第一次编码
    List<int> l1 = utf8.encode(currentStr);
    String currentOne = base64Encode(l1);
    String indexStr = 'index_' + index.toString();
    // index编码
    List<int> index1 = utf8.encode(indexStr);
    String indexOne = base64Encode(index1);
    // index 二次编码
    List<int> index2 = utf8.encode(indexOne);
    String indexTwo = base64Encode(index2);

    DateTime today = new DateTime.now();
    String dateStr = "${today.year.toString()}年${today.month.toString().padLeft(
        2, '0')}年${today.day.toString().padLeft(2, '0')}年";
    print(dateStr);

    // date 二次编码
    List<int> date1 = utf8.encode(dateStr);
    String enString = base64Encode(date1);
    String currentTwo = currentOne;
    List<String> enArr = enString.split('');
    enArr.insert(2, r"$" + currentOne);
    enArr.insert(enArr.length - 3, r"$" + currentTwo);
    enArr.add(r"$"+indexTwo);
    return enArr.join();
  }

  static setUserAgreenStatus(int value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('user_agree', value);
    }catch (e){

    }
  }

  static Future<int> getUserGreenStatus() async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? data = prefs.getInt('user_agree');
      if (data == 1) {
        return 1;
      }else{
        return 0;
      }
    }catch(e){
      return 0;
    }
  }
}
//
/// 无参数
// typedef ActionNoParam = void Function();
/// 有参数
// typedef ChangedCallBack<T> = void Function(T value);


/// 空白页
// ignore: must_be_immutable
class EmptyPage extends StatelessWidget {
  String? image;
  String title;
  String desc;
  Function() obj;
  EmptyPage(this.obj,{super.key, this.title='暂无数据',this.desc='请点击重试',this.image});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: GestureDetector(
          child: emptyWidget(),
          onTap: () {
            obj();
          },
        )
    );
  }

  Widget emptyWidget() {
    List<Widget> centerWidgets = [];
    if (this.image != null) {
      centerWidgets = [
        Container(
          height: 45,
          width: 45,
          child: Image.asset('assets/icons/icon_complete.png'),
        ),
        Text(title,style: TextStyle(
          color: ColorsUtil.fromEnmu(ColorEnum.content),
          fontSize: FontUtil.from(FontSizeEnum.content),
        ),
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Text(desc,style: TextStyle(
          color: ColorsUtil.fromEnmu(ColorEnum.desc),
          fontSize: FontUtil.from(FontSizeEnum.desc),
        ),
        ),
      ];
    }else{
      centerWidgets = [
        Text(title,style: TextStyle(
          color: ColorsUtil.fromEnmu(ColorEnum.content),
          fontSize: FontUtil.from(FontSizeEnum.content),
        ),
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Text(desc,style: TextStyle(
          color: ColorsUtil.fromEnmu(ColorEnum.desc),
          fontSize: FontUtil.from(FontSizeEnum.desc),
        ),
        ),
      ];
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: centerWidgets,
      ),
    );
  }
}
/// 第一次加载的widget
// Widget FirstLoadWidget() {
//   return SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,);
// }
