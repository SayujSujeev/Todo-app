import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/provider/task_provider.dart';

class TaskScreen extends StatefulWidget {

  final DocumentSnapshot? task;

  const TaskScreen({Key? key, this.task}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  bool isCompleted = false;
  String selectedDate = '';
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _tasksCollection;

  @override
  void initState() {
    super.initState();

    _tasksCollection = _firestore.collection('tasks');

    if (widget.task != null) {
      titleController.text = widget.task!['title'];
      descriptionController.text = widget.task!['description'];
      dateController.text = widget.task!['date'];
      isCompleted = widget.task!['isCompleted'] ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskModel, child){
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.arrow_back_ios),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              'Add Task',
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: titleController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter title';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                color: primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: descriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                color: primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: dateController,
                          readOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please pick a date';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Pick a Date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                color: primary,
                              ),
                            ),
                          ),
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: primary, // Your custom color
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              selectedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                              dateController.text = selectedDate; // Updating the text
                            }
                          },
                        )
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                if (widget.task == null) {
                                  // Add a new task
                                  await _tasksCollection.add({
                                    'title': titleController.text,
                                    'description': descriptionController.text,
                                    'date': dateController.text,
                                    'isCompleted': isCompleted,
                                    'user': _auth.currentUser!.uid,
                                  });
                                } else {
                                  // Update the existing task
                                  await _tasksCollection.doc(widget.task!.id).update({
                                    'title': titleController.text,
                                    'description': descriptionController.text,
                                    'date': dateController.text,
                                    'isCompleted': isCompleted,
                                    'user': _auth.currentUser!.uid,
                                  });
                                }
                                Navigator.pop(context);
                              } catch (e) {
                                print('Error when adding/updating task: $e');
                              }
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: widget.task == null ? primary : blue,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                widget.task == null ? 'Add Task' : 'Edit Task',
                                style: const TextStyle(
                                  color: white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
