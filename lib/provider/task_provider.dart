import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TaskProvider with ChangeNotifier {
  String title = '';
  String description = '';
  String date = '';
  bool isCompleted = false;
  int completedTasksCount = 0;


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _tasksCollection;

  final FirebaseAuth firebaseAuth;

  List<QueryDocumentSnapshot> tasks = [];

  void setTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }

  void setDescription(String newDescription) {
    description = newDescription;
    notifyListeners();
  }

  void setDate(String newDate) {
    date = newDate;
    notifyListeners();
  }

  TaskProvider(this.firebaseAuth) {
    _tasksCollection = _firestore.collection('tasks');
    firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        // The user is logged in, fetch their tasks
        fetchTasks(user.uid);
      } else {
        // The user is not logged in, clear tasks
        tasks = [];
      }
      notifyListeners();
    });
  }

  void setCompleted(bool newIsCompleted) {
    isCompleted = newIsCompleted;
    notifyListeners();
  }

  bool getCompleted() {
    return isCompleted;
  }

  Future<void> deleteTask(DocumentSnapshot task) async {
    await _firestore.collection('tasks').doc(task.id).delete();

    tasks.remove(task);

    notifyListeners();
  }

  void fetchTasks(String userId) {
    _tasksCollection.where('user', isEqualTo: userId)
        .snapshots().listen((QuerySnapshot snapshot) {
      tasks = snapshot.docs;

      // Debug prints to check fetched data
      print("Fetched tasks: $tasks");

      // Reset the count before calculating again
      completedTasksCount = 0;

      for (var task in tasks) {
        if (task['isCompleted'] == true) {
          completedTasksCount++;
          print("Incrementing completed tasks count to $completedTasksCount");
        }
      }

      notifyListeners();
    });
  }

}
