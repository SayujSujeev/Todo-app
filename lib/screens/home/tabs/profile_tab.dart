import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/provider/theme_provider.dart';
import 'package:todo_app/screens/login/login_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark/Light theme',style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),),
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
                    }
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                final provider = Provider.of<AuthProvider>(context, listen: false);
                await provider.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen())
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

