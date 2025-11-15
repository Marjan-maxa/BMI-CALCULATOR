import 'package:flutter/material.dart';

import 'bmi_calculator.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false ,
      initialRoute: 'Bmi',
      routes: {
        'Bmi':(context)=> bmi(),
      },
    );
  }
}
