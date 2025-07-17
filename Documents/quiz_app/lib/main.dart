import 'package:flutter/material.dart';
import 'package:quiz_app/question_bank.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Quizbank quizbank = Quizbank();
  List<Icon> scorekeeper = [];

  void checkscore(bool userselectedanswer) {
    bool correctanswer = quizbank.getanswer();

    setState(() {
      if (quizbank.isfinished() == true) {
        Alert(
          context: context,
          title: "Finished",
          desc: "You have Successfully completed",
        ).show();
        quizbank.reset();
        scorekeeper = [];
      } else {
        if (userselectedanswer == correctanswer) {
          scorekeeper.add(Icon(Icons.check, color: Colors.green));
        } else {
          scorekeeper.add(Icon(Icons.clear, color: Colors.red));
        }
        quizbank.nextquestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Text(
                  quizbank.getquestion(),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                checkscore(true);
              },
              child: Text(
                "True",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                checkscore(false);
              },
              child: Text(
                "False",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Row(children: scorekeeper),
        ],
      ),
    );
  }
}
