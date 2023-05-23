import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'emergency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Itooth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EmergencyPage(), // Use EmergencyPage as the initial page
    );
  }
}
