import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:translator/boxes/boxes.dart';
import 'package:translator/model/history_model.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.indigo.shade900,
        title: Text(
          "History",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: ValueListenableBuilder<Box<HistoryModel>>(
          valueListenable: Boxes.getHistory().listenable(),
          builder: (context, box, _) {
            var data = box.values.toList().cast<HistoryModel>();
            return data.isEmpty
                ? Center(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100.h,
                      ),
                      Lottie.asset("assets/file/empty.json", height: 250.h),
                      Text(
                        "Empty History",
                        style: TextStyle(
                          fontSize: 25.sp,
                          color: Colors.indigo.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ))
                : ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white70,
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "From:",
                                    style: TextStyle(
                                        color: Colors.indigo.shade900,
                                        fontSize: 14.sp),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        delete(data[index]);
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.indigo.shade900,
                                      )),
                                ],
                              ),
                              Text(
                                data[index].question,
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.indigo.shade900,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              Text("To:",
                                  style: TextStyle(
                                      color: Colors.indigo.shade900,
                                      fontSize: 14.sp)),
                              SizedBox(
                                height: 3.h,
                              ),
                              Text(
                                data[index].answer,
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.indigo.shade900),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
          }),
    );
  }

  void delete(HistoryModel historyModel) async {
    await historyModel.delete();
  }
}
