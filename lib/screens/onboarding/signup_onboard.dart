import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:flutter/material.dart';
import '../../reusable_widgets/reusable_widgets.dart'; // Import reusable_widgets.dart
import 'package:ai_match_making_app/screens/onboarding/onboarding_pages.dart';

class SignUpOnboard extends StatefulWidget {
  const SignUpOnboard({Key? key}) : super(key: key);

  @override
  State<SignUpOnboard> createState() => _SignUpOnboardState();
}

class _SignUpOnboardState extends State<SignUpOnboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF115695),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    signupOnboard['welcome']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    signupOnboard['AiMatch']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/signuponboard.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 150),
            Text(
              signupOnboard['letsGetStarted']!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 40), // Adjust the bottom padding value as needed
              child: Btn(
                context,
                signupOnboard['letsGo']!,
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BasicInfoSchool()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
