import 'package:ai_match_making_app/screens/auth/signin_screen.dart';
import 'package:ai_match_making_app/screens/auth/main_screen.dart';
import 'package:ai_match_making_app/screens/match/match_making.dart';
import 'package:ai_match_making_app/screens/onboarding/main_screen1.dart';
import 'package:ai_match_making_app/screens/onboarding/signup_onboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'firebase_options.dart';?
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( options: const FirebaseOptions( apiKey: "AIzaSyAq6LMybCOCGyWdHQFZ7Qw5i12DRuMfyTQ",
    appId: "1:415320675205:android:07596a9fdfd70043c8aaec",
    messagingSenderId: "415320675205",
    projectId: "mapp-68472", ), );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Match Making',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        fontFamily: 'NotoSans'
      ),
      home:  const MainScreen1()
    );
  }
}