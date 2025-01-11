import 'package:flutter/material.dart';


class RevisionResultPage extends StatefulWidget {
  const RevisionResultPage({super.key, required this.setTitle, required this.isEasyResults});

  final String setTitle;
  final Map<int, bool> isEasyResults;

  @override
  State<RevisionResultPage> createState() => _RevisionResultPageState();
}

class _RevisionResultPageState extends State<RevisionResultPage> {

  @override
  Widget build(BuildContext context) {

    double easyResult = widget.isEasyResults.values.where((value) => value).length / widget.isEasyResults.length * 100;
    double hardResult = widget.isEasyResults.values.where((value) => !value).length / widget.isEasyResults.length * 100;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Results",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        automaticallyImplyLeading: false,
      ),
      
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 60.0),
        child: SingleChildScrollView(
          child: Container(
            height: 550,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Text(
                      widget.setTitle,
                      style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold,
                      )
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(156, 76, 154, 255),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 40.0),
                              child: Text(
                                "Easy",
                                style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 40.0),
                              child: Text(
                                "${easyResult.toStringAsFixed(1)} %",
                                style: const TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.red.shade200,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 40.0),
                              child: Text(
                                "Hard",
                                style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 40.0),
                              child: Text(
                                "${hardResult.toStringAsFixed(1)} %",
                                style: const TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 90.0,),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      child: InkWell(
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: const Center(
                            child: Text(
                              "Go Back",
                              style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white
                              ),
                            ),
                          )
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      ),
                    ),
                  ],
                ),
              ),
            )
          )
        )
      )
    );
  }
}

