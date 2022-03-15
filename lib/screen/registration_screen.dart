import 'package:chat_app/screen/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'REGISTRATION_SCREEN';
  const RegistrationScreen({Key? key}) : super(key:key) ;

  @override
  _RegistrationScreenState  createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: const Text ('Register'),
        backgroundColor: Colors.blueAccent,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 200.0,
              child: Image.asset('images/logo.png'),
            ),
            const SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
              onChanged: (value){
                email = value;
              },
              decoration: const InputDecoration(
                hintText: 'Enter Your Email',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 13.0, fontStyle: FontStyle.italic),
                contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                    BorderSide(color: Colors.blueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
              onChanged: (value){
                password = value;
              },
              decoration: const InputDecoration(
                hintText: 'Enter Your Password',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 13.0, fontStyle: FontStyle.italic),
                contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Material(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(30.0),
            elevation: 5.0,
            child: MaterialButton(
              onPressed: () async {
                try {
                  await _auth.createUserWithEmailAndPassword(email: email, password: password);
                  Navigator.pushNamed(context, ChatScreen.id);
                }catch (e) {
                  print(e);
                }
              },
              minWidth: 200,
              height: 42.0,
              child: const Text('Register', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            )),
          ],
        ),
      ),
    );
  }
}