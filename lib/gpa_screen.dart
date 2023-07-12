import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model_theme.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();

  static MyHomePageState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyHomePageState>();
}

class MyHomePageState extends State<MyHomePage> {
  List<List<String>> dropDown = [[], []];

  var items = [
    ['0', '4', '3', '2', '1'],
    ['A+/A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'F'],
  ];

  var gradePoint = [
    4.00,
    3.67,
    3.33,
    3.00,
    2.67,
    2.33,
    2.00,
    1.67,
    1.33,
    1.00,
    0.00
  ];

  List<Color> colorDark = [
    const Color.fromARGB(255, 90, 43, 219),
    const Color.fromARGB(255, 197, 47, 47),
  ];
  List<Color> colorLight = [
    const Color(0xFF6DE195),
    const Color(0xFFC4E759),
    // Colors.blueAccent,
    // Colors.green,
  ];

  var whatIt = ["Cr: ", 'Grade: '];
  var left = [25.0, 0.0];

  var gpa = 0.0;
  String gpaDisplay = "0.00";

  @override
  void initState() {
    for (int i = 0; i < 5; i++) {
      addMore();
    }
    super.initState();
  }

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
                return homeScreen(themeNotifier);
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

  Widget homeScreen(ModelTheme themeNotifier) {
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
      body: homeScreenBody(themeNotifier),
    );
  }

  Widget homeScreenBody(ModelTheme themeNotifier) {
    return addingColumn(themeNotifier);
  }

  Widget addingColumn(ModelTheme themeNotifier) {
    return ListView.builder(
      itemCount: dropDown[0].length + 2,
      itemBuilder: (context, index) {
        if(index == dropDown[0].length){
          return addingButtons();
        }
        else if(index == dropDown[0].length + 1){
          return addingLastRow();
        }
        return Container(
          alignment: Alignment.center,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(colors: themeNotifier.isDark ? colorDark : colorLight),
          ),
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
          child: addingDropDown(index),
        );
      },
    );
  }

  Widget addingDropDown(int i) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: (context, index) {
        int j = 0;
        String text = "";
        if(index == 0){
          text = "Cr:";
          j = 1;
        }
        else if(index == 2){
          text = "Grade:";
          j = 0;
        }

        if(index == 0 || index == 2){
          return Padding(
            padding: EdgeInsets.only(left: left[j], top: 10),
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          );
        }
        else if(index == 1) {
          j = 0;
        }
        else if(index == 3){
          j = 1;
        }
        return ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            value: dropDown[j][i],
            icon: const Icon(Icons.keyboard_arrow_down),
            items: items[j].map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(
                () {
                  dropDown[j][i] = newValue!;
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget addingLastRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            right: 30.0,
            bottom: 25,
          ),
          child: ElevatedButton(
            onPressed: calculateGPA,
            child: const Text("Submit"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 25),
          child: Text(
            "GPA: $gpaDisplay",
            style: const TextStyle(fontSize: 20.0),
          ),
        ),
      ],
    );
  }

  Widget addingButtons() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: ElevatedButton(
              onPressed: addMore,
              child: const Text("Add"),
            ),
          ),
          ElevatedButton(
            onPressed: removeRow,
            child: const Text("Remove"),
          )
        ],
      ),
    );
  }

  void calculateGPA() {
    setState(() {
      gpa = 0.00;
      if (dropDown[0].isEmpty) {
        gpaDisplay = gpa.toStringAsFixed(2);
        return;
      }
      var totalCreditHours = 0;
      for (int i = 0; i < dropDown[0].length; i++) {
        totalCreditHours += int.parse(dropDown[0][i]);
        var selected = dropDown[1][i];
        var index = items[1].indexOf(selected);
        gpa += (int.parse(dropDown[0][i]) * gradePoint[index]);
      }
      gpa /= totalCreditHours == 0 ? 1 : totalCreditHours;
      gpaDisplay = gpa.toStringAsFixed(2);
    });
  }

  void addMore() {
    setState(() {
      dropDown[0].add('0');
      dropDown[1].add('A+/A');
    });
  }

  void removeRow() {
    setState(() {
      if (dropDown[0].isEmpty) return;
      for (int i = dropDown[0].length - 1; i > -1; i--) {
        if (dropDown[0][i].compareTo('0') == 0 &&
            dropDown[1][i].compareTo("A+/A") == 0) {
          dropDown[0].removeAt(i);
          dropDown[1].removeAt(i);
          return;
        }
      }
      for (int i = dropDown[0].length - 1; i > -1; i--) {
        if (dropDown[0][i].compareTo('0') == 0) {
          dropDown[0].removeAt(i);
          dropDown[1].removeAt(i);
          return;
        }
      }
      dropDown[0].removeAt(dropDown[0].length - 1);
      dropDown[1].removeAt(dropDown[1].length - 1);
      return;
    });
  }
}
