import 'package:ai_match_making_app/screens/onboarding/matchingcondition1.dart';
import 'package:ai_match_making_app/screens/onboarding/onboarding_pages.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:ai_match_making_app/screens/profile/util_classes.dart";

class MatchingConditionOnboard extends StatefulWidget {
  const MatchingConditionOnboard({Key? key}) : super(key: key);

  @override
  State<MatchingConditionOnboard> createState() =>
      _MatchingConditionOnboardState();
}

class _MatchingConditionOnboardState extends State<MatchingConditionOnboard> {
  Map<String, dynamic>? fetchedData;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    String uid = getCurrentUID();
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("Teams").doc(uid).get();
    if (snapshot.exists) {
      setState(() {
        fetchedData = snapshot.data() as Map<String, dynamic>?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (fetchedData != null) {
      String eduLevel = fetchedData!['teamComposition']['type'];
      bool flag = true;
      if (eduLevel.startsWith("草野球") || eduLevel.startsWith("社会人")) {
        flag = false;
      }
      return Scaffold(
        backgroundColor: const Color(0xFF115695),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                // 'This is the end of entering basic information!',
                '基本情報入力はこれで終わりです！',
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Image.asset(
                'assets/images/matchingconditiononboard.png',
                width: 100,
                height: 100,
              ),
            ),
            const Center(
              child: Text(
                // "From here on, we're going to be able to see What kind of conditions do you want to match Set up.",
                'ここからは試合相手と\nどのような条件でマッチングしたいか\nを設定していきます。',
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 150),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ImagePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF115695),
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.all(20),
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                      child: Text(signupOnboard['backBtn']!),
                    ),
                  ),
                  const SizedBox(width: 100),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => flag
                                    ? const MatchingCondition1()
                                    : const MatchingCondition2()));
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFF115695),
                        backgroundColor: const Color(0xFFFFFFFF),
                        padding: const EdgeInsets.all(20),
                        textStyle: const TextStyle(
                            fontSize: 13, color: Color(0xFF115695)),
                      ),
                      child: Text(signupOnboard['nextBtn']!),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
