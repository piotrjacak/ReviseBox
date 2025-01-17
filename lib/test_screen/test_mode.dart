import 'dart:math';
import 'package:flutter/material.dart';

import 'package:revise_box/main.dart';
import 'package:revise_box/classes/flashcard.dart';
import 'package:revise_box/classes/flashcard_set.dart';
import 'package:revise_box/test_screen/test_result.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TestModePage extends StatefulWidget {
  const TestModePage({super.key, required this.set});

  final FlashcardSet set;

  @override
  State<TestModePage> createState() => _TestModePageState();
}

class _TestModePageState extends State<TestModePage>
    with TickerProviderStateMixin {
  late AnimationController controller;

  int flashcardIdx = 0;
  bool answerMode = true;
  bool initialize = true;

  int correctAnswerIdx = 0;
  List<String> answers = [];
  List<Color> colors = List.filled(4, Colors.grey.shade300);

  Map<int, bool> isCorrectResults = {};

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          if (!isCorrectResults.containsKey(flashcardIdx)) {
            isCorrectResults[flashcardIdx] = false;
          }
          if (flashcardIdx < widget.set.cards.length - 1) {
            initialize = true;
            answerMode = true;
            colors = List.filled(4, Colors.grey.shade300);
            flashcardIdx += 1;
            setState(() {});
            controller.reverse(from: 1.0);
          } else {
            controller.stop();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TestResultPage(
                        setTitle: widget.set.title,
                        isCorrectResults: isCorrectResults)));
          }
        }
      });
    controller.reverse(from: 1.0);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildAnswer(Flashcard flashcard, int answerIdx) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
      child: InkWell(
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: colors[answerIdx],
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              answers[answerIdx],
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        onTap: () {
          if (answerMode) {
            if (answers[answerIdx] == flashcard.correct) {
              colors[answerIdx] = Colors.green;
              isCorrectResults[flashcardIdx] = true;
            } else {
              colors[answerIdx] = Colors.red.shade300;
              colors[correctAnswerIdx] = Colors.green;
              isCorrectResults[flashcardIdx] = false;
            }

            answerMode = false;
            setState(() {});
          }
        },
      ),
    );
  }

  Widget buildTestCard(Flashcard flashcard) {
    if (initialize) {
      answers = [flashcard.correct, ...flashcard.answers];
      answers.shuffle(Random());
      answers = answers.toSet().toList();

      for (int i = 0; i < answers.length; i++) {
        if (answers[i] == flashcard.correct) {
          correctAnswerIdx = i;
          break;
        }
      }
      initialize = false;
    }

    return Container(
        height: 550,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                height: 20,
                child: Center(
                  child: Text(
                    "${AppLocalizations.of(context)!.question} ${flashcardIdx + 1}/${widget.set.cards.length}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                height: 100.0,
                child: Center(
                  child: Text(
                    flashcard.question,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              buildAnswer(flashcard, 0),
              answers.length > 1 ? buildAnswer(flashcard, 1) : const Center(),
              answers.length > 2 ? buildAnswer(flashcard, 2) : const Center(),
              answers.length > 3 ? buildAnswer(flashcard, 3) : const Center(),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.set.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  LinearProgressIndicator(
                    value: controller.value,
                  ),
                  const SizedBox(height: 30),
                  buildTestCard(widget.set.cards[flashcardIdx]),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, bottom: 50.0, left: 20.0, right: 20.0),
                    child: InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        height: 60.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: defaultColor,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.next,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      onTap: () {
                        if (!isCorrectResults.containsKey(flashcardIdx)) {
                          isCorrectResults[flashcardIdx] = false;
                        }

                        if (flashcardIdx < widget.set.cards.length - 1) {
                          controller.reverse(from: 1.0);
                          initialize = true;
                          answerMode = true;
                          colors = List.filled(4, Colors.grey.shade300);
                          flashcardIdx += 1;
                          setState(() {});
                        } else {
                          controller.stop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TestResultPage(
                                      setTitle: widget.set.title,
                                      isCorrectResults: isCorrectResults)));
                        }
                      },
                    ),
                  )
                ]),
          )),
    );
  }
}
