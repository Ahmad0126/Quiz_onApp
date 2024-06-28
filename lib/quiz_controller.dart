import 'package:quiz_onapp/question.dart';

class QuizController {
  final List<Question> questionBank;

  QuizController(this.questionBank);

  int _questionNumber = 0;


  void nextQuestion(){
    if(_questionNumber < questionBank.length -1){
      _questionNumber++;
    }
  }

  String getQuestionText(){
    return questionBank[_questionNumber].soal;
  }
  
  String getPage(){
    return "${_questionNumber +1} / ${questionBank.length}";
  }

  bool getCorrectAnswer(){
    return questionBank[_questionNumber].jawaban;
  }

  bool isFinished(){
    if(_questionNumber >= questionBank.length -1){
      return true;
    }else{
      return false;
    }
  }

  void reset(){
    _questionNumber = 0;
  }
}