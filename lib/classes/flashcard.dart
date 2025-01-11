import 'package:hive/hive.dart';

part 'flashcard.g.dart';

@HiveType(typeId: 1)
class Flashcard {

  @HiveField(0)
  final String question;
  
  @HiveField(1)
  final String type;

  // For "ABC" type
  @HiveField(2)
  final List<String> answers; 
  
  @HiveField(3)
  final String correct;       

  // For "Text" type
  @HiveField(4)
  final String? text;         
  
  @HiveField(5)
  final String? gap;   

  Flashcard({
    required this.type,
    required this.question,
    required this.answers, 
    required this.correct,
    required this.text, 
    required this.gap,
  });
}