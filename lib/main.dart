import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:presentation_card_challenge/ui/pages/PagProfile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: {
        'PagProfile': (context) => PagProfile(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Profile card',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PagProfile(),
    );
  }
}
