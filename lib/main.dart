import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:translator/model/history_model.dart';
import 'package:translator/view/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  //for history
  Hive.registerAdapter(HistoryModelAdapter());
  await Hive.openBox<HistoryModel>("history");

  //for favourite
  await Hive.openBox<HistoryModel>("favourite");

  //for admob ads
  MobileAds.instance.initialize();
  runApp(Translator());
}

class Translator extends StatelessWidget {
  const Translator({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          theme: ThemeData(
            primaryIconTheme: IconThemeData(
              color: Colors.red, // Set the primary icon color here
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}
