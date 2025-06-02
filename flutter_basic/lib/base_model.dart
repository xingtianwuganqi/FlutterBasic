import 'package:flutter/cupertino.dart';

class BottomNavigationModel {
  String selectIcon;
  String unSelectIcon;
  String title;
  bool isSelect = false;
  int unreadNum = 0;
  AssetImage? selectImg;
  AssetImage? unSelectImg;

  BottomNavigationModel(
      {
        required this.selectIcon,
        required this.unSelectIcon,
        required this.title,
        required this.isSelect,
        required this.unreadNum,
        this.selectImg,
        this.unSelectImg,
      }
  );

  factory BottomNavigationModel.fromJson(Map<String, dynamic> json) {
    return BottomNavigationModel(
        selectIcon: json['selectIcon'],
        unSelectIcon: json['unSelectIcon'],
        title: json['title'],
        isSelect: false,
        unreadNum: 0
    );
  }
}


enum ThumbType {

}