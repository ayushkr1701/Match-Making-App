import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai_match_making_app/screens/Base/home_screen.dart';
import 'package:ai_match_making_app/reusable_widgets/reusable_widgets.dart';
import 'package:ai_match_making_app/screens/auth/signup_screen.dart';
import 'package:ai_match_making_app/screens/auth/reset_password.dart';
import 'package:ai_match_making_app/screens/auth/shared_preference_services.dart';
import 'package:ai_match_making_app/screens/onboarding/signup_onboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../profile/util_classes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  String sr = "";

  Map<String, dynamic>? fetchedData;
  bool flag = false;

  // @override
  // void initState() {
  //   String uid = getCurrentUID();
  //   if (uid != ""){
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => flag
  //                 ? const SignUpOnboard()
  //                 : HomeScreen(
  //               uid: uid,
  //             )));
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(

                    child: Text(
                      signInPage['enterLoginInfo']!,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                    ),

                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  signInPage['emailAdd']!,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                reusableTextField(signInPage['emailPlaceholder']!,
                    Icons.person_outline, false, _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  signInPage['pswd']!,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                reusableTextField(signInPage['pswdPlaceholder']!, Icons.lock_outline, true,
                    _passwordTextController),
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
                      // height: 0,
                      // textAlign:
                    ),
                  ),
                ),

                forgetPassword(context),
                const SizedBox(height: 333),


                firebaseUIButton(context, signInPage['loginBtn']!, ()  {
                  String username = _emailTextController.text;
                  String password = _passwordTextController.text;
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: username, password: password)
                      .then((value) async {
                    if (!FirebaseAuth.instance.currentUser!.emailVerified) {
                      var snackBar = SnackBar(
                        content: Text(signInPage['emailnotVerified']!),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      FirebaseAuth.instance.signOut();
                    }

                    if (FirebaseAuth.instance.currentUser!.emailVerified) {
                      SharedPreferencesService.updateBoolValue(true);
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final User? user = auth.currentUser;
                      final uid = user?.uid;
                      DocumentSnapshot snapshot = await FirebaseFirestore
                          .instance
                          .collection("Teams")
                          .doc(uid)
                          .get();
                      if (snapshot.exists) {
                        setState(() {
                          fetchedData =
                              snapshot.data() as Map<String, dynamic>?;
                        });
                      }
                      if (fetchedData!['matchingConditions']['maximumDistance'].isEmpty || fetchedData!['matchingConditions']['stationDistance'].isEmpty){
                        flag = true;
                      }
                      // ignore: use_build_context_synchronously
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => flag
                                  ? const SignUpOnboard()
                                  : HomeScreen(
                                      uid: uid,selectedIndex: 0,
                                    )));
                    }
                  }).onError((error, stackTrace) {
                    print(error.toString());
                    if (error.toString() ==
                        "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
                      setState(() {
                        sr = "*password does not match";
                      });
                    }
                  });
                }),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(signInPage['dontHaveAccount']!,
            style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: Text(
            signInPage['signup']!,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomLeft,
      child: TextButton(
        child: Text(
          signInPage['forgotPswd']!,
          style: const TextStyle(color: Colors.black87),
          textAlign: TextAlign.left,
        ),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ResetPassword())),
      ),
    );
  }
}
