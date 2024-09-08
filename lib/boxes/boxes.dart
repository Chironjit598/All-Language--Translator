import 'package:hive/hive.dart';
import 'package:translator/model/history_model.dart';

class Boxes {
  static Box<HistoryModel>getHistory()=>Hive.box("history");
  static Box<HistoryModel>getFavourite()=>Hive.box("favourite");
  
}