// ignore_for_file: unused_import, library_private_types_in_public_api, sized_box_for_whitespace

import 'package:ai_match_making_app/screens/auth/signin_screen.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai_match_making_app/reusable_widgets/reusable_widgets.dart';
import 'package:ai_match_making_app/utils/color_utils.dart';
import 'package:ai_match_making_app/utils/constants.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _psdTextController = TextEditingController();
  String sr = "";
  void createUserDataStructure(String uid) {
    FirebaseFirestore.instance.collection("Teams").doc(uid).set({
      'basicInfo': {
        'bio': "",
        'matchFrequency': '',
        'representativeName': "",
        'win': 0,
        'loss':0,
        'schoolAddress': {
          'city': "",
          'nearestStation': "",
          'parkingAvailability': true,
          'pincode': "",
          'prefecture': "",
          'street': "",
          'lat': 0,
          'lang': 0,
        },
        'schoolName': "",
        'teamLevel' : 1,
        'totalMembers': "",
      },
      'matchHistory': [],
      'teamComposition': {
        '1stGradeMembers': 0,
        '2ndGradeMembers': 0,
        '3rdGradeMembers': 0,
        '4thGradeMembers': 0,
        '5thGradeMembers': 0,
        '6thGradeMembers': 0,
        'teamGrade': '',
        'type': schoolLevelOptionsJap[0],
      },
      'homeGround': {
        'firstHomeGround': {
          'address': {
            'city': '',
            'prefecture': '',
            'street': '',
          },
          'geoLocation': '',
          'nearestStation': '',
          'parkingAvailability': false,
          'pincode': '',
          'priority': true,
        },
        'secondHomeGround': {
          'address': {
            'city': '',
            'prefecture': '',
            'street': '',
          },
          'geoLocation': '',
          'nearestStation': '',
          'parkingAvailability': false,
          'pincode': '',
          'priority': true,
        },
        'thirdHomeGround': {
          'address': {
            'city': '',
            'prefecture': '',
            'street': '',
          },
          'geoLocation': '',
          'nearestStation': '',
          'parkingAvailability': false,
          'pincode': '',
          'priority': true,
        },
      },
      'images': {},
      'matchApplied':[],
      'matchAvailability':[],
      'matchCard':[],
      'matchRequests':[],
      'matchScheduled':[],
      'matchVerification':[],

      'matchingConditions':{
        'cityPreference':'',
        'matchAgainst':'',
        'maximumDistance':'',
        'parkingAvailability':false,
        'prefecturePreference':'',
        'stationDistance':'',
        'teamGrade':academicYearOptionsJap[0],
        'teamType': schoolLevelOptionsJap[0],
        'useCar': false,
        'useMetro': false,
        'useWalk': false,
        'useExpressway': false,
      },
      'points': 0,
      'sortAction': 0,
    });
  }
  Future valid() async {
    if (_psdTextController.text != _passwordTextController.text) {
      setState(() {
        sr = registerPage['pswdDontMatch']!;
      });

      // print(sr);
    } else if (_passwordTextController.text.length < 6) {
      setState(() {
        sr = registerPage['pswdMoreThanSix']!;
      });
    } else {
      setState(() {
        sr = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,

      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Padding(
            padding:  EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(

                  child:  Text(
                    registerPage['enterNewReg']!,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),

                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  registerPage['emailAdd']!,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                reusableTextField(registerPage['emailPlaceholder']!, Icons.person_outline,
                    false, _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  registerPage['pswd']!,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                reusableTextField(registerPage['pswdPlaceholder']!, Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  registerPage['pswdCnf']!,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                reusableTextField(registerPage['pswdCnfPlaceholder']!, Icons.lock_outlined, true,
                    _psdTextController),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    sr,
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
                const SizedBox(height: 290),
                firebaseUIButton(context, registerPage['confirmationBtn']!,
                    () {
                  valid();
                  if (_passwordTextController.text.length < 6) {
                    setState(() {
                      sr = registerPage['pswdMoreThanSix']!;
                    });

                    // const snackBar = SnackBar(
                    //   content: Text(
                    //       'Password should be greater than 6 characters'),
                    // );
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (_psdTextController.text !=
                      _passwordTextController.text) {
                    // const snackBar = SnackBar(
                    //   content: Text(
                    //       'Passwords do not match'),
                    // );
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    var snackBar = SnackBar(
                      content:
                          Text(registerPage['checkInboxVerify']!),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then((value) {
                      final user = FirebaseAuth.instance.currentUser!;
                      user.sendEmailVerification();
                      FirebaseAuth.instance.signOut();

                      createUserDataStructure(
                          user.uid); // Create the data structure

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()),
                      );
                    }).onError((error, stackTrace) {});
                  }
                })
              ],
            ),
          ))),
    );
  }
}
