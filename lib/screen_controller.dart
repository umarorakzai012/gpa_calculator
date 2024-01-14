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
  @override
  Widget build(BuildContext context) {
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
                WidgetsBinding.instance.addPostFrameCallback(
                  (timeStamp) => CheckUpdate(
                    context: context,
                    fromNavigation: false,
                  ),
                );
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.calculate),
              ),
              Tab(
                icon: Icon(Icons.calculate),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyHomePage(themeNotifier),
            CgpaScreen(themeNotifier),
          ],
        ),
      ),
    );
  }
}
