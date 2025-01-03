import 'package:flutter/material.dart';
import 'package:revise_box/classes/flashcard_set.dart';
import 'package:revise_box/classes/flashcard.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:revise_box/screens/new_flashcard.dart';

class NewSetPage extends StatefulWidget {
  const NewSetPage({super.key, required this.setsCount});

  final int setsCount;

  @override
  State<NewSetPage> createState() => _NewSetPageState();
}


class _NewSetPageState extends State<NewSetPage> {

  final _formKey = GlobalKey<FormState>();
  String? newTitle;
  String? newSubtitle;

  List<Flashcard> flashcards = [];

  Future addFlashCard(int id, String title, String subtitle, bool finished, bool favourite, List<Flashcard> flashcards) async {
    final set = FlashcardSet(
      id: id, 
      title: title,
      subtitle: subtitle,
      finished: finished,
      favourite: favourite,
      cards: flashcards,
    );

    final box = Hive.box<FlashcardSet>("flashcardsSetBox");
    box.add(set);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "New set",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Title", 
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text("Enter title"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
                          onSaved: (value) => newTitle = value,
                        ),
                      ),
                      const Text(
                        "Subtitle", 
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text("Enter subtitle"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          onSaved: (value) => newSubtitle = value,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Flashcards", 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const NewFlashcardPage()),
                                );
                              }, 
                              icon: const Icon(Icons.add),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final flashcard = flashcards[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 12.0, right: 12.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 40.0, right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Question ${index + 1}",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    flashcard.question.substring(0, 20),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                ),
                                onPressed: () {
                                  setState(() {});
                                },
                              ),
                            ],
                          )
                        ),
                      ), 
                    );
                  },
                  childCount: flashcards.length,
                ),
              ),
            ],
          ),
        ),


        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              addFlashCard(widget.setsCount, newTitle!, newSubtitle!, false, false, flashcards);
              Navigator.pop(context);
            }
          },
          label: const Text('Add new set'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    }
}