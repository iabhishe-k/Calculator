import 'package:calculator/buttons.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userQuestion = "";
  var userAnswer = "";
  var equal = false;
  var nextQuestion = "";
  var bigger = false;

  final List<String> buttons = [
    'C',
    'DEL',
    '%',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '00',
    '0',
    '.',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(height: 60),
                  AnimatedContainer(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    duration: const Duration(seconds: 1),
                    child: Text(
                      userQuestion,
                      style: TextStyle(
                        fontSize: !bigger ? 40 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    duration: const Duration(seconds: 1),
                    child: Text(
                      userAnswer,
                      style: TextStyle(
                        fontSize: bigger ? 40 : 20,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  return MyButton(
                    buttonTapped: () {
                      setState(
                        () {
                          if (index == 1) {
                            userQuestion = userQuestion.substring(
                                0, userQuestion.length - 1);
                          } else if (index == 0) {
                            userQuestion = '';
                            userAnswer = '';
                            nextQuestion = '';
                          } else if (index == buttons.length - 1) {
                            equalPressed();
                          } else if(userQuestion.length<=15) {
                            if (equal == true) {
                              userQuestion = nextQuestion;
                              equal = false;
                              userAnswer = "";
                              bigger = false;
                            }
                            userQuestion += buttons[index];
                          }
                        },
                      );
                    },
                    color: isOperator(buttons[index])
                        ? Colors.deepPurple
                        : Colors.deepPurple[300],
                    textColor: Colors.white,
                    buttonText: buttons[index],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  bool isOperator(String x) {
    if (x == 'C' ||
        x == '%' ||
        x == 'DEL' ||
        x == '/' ||
        x == 'x' ||
        x == '-' ||
        x == '+' ||
        x == '=') {
      return true;
    }
    return false;
  }

  void equalPressed() {
    String finalQuestion = userQuestion;
    finalQuestion = finalQuestion.replaceAll('x', '*');
    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    int intEval = eval.toInt();
    if (eval - intEval == 0) {
      userAnswer = intEval.toString();
    } else {
      userAnswer = eval.toString();
    }
    nextQuestion = userAnswer;
    equal = true;
    bigger = true;
  }
}
