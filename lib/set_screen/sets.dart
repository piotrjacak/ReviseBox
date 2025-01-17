import 'package:flutter/material.dart';

import 'package:revise_box/classes/flashcard_set.dart';
import 'package:revise_box/set_screen/modify_set.dart';
import 'package:revise_box/set_screen/new_set.dart';
import 'package:revise_box/main.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SetsPage extends StatefulWidget {
  const SetsPage({super.key});

  @override
  State<SetsPage> createState() => _SetsPageState();
}

class _SetsPageState extends State<SetsPage> {
  late Future<Box<FlashcardSet>> _boxFuture;
  int setsCount = 0;

  @override
  void initState() {
    super.initState();
    _boxFuture = Hive.openBox<FlashcardSet>("flashcardsSetBox");
  }

  // Widget for the Sets Page with filter function
  Widget buildFlashcardList(
      {required BuildContext context,
      required bool Function(FlashcardSet) filter}) {
    return FutureBuilder(
      future: _boxFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final box = snapshot.data!;
        return ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<FlashcardSet> box, _) {
            final sets =
                box.values.toList().cast<FlashcardSet>().where(filter).toList();
            setsCount = sets.length;

            return ListView.builder(
              itemCount: sets.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, bottom: 5.0, left: 12.0, right: 12.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ModifySetPage(set: sets[index])),
                      );
                    },
                    child: Card(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 40.0, right: 20.0),
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
                                        fontWeight: FontWeight.bold),
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
                                        sets[index].favourite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: defaultColor,
                                      ),
                                      onPressed: () {
                                        if (sets[index].favourite) {
                                          sets[index].favourite = false;
                                        } else {
                                          sets[index].favourite = true;
                                        }
                                        setState(() {});
                                      }),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: defaultColor,
                                    ),
                                    onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Are you sure?",
                                                style:
                                                    TextStyle(fontSize: 18.0)),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  sets[index].delete();
                                                  setState(() {});
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
                              )
                            ],
                          )),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
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
                  child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: const BoxDecoration(
                          color: defaultColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(child: Text(AppLocalizations.of(context)!.all)),
                        const Tab(child: Text("To-do")),
                        Tab(
                            child:
                                Text(AppLocalizations.of(context)!.finished)),
                      ]),
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              buildFlashcardList(
                context: context,
                filter: (_) => true, // Wszystkie elementy
              ),
              buildFlashcardList(
                context: context,
                filter: (set) => !set.finished, // Tylko nieukończone
              ),
              buildFlashcardList(
                context: context,
                filter: (set) => set.finished, // Tylko nieukończone
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewSetPage(setsCount: setsCount)),
              );
            },
            label: Text(AppLocalizations.of(context)!.createNewSet),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ));
  }
}
