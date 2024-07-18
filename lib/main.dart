import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_project/models/quiz_model.dart';
import 'package:flutter_application_project/services/quiz_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizHomePage(),
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            fixedSize: Size(200, 60)
          ),
        ),
      ),
    );
  }
}

// Future<List<dynamic>> loadjson() async {
//   String jsonString = await rootBundle.loadString('assets/data.json');
//   return json.decode(jsonString)['quiz'];
// }

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  List<QuizQuestion>? _questionList;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizFinished = false;
  bool _startQuiz = false;
  @override
  void initState() {
    super.initState();
    _loadquestions();
  }

  void _startQuizfn() {
    setState(() {
      _startQuiz = true;
    });
  }

  Future<void> _loadquestions() async {
    List<QuizQuestion> questions = await fetchQuizQuedtions();
    setState(() {
      _questionList = questions;
    });
  }

  void _answerQuestion(String answer) {
    if (answer == _questionList![_currentQuestionIndex].answer) {
      _score++;
    }
    setState(() {
      if (_currentQuestionIndex < _questionList!.length - 1) {
        _currentQuestionIndex++;
      } else {
        _quizFinished = true;
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _quizFinished = false;
      _startQuiz = false;
    });
  }

  Widget build(BuildContext context) {
    if (!_startQuiz) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sample Quiz',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: _startQuizfn,
            child: const Text('Start Quiz'),
          ),
        ),
      );
    } else if (_quizFinished) {
      return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Sample Quiz',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: Center(
            child: Column(
              children: [
                Text('Your Score: $_score / ${_questionList!.length}'),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _restartQuiz,
                  child: Text('Restart Quiz'),
                )
              ],
            ),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Sample Quiz'),
          ),
          body: Center(
            child: Column(children: [
              Text(_questionList![_currentQuestionIndex].question),
              ..._buildOptions(),
            ]),
          ));
    }
  }

  Widget _buildOptionButton(String option) {
    return ElevatedButton(
        onPressed: () {
          _answerQuestion(option);
        },
        child: Text(
          option,
        ));
  }

  List<Widget> _buildOptions() {
    List<Widget> optionButtons = [];
    for (String option in _questionList![_currentQuestionIndex].options) {
      optionButtons.add(_buildOptionButton(option));
      optionButtons.add(SizedBox(
        height: 10,
      ));
    }
    return optionButtons;
  }
}
