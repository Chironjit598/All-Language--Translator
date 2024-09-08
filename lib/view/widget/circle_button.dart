import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget CircleButton({required icon}) {
  return Container(
    decoration:
        BoxDecoration(shape: BoxShape.circle, color: Colors.indigo.shade900),
    padding: EdgeInsets.all(7.h),
    child: Icon(
      icon,
      color: Colors.white,
    ),
  );
}
