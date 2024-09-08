import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomListtile extends StatelessWidget {
  String title;
  var icon;

  CustomListtile({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

Widget CustomListTileWithNav(
    {context, required icon, required title, required ontp}) {
  return ListTile(
    leading: Icon(
      icon,
      color: Colors.white,
    ),
    title: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
    onTap: () =>
        Navigator.push(context, MaterialPageRoute(builder: (context) => ontp)),
  );
}
