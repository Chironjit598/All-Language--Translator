import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/boxes/boxes.dart';

import 'package:translator/boxes/lang_coun_code.dart';
import 'package:translator/model/history_model.dart';
import 'package:translator/view/bottomnavigationbar_page/favourite_screen.dart';
import 'package:translator/view/bottomnavigationbar_page/history_screen.dart';
import 'package:translator/view/widget/circle_avater_widget.dart';
import 'package:translator/view/widget/circle_button.dart';
import 'package:translator/view/widget/drwer_listttile.dart';
import 'package:translator/view/widget/toast_widget.dart';
import 'package:translator_plus/translator_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class TranslatorScreen extends StatefulWidget {
  TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final translator = GoogleTranslator();
  String from = 'en';
  String to = "bn";
  String data = "";
  String? selectedValue = "English";
  String? selectedValue2 = "Bengali";

  final fromKey = GlobalKey<FormState>();
  bool isLoading = false;
  String speechText = "";
  TextEditingController controller = TextEditingController();
  SpeechToText? _speech;
  bool _isListening = false;
  String _text = '';
  bool translated = false;
  late BannerAd _bannerAd;
  bool _isTranslateButtonVisible = false;

  @override
  void initState() {
    super.initState();
    _speech = SpeechToText();
  }

  translat() async {
    try {
      if (fromKey.currentState!.validate()) {
        translator.translate(controller.text, from: from, to: to).then((value) {
          data = value.text;
          final historyData =
              HistoryModel(question: controller.text, answer: value.text);
          final box = Boxes.getHistory();
          box.add(historyData);

          isLoading = false;
          translated = true;
          setState(() {});
        });
      } else {
        ToastWidget(msg: "Please type something");
      }
    } on SocketException catch (_) {
      isLoading = true;
      SnackBar mySnackbar = SnackBar(
        content: Text("Internet not connected"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(mySnackbar);
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _bannerAd.dispose();

    super.dispose();
  }
  // ======== launch more app function======

  _launchMoreApps() async {
    const url =
        'https://play.google.com/store/apps/developer?id=Chironjit+Roy&hl=en&gl=US'; // Replace with your website URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // ======== launch more app function======

  _checkUpdateApps() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.chironjitroy.language_translator'; // Replace with your website URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // ======== privacy policy function======

  _privacyPolicy() async {
    const url =
        'https://sites.google.com/view/languagetrans/home'; // Replace with your website URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.indigo.shade900,
        child: ListView(
          children: [
            DrawerHeader(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: Image.asset(
                          "assets/logo/translator_logo.png",
                          height: 60.h,
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "All Lanuage Translator",
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomListTileWithNav(
                context: context,
                icon: Icons.history_outlined,
                title: "History",
                ontp: HistoryPage()),
            CustomListTileWithNav(
                context: context,
                icon: Icons.favorite,
                title: "Favourites",
                ontp: FavouritePage()),
            InkWell(
                onTap: () {
                  LaunchReview.launch(
                    androidAppId: "com.chironjitroy.language_translator",
                  );
                },
                child:
                    CustomListtile(title: "Rate Us", icon: Icons.rate_review)),
            InkWell(
                onTap: () => Share.share(
                    "https://play.google.com/store/apps/details?id=com.chironjit_roy.bangladesh_weather"),
                child: CustomListtile(title: "Share", icon: Icons.share)),
            InkWell(
                onTap: () {
                  _launchMoreApps();
                },
                child: CustomListtile(title: "More App", icon: Icons.more)),
            InkWell(
              onTap: () {
                _checkUpdateApps();
              },
              child: CustomListtile(
                  title: "Check Update", icon: Icons.check_circle_outline),
            ),
            InkWell(
                onTap: () {
                  _privacyPolicy();
                },
                child: CustomListtile(
                    title: "Privacy Policy", icon: Icons.privacy_tip)),
            InkWell(
                onTap: () => SystemNavigator.pop(),
                child: CustomListtile(
                    title: "Exit", icon: Icons.exit_to_app_outlined)),
          ],
        ),
      ),
      backgroundColor: Colors.indigo.shade200,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the drawer icon here
        ),
        elevation: 0,
        backgroundColor: Colors.indigo.shade900,
        title: Text(
          "Translator App",
          style: TextStyle(
              color: Colors.white,
              fontSize: 23.sp,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Container(
              height: 52.h,
              margin: EdgeInsets.symmetric(horizontal: 9.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: DropdownButton(
                        iconEnabledColor: Colors.indigo.shade900,
                        underline: Container(
                          height: 0,
                        ),
                        alignment: Alignment.center,
                        value: selectedValue,
                        focusColor: Colors.transparent,
                        items: languages.map((lang) {
                          return DropdownMenuItem(
                              onTap: () {
                                if (lang == languages[0]) {
                                  from = languageCode[0];
                                } else if (lang == languages[1]) {
                                  from = languageCode[1];
                                } else if (lang == languages[2]) {
                                  from = languageCode[2];
                                } else if (lang == languages[3]) {
                                  from = languageCode[3];
                                } else if (lang == languages[4]) {
                                  from = languageCode[4];
                                } else if (lang == languages[5]) {
                                  from = languageCode[5];
                                } else if (lang == languages[6]) {
                                  from = languageCode[6];
                                } else if (lang == languages[7]) {
                                  from = languageCode[7];
                                } else if (lang == languages[8]) {
                                  from = languageCode[8];
                                } else if (lang == languages[9]) {
                                  from = languageCode[9];
                                } else if (lang == languages[10]) {
                                  from = languageCode[10];
                                } else if (lang == languages[11]) {
                                  from = languageCode[11];
                                } else if (lang == languages[12]) {
                                  from = languageCode[12];
                                } else if (lang == languages[13]) {
                                  from = languageCode[13];
                                } else if (lang == languages[14]) {
                                  from = languageCode[14];
                                } else if (lang == languages[15]) {
                                  from = languageCode[15];
                                } else if (lang == languages[16]) {
                                  from = languageCode[16];
                                } else if (lang == languages[17]) {
                                  from = languageCode[17];
                                } else if (lang == languages[18]) {
                                  from = languageCode[18];
                                } else if (lang == languages[19]) {
                                  from = languageCode[19];
                                } else if (lang == languages[20]) {
                                  from = languageCode[20];
                                } else if (lang == languages[21]) {
                                  from = languageCode[21];
                                } else if (lang == languages[22]) {
                                  from = languageCode[22];
                                } else if (lang == languages[23]) {
                                  from = languageCode[23];
                                } else if (lang == languages[24]) {
                                  from = languageCode[24];
                                } else if (lang == languages[25]) {
                                  from = languageCode[25];
                                } else if (lang == languages[26]) {
                                  from = languageCode[26];
                                } else if (lang == languages[27]) {
                                  from = languageCode[27];
                                } else if (lang == languages[28]) {
                                  from = languageCode[28];
                                } else if (lang == languages[29]) {
                                  from = languageCode[29];
                                } else if (lang == languages[30]) {
                                  from = languageCode[30];
                                } else if (lang == languages[31]) {
                                  from = languageCode[31];
                                } else if (lang == languages[32]) {
                                  from = languageCode[32];
                                } else if (lang == languages[33]) {
                                  from = languageCode[33];
                                } else if (lang == languages[34]) {
                                  from = languageCode[34];
                                } else if (lang == languages[35]) {
                                  from = languageCode[35];
                                } else if (lang == languages[36]) {
                                  from = languageCode[36];
                                } else if (lang == languages[37]) {
                                  from = languageCode[37];
                                } else if (lang == languages[38]) {
                                  from = languageCode[38];
                                } else if (lang == languages[39]) {
                                  from = languageCode[39];
                                } else if (lang == languages[40]) {
                                  from = languageCode[40];
                                } else if (lang == languages[41]) {
                                  from = languageCode[41];
                                } else if (lang == languages[42]) {
                                  from = languageCode[42];
                                } else if (lang == languages[43]) {
                                  from = languageCode[43];
                                } else if (lang == languages[44]) {
                                  from = languageCode[44];
                                } else if (lang == languages[45]) {
                                  from = languageCode[45];
                                } else if (lang == languages[46]) {
                                  from = languageCode[46];
                                } else if (lang == languages[47]) {
                                  from = languageCode[47];
                                } else if (lang == languages[48]) {
                                  from = languageCode[48];
                                } else if (lang == languages[49]) {
                                  from = languageCode[49];
                                } else if (lang == languages[50]) {
                                  from = languageCode[50];
                                } else if (lang == languages[51]) {
                                  from = languageCode[51];
                                } else if (lang == languages[51]) {
                                  from = languageCode[52];
                                } else if (lang == languages[53]) {
                                  from = languageCode[53];
                                } else if (lang == languages[54]) {
                                  from = languageCode[54];
                                } else if (lang == languages[55]) {
                                  from = languageCode[55];
                                } else if (lang == languages[56]) {
                                  from = languageCode[56];
                                } else if (lang == languages[57]) {
                                  from = languageCode[57];
                                } else if (lang == languages[58]) {
                                  from = languageCode[58];
                                } else if (lang == languages[59]) {
                                  from = languageCode[59];
                                } else if (lang == languages[60]) {
                                  from = languageCode[60];
                                } else if (lang == languages[61]) {
                                  from = languageCode[61];
                                } else if (lang == languages[62]) {
                                  from = languageCode[62];
                                } else if (lang == languages[63]) {
                                  from = languageCode[63];
                                } else if (lang == languages[64]) {
                                  from = languageCode[64];
                                } else if (lang == languages[65]) {
                                  from = languageCode[65];
                                } else if (lang == languages[66]) {
                                  from = languageCode[66];
                                } else if (lang == languages[67]) {
                                  from = languageCode[67];
                                } else if (lang == languages[68]) {
                                  from = languageCode[68];
                                } else if (lang == languages[69]) {
                                  from = languageCode[69];
                                } else if (lang == languages[70]) {
                                  from = languageCode[70];
                                }
                                setState(() {});
                              },
                              value: lang,
                              child: Container(
                                  padding: EdgeInsets.all(0),
                                  child: Row(
                                    children: [
                                      Text(
                                        lang,
                                        style: TextStyle(
                                          color: Colors.indigo.shade900,
                                        ),
                                      ),
                                    ],
                                  )));
                        }).toList(),
                        onChanged: (value) {
                          selectedValue = value;
                        }),
                  ),
                  Text(
                    " To",
                    style: TextStyle(
                        fontSize: 23.sp,
                        color: Colors.indigo.shade900,
                        fontWeight: FontWeight.w700),
                  ),
                  Flexible(
                    child: DropdownButton(
                        iconEnabledColor: Colors.indigo.shade900,
                        underline: Container(
                          height: 0,
                        ),
                        alignment: Alignment.topCenter,
                        value: selectedValue2,
                        focusColor: Colors.transparent,
                        items: languages.map((lang) {
                          return DropdownMenuItem(
                              onTap: () {
                                if (lang == languages[0]) {
                                  to = languageCode[0];
                                } else if (lang == languages[1]) {
                                  to = languageCode[1];
                                } else if (lang == languages[2]) {
                                  to = languageCode[2];
                                } else if (lang == languages[3]) {
                                  to = languageCode[3];
                                } else if (lang == languages[4]) {
                                  to = languageCode[4];
                                } else if (lang == languages[5]) {
                                  to = languageCode[5];
                                } else if (lang == languages[6]) {
                                  to = languageCode[6];
                                } else if (lang == languages[7]) {
                                  to = languageCode[7];
                                } else if (lang == languages[8]) {
                                  to = languageCode[8];
                                } else if (lang == languages[9]) {
                                  to = languageCode[9];
                                } else if (lang == languages[10]) {
                                  to = languageCode[10];
                                } else if (lang == languages[11]) {
                                  to = languageCode[11];
                                } else if (lang == languages[12]) {
                                  to = languageCode[12];
                                } else if (lang == languages[13]) {
                                  to = languageCode[13];
                                } else if (lang == languages[14]) {
                                  to = languageCode[14];
                                } else if (lang == languages[15]) {
                                  to = languageCode[15];
                                } else if (lang == languages[16]) {
                                  to = languageCode[16];
                                } else if (lang == languages[17]) {
                                  to = languageCode[17];
                                } else if (lang == languages[18]) {
                                  to = languageCode[18];
                                } else if (lang == languages[19]) {
                                  to = languageCode[19];
                                } else if (lang == languages[20]) {
                                  to = languageCode[20];
                                } else if (lang == languages[21]) {
                                  to = languageCode[21];
                                } else if (lang == languages[22]) {
                                  to = languageCode[22];
                                } else if (lang == languages[23]) {
                                  to = languageCode[23];
                                } else if (lang == languages[24]) {
                                  to = languageCode[24];
                                } else if (lang == languages[25]) {
                                  to = languageCode[25];
                                } else if (lang == languages[26]) {
                                  to = languageCode[26];
                                } else if (lang == languages[27]) {
                                  to = languageCode[27];
                                } else if (lang == languages[28]) {
                                  to = languageCode[28];
                                } else if (lang == languages[29]) {
                                  to = languageCode[29];
                                } else if (lang == languages[30]) {
                                  to = languageCode[30];
                                } else if (lang == languages[31]) {
                                  to = languageCode[31];
                                } else if (lang == languages[32]) {
                                  to = languageCode[32];
                                } else if (lang == languages[33]) {
                                  to = languageCode[33];
                                } else if (lang == languages[34]) {
                                  to = languageCode[34];
                                } else if (lang == languages[35]) {
                                  to = languageCode[35];
                                } else if (lang == languages[36]) {
                                  to = languageCode[36];
                                } else if (lang == languages[37]) {
                                  to = languageCode[37];
                                } else if (lang == languages[38]) {
                                  to = languageCode[38];
                                } else if (lang == languages[39]) {
                                  to = languageCode[39];
                                } else if (lang == languages[40]) {
                                  to = languageCode[40];
                                } else if (lang == languages[41]) {
                                  to = languageCode[41];
                                } else if (lang == languages[42]) {
                                  to = languageCode[42];
                                } else if (lang == languages[43]) {
                                  to = languageCode[43];
                                } else if (lang == languages[44]) {
                                  to = languageCode[44];
                                } else if (lang == languages[45]) {
                                  to = languageCode[45];
                                } else if (lang == languages[46]) {
                                  to = languageCode[46];
                                } else if (lang == languages[47]) {
                                  to = languageCode[47];
                                } else if (lang == languages[48]) {
                                  to = languageCode[48];
                                } else if (lang == languages[49]) {
                                  to = languageCode[49];
                                } else if (lang == languages[50]) {
                                  to = languageCode[50];
                                } else if (lang == languages[51]) {
                                  to = languageCode[51];
                                } else if (lang == languages[51]) {
                                  to = languageCode[52];
                                } else if (lang == languages[53]) {
                                  to = languageCode[53];
                                } else if (lang == languages[54]) {
                                  to = languageCode[54];
                                } else if (lang == languages[55]) {
                                  to = languageCode[55];
                                } else if (lang == languages[56]) {
                                  to = languageCode[56];
                                } else if (lang == languages[57]) {
                                  to = languageCode[57];
                                } else if (lang == languages[58]) {
                                  to = languageCode[58];
                                } else if (lang == languages[59]) {
                                  to = languageCode[59];
                                } else if (lang == languages[60]) {
                                  to = languageCode[60];
                                } else if (lang == languages[61]) {
                                  to = languageCode[61];
                                } else if (lang == languages[62]) {
                                  to = languageCode[62];
                                } else if (lang == languages[63]) {
                                  to = languageCode[63];
                                } else if (lang == languages[64]) {
                                  to = languageCode[64];
                                } else if (lang == languages[65]) {
                                  to = languageCode[65];
                                } else if (lang == languages[66]) {
                                  to = languageCode[66];
                                } else if (lang == languages[67]) {
                                  to = languageCode[67];
                                } else if (lang == languages[68]) {
                                  to = languageCode[68];
                                } else if (lang == languages[69]) {
                                  to = languageCode[69];
                                } else if (lang == languages[70]) {
                                  to = languageCode[70];
                                }
                                setState(() {
                                  print(lang);
                                  print(to);
                                });
                              },
                              value: lang,
                              child: Text(
                                lang,
                                style: TextStyle(
                                  color: Colors.indigo.shade900,
                                ),
                              ));
                        }).toList(),
                        onChanged: (value) {
                          selectedValue2 = value;
                        }),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 9.w, right: 9.w, top: 5.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white,
                  ),
                  child: Form(
                    key: fromKey,
                    child: TextFormField(
                      controller: controller,
                      onChanged: (text) {
                        setState(() {
                          _isTranslateButtonVisible = text.isNotEmpty;
                          translated = text.isNotEmpty;
                        });
                      },
                      maxLines: 7,
                      minLines: null,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please return some text";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.indigo.shade900),
                          hintText: "Type Here",
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          border: InputBorder.none,
                          errorStyle: TextStyle(color: Colors.white)),
                      style: TextStyle(
                          color: Colors.indigo.shade900,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp),
                    ),
                  ),
                ),
                Positioned(
                    right: 150.w,
                    bottom: _speech!.isNotListening ? 10 : 0.h,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            _listen();
                          },
                          child: _speech!.isNotListening
                              ? CircleButton(icon: Icons.mic)
                              : CircleAvaterWidget(),
                        ),
                        SizedBox(
                          width: 7.w,
                        ),
                        InkWell(
                            onTap: () {
                              textfeildTextToSpeak();
                            },
                            child: Visibility(
                                visible: translated,
                                child: CircleButton(icon: Icons.volume_up)))
                      ],
                    )),
                Positioned(
                    right: 20.w,
                    top: 20.h,
                    child: Row(
                      children: [
                        Container(
                          child: InkWell(
                              onTap: () {
                                controller.clear();
                                translated = false;
                                _isTranslateButtonVisible = false;

                                data = "";
                                setState(() {});
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.indigo.shade900,
                              )),
                        ),
                        SizedBox(
                          width: 7.w,
                        ),
                      ],
                    )),
                Positioned(
                  bottom: 5.h,
                  right: 15.w,
                  child: Visibility(
                    visible: _isTranslateButtonVisible,
                    child: ElevatedButton(
                        onPressed: () {
                          translat();

                          // intarsitailAds;

                          setState(() {});
                        },
                        style: ButtonStyle(
                            fixedSize:
                                MaterialStatePropertyAll(Size(125.w, 36.h)),
                            backgroundColor: MaterialStatePropertyAll(
                                Colors.indigo.shade900)),
                        child: isLoading
                            ? SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Translate",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4.h,
            ),
            Stack(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  height: 235.h,
                  width: double.maxFinite,
                  margin: EdgeInsets.only(left: 9.w, right: 9.w, top: 5.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 17.w, vertical: 15.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white70,
                  ),
                  child: SelectableText(
                    data,
                    style: TextStyle(
                        color: Colors.indigo.shade900,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                    bottom: 13.h,
                    right: 22.w,
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              textToSpeak();
                            },
                            child: CircleButton(icon: Icons.volume_up)),
                        SizedBox(
                          width: 7.w,
                        ),
                        InkWell(
                            onTap: () {
                              favourite();
                            },
                            child: CircleButton(icon: Icons.favorite)),
                        SizedBox(
                          width: 7.w,
                        ),
                        InkWell(
                            onTap: () {
                              _textCopy(text: data);
                            },
                            child: CircleButton(icon: Icons.copy_outlined)),
                        SizedBox(
                          width: 7.w,
                        ),
                        InkWell(
                            onTap: () {
                              shareText();
                            },
                            child: CircleButton(icon: Icons.share)),
                      ],
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  //========Copy text Start code==========

  void _textCopy({required text}) {
    if (fromKey.currentState!.validate()) {
      Clipboard.setData(ClipboardData(text: text));
      ToastWidget(msg: "Copy Succesfull");
    } else {
      ToastWidget(msg: "Empty Data...");
    }
  }

  //========favourite data function====

  void favourite() {
    if (fromKey.currentState!.validate()) {
      final favData = HistoryModel(question: controller.text, answer: data);
      final favBox = Boxes.getFavourite();
      favBox.add(favData);

      ToastWidget(msg: "added to favourites");
    } else {
      ToastWidget(msg: "Please type something...");
    }
  }

  //===========share text function===================

  void shareText() {
    if (data.isNotEmpty) {
      Share.share(data);
    } else {
      ToastWidget(msg: "Empty Data");
    }
  }

  //====== text to speech function=========

  Future<void> textToSpeak() async {
    if (data.isNotEmpty) {
      FlutterTts flutterTts = FlutterTts();
      flutterTts.speak(data);
    } else {
      ToastWidget(msg: "Empty Data...");
    }
  }

  //====== textfeild text to speech function=========

  Future<void> textfeildTextToSpeak() async {
    if (data.isNotEmpty) {
      FlutterTts flutterTts = FlutterTts();
      flutterTts.speak(controller.text);
    } else {
      ToastWidget(msg: "Empty Data...");
    }
  }

  //=============speech to text===========

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech!.initialize(
        onStatus: (status) {
          print('onStatus: $status');
        },
        onError: (errorNotification) {
          print('onError: $errorNotification');
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
        });

        _speech?.listen(
          onResult: (result) {
            String recognizedText = result.recognizedWords;
            setState(() {
              _text = recognizedText;
              controller.text = _text;
              _isTranslateButtonVisible = true;
              translated = true;
            });
          },
          localeId: from,
        );
      }
    } else {
      setState(() {
        _isListening = false;
      });

      _speech?.stop();
    }
  }
}
