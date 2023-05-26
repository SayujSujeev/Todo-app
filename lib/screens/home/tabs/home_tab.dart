import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/provider/list_provider.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/provider/theme_provider.dart';
import 'package:todo_app/screens/task/task_screen.dart';
import 'package:vibration/vibration.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}


class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animationOpacity;
  late final Animation<Offset> _animationPosition;
  final Map<String, AnimationController> _animationControllers = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animationOpacity = Tween<double>(begin: 0, end: 1).animate(_controller);
    _animationPosition =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
            .animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget buildTaskList(List<DocumentSnapshot> tasks, bool isCompleted) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        DocumentSnapshot task = tasks[index];

        _animationControllers[task.id] ??= AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        );
        Animation<double> heightAnimation =
            Tween<double>(begin: 1, end: 0).animate(
          CurvedAnimation(
              parent: _animationControllers[task.id]!, curve: Curves.easeOut),
        );

        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return FadeTransition(
              opacity: _animationOpacity,
              child: SlideTransition(
                position: _animationPosition,
                child: SizeTransition(
                  sizeFactor: heightAnimation,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: SlideTransition(
                          position: _animationPosition,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: black.withOpacity(0.25),
                                  offset: const Offset(0, 5),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  task['description'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.calendar_month_outlined,
                                      size: 17,
                                      color: primary,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      task['date'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (isCompleted)
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            task.reference
                                                .update({'isCompleted': false});
                                            bool? hasVibrator = await Vibration.hasVibrator();
                                            if (hasVibrator == true) {
                                              Vibration.vibrate(amplitude: 128);
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: green,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Re-Do',
                                                style: TextStyle(
                                                    color: white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (!isCompleted)
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            task.reference
                                                .update({'isCompleted': true});

                                            bool? hasVibrator = await Vibration.hasVibrator();
                                            if (hasVibrator == true) {
                                              Vibration.vibrate(amplitude: 128);
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: green,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Done',
                                                style: TextStyle(
                                                    color: white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TaskScreen(task: task),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: blue,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Edit',
                                              style: TextStyle(
                                                  color: white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          // Start the collapse animation
                                          _animationControllers[task.id]!
                                              .forward();

                                          // Wait for the animation to finish
                                          await Future.delayed(
                                            _animationControllers[task.id]!
                                                .duration!,
                                          );

                                          bool? hasVibrator = await Vibration.hasVibrator();
                                          if (hasVibrator == true) {
                                            Vibration.vibrate(amplitude: 128);
                                          }

                                          // Then delete the task
                                          Provider.of<TaskProvider>(context,
                                                  listen: false)
                                              .deleteTask(task);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: primary,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                  color: white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (isCompleted)
                        Positioned(
                          top: -25,
                          right: -30,
                          child: Opacity(
                            opacity: 0.8,
                            child: Image.asset(
                              'assets/images/done.png',
                              height: 100,
                              width: 100,
                              color: primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskModel, child) {
        if (taskModel.tasks.isEmpty) {
          return Center(
            child: SvgPicture.asset(
              'assets/images/AddTasks.svg',
              width: 350,
            ),
          );
        }

        var completedTasks = taskModel.tasks
            .where((task) => task['isCompleted'] == true)
            .toList();
        var pendingTasks = taskModel.tasks
            .where((task) => task['isCompleted'] == false)
            .toList();

        return ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pendingTasks.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<ListProvider>(
                        builder: (context, taskListProvider, child) => InkWell(
                          onTap: taskListProvider.toggleTaskListVisibility,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Task List',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Icon(
                                taskListProvider.taskListIsHide ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Consumer<ListProvider>(
                        builder: (context, taskListProvider, child) => taskListProvider.taskListIsHide ? Container() : buildTaskList(pendingTasks, false),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                if (completedTasks.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<ListProvider>(
                        builder: (context, taskListProvider, child) => InkWell(
                          onTap: taskListProvider.toggleCompletedListVisibility,
                          child: Row(
                            children: [
                              const Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Icon(
                                taskListProvider.completedListIsHide ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Consumer<ListProvider>(
                        builder: (context, taskListProvider, child) => taskListProvider.completedListIsHide ? Container() : buildTaskList(completedTasks, true),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
