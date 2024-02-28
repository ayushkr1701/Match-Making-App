import 'package:ai_match_making_app/screens/onboarding/finish_onboard.dart';
import 'package:ai_match_making_app/screens/onboarding/matchingcondition_onboard.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ai_match_making_app/screens/onboarding/onboarding_reusable_widgets.dart';
import "package:ai_match_making_app/screens/profile/util_classes.dart";
import 'package:ai_match_making_app/utils/constants.dart';

class MatchingCondition1 extends StatefulWidget {
  const MatchingCondition1({Key? key}) : super(key: key);

  @override
  State<MatchingCondition1> createState() => _MatchingCondition1State();
}

class _MatchingCondition1State extends State<MatchingCondition1> {
  String? selectedOption;

  Map<String, dynamic>? fetchedData;

  void handleOptionSelected(String option) {
    // Do something with the selected option
    selectedOption = option;
  }

  String textError = "";
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

  List<List<String>>? options;
  void updateOptions() {
    String str = fetchedData!['teamComposition']['type'];
    if (str.startsWith("小学生")) {
      options = [
        academicYearOptionsJap.sublist(0,2),
        academicYearOptionsJap.sublist(2,4),
        academicYearOptionsJap.sublist(4,6),
      ];
    } else if (str.startsWith("中学生") || str.startsWith("高校生")) {
      options = [
        academicYearOptionsJap.sublist(0,2),
        academicYearOptionsJap.sublist(2,3),
      ];
    } else {
      options = [
        academicYearOptionsJap.sublist(0,2),
        academicYearOptionsJap.sublist(2,4),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (fetchedData != null) {
      updateOptions();
      void onPressedFunction1() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MatchingConditionOnboard()));
      }

      void onPressedFunction2() {
        if (selectedOption == null) {
          setState(() {
            textError = "Please select an option !";
          });
        } else {
          String uid = getCurrentUID();
        DocumentReference teamRef =
            FirebaseFirestore.instance.collection("Teams").doc(uid);

        Map<String, dynamic> newData = {
          "matchingConditions.teamGrade": selectedOption,
        };

        try {
          teamRef.update(newData);
        } catch (error) {
          print('Error updating field: $error');
        }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MatchingCondition2()));
        }
      }

      return onboardPage(
          signupOnboard['matchingSettings']!, 1, 3, onPressedFunction1, onPressedFunction2, [
        Padding(
          padding: const EdgeInsets.only(left: 5, top: 5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                // "The grade of the opposing team",
                signupOnboard['theGradeofOpp']!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ButtonCard(
                onOptionSelected: handleOptionSelected, options: options!),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  textError,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    // fontFamily: 'Arial',
                    // fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    height: 2,
                    // textAlign:
                  ),
                ),
              ),
            ),
          ]),
        ),
      ]);
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

class MatchingCondition2 extends StatefulWidget {
  const MatchingCondition2({Key? key}) : super(key: key);

  @override
  State<MatchingCondition2> createState() => _MatchingCondition2State();
}

class _MatchingCondition2State extends State<MatchingCondition2> {
  TextEditingController classTextController = TextEditingController();
  double currentSliderVal = 50;
  String sliderText = matCondTravelSliderLevelsJap[2];
  void handleSliderChanged(double value) {
    // Update the sliderValue when the slider changes
    currentSliderVal = value;
    sliderText = matCondTravelSliderLevelsJap[(currentSliderVal ~/ 25)];
    // Do any additional processing or update the UI as needed
  }

  void onPressedFunction1() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MatchingCondition1()));
  }

  void onPressedFunction2() {
    String uid = getCurrentUID();
    DocumentReference teamRef =
        FirebaseFirestore.instance.collection("Teams").doc(uid);

    Map<String, dynamic> newData = {
      "matchingConditions.maximumDistance": sliderText,
    };

    try {
      teamRef.update(newData);
    } catch (error) {
      print('Error updating field: $error');
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MatchingCondition3()));
  }

  @override
  Widget build(BuildContext context) {
    return onboardPage(
        signupOnboard['matchingSettings']!, 2, 3, onPressedFunction1, onPressedFunction2, [
      Padding(
        padding: const EdgeInsets.all(5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(5),
            child:  Text(
              // "Maximum travel time",
              signupOnboard['maximumTravTime']!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          SliderCard(
            sliderLevels: matCondTravelSliderLevelsJap,
            currentSliderVal: currentSliderVal,
            onSliderChanged: handleSliderChanged,
          ),
        ]),
      ),
    ]);
  }
}

class MatchingCondition3 extends StatefulWidget {
  const MatchingCondition3({Key? key}) : super(key: key);

  @override
  State<MatchingCondition3> createState() => _MatchingCondition3State();
}

class _MatchingCondition3State extends State<MatchingCondition3> {
  double currentSliderVal = 50;
  String sliderText = matCondTrolleySliderLevelsJap[2];
  void handleSliderChanged(double value) {
    // Update the sliderValue when the slider changes
    currentSliderVal = value;
    sliderText = matCondTrolleySliderLevelsJap[(currentSliderVal ~/ 25)];
    // Do any additional processing or update the UI as needed
  }

  String textError = "";
  String? selectedOption1, selectedOption2;
  void handleOptionSelected1(String option) {
    // Do something with the selected option
    selectedOption1 = option;
  }

  void handleOptionSelected2(String option) {
    // Do something with the selected option
    selectedOption2 = option;
  }

  void onPressedFunction1() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MatchingCondition2()));
  }

  void onPressedFunction2() {
    if (selectedOption1 == null || selectedOption2 == null) {
      setState(() {
        textError = "Please select an option !";
      });
    } else {
      String uid = getCurrentUID();
      DocumentReference teamRef =
          FirebaseFirestore.instance.collection("Teams").doc(uid);

      Map<String, dynamic> newData = {
        "matchingConditions.useExpressway" : selectedOption1 == matCondCarSpecifyJap[0] ? true : false,
        "matchingConditions.stationDistance": sliderText,
        "matchingConditions.parkingAvailability" : selectedOption2 == matCondParkingSlotJap[0] ? true : false,
      };

      try {
        teamRef.update(newData);
      } catch (error) {
        print('Error updating field: $error');
      }
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FinishOnboard()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return onboardPage(
        signupOnboard['matchingSettings']!, 3, 3, onPressedFunction1, onPressedFunction2, [
      Padding(
        padding: const EdgeInsets.all(5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              // "About car movement",
              signupOnboard['aboutCarMov']!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            // "Moving on the highway",
            signupOnboard['movingOnHighway']!,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          ButtonCard2(onOptionSelected: handleOptionSelected1, options:
            [matCondCarSpecifyJap],
          ),
          Text(
            // "Availability of parking lot",
            signupOnboard['availPark']!,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          ButtonCard2(onOptionSelected: handleOptionSelected2, options: [
            matCondParkingSlotJap,
          ]),
          const SizedBox(height: 10),
          Text(
            // "About train movement",
            signupOnboard['aboutTrainMov']!,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            // "Walk from the station",
            signupOnboard['walkFromStation']!,
            style: TextStyle(fontSize: 16),
          ),
          SliderCard(
            sliderLevels: matCondTrolleySliderLevelsJap,
            currentSliderVal: currentSliderVal,
            onSliderChanged: handleSliderChanged,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                textError,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  // fontFamily: 'Arial',
                  // fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  height: 2,
                  // textAlign:
                ),
              ),
            ),
          ),
        ]),
      ),
    ]);
  }
}
