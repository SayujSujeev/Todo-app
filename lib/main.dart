import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/provider/list_provider.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/provider/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/screens/landing/landing_screen.dart';
import 'package:todo_app/screens/splash/splash_screen.dart';

import 'constants/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider(FirebaseAuth.instance)),
        ChangeNotifierProvider(create: (_) => ListProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: bgColorLight,
        colorScheme: const ColorScheme.light(
          secondary: secondaryColorLight,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(6),
          ),
        ), textSelectionTheme: const TextSelectionThemeData(cursorColor: primary),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bgColorDark,
        colorScheme: const ColorScheme.dark(
          secondary: secondaryColorDark,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(6),
          ),
        ), textSelectionTheme: const TextSelectionThemeData(cursorColor: primary),
      ),
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      home: const AnimatedSplashScreen(),
    );
  }
}

