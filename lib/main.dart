import 'package:acappella_station/screens/login/login1.dart';
import 'package:acappella_station/screens/root/root.dart';
import 'package:acappella_station/states/currentUser.dart';
import 'package:acappella_station/utils/ourTheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentUser(),
      child: MaterialApp(
        home: OurRoot(),
        theme: OurTheme().buildTheme(),
      ),
    );
  }
}
