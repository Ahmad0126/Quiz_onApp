import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_onapp/constants.dart';
import 'package:quiz_onapp/pages/home_page.dart';
import 'package:quiz_onapp/pages/login.dart';

class AdminPage extends StatefulWidget {
  final String idDoc;
  const AdminPage(this.idDoc, {super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Constants widgets = Constants();
  final TextEditingController _soalController = TextEditingController();
  final CollectionReference _soal = FirebaseFirestore.instance.collection('soal');
  bool? jawaban = true;
  String action = 'create';

  Future<void> send([DocumentSnapshot? doc]) async {
    final String? soal = _soalController.text;
    if (soal != null) {
      if(action == 'create'){
        await _soal.add({
          'soal': soal,
          'jawaban': jawaban,
          'id_quiz': widget.idDoc
        });
      }

      if(action == 'update'){
        await _soal
          .doc(doc!.id)
          .update({
            'soal': soal,
            'jawaban': jawaban
          }
        );
      }
      _soalController.text = '';

      if (!context.mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> _createQuiz([DocumentSnapshot? documentSnapshot]) async {
    if(documentSnapshot != null){
      action = 'update';
      _soalController.text = documentSnapshot['soal'];
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _soalController,
                decoration: const InputDecoration(labelText: 'Soal'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text('Jawaban'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white
                          ),
                          onPressed: () {
                            setState(() {
                              jawaban = true;
                              send(documentSnapshot);
                            });
                          },
                          child: Text('Benar')
                        ),
                      )
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white
                          ),
                          onPressed: () {
                            setState(() {
                              jawaban = false;
                              send(documentSnapshot);
                            });
                          },
                          child: Text('Salah')
                        ),
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteQuiz(String prductId) async {
    await _soal.doc(prductId).delete();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Berhasil menghapus Soal')));
  }

  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widgets.appBar,
      backgroundColor: Colors.grey.shade900,
      body: StreamBuilder(
          stream: _soal.where("id_quiz", isEqualTo: widget.idDoc).snapshots(),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                documentSnapshot['soal'],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                documentSnapshot['jawaban'] == true ? 'Benar' : 'Salah',
                                style: TextStyle(color: documentSnapshot['jawaban'] == true ? Colors.green : Colors.red),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            children: [
                              IconButton(
                                  color: Colors.white,
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _createQuiz(documentSnapshot)),
                              IconButton(
                                color: Colors.white,
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    _deleteQuiz(documentSnapshot.id),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createQuiz(),
        child: const Icon(Icons.add),
      ),
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
              TextButton(
                onPressed: () async{
                  await _users
                      .doc('h3l6acQAB1XNWDdV5oE9')
                      .update({
                        'is_login': false
                      }
                    );
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => HomePage())
                    );
                }, 
                child: ListTile(
                  leading: Icon(Icons.search),
                  title: Text("Logout"),
                  subtitle: Text("Keluar dari aplikasi"),
                )
              )
            ],
          ),
        ),
      )
    );
  }
}
