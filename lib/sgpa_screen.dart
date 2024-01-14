import 'package:flutter/material.dart';
import 'model_theme.dart';

class MyHomePage extends StatefulWidget {
  final ModelTheme themeNotifier;

  const MyHomePage(this.themeNotifier, {Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

List<List<String>> _dropDown = [[], []];
var _firstTime = true;
var _gpa = 0.0;
String _gpaDisplay = "0.00";

class MyHomePageState extends State<MyHomePage> {
  MyHomePageState();

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
  ];

  var whatIt = ["Cr: ", 'Grade: '];
  var left = [25.0, 0.0];

  @override
  void initState() {
    if (_firstTime) {
      for (int i = 0; i < 5; i++) {
        addMore();
      }
      _firstTime = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return homeScreenBody();
  }

  Widget homeScreenBody() {
    return addingColumn();
  }

  Widget addingColumn() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: _dropDown[0].length + 2,
      itemBuilder: (context, index) {
        if (index == _dropDown[0].length) {
          return addingButtons();
        } else if (index == _dropDown[0].length + 1) {
          return addingLastRow();
        }
        return Container(
          alignment: Alignment.center,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
                colors: widget.themeNotifier.isDark ? colorDark : colorLight),
          ),
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
          child: addingDropDown(index),
        );
      },
    );
  }

  Widget addingDropDown(int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          children: [
            makeText("Cr: "),
            makeDropDown(i, 0),
          ],
        ),
        Row(
          children: [
            makeText("Grade: "),
            makeDropDown(i, 1),
          ],
        )
      ],
    );
  }

  Widget makeDropDown(int i, int j) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButton(
        value: _dropDown[j][i],
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
              _dropDown[j][i] = newValue!;
            },
          );
        },
      ),
    );
  }

  Widget makeText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
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
            "GPA: $_gpaDisplay",
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
      _gpa = 0.00;
      if (_dropDown[0].isEmpty) {
        _gpaDisplay = _gpa.toStringAsFixed(2);
        return;
      }
      var totalCreditHours = 0;
      for (int i = 0; i < _dropDown[0].length; i++) {
        totalCreditHours += int.parse(_dropDown[0][i]);
        var selected = _dropDown[1][i];
        var index = items[1].indexOf(selected);
        _gpa += (int.parse(_dropDown[0][i]) * gradePoint[index]);
      }
      _gpa /= totalCreditHours == 0 ? 1 : totalCreditHours;
      _gpaDisplay = _gpa.toStringAsFixed(2);
    });
  }

  void addMore() {
    setState(() {
      _dropDown[0].add('0');
      _dropDown[1].add('A+/A');
    });
  }

  void removeRow() {
    setState(() {
      if (_dropDown[0].isEmpty) return;
      _dropDown[0].removeLast();
      _dropDown[1].removeLast();
    });
  }
}
