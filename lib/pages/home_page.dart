import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_onapp/constants.dart';
import 'package:quiz_onapp/pages/login.dart';
import 'package:quiz_onapp/pages/quiz_page.dart';
import 'package:quiz_onapp/question.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Constants widgets = Constants();
  final CollectionReference _quiz = FirebaseFirestore.instance.collection('quiz');
  final CollectionReference _soal = FirebaseFirestore.instance.collection('soal');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widgets.appBar,
      backgroundColor: Colors.grey.shade900,
      body: StreamBuilder(
          stream: _quiz.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                      color: Colors.black,
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  documentSnapshot['judul'],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    List questionBank = <Question>[];
                                    _soal.where('id_quiz', isEqualTo: documentSnapshot.id).get().then((value) {
                                      for (var docSnapshot in value.docs) {
                                        questionBank.add(Question(docSnapshot.get('soal'), docSnapshot.get('jawaban')));
                                      }
                                      Navigator.push(
                                        context, 
                                        MaterialPageRoute(
                                          builder: (context) => QuizPage(questionBank as List<Question>),
                                        )
                                      );
                                    });
                                  },
                                  child: Text(
                                    'Kerjakan',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                ),
                              ],
                            ),
                          )
                        ],
                      ));
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
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
                  title: Text("Admin"),
                  subtitle: Text("Menu Admin"),
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}
