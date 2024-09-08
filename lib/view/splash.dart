import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';
import 'package:translator/boxes/interstial_ads.dart';
import 'package:translator/view/bottom_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Get.to(BottomNavigationPage());
      intarsitailAds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: AnimatedSplashScreen(
      //   backgroundColor: Colors.indigo.shade200,
      //   splash: Lottie.asset("assets/file/splash_animation.json"),
      //   nextScreen: BottomNavigationPage(),
      //   splashIconSize: 280.sp,
      //   duration: 3000,
      //   splashTransition: SplashTransition.scaleTransition,
      //   animationDuration: Duration(milliseconds: 300),
      // ),

      body: Center(
        child: Lottie.asset("assets/file/splash_animation.json", height: 280.h),
      ),
    );
  }
}
