import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model_theme.dart';

List<String> _totalCreditHours = [];
List<String> _sgpa = [];
var _first = true;
var _cgpa = 0.0;
var _cgpaDisplay = "0.00";

List<GlobalKey<FormState>> _formKey = [];

class CgpaScreen extends StatefulWidget {
  final ModelTheme themeNotifier;

  const CgpaScreen(this.themeNotifier, {super.key});

  @override
  State<CgpaScreen> createState() => _CgpaScreenState();
}

class _CgpaScreenState extends State<CgpaScreen> {
  _CgpaScreenState();

  @override
  void initState() {
    if (_first) {
      for (int i = 0; i < 5; i++) {
        addMore();
      }
      _first = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: _totalCreditHours.length + 2,
      itemBuilder: (context, index) {
        if (index == _totalCreditHours.length) {
          return addingButtons();
        } else if (index == _totalCreditHours.length + 1) {
          return addingLastRow();
        }
        return addFormRow(index);
      },
    );
  }

  List<Color> colorDark = [
    const Color.fromARGB(255, 90, 43, 219),
    const Color.fromARGB(255, 197, 47, 47),
  ];
  List<Color> colorLight = [
    const Color(0xFF6DE195),
    const Color(0xFFC4E759),
  ];

  Widget addFormRow(int i) {
    return Form(
      key: _formKey[i],
      child: Container(
        alignment: Alignment.center,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              colors: widget.themeNotifier.isDark ? colorDark : colorLight),
        ),
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              children: <Widget>[
                makeText("Total Cr: "),
                Container(
                  width: 30,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 8),
                    ),
                    initialValue: _totalCreditHours[i],
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      _totalCreditHours[i] = value;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                makeText("SGPA: "),
                Container(
                  width: 50,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 8),
                    ),
                    initialValue: _sgpa[i],
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))
                    ],
                    onChanged: (value) {
                      _sgpa[i] = value;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
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
            onPressed: calculateCGPA,
            child: const Text("Submit"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 25),
          child: Text(
            "CGPA: $_cgpaDisplay",
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

  void addMore() {
    _formKey.add(GlobalKey<FormState>());
    _totalCreditHours.add("");
    _sgpa.add("");
    if (!_first) setState(() {});
  }

  void removeRow() {
    setState(() {
      if (_totalCreditHours.isEmpty) return;
      _totalCreditHours.removeLast();
      _sgpa.removeLast();
      _formKey.removeLast();
    });
  }

  void calculateCGPA() {
    setState(() {
      _cgpa = 0.00;
      if (_totalCreditHours.isEmpty) {
        _cgpaDisplay = _cgpa.toStringAsFixed(2);
        return;
      }
      var totalCreditHours = 0;
      for (int i = 0; i < _totalCreditHours.length; i++) {
        var currentIndexCR =
            _totalCreditHours[i] != "" ? int.parse(_totalCreditHours[i]) : 0;
        var currentIndexSGPA = _sgpa[i] != "" ? double.parse(_sgpa[i]) : 0.0;
        totalCreditHours += currentIndexCR;
        _cgpa += (currentIndexCR * currentIndexSGPA);
      }
      _cgpa /= totalCreditHours == 0 ? 1 : totalCreditHours;
      _cgpaDisplay = _cgpa.toStringAsFixed(2);
    });
  }
}
