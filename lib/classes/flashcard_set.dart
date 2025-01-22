import 'package:hive/hive.dart';
import 'flashcard.dart';

part 'flashcard_set.g.dart';

@HiveType(typeId: 0)
class FlashcardSet extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String subtitle;

  @HiveField(3)
  late bool finished;

  @HiveField(4)
  late bool favourite;

  @HiveField(5)
  late List<Flashcard> cards;

  FlashcardSet({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.finished,
    required this.favourite,
    required this.cards,
  });
}
