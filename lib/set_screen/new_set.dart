import 'package:flutter/material.dart';
import 'package:revise_box/classes/flashcard_set.dart';
import 'package:revise_box/classes/flashcard.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:revise_box/set_screen/new_flashcard.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  Future addSet(int id, String title, String subtitle, bool finished,
      bool favourite, List<Flashcard> flashcards) async {
    final set = FlashcardSet(
      id: id,
      title: title,
      subtitle: subtitle,
      finished: finished,
      favourite: favourite,
      cards: List.from(flashcards),
    );

    final box = Hive.box<FlashcardSet>("flashcardsSetBox");
    box.put(id, set);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.newSet,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: BackButton(
          onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.areYouSure,
                      style: const TextStyle(fontSize: 18.0)),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.yes),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.no),
                    ),
                  ],
                );
              }),
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
                    Text(
                      AppLocalizations.of(context)!.title,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          label: Text(
                              "${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.title}"),
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter a title'
                            : null,
                        onSaved: (value) => newTitle = value,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.subtitle,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          label: Text(
                              "${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.subtitle}"),
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
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
                          Text(
                            AppLocalizations.of(context)!.flashcards,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          IconButton(
                            onPressed: () async {
                              final newFlashcard =
                                  await Navigator.push<Flashcard>(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NewFlashcardPage()),
                              );

                              if (newFlashcard != null) {
                                setState(() {
                                  flashcards.add(newFlashcard);
                                });
                              }
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
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 5.0, left: 12.0, right: 12.0),
                    child: Card(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 40.0, right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${AppLocalizations.of(context)!.question} ${index + 1}",
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    flashcard.question.length >= 20
                                        ? "${flashcard.question.substring(0, 20)}..."
                                        : flashcard.question,
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
                                onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                            AppLocalizations.of(context)!
                                                .areYouSure,
                                            style: const TextStyle(
                                                fontSize: 18.0)),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                flashcards.remove(flashcard);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .yes),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .no),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          )),
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
            addSet(widget.setsCount, newTitle!, newSubtitle!, false, false,
                flashcards);
            Navigator.pop(context);
          }
        },
        label: Text(AppLocalizations.of(context)!.addNewSet),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
