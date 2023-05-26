import 'package:flutter/material.dart';

class ListProvider extends ChangeNotifier {
  bool taskListIsHide = false;
  bool completedListIsHide = true;

  void toggleTaskListVisibility() {
    taskListIsHide = !taskListIsHide;
    notifyListeners();
  }

  void toggleCompletedListVisibility() {
    completedListIsHide = !completedListIsHide;
    notifyListeners();
  }
}