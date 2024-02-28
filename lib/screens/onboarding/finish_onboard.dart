import 'package:flutter/material.dart';
import '../../reusable_widgets/reusable_widgets.dart';
import 'package:ai_match_making_app/screens/profile/setting_schedule.dart';
import 'package:ai_match_making_app/screens/Base/home_screen.dart';
import 'package:ai_match_making_app/screens/profile/util_classes.dart';

class FinishOnboard extends StatefulWidget {
  const FinishOnboard({Key? key}) : super(key: key);

  @override
  State<FinishOnboard> createState() => _FinishOnboardState();
}

class _FinishOnboardState extends State<FinishOnboard> {
  String currentID = getCurrentUID();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF115695),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 100),
          const Center(
            child: Text(
              'Hard Work!',
              style: TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Image.asset(
              'assets/images/finishonboard.png',
              width: 100,
              height: 100,
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              "All you have to do is set a match date Find your opponent!",
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 150),
          const Center(
            child: Text(
              "Let's set the date of the match!",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Btn(
                  context,
                  "Set up",
                      () {
                    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SettingSchedulePage()));
                  },
                ),
                firebaseUIButton(
                  context,
                  "Close",
                      () {
                    Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomeScreen(uid: currentID,selectedIndex: 0,)));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
