import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget CircleAvaterWidget() {
  return AvatarGlow(
    glowColor: Colors.indigo.shade900,
    endRadius: 35.0.r,
    duration: Duration(milliseconds: 2000),
    repeat: true,
    showTwoGlows: true,
    repeatPauseDuration: Duration(milliseconds: 200),
    child: Material(
      // Replace this child with your own
      elevation: 8.0,
      shape: CircleBorder(),
      child: CircleAvatar(
        backgroundColor: Colors.indigo.shade900,
        child: Icon(
          Icons.mic,
          color: Colors.white,
        ),
        radius: 20.0.r,
      ),
    ),
  );
}
