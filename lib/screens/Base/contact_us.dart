import 'package:ai_match_making_app/screens/modals/info_modal.dart';
import 'package:ai_match_making_app/screens/profile/util_classes.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:email_validator/email_validator.dart';

bool validateEmail(String email) {
  return EmailValidator.validate(email);
}

Future<void> sendEmail(String userEmail, String query) async {
  final smtpServer = gmail('aimatchmakingwillings@gmail.com', 'ogchevayzrxvutnb');
  // Replace <YOUR_EMAIL> and <YOUR_PASSWORD> with your actual email and password

  final message = Message()
    ..from = const Address('aimatchmakingwillings@gmail.com', 'Willings')
    ..recipients
        .add(('kumar.242@iitj.ac.in')) // Replace with your receiving email
    ..subject = 'New Contact Us Query'
    ..text = 'Email: $userEmail\nQuery: $query';
    print('$userEmail, $query');

  try {
    final sendReport = await send(message, smtpServer);
  } catch (e) {
    print('Error sending email: $e');
  }
}

void submitQuery(String userEmail, String query, String uid, String teamName) {
  final firestore = FirebaseFirestore.instance;

  firestore.collection('ContactUs').add({
    'contactEmail': userEmail,
    'query': query,
    'timestamp': FieldValue.serverTimestamp(),
    'ourReply': "our_reply",
    'querySolved': false,
    'teamID': uid,
    'teamName': teamName,
  }).then((value) {
    print('Query stored in Firebase with ID: ${value.id}');
  }).catchError((error) {
    print('Error storing query in Firebase: $error');
  });
  sendEmail(userEmail, query);
}

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});
  @override
  ContactUsState createState() => ContactUsState();
}

class ContactUsState extends State<ContactUs> {
  String emailErrorText = "";
  String queryErrorText = "";
  bool show = false;
  Map<String, dynamic>? fetchedData;
  List<TextEditingController> tec =
      List.generate(2, (index) => TextEditingController());
  String schoolName = "";
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

  void updateSchoolName() {
    schoolName = fetchedData!['basicInfo']['schoolName'] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    if (fetchedData != null) {
      updateSchoolName();
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            contactUs['title']!,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: Column(children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        // "Contact email address",
                        contactUs['contactEmail']!,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Card(
                      child: TextField(
                        controller: tec[0],
                        style: const TextStyle(
                            color: Color.fromRGBO(17, 86, 149, 1)),
                        decoration: InputDecoration(
                            hintText: contactUs['enterEmailAdd']!,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ),
                    show ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          emailErrorText,
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
                    ):const SizedBox(height: 1,),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        // "School/team name",
                        contactUs['schoolTeam']!,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        schoolName,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        // "Contents of inquiry",
                        contactUs['contentsOfInquiry']!,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Card(
                      child: TextField(
                        controller: tec[1],
                        maxLines: null,
                        style: const TextStyle(
                            color: Color.fromRGBO(17, 86, 149, 1)),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          queryErrorText,
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
                  ],
                ),
              ),
            ])),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (validateEmail(tec[0].text)) {
                      if (tec[1].text.isEmpty) {
                        setState(() {
                          queryErrorText = "The query field can't be empty!";
                        });
                      } else {
                        submitQuery(tec[0].text, tec[1].text, getCurrentUID(),
                            schoolName);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Stack(
                              children: <Widget>[
                                Opacity(
                                  opacity:
                                      0.4, // set the opacity level for the background
                                  child: ModalBarrier(
                                      dismissible: false, color: Colors.black),
                                ),
                                PopUpsContactPage(),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      setState(() {
                        emailErrorText = "invalid email address!";
                        show = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(17, 86, 149, 1),
                    padding: const EdgeInsets.fromLTRB(80, 16, 80, 16),
                  ),
                  child: Text(
                    // 'Deliver a message'
                    contactUs['deliverBtn']!,
                    ),
                ),
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
