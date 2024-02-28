import 'package:ai_match_making_app/reusable_widgets/reusable_widgets.dart';
import 'package:ai_match_making_app/screens/Base/home_screen.dart';
import 'package:ai_match_making_app/screens/auth/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import '../auth/shared_preference_services.dart';

class MainScreen1 extends StatefulWidget {
  const MainScreen1({Key? key}) : super(key: key);

  @override
  State<MainScreen1> createState() => _MainScreen1State();
}

class _MainScreen1State extends State<MainScreen1> {
  bool _isBoolValue = false;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  void initializeSharedPreferences() async {
    _isBoolValue = await SharedPreferencesService.getBoolValue('_isBoolValue');


    if (_isBoolValue) {
      // User is already logged in, navigate to home screen
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uid = user?.uid;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  HomeScreen(uid: uid,selectedIndex: 0,)),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              Image.asset('assets/images/onboarding1.png'),
              Align(
                alignment: Alignment.topCenter,
                child: Transform.scale(
                  scale: 0.85, // Adjust the scale value to zoom out the image
                  child: Image.asset(
                    'assets/images/onboarding2.png',
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Transform.scale(
                  scale: 0.9, // Adjust the scale value to zoom out the image
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 150.0), // Adjust the bottom padding value as desired
                    child: Image.asset(
                      'assets/images/onboarding3.png',
                    ),
                  ),
                ),
              ), // Page 3
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: const Color(0xFF115695),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    height: 45, // Set the fixed height of the text container
                    child: Text(
                      getPageText(_currentPage),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildDotIndicator(0),
                      buildDotIndicator(1),
                      buildDotIndicator(2),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Btn(context, _currentPage < 2 ? mainonboardingpage['Nextto']! : mainonboardingpage['Begin!']!, () {
                    if (_currentPage < 2) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Navigate to an external page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MainScreen()),
                      );
                    }
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }




  String getPageText(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return mainonboardingpage['page1']!;
      case 1:
        return mainonboardingpage['page2']!;
      case 2:
        return mainonboardingpage['page3']!;
      default:
        return '';
    }
  }

  Widget buildDotIndicator(int pageIndex) {
    final isActive = pageIndex == _currentPage;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 10 : 6,
      height: isActive ? 10 : 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.white : Colors.grey,
      ),
    );
  }
}
