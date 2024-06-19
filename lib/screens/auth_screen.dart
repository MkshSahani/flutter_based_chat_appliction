import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/widgets/user_image_picker.dart';
import 'dart:io';

final _firebase = FirebaseAuth.instance;


class AuthScreen extends StatefulWidget {

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }

}

class _AuthScreenState extends State<AuthScreen> {

  var _isLogin = true;

  final _formKey = GlobalKey<FormState>();

  var _userEmailAddress = '';
  var _userPassword = '';
  File? _selectedImage;


  void onPickImage(File pickedImage) {
    _selectedImage = pickedImage;
  }

  _submit() async {
    final isValid = _formKey.currentState!.validate();
    if(!isValid || (!_isLogin && _selectedImage == null)) {
      return;
    }

    

    _formKey.currentState!.save();
    if(_isLogin) {
      try {
        final userCredential = await _firebase.signInWithEmailAndPassword(email: _userEmailAddress, password: _userPassword);
      } on FirebaseAuthException catch(error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message ?? "Autentication Failed")));
      }
    } else {
      try {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(email: _userEmailAddress, password: _userPassword);
        print(userCredentials);
      } on FirebaseAuthException catch(e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Autentication Failed")));
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20
                ),
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(!_isLogin)
                            UserImagePicker(onPickImage: onPickImage,),
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text("Email Address")
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if(value == null || value.trim().isEmpty || !value.contains('@')) {
                                return "Please enter valid email address";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userEmailAddress = value!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text("Password")
                            ),
                            obscureText: true,
                            validator: (value) {
                              if(value == null || value.trim().length < 6) {
                                return "Password must be atlease 6 character long";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userPassword = value!;
                            },
                          ),
                          const SizedBox(height: 12,),
                          ElevatedButton(onPressed: _submit, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer
                          ),
                          child: Text(_isLogin ? "Log in" : "Sign up")),
                          const SizedBox(height: 12,),
                          TextButton(onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });

                          }, child: Text(_isLogin ? "Create a new account" : "I already have an account"))
                        ],   
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}