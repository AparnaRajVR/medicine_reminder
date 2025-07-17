import 'package:quiz_app/questions.dart';

class Quizbank{
  int _questionnumber = 0;
final List<Questions> _questionbank = [
  Questions(q: "The star sign Aquarius is represented by a tiger", a: false),
  Questions(
    q: "The letter A is the most common letter used in the English language",
    a: false,
  ),
  Questions(q: "ASOS stands for As Seen On Screen", a: true),
  Questions(q: "The Battle Of Hastings took place in 1066", a: true),
  Questions(q: "H&M stands for Hennes & Mauritz", a: true),
  Questions(q: "K is worth four points in Scrabble", a: true),
  Questions(q: "In a deck of cards, the king has a moustache", a: false),
  Questions(
    q: "When the two numbers on opposite sides of a dice are added together it always equals 7",
    a: true,
  ),
  Questions(
    q: "In the English language there is no word that rhymes with orange",
    a: true,
  ),
  Questions(q: "English is the most spoken language in the world", a: false),
];
void nextquestion(){
  if(_questionnumber <_questionbank.length-1){
    _questionnumber++;
    print(_questionnumber);
    print(_questionbank.length);
  }
}

String getquestion(){
  return _questionbank[_questionnumber].questions;
}

bool getanswer(){
  return _questionbank[_questionnumber].answers;
}

 bool isfinished(){
    if(_questionnumber==_questionbank.length-1){
      return true;
    }
    else{
      return false;
    }
  }
  void reset(){
    _questionnumber=0;
  }
}