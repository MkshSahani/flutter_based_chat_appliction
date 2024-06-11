import 'package:flutter/material.dart';
import 'package:chat_app/screens/auth_screen.dart';

void main() {
  return runApp(const ChatApp());
}


class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Application",
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 63, 17, 177)
        ),
      ),
      home: const AuthScreen(),
    );
  }

}