// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkTheme = true;

  bool get isDarkTheme => _isDarkTheme;
  ThemeMode get themeMode => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toogleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  } // end method

  void setTheme(bool isDark) {
    _isDarkTheme = isDark;
    notifyListeners();
  } // end method
} // end class
