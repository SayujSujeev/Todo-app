import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final loadingNotifier = ValueNotifier<bool>(false);


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/todologo.png',
                color: primary,
                height: 50,
                width: 100,
              ),
              FadeTransition(
                opacity: _animation,
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        'ToDo',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      const Text(
                        'Prioritize your day with ToDo list.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      SvgPicture.asset(
                        'assets/images/loginillu.svg',
                        width: 350,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final provider = Provider.of<AuthProvider>(context, listen: false);
                      loadingNotifier.value = true;
                      try {
                        bool isSignedIn = await provider.signInWithGoogle();
                        if (isSignedIn) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen(),),);
                        } else {
                          // Handle the error here
                        }
                      } catch (e) {
                        print('Error: $e');
                      } finally {
                        loadingNotifier.value = false;
                      }
                    },
                    child: ValueListenableBuilder<bool>(
                      valueListenable: loadingNotifier,
                      builder: (context, isLoading, child) {
                        if (isLoading) {
                          // If loading, show a circular progress indicator
                          return const Center(
                            child: CircularProgressIndicator(
                              color: primary,
                            ),
                          );
                        } else {
                          // If not loading, show the normal button
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(6),
                                boxShadow: [BoxShadow(
                                    color: black.withOpacity(0.5),
                                    offset: const Offset(0,5),
                                    blurRadius: 5
                                )]
                            ),
                            child: const Center(
                              child: Text(
                                'Login with Google',
                                style: TextStyle(
                                  color: white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          );
                        }
                      },
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
    );
  }
}
