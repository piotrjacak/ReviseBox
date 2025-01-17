import 'package:flutter/material.dart';
import 'package:revise_box/classes/flashcard.dart';
import 'package:revise_box/main.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewFlashcardPage extends StatefulWidget {
  const NewFlashcardPage({super.key});

  @override
  State<NewFlashcardPage> createState() => _NewFlashcardPageState();
}

class _NewFlashcardPageState extends State<NewFlashcardPage> {
  final _formKey = GlobalKey<FormState>();
  Flashcard? flashcard;

  String question = '';

  // For "ABC" type
  List<String> answers = [];
  String correct = '';
  String? wrong1;
  String? wrong2;
  String? wrong3;

  // For "Text" type
  String? text = '';
  String? gap = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.addNewFlashcard,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Container(
                height: 40.0,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Color.fromARGB(156, 88, 161, 255),
                ),
                child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: const BoxDecoration(
                        color: defaultColor,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      const Tab(child: Text("ABC")),
                      Tab(child: Text(AppLocalizations.of(context)!.text)),
                    ]),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
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
                            AppLocalizations.of(context)!.question,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 20.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                label: Text(
                                    "${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.question}"),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter a question'
                                      : null,
                              onSaved: (value) => question = value!,
                            ),
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.correct} ${AppLocalizations.of(context)!.answer}",
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0, right: 40.0),
                            child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Please enter a correct answer'
                                        : null,
                                onSaved: (value) {
                                  correct = value!;
                                  answers.add(correct);
                                }),
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.wrong} ${AppLocalizations.of(context)!.answer} 1",
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0, right: 40.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              onSaved: (value) {
                                wrong1 = value;
                                if (wrong1 != null) {
                                  answers.add(wrong1!);
                                }
                              },
                            ),
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.wrong} ${AppLocalizations.of(context)!.answer} 2",
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0, right: 40.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              onSaved: (value) {
                                wrong2 = value;
                                if (wrong2 != null) {
                                  answers.add(wrong2!);
                                }
                              },
                            ),
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.wrong} ${AppLocalizations.of(context)!.answer} 3",
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0, right: 40.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              onSaved: (value) {
                                wrong3 = value;
                                if (wrong3 != null) {
                                  answers.add(wrong3!);
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0, right: 40.0),
                            child: FloatingActionButton.extended(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  flashcard = Flashcard(
                                      type: "ABC",
                                      question: question,
                                      answers: answers,
                                      correct: correct,
                                      text: text,
                                      gap: gap);
                                  Navigator.pop(context, flashcard);
                                }
                              },
                              label: Text(AppLocalizations.of(context)!
                                  .addThisFlashcard),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text("temp"),
          ],
        ),
      ),
    );
  }
}
