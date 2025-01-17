import 'package:flutter/material.dart';
import 'package:revise_box/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String currentLanguage = 'en';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.profile,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.only(
                top: 30.0, bottom: 30.0, right: 20.0, left: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: const CircleAvatar(
                      backgroundColor: Color.fromARGB(156, 117, 177, 255),
                      radius: 40.0,
                      child: Text('JP',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 90.0, bottom: 10.0, left: 30.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.settings,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 2.0, color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                    child: InkWell(
                        child: Container(
                          height: 80.0,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.changeLanguage,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.language,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey.shade700,
                                ),
                              )
                            ],
                          )),
                        ),
                        onTap: () {
                          if (currentLanguage == 'en') {
                            currentLanguage = 'pl';
                            MyApp.of(context)!.setLocale(
                                const Locale.fromSubtags(languageCode: 'pl'));
                          } else {
                            currentLanguage = 'en';
                            MyApp.of(context)!.setLocale(
                                const Locale.fromSubtags(languageCode: 'en'));
                          }
                          setState(() {});
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: InkWell(
                      child: Container(
                        height: 80.0,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.signOut,
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
