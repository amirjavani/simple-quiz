import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:quizzler2/BrainQuestion.dart';

BrainQuestion brainQuestion = BrainQuestion();
bool isFinished = false;
int questionIndex = 0;

void main() => runApp(Quizzler());

class Quizzler extends StatefulWidget {
  const Quizzler({Key? key}) : super(key: key);

  @override
  State<Quizzler> createState() => _QuizzlerState();
}

class _QuizzlerState extends State<Quizzler> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "good job",
            style: TextStyle(color: Colors.white),
          ),
          Row(
            children: [],
          ),
        ],
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  var userAnswer = [];

  int questionIndex = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  void checkAnswer(bool answerValue) {
    if (brainQuestion.questionGetter(questionIndex).correctAnswer ==
        answerValue) {
      userAnswer.add(true);
    } else {
      userAnswer.add(false);
    }
    if (questionIndex == 12) {
      for (bool answer in userAnswer) {
        if (answer) {
          correctAnswers++;
        } else {
          wrongAnswers++;
        }
      }
      _onAlertButtonPressed(context);
      isFinished = true;
    }
  }

  _onAlertButtonPressed(context) {
    Alert(
      context: context,
      title: (correctAnswers > wrongAnswers) ? " good job " : "try better",
      content: Column(
        children: [
          (correctAnswers > wrongAnswers)
              ? const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 200,
                )
              : const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 200,
                ),
          Row(
            children: [
              for (bool answer in userAnswer)
                if (answer)
                  Expanded(
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  )
                else
                  Expanded(
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  )
            ],
          ),
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Reset",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            setState(() {
              questionIndex = 0;
              userAnswer = [];
              wrongAnswers = 0;
              correctAnswers = 0;
              Navigator.pop(context);
            });
          },
          width: 120,
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                (questionIndex < 13)
                    ? brainQuestion.questionGetter(questionIndex).question
                    : 'tamam',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                setState(() {
                  if (questionIndex < brainQuestion.questionLength()) {
                    checkAnswer(true);
                    questionIndex++;
                  }
                });
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: const Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                setState(() {
                  if (questionIndex < brainQuestion.questionLength()) {
                    checkAnswer(false);
                    questionIndex++;
                  }
                });
              },
            ),
          ),
        ),
        Row(
          children: [
            for (bool answer in userAnswer)
              if (answer)
                Icon(
                  Icons.check,
                  color: Colors.green,
                )
              else
                Icon(
                  Icons.close,
                  color: Colors.red,
                )
          ],
        )
      ],
    );
  }
}
