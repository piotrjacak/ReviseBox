import 'package:flutter/material.dart';

import 'package:revise_box/classes/flashcard_set.dart';
import 'package:revise_box/classes/flashcard.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:revise_box/revise_screen/revise.dart';
import 'package:revise_box/set_screen/sets.dart';


const defaultColor = Color.fromARGB(156, 0, 110, 255);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(FlashcardSetAdapter());
  Hive.registerAdapter(FlashcardAdapter());
  //await Hive.deleteBoxFromDisk("flashcardsSetBox");
  await Hive.openBox<FlashcardSet>("flashcardsSetBox");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

  int pageIndex = 0;

  List<Widget Function()> widgetList = [
    () => const SetsPage(),
    () => const RevisePage(),
    () => const Center(child:  Text("Temp")),
    () => const Center(child:  Text("Temp")),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: widgetList[pageIndex](),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              pageIndex = value;
            });
          },
          currentIndex: pageIndex,
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
    );
  }
}

