import 'dart:async';

import 'package:flutter/material.dart';

import '../feed screen/feed_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) =>  FeedScreen(id: '',)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Container
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(image: AssetImage( 'assets/icons/iconfree.png',))
                // boxShadow: [
                //   // BoxShadow(
                //   //   color: Colors.white.withOpacity(0.3),
                //   //   blurRadius: 30,
                //   //   spreadRadius: 5,
                //   // ),
                // ],
              ),
              // child: Center(
              //   child: ClipRRect(
              //     // borderRadius: BorderRadiusGeometry.circular(12),
              //     child: Image.asset(
              //       'assets/icons/playstore.jpeg',
              //       fit: BoxFit.fill,
              //     ),
              //   ),
              // ),
            ),
            // const SizedBox(height: 40),
            //
            // // App Name
            // const Text(
            //   'Srishna',
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 48,
            //     fontWeight: FontWeight.bold,
            //     letterSpacing: 8,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // const Text(
            //   'Telugu',
            //   style: TextStyle(
            //     color: Colors.white70,
            //     fontSize: 24,
            //     fontWeight: FontWeight.w300,
            //     letterSpacing: 6,
            //   ),
            // ),
            // const SizedBox(height: 60),

            // Loading Indicator
            // SizedBox(
            //   width: 40,
            //   height: 40,
            //   child: CircularProgressIndicator(
            //     strokeWidth: 3,
            //     valueColor: AlwaysStoppedAnimation<Color>(
            //       Colors.white.withOpacity(0.7),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
