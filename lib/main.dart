import 'package:flutter/material.dart';
import 'package:assignment_1/screens/input_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel Planner',
     
      home: const InputScreen(title: 'Flutter Demo Home Page'),
    );
  }
}