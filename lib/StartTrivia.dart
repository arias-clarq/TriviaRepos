import 'dart:convert';
import 'dart:js_util';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/RandomTrivia.dart';
import 'service/getRandomTrivia.dart';
import 'package:html_unescape/html_unescape.dart';
// import 'package:http/http.dart' as http;

class StartTrivia extends StatefulWidget {
  const StartTrivia({super.key});

  @override
  State<StartTrivia> createState() => _StartTriviaState();
}

class _StartTriviaState extends State<StartTrivia> {
  final _getRandomTrivia = getRandomTrivia();
  RandomTrivia? _randomTrivia;

  String? question;

  //inside the _fetchTrivia you put a integer param for category
  _fetchTrivia(int category) async{
    try{
      final trivia = await _getRandomTrivia.getTrivia(category);
      setState(() {
        _randomTrivia = trivia;
        print("Question: ${_randomTrivia?.question}");
        print("Correct: ${_randomTrivia?.correctAnswer}");
      });
      question = HtmlUnescape().convert(_randomTrivia!.question);
    }catch(e){
      print(e);
    }
  }


  @override
  void initState() {
    _fetchTrivia(31); //31 is Entertainment: Japanese Anime & Manga
    super.initState();
  }

  void _showResultDialog(bool isCorrect) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Result'),
          content: Text(
              isCorrect ? 'Your choice is correct!' : 'Your choice is incorrect!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _fetchTrivia(31);
                Navigator.of(context).pop();
              },
              child: Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2c2c2c),
      appBar: AppBar(
        title: Text('Start Trivia', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Color(0xff8eaccd),
      ),
      body: Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(10),
                    height: 200,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Color(0xffD7E5CA),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text('Question: ${question ?? "loading.."}'),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color(0xffF9F3CC),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      children: [
                        ElevatedButton(onPressed: (){
                          bool isCorrect =
                              _randomTrivia!.correctAnswer.toLowerCase() == 'true';
                          _showResultDialog(isCorrect);
                        }, child: Text('True'))
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color(0xffD2E0FB),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      children: [
                        ElevatedButton(onPressed: (){
                          bool isCorrect =
                              _randomTrivia!.correctAnswer.toLowerCase() == 'false';
                          _showResultDialog(isCorrect);
                        }, child: Text('False'))
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

}