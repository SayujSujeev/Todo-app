import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/screens/home/tabs/home_tab.dart';
import 'package:todo_app/screens/home/tabs/profile_tab.dart';
import 'package:todo_app/screens/task/task_screen.dart';

import '../../provider/auth_provider.dart';
import '../../provider/theme_provider.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFabPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TaskScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: purple,
        child: Column(
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/mountains.jpg',
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, 0.5),
                        end: Alignment(0.0, 0.0),
                        colors: <Color>[
                          Color(0x60000000),
                          Color(0x00000000),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      "Your Things",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dark/Light theme',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: white,
                    ),
                  ),
                  Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                    return Switch(
                      activeTrackColor: primary.withOpacity(0.5),
                      activeColor: primary,
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                    );
                  }),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: InkWell(
                onTap: () async {
                  final provider =
                  Provider.of<AuthProvider>(context, listen: false);
                  await provider.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded,color: white,size: 25,),
                      SizedBox(width: 15,),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            backgroundColor: purple,
            pinned: true,
            leading: Builder(
              builder: (context) => IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.menu_rounded,
                  size: 28,
                ),
              ),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double top = constraints.biggest.height;
                return FlexibleSpaceBar(
                  title: top > 100
                      ? null
                      : const Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Your Things",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                  centerTitle: false,
                  background: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/mountains.jpg',
                        fit: BoxFit.cover,
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, 0.3),
                            end: Alignment(0.0, 0.0),
                            colors: <Color>[
                              Color(0x60000000),
                              Color(0x00000000),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Your\nThings',
                                    style: TextStyle(
                                      color: white,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Consumer<TaskProvider>(
                                    builder: (context, provider, child) =>
                                        Column(
                                      children: [
                                        Text(
                                          '${provider.tasks.length}',
                                          // Total tasks count.
                                          style: const TextStyle(
                                            color: white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Text(
                                          'Tasks',
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('MMM d, y')
                                        .format(DateTime.now()),
                                    style: TextStyle(
                                      color: white.withOpacity(0.5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Consumer<TaskProvider>(
                                    builder: (context, provider, child) {
                                      int totalTasks = provider.tasks.length;
                                      int completedTasks =
                                          provider.completedTasksCount;
                                      double completionRate = totalTasks > 0
                                          ? (completedTasks / totalTasks) * 100
                                          : 0;

                                      return Text(
                                        '${completionRate.toStringAsFixed(0)}% done',
                                        style: TextStyle(
                                          color: white.withOpacity(0.5),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: HomeTab(),
            ),
          ),
        ],
      ),
      floatingActionButton: Transform.scale(
        scale: _animation.value,
        child: FloatingActionButton(
          backgroundColor: primary,
          elevation: 10,
          onPressed: _onFabPressed,
          child: const Icon(
            Icons.add,
            color: white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
