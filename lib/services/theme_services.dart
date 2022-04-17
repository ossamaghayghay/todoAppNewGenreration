import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
class ThemeServices {

  final GetStorage _box=GetStorage();
  final _key='isDarkMode';

   _saveThemeTobox(bool isDarkMode){
     _box.write(_key, isDarkMode);
   }

  bool _loadThemeFromBox()=>_box.read<bool>(_key)??false;
    // return false;
  

  ThemeMode get theme{
    return _loadThemeFromBox()?ThemeMode.dark:ThemeMode.light;
    }

  void switchThme(){
    Get.changeThemeMode(_loadThemeFromBox()? ThemeMode.light:ThemeMode.dark);
    _saveThemeTobox(!_loadThemeFromBox());
  }


}
