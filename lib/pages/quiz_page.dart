import 'package:flutter/material.dart';
import 'package:quiz_onapp/constants.dart';
import 'package:quiz_onapp/pages/login.dart';
import 'package:quiz_onapp/question.dart';
import 'package:quiz_onapp/quiz_controller.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class QuizPage extends StatefulWidget{
  final List<Question> questionBank;
  QuizPage(this.questionBank, {super.key});
  
  @override
  State<StatefulWidget> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>{
  Constants widgets = Constants();
  late QuizController quizController;
  late Function checkAnswer;
  int benar = 0;
  int salah = 0;

  @override
  void initState() {
    super.initState();
    quizController = QuizController(widget.questionBank);
    checkAnswer = (bool userAnswer){
      bool correctAnswer = quizController.getCorrectAnswer();

      setState(() {
        if(userAnswer == correctAnswer){
          benar += 1;
          Alert(
            context: context,
            title: "Benar!",
            desc: "Jawabanmu benar +1 poin",
            buttons: [
              DialogButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              )
            ]
          ).show();
        }else{
          salah += 1;
          Alert(
            context: context,
            title: "Salah!",
            desc: "Jawabanmu salah -1 poin",
            buttons: [
              DialogButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              )
            ]
          ).show();
        }
        if(quizController.isFinished()){
          Alert(
            context: context,
            title: "Selesai!",
            desc: "Kamu mendapat ${benar} poin",
            buttons: [
              DialogButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
                color: Colors.green,
              ),
              DialogButton(
                onPressed: (){
                  benar = 0;
                  salah = 0;
                  quizController.reset();
                },
                child: const Text("Reset"),
              )
            ]
          ).show();
          
        }else{
          quizController.nextQuestion();
        }
      });
    };
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widgets.appBar,
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login())
                  );
                }, 
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Login"),
                  subtitle: Text("Login untuk mengedit soal"),
                )
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Text(
                      quizController.getQuestionText(),
                      style: const TextStyle(color: Colors.white, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(fontSize: 20)
                          ),
                          onPressed: () { checkAnswer(true); },
                          child: const Text("True"),
                        ),
                      )
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(fontSize: 20)
                          ),
                          onPressed: () { checkAnswer(false); },
                          child: const Text("False"),
                        ),
                      )
                    )
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text("Statistik", style: TextStyle(fontSize: 18, color: Colors.white))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Benar : ${benar}", style: const TextStyle(color: Colors.white)),
                        Text("Salah : ${salah}", style: const TextStyle(color: Colors.white)),
                      ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(quizController.getPage(), style: const TextStyle(color: Colors.white))
                      ],
                    ),
                  ]
                ),
              )
            ],
          ),
        ),
      )
    );
  }

}