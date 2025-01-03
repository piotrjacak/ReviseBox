import 'package:flutter/material.dart';
import 'package:revise_box/classes/flashcard.dart';

const defaultColor = Color.fromARGB(156, 0, 110, 255);

class NewFlashcardPage extends StatefulWidget {
  const NewFlashcardPage({super.key});

  @override
  State<NewFlashcardPage> createState() => _NewFlashcardPageState();
}


class _NewFlashcardPageState extends State<NewFlashcardPage> {

  final _formKey = GlobalKey<FormState>();
  Flashcard? flashcard;

  String? question;

  // For "ABC" type
  List<String> answers = []; 
  String? correct;      
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
          title: const Text(
            "Add new flashcard",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                  child: const TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: defaultColor,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(child: Text("ABC")),
                      Tab(child: Text("Text")),
                    ]
                  ),
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
                          const Text(
                            "Question", 
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                            child: TextFormField(
                            decoration: const InputDecoration(
                              label: Text("Enter question"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              validator: (value) => value == null || value.isEmpty ? 'Please enter a question' : null,
                              onSaved: (value) => question = value,
                            ),
                          ),
                          const Text(
                            "Correct answer", 
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 40.0),
                            child: TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              validator: (value) => value == null || value.isEmpty ? 'Please enter a correct answer' : null,
                              onSaved: (value) {
                                correct = value;
                                if (correct != null)
                                {
                                  answers.add(correct!);
                                }
                              }
                            ),
                          ),
                          const Text(
                            "Wrong answer 1", 
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 40.0),
                            child: TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              onSaved: (value) {
                                wrong1 = value;
                                if (wrong1 != null)
                                {
                                  answers.add(wrong1!);
                                }
                              },
                            ),
                          ),
                          const Text(
                            "Wrong answer 2", 
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 40.0),
                            child: TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              onSaved: (value) {
                                wrong2 = value;
                                if (wrong2 != null)
                                {
                                  answers.add(wrong2!);
                                }
                              },
                            ),
                          ),
                          const Text(
                            "Wrong answer 3", 
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 40.0),
                            child: TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              onSaved: (value) {
                                wrong3 = value;
                                if (wrong3 != null)
                                {
                                  answers.add(wrong3!);
                                }
                              },
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


        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
          },
          label: const Text('Add this flashcard'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
      ),
    );
  }
}