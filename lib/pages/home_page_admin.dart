import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_onapp/constants.dart';
import 'package:quiz_onapp/pages/admin_page.dart';
import 'package:quiz_onapp/pages/login.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  Constants widgets = Constants();
  final TextEditingController _judulController = TextEditingController();
  final CollectionReference _quiz = FirebaseFirestore.instance.collection('quiz');

  Future<void> _createQuiz([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if(documentSnapshot != null){
      action = 'update';
      _judulController.text = documentSnapshot['judul'];
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
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: TextField(
                  controller: _judulController,
                  decoration: const InputDecoration(labelText: 'Judul'),
                ),
              ),
              ElevatedButton(
                child: Text(action == 'create'? 'Create' : 'Update'),
                onPressed: () async {
                  final String? judul = _judulController.text;
                  if(judul != null){
                    if(action == 'create'){
                      await _quiz.add({'judul': judul});
                    }

                    if(action == 'update'){
                      await _quiz
                        .doc(documentSnapshot!.id)
                        .update({'judul': judul})
                      ;
                    }

                    _judulController.text = '';

                    if(!context.mounted) return;
                    Navigator.pop(context);
                  }
                }, 
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteQuiz(String prductId) async {
    await _quiz.doc(prductId).delete();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Berhasil menghapus Quiz')));
  }

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
                                Row(
                                  children: [
                                    IconButton(
                                      color: Colors.white,
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => _createQuiz(documentSnapshot)
                                      ),
                                    IconButton(
                                      color: Colors.white,
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => _deleteQuiz(documentSnapshot.id),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AdminPage(documentSnapshot.id),
                                      )
                                    );
                                  },
                                  child: Text(
                                    'Edit',
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
            ],
          ),
        ),
      ),
    );
  }
}
