import 'package:flutter/material.dart';

class AppLayout extends ChangeNotifier {
  static final AppLayout _instance = AppLayout._internal();
  
  factory AppLayout() {
    return _instance;
  }
  
  AppLayout._internal();

  int _currentIndex = 0;
  bool _isFooterVisible = true;

  int get currentIndex => _currentIndex;
  bool get isFooterVisible => _isFooterVisible;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setFooterVisibility(bool visible) {
    _isFooterVisible = visible;
    notifyListeners();
  }
}