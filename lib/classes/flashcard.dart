class Flashcard {
  final String question;
  final String type;

  // For "ABC" type
  final List<String> answers; 
  final String correct;       

  // For "Text" type
  final String? text;         
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