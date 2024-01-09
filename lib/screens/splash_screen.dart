import 'dart:async';
import 'package:ezi_taskmanager/screens/auth_screen.dart';
import 'package:flutter/material.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
            () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AuthScreen())));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Image.asset('assets/images/image1.png')
    );
  }
}


