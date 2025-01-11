import 'dart:math';
import 'package:flutter/material.dart';

import 'package:revise_box/main.dart';
import 'package:revise_box/classes/flashcard.dart';
import 'package:revise_box/classes/flashcard_set.dart';
import 'package:revise_box/revise_screen/revision_result.dart';

class RevisionModePage extends StatefulWidget {
  const RevisionModePage({super.key, required this.set});

  final FlashcardSet set;

  @override
  State<RevisionModePage> createState() => _RevisionModePageState();
}

class _RevisionModePageState extends State<RevisionModePage> with TickerProviderStateMixin {

  late AnimationController flipController;
  late Animation flipAnimation;
  AnimationStatus flipStatus = AnimationStatus.dismissed;

  int flashcardIdx = 0;

  Map<int, bool> isEasyResults = {};


  @override
  void initState() {
    super.initState();
    
    flipController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    flipAnimation = Tween(end: 1.0, begin: 0.0).animate(flipController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        flipStatus = status;
      });
  }

  Widget buildFlashcard(Flashcard flashcard) {
    List<String> answers = [flashcard.correct, ...flashcard.answers];
    answers.shuffle(Random());
    answers = answers.toSet().toList();

    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(2, 1, 0.0015)
        ..rotateY(pi * flipAnimation.value),
      child: InkWell(
        child: Card(
          child: flipAnimation.value <= 0.5
            ? Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 30.0, left: 16.0, right: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0), 
                    height: 20,
                    child: Center(
                      child: Text(
                        "Question ${flashcardIdx + 1}/${widget.set.cards.length}",
                        style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        flashcard.question,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 80.0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 2.0, color: Colors.grey.shade300), 
                      ),
                    ),
                    child: Center(
                      child: Text(
                        answers[0],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 80.0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 2.0, color: Colors.grey.shade300), 
                      ),
                    ),
                    child: Center(
                      child: Text(
                        answers.length > 1 ? answers[1] : "",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 80.0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 2.0, color: Colors.grey.shade300), 
                      ),
                    ),
                    child: Center(
                      child: Text(
                        answers.length > 2 ? answers[2] : "",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 80.0,
                    color: Colors.grey.shade100,
                    child: Center(
                      child: Text(
                        answers.length > 3 ? answers[3] : "",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
            : Padding(
                padding: const EdgeInsets.only(
                  top: 30.0, bottom: 30.0, left: 16.0, right: 16.0
                ),
                child: Transform.scale(
                  scaleX: -1,
                  child: SizedBox(
                    height: 440,
                    child: Center(
                      child: Text(
                        flashcard.correct,
                        style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ),
        ),
        onTap: () {
          if (flipStatus == AnimationStatus.dismissed) {
            flipController.forward();
          }
          else {
            flipController.reverse();
          }          
        }
      ),
    );
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
      ) ,
      body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  buildFlashcard(widget.set.cards[flashcardIdx]),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        width: 200,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            "Previous card",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade900,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      if (flashcardIdx > 0) {
                        if (flipStatus != AnimationStatus.dismissed) {
                          await flipController.reverse();
                        }
                        flashcardIdx -= 1;
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, bottom: 50.0, left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            width: MediaQuery.sizeOf(context).width * 0.35,
                            height: 60.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.red.shade200,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                "Hard",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          onTap: () async {
                            isEasyResults[flashcardIdx] = false;
                            if (flashcardIdx < widget.set.cards.length - 1) {
                              if (flipStatus != AnimationStatus.dismissed) {
                                await flipController.reverse();
                              }
                              flashcardIdx += 1;
                              setState(() {});
                            }
                            else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RevisionResultPage(setTitle: widget.set.title, isEasyResults: isEasyResults))
                              );
                            }
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            width: MediaQuery.sizeOf(context).width * 0.35,
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
                            child: const Center(
                              child: Text(
                                "Easy",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          onTap: () async {
                            isEasyResults[flashcardIdx] = true;
                            if (flashcardIdx < widget.set.cards.length - 1) {
                              if (flipStatus != AnimationStatus.dismissed) {
                                await flipController.reverse();
                              }
                              flashcardIdx += 1;
                              setState(() {});
                            }
                            else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RevisionResultPage(setTitle: widget.set.title, isEasyResults: isEasyResults))
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ]),
          )),
    );
  }

}

