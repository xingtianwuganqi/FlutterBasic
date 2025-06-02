import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// photo 的key
String get comPhotoKey => '${DateTime.now().millisecondsSinceEpoch}/${ToolConfig.random()}.png';

typedef commentInfoChanged = void Function(int id,dynamic info);
typedef clickChange = void Function(int index);

AppIdEnum appIdentifier = AppIdEnum.none;
void setAppIdentifier(AppIdEnum type) {
  appIdentifier = type;
}

enum AppIdEnum{
  zmtm,
  plan,
  none,
}

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
  static Color fromEnum(ColorEnum value) {
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
      case ColorEnum.backGround:
        return ColorsUtil.hexColor("#F2F2F5");
      case ColorEnum.lineColor:
        return ColorsUtil.hexColor("#EEEEEE");
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
  backGround,
  lineColor,
}

/// 字体大小
class FontUtil {
  static double from(FontSizeEnum value) {
    switch (value) {
      case FontSizeEnum.big:
        return 22.0;
      case FontSizeEnum.title:
        return 19.0;
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

  static String loadImgUrl(String url,{ThumbType bType}) {
    var headImg = '';
    if (url.contains("http")) {
      headImg = url;
    }else{
      switch (bType) {
        case ThumbType.thumbNail: {
          headImg = NetWorkingConfig.imgBaseUrl + url + NetWorkingConfig.imgNailTail;
        }
        break;
        case ThumbType.thumbFour: {
          headImg = NetWorkingConfig.imgBaseUrl + url + NetWorkingConfig.imgFourTail;
        }
        break;
        case ThumbType.thumbSeven: {
          headImg = NetWorkingConfig.imgBaseUrl + url + NetWorkingConfig.imgSevenTail;
        }
        break;
        default: {
          headImg = NetWorkingConfig.imgBaseUrl + url;
        }
        break;
      }

    }
    return headImg;
  }

}

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
    if (image != null) {
      centerWidgets = [
        Container(
          height: 45,
          width: 45,
          child: Image.asset('assets/icons/icon_complete.png'),
        ),
        Text(title,style: TextStyle(
          color: ColorsUtil.fromEnum(ColorEnum.content),
          fontSize: FontUtil.from(FontSizeEnum.content),
        ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Text(desc,style: TextStyle(
          color: ColorsUtil.fromEnum(ColorEnum.desc),
          fontSize: FontUtil.from(FontSizeEnum.desc),
        ),
        ),
      ];
    }else{
      centerWidgets = [
        Text(title,style: TextStyle(
          color: ColorsUtil.fromEnum(ColorEnum.content),
          fontSize: FontUtil.from(FontSizeEnum.content),
        ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Text(desc,style: TextStyle(
          color: ColorsUtil.fromEnum(ColorEnum.desc),
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
