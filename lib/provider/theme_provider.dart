import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  ThemeProvider() {
    final Brightness brightness = SchedulerBinding.instance.window.platformBrightness;
    themeMode = (brightness == Brightness.dark) ? ThemeMode.dark : ThemeMode.light;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    final Brightness brightness = SchedulerBinding.instance.window.platformBrightness;
    themeMode = (brightness == Brightness.dark) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    super.didChangePlatformBrightness();
  }

  void toggleTheme() {
    themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
