import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/screens/home/tabs/home_tab.dart';
import 'package:todo_app/screens/home/tabs/profile_tab.dart';
import 'package:todo_app/screens/task/task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<double> _animation;

  int _bottomNavIndex = 0;

  final iconList = <IconData>[
    Icons.list_alt_outlined,
    // Icons.favorite,
    // Icons.calendar_today,
    Icons.person,
  ];

  final tabList = <Widget>[
    const HomeTab(),
    // HomeTab(),
    // HomeTab(),
    const ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addListener(() { setState(() {}); });

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
    Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskScreen(),),);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 5,left: 20,right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(child: tabList[_bottomNavIndex]),
              ),
              // Use Container or IndexedStack instead of Expanded
            ],
          ),
        ),
      ),
      floatingActionButton: Transform.scale(
        scale: _animation.value,
        child: FloatingActionButton(
          backgroundColor: primary,
          onPressed: _onFabPressed,
          child: const Icon(Icons.add,color: white,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? secondaryColorDark : secondaryColorLight,
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,

        activeColor: primary,
        splashColor: Theme.of(context).brightness == Brightness.dark ? white : black,
        inactiveColor: Theme.of(context).brightness == Brightness.dark ? white : black,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
