import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:presentation_card_challenge/ui/pages/PagProfile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        'PagProfile': (context) => const PagProfile(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Profile card',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const PagProfile(),
    );
  }
}
