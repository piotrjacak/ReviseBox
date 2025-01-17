import 'package:flutter/material.dart';
import 'package:revise_box/classes/flashcard_set.dart';
import 'package:revise_box/classes/flashcard.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:revise_box/set_screen/new_flashcard.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModifySetPage extends StatefulWidget {
  const ModifySetPage({super.key, required this.set});

  final FlashcardSet set;

  @override
  State<ModifySetPage> createState() => _ModifySetPageState();
}

class _ModifySetPageState extends State<ModifySetPage> {
  final _formKey = GlobalKey<FormState>();

  Future modifySet() async {
    final id = widget.set.id;
    final box = Hive.box<FlashcardSet>("flashcardsSetBox");
    final existingSet = box.get(id);

    if (existingSet != null) {
      final updatedSet = FlashcardSet(
        id: id,
        title: widget.set.title,
        subtitle: widget.set.subtitle,
        finished: widget.set.finished,
        favourite: widget.set.favourite,
        cards: List.from(widget.set.cards),
      );

      await box.put(id, updatedSet);
    } else {
      throw Exception("Set with id $id not found");
    }
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
        leading: BackButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              modifySet();
              Navigator.pop(context);
              setState(() {});
            }
          },
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
                        initialValue: widget.set.title,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter a title'
                            : null,
                        onSaved: (value) => widget.set.title = value!,
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
                        initialValue: widget.set.subtitle,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        onSaved: (value) => widget.set.subtitle = value!,
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
                                  widget.set.cards.add(newFlashcard);
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
                  final flashcard = widget.set.cards[index];
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
                                        title: const Text("Are you sure?",
                                            style: TextStyle(fontSize: 18.0)),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                widget.set.cards
                                                    .remove(flashcard);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Yes"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("No"),
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
                childCount: widget.set.cards.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          widget.set.finished = true;
          modifySet();
          Navigator.pop(context);
          setState(() {});
        },
        label: Text(AppLocalizations.of(context)!.markAsFinished),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
