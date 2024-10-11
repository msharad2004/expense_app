import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier{

  bool _isDark = false;
  static final String IS_DARK_KEY = "isDark";

  bool get themeValue{
    return _isDark;
  }

  set themeValue(bool value){
    _isDark = value;
    /// storing user pref about his/her theme
    updateThemeInPref(value);
    notifyListeners();
  }

  void updateThemeInPref(bool value) async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(IS_DARK_KEY, value);
  }

  void updateThemeOnStart()async{
    var prefs = await SharedPreferences.getInstance();
    var isDarkPref = prefs.getBool(IS_DARK_KEY);

    if(isDarkPref!=null){
      _isDark = isDarkPref;
    } else {
      _isDark = false;
    }
    notifyListeners();
  }

}