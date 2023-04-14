import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String name = "";
  int grade = 0;
  int distance = 0;
  int income = 0;
  int students = 0;

  final List<Map<String, dynamic>> grades = [
    {'title': 'A', 'value': 0},
    {'title': 'B+', 'value': 1},
    {'title': 'B', 'value': 2},
    {'title': 'C', 'value': 3},
    {'title': 'D', 'value': 4},
  ];

  final List<Map<String, dynamic>> distances = [
    {'title': '0 - 0.75 KM', 'value': 0},
    {'title': '0.76 - 1.5 KM', 'value': 1},
    {'title': '1.51 - 2.25 KM', 'value': 2},
    {'title': '2.26 - 3 KM', 'value': 3},
    {'title': '> 3 KM', 'value': 4},
  ];

  final List<Map<String, dynamic>> incomes = [
    {'title': '0 - 25.000', 'value': 0},
    {'title': '26.000 - 50.000', 'value': 1},
    {'title': '51.000 - 75.000', 'value': 2},
    {'title': '76.000 - 100.000', 'value': 3},
    {'title': '> 100.000', 'value': 4},
  ];

  final List<Map<String, dynamic>> studentsList = [
    {'title': '50 - 100 Siswa per tahun ajaran', 'value': 0},
    {'title': '100 - 200 Siswa per tahun ajaran', 'value': 1},
    {'title': '200 - 300 Siswa per tahun ajaran', 'value': 2},
    {'title': '> 300 Siswa per tahun ajaran', 'value': 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Waspas'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Grade',
                  ),
                  value: grade,
                  items: grades
                      .map<DropdownMenuItem<int>>((Map<String, dynamic> grade) {
                    return DropdownMenuItem<int>(
                      value: grade['value'],
                      child: Text(grade['title']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      grade = value!;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Distance',
                  ),
                  value: distance,
                  items: distances.map<DropdownMenuItem<int>>(
                      (Map<String, dynamic> distance) {
                    return DropdownMenuItem<int>(
                      value: distance['value'],
                      child: Text(distance['title']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      distance = value!;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Income',
                  ),
                  value: income,
                  items: incomes.map<DropdownMenuItem<int>>(
                      (Map<String, dynamic> income) {
                    return DropdownMenuItem<int>(
                      value: income['value'],
                      child: Text(income['title']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      income = value!;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Number of Students',
                  ),
                  value: students,
                  items: studentsList.map<DropdownMenuItem<int>>(
                      (Map<String, dynamic> students) {
                    return DropdownMenuItem<int>(
                      value: students['value'],
                      child: Text(students['title']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      students = value!;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    if (kDebugMode) {
                      print('Name: $name');
                      print('Grade: ${grades[grade]['title']}');
                      print('Distance: ${distances[distance]['title']}');
                      print('Income: ${incomes[income]['title']}');
                      print(
                          'Number of Students: ${studentsList[students]['title']}');
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
