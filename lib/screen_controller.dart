import 'package:flutter/material.dart';
import 'package:gpa_calculator/update/update_checker.dart';
import 'package:provider/provider.dart';

import 'sgpa_screen.dart';
import 'model_theme.dart';
import 'cgpa_screen.dart';

class ScreenController extends StatefulWidget {
  const ScreenController({super.key});

  @override
  State<ScreenController> createState() => _ScreenControllerState();
}

class _ScreenControllerState extends State<ScreenController> {
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    CheckUpdate(fromNavigation: false, context: context);
    return ChangeNotifierProvider(
      create: (_) => ModelTheme(),
      child: Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
          return MaterialApp(
            title: 'GPA Calculator',
            theme: themeChanger(themeNotifier),
            debugShowCheckedModeBanner: false,
            home: Consumer<ModelTheme>(
              builder: (context, ModelTheme themeNotifier, child) {
                return scaffoldSettings(themeNotifier);
              },
            ),
          );
        },
      ),
    );
  }

  ThemeData themeChanger(ModelTheme themeNotifier) {
    return themeNotifier.isDark
        ? ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.indigo,
          )
        : ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.indigo,
          );
  }

  Widget scaffoldSettings(ModelTheme themeNotifier) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GPA Calculator"),
        actions: [
          IconButton(
            icon: Icon(
              themeNotifier.isDark ? Icons.nightlight_round : Icons.wb_sunny,
            ),
            onPressed: () {
              themeNotifier.isDark
                  ? themeNotifier.isDark = false
                  : themeNotifier.isDark = true;
            },
          ),
        ],
      ),
      body: _selected == 0
          ? MyHomePage(themeNotifier)
          : CgpaScreen(themeNotifier),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selected,
        selectedItemColor: Colors.blueAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: "SGPA",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: "CGPA")
        ],
        onTap: (value) {
          setState(() {
            _selected = value;
          });
        },
      ),
    );
  }
}
