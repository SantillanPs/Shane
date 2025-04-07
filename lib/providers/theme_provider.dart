import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _accentColor = 'blue';
  
  ThemeMode get themeMode => _themeMode;
  String get accentColor => _accentColor;
  
  ThemeProvider() {
    _loadPreferences();
  }
  
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    final accentColor = prefs.getString('accentColor') ?? 'blue';
    
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    _accentColor = accentColor;
    notifyListeners();
  }
  
  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', themeMode == ThemeMode.dark);
    notifyListeners();
  }
  
  Future<void> setAccentColor(String color) async {
    _accentColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accentColor', color);
    notifyListeners();
  }
}

