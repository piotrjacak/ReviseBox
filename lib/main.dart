import 'package:flutter/material.dart';

import 'package:revise_box/classes/flashcard_set.dart';
import 'package:revise_box/classes/flashcard.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:revise_box/revise_screen/revise.dart';
import 'package:revise_box/set_screen/sets.dart';

import 'package:revise_box/test_screen/test.dart';
import 'package:revise_box/profile_screen/profile.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revise_box/l10n/l10n.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();

  static MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();
}

class MyAppState extends State<MyApp> {
  Locale locale = const Locale('en');

  void setLocale(Locale value) {
    setState(() {
      locale = value;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReviseBox',
      theme: ThemeData(
          fontFamily: 'Inter',
          colorSchemeSeed: defaultColor,
          useMaterial3: true),
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      locale: locale,
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
    () => const TestPage(),
    () => const ProfilePage(),
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore),
            label: AppLocalizations.of(context)!.sets,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.edit),
            label: AppLocalizations.of(context)!.revise,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.check),
            label: AppLocalizations.of(context)!.test,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
      ),
    );
  }
}
