import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_onapp/constants.dart';
import 'package:quiz_onapp/pages/home_page_admin.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Login extends StatelessWidget{
  Constants widgets = Constants();
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           TextField(
              controller: _controllerUsername,
              decoration: const InputDecoration(
                labelText: "Username",
                fillColor: Colors.white
              ),
              style: TextStyle(
                color: Colors.white
              ),
            ),
           TextField(
              controller: _controllerPassword,
              decoration: const InputDecoration(
                labelText: "Password"
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white
                ),
                onPressed: () async{
                  _users.where('username', isEqualTo: _controllerUsername.text).where('password', isEqualTo: _controllerPassword.text).get().then((value) async {
                    if(value.docs.isEmpty){
                      Alert(
                        context: context,
                        title: "Gagal",
                        desc: "Cek kembali username dan password",
                        buttons: [
                          DialogButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          )
                        ]
                      ).show();
                    }else{
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => HomePageAdmin())
                      );
                    }
                  });
                }, 
                child: Text('Login')
              ),
            )
            
          ],
        ),
      ),
    );
  }
  
}