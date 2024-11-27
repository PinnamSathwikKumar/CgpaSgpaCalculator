import 'package:flutter/material.dart';

void main() => runApp(const CgpaSgpaCalculatorApp());

class CgpaSgpaCalculatorApp extends StatelessWidget {
  const CgpaSgpaCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JNTUH CGPA & SGPA Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CGPA & SGPA Calculator')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SgpaCalculatorScreen()),
                    );
                  },
                  child: const Text('Calculate SGPA'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CgpaCalculatorScreen()),
                    );
                  },
                  child: const Text('Calculate CGPA'),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '© 2024 Pinnam Sathwik Kumar',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class Grade {
  final String letter;
  final int points;

  Grade(this.letter, this.points);
}

List<Grade> grades = [
  Grade('O', 10),
  Grade('A+', 9),
  Grade('A', 8),
  Grade('B+', 7),
  Grade('B', 6),
  Grade('C', 5),
  Grade('F', 0),
  Grade('Ab', 0),
];

class SgpaCalculatorScreen extends StatefulWidget {
  const SgpaCalculatorScreen({super.key});

  @override
  _SgpaCalculatorScreenState createState() => _SgpaCalculatorScreenState();
}

class _SgpaCalculatorScreenState extends State<SgpaCalculatorScreen> {
  int numberOfSubjects = 1;
  List<TextEditingController> subjectControllers = [];
  List<TextEditingController> creditControllers = [];
  List<String> selectedGrades = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    subjectControllers =
        List.generate(numberOfSubjects, (_) => TextEditingController());
    creditControllers =
        List.generate(numberOfSubjects, (_) => TextEditingController());
    selectedGrades = List.generate(numberOfSubjects, (_) => 'O');
  }

  void _calculateSgpa() {
    int totalCredits = 0;
    int totalGradePoints = 0;

    for (int i = 0; i < numberOfSubjects; i++) {
      int gradePoints =
          grades.firstWhere((g) => g.letter == selectedGrades[i]).points;
      int credits = int.tryParse(creditControllers[i].text) ?? 0;

      totalCredits += credits;
      totalGradePoints += gradePoints * credits;
    }

    double sgpa = totalCredits > 0 ? totalGradePoints / totalCredits : 0;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text('Your SGPA is: ${sgpa.toStringAsFixed(2)}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SGPA Calculator')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Number of Subjects'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        numberOfSubjects = int.tryParse(value) ?? 1;
                        _initializeControllers();
                      });
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: numberOfSubjects,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: subjectControllers[index],
                                decoration: InputDecoration(
                                    labelText: 'Subject ${index + 1}'),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: creditControllers[index],
                                decoration:
                                    const InputDecoration(labelText: 'Credits'),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            DropdownButton<String>(
                              value: selectedGrades[index],
                              items: grades.map((g) {
                                return DropdownMenuItem(
                                    value: g.letter, child: Text(g.letter));
                              }).toList(),
                              onChanged: (newGrade) {
                                setState(() {
                                  selectedGrades[index] = newGrade!;
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _calculateSgpa,
                    child: const Text('Calculate SGPA'),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '© 2024 Pinnam Sathwik Kumar',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class CgpaCalculatorScreen extends StatefulWidget {
  const CgpaCalculatorScreen({super.key});

  @override
  _CgpaCalculatorScreenState createState() => _CgpaCalculatorScreenState();
}

class _CgpaCalculatorScreenState extends State<CgpaCalculatorScreen> {
  int numberOfSemesters = 1;
  List<TextEditingController> sgpaControllers = [];
  List<TextEditingController> creditControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    sgpaControllers =
        List.generate(numberOfSemesters, (_) => TextEditingController());
    creditControllers =
        List.generate(numberOfSemesters, (_) => TextEditingController());
  }

  void _calculateCgpa() {
    int totalCredits = 0;
    double totalGradePoints = 0.0;

    for (int i = 0; i < numberOfSemesters; i++) {
      double sgpa = double.tryParse(sgpaControllers[i].text) ?? 0.0;
      int credits = int.tryParse(creditControllers[i].text) ?? 0;

      totalCredits += credits;
      totalGradePoints += sgpa * credits;
    }

    double cgpa = totalCredits > 0 ? totalGradePoints / totalCredits : 0;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text('Your CGPA is: ${cgpa.toStringAsFixed(2)}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CGPA Calculator')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Number of Semesters'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        numberOfSemesters = int.tryParse(value) ?? 1;
                        _initializeControllers();
                      });
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: numberOfSemesters,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: sgpaControllers[index],
                                decoration: InputDecoration(
                                    labelText: 'Semester ${index + 1} SGPA'),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: creditControllers[index],
                                decoration:
                                    const InputDecoration(labelText: 'Credits'),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _calculateCgpa,
                    child: const Text('Calculate CGPA'),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '© 2024 Pinnam Sathwik Kumar',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
