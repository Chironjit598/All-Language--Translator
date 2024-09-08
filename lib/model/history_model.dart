
import 'package:hive/hive.dart';
part 'history_model.g.dart';

@HiveType(typeId: 0)
class HistoryModel extends HiveObject {
  @HiveField(0)
  String question;
  @HiveField(1)
  String answer;
  HistoryModel({required this.question, required this.answer});

  
  
}