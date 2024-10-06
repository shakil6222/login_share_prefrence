import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login_share_prefrence/home_screen.dart';
import 'package:login_share_prefrence/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SplaceScreen extends StatefulWidget {
  const SplaceScreen({super.key, required String title});

  @override
  State<SplaceScreen> createState() => _SplaceScreenState();
}

class _SplaceScreenState extends State<SplaceScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 2),
      () {
        loginStates();
      },
    );
  }

  // Login States for New User
  void loginStates() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? isLogin = pref.getBool('isLogin');
    if (isLogin != null && isLogin) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50,
                  backgroundImage: NetworkImage(
                      "https://th.bing.com/th/id/OIP.06PCKbs2UGMyg6l1I5cQwQAAAA?rs=1&pid=ImgDetMain"),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Text(
                        "My Flutter App",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "FlutterLogonScreen\nv2.1.0",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
