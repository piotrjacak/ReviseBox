import 'package:flutter/material.dart';

import 'package:revise_box/classes/flashcard_set.dart';
import 'package:revise_box/screens/new_set.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


const defaultColor = Color.fromARGB(156, 0, 110, 255);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(FlashcardSetAdapter());
  await Hive.deleteBoxFromDisk("flashcardsSetBox");
  await Hive.openBox<FlashcardSet>("flashcardsSetBox");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReviseBox',
      theme: ThemeData(
        fontFamily: 'Inter', 
        colorSchemeSeed: defaultColor, useMaterial3: true
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  int setsCount = 0;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "ReviseBox",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            IconButton(
              onPressed: () {}, 
              icon: const Icon(
                Icons.search,
              ),
            ),
          ],
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
                      Tab(child: Text("All")),
                      Tab(child: Text("To-do")),
                      Tab(child: Text("Finished")),
                    ]
                  ),
              ),
            ),
          ),
        ),
        
        body: TabBarView(
          children: [
            ValueListenableBuilder<Box<FlashcardSet>>(
              valueListenable: Hive.box<FlashcardSet>("flashcardsSetBox").listenable(),
              builder: (context, box, _) {
                final sets = box.values.toList().cast<FlashcardSet>();
                setsCount = sets.length;

                return ListView.builder(
                  itemCount: sets.length,
                  itemBuilder: (context, index) {
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
                                children: <Widget>[
                                  Text(
                                    sets[index].title,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    sets[index].subtitle,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      sets[index].favourite ? Icons.favorite : Icons.favorite_border,
                                      color: defaultColor,
                                    ),
                                    onPressed: () {
                                      if (sets[index].favourite) {
                                        sets[index].favourite = false;
                                      }
                                      else {
                                        sets[index].favourite = true;
                                      }
                                      setState(() {});
                                    }
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: defaultColor,
                                    ),
                                    onPressed: () {
                                      sets[index].delete();
                                      setState(() {});
                                    },
                                  )
                                ],
                              )
                            ],
                          )
                        ),
                      ), 
                    );
                  },
                );
              },
            ),
            const Text("temp"),
            const Text("temp"),
          ],
        ),

        // body: 

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewSetPage(setsCount: setsCount)),
            );
          },
          label: const Text('Create new set'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: "Sets",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              label: "Revise",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check),
              label: "Test",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      )
    );
  }
}

