import 'package:ai_match_making_app/screens/auth/signin_screen.dart';
import 'package:ai_match_making_app/screens/auth/signup_screen.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:ai_match_making_app/screens/onboarding/main_screen1.dart';
import 'package:flutter/material.dart';
import 'package:ai_match_making_app/reusable_widgets/reusable_widgets.dart';
import 'package:ai_match_making_app/screens/auth/shared_preference_services.dart';
import 'package:ai_match_making_app/screens/Base/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(

          image: DecorationImage(
              image: AssetImage("assets/images/front_new.png"), fit: BoxFit.cover),

        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.30, 20, 0),
            child: Column(
              children: <Widget>[

                const Text(
                  "AI",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 36.8, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                 Text(
                  landingPage['match-making']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 36.8, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Image.asset(
                  'assets/images/hand.png',
                  scale: 2.1,

                ),

                const SizedBox(height: 120),

                Text(
                  landingPage['labelAboveLoginBtn']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                firebaseUIButton(context, landingPage['register']!, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                }),
                Btn(context, landingPage['login']!, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));



                }),
              ],


            ),
          ),
        ),
      ),
    );

  }
}