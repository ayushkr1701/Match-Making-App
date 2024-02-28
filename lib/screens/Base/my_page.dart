import 'package:ai_match_making_app/screens/Base/contact_us.dart';
import 'package:ai_match_making_app/screens/accountsetting/accountsettinghome.dart';
import 'package:ai_match_making_app/screens/onboarding/main_screen1.dart';
import 'package:ai_match_making_app/screens/profile/profile_screen.dart';
import 'package:ai_match_making_app/screens/profile/setting_schedule.dart';
import 'package:ai_match_making_app/screens/profile/util_classes.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../reusable_widgets/reusable_widgets.dart';
import '../Base/scheduled_matches_screen.dart';
import '../match/match_making.dart';
import 'package:ai_match_making_app/screens/match/matching_condtion.dart';
import '../requests/request_manage.dart';
import '../messages/message.dart';
import 'package:ai_match_making_app/screens/auth/main_screen.dart';
import 'package:ai_match_making_app/screens/auth/shared_preference_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    String us = getCurrentUID();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    CollectionReference scheduledCardData =
        FirebaseFirestore.instance.collection('Teams');
    return WillPopScope(
      onWillPop: () async {
        // Disable back button functionality
        return false;
      },
      child: Scaffold(
        // backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            myPage['title']!,
            style: const TextStyle(color: Colors.black, fontSize: 24),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: scheduledCardData.doc(uid).snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              // if (snapshot.hasError) {
              //   return Text(somethingWrong);
              // }

              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return const Center(child: CircularProgressIndicator());
              // }

              // if (!snapshot.hasData || !snapshot.data!.exists) {
              //   return Text(documentDoesNotExist);
              // }

              // else{
              //   Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              //   // print(data.length);
              //   // print("printing data :-");
              //   // print(data);
              //   List<dynamic> scheduledCardsInfo;
              //   // List<dynamic> scheduledCardsDate;
              //   // List<dynamic> newList = [];
              //   scheduledCardsInfo = data["matchScheduled"];
              //   // scheduledCardsDate= data["matchScheduledDate"];
              //   scheduledCardsInfo = sortMatchCards(scheduledCardsInfo);

              //   // scheduledCardsDate =  sortMatchCardsDate(scheduledCardsDate);

              //   // else {

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MatchingConditionScreen()));
                              },
                              child: SizedBox(
                                height: 90,
                                width: 180,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/handshake.png',
                                          width: 40.0,
                                          height: 30.0,
                                          fit: BoxFit.contain,
                                        ),
                                        Text(
                                          myPage["settingMatchingCondn"]!,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        // const Text(
                                        //   'condition',
                                        //   style: TextStyle(fontSize: 12),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SettingSchedulePage()));
                              },
                              child: SizedBox(
                                height: 90,
                                width: 180,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/list.png',
                                          width: 30.0,
                                          height: 30.0,
                                          fit: BoxFit.contain,
                                        ),
                                        Text(
                                          myPage['settingDateNdTime']!,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        // const Text(
                                        //   'and time for match',
                                        //   style: TextStyle(fontSize: 12),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyProfilePage(
                                              uid: us,
                                            )));
                              },
                              child: Card(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/pen.png',
                                        width: 40.0,
                                        height: 40.0,
                                        fit: BoxFit.contain,
                                      ),
                                      Text(
                                        myPage['viewAndEdit']!,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            myPage['gameSchedule']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                            ),
                          )
                        ],
                      ),

                      // if(scheduledCardsInfo.isEmpty)...[
                      //   const SizedBox(
                      //     height: 5,
                      //   ),
                      //     Center(
                      //       child: Text(myPage['ifGameDecidedText']!,
                      //         style: TextStyle(

                      //           fontWeight: FontWeight.w500,
                      //           letterSpacing: 1.0,
                      //         ),),
                      //     ),
                      //   const SizedBox(
                      //     height: 10,
                      //   ),

                      // ]
                      // else...[
                      // for(int i = 0; i <
                      //     scheduledCardsInfo.length; i++)...[

                      //   StreamBuilder<DocumentSnapshot>(
                      //     stream: scheduledCardData.doc(scheduledCardsInfo[i]["opponentUID"]).snapshots(),
                      //     builder:
                      //         (BuildContext context,
                      //         AsyncSnapshot<DocumentSnapshot> snapshot) {
                      //       if (snapshot.hasError) {
                      //         return Text(somethingWrong);
                      //       }

                      //       if (snapshot.connectionState == ConnectionState.waiting) {
                      //         return const Text("");
                      //       }

                      //       else{
                      //         Map<String, dynamic> info = snapshot.data!
                      //             .data() as Map<String, dynamic>;
                      //         //
                      //         String time;

                      //         if (scheduledCardsInfo[i]["timeSlot"] ==
                      //             1) {
                      //           time = '9:00-11:00';
                      //         }
                      //         else
                      //         if (scheduledCardsInfo[i]["timeSlot"] ==
                      //             2) {
                      //           time = '11:00-13:00';
                      //         }
                      //         else {
                      //           time = '13:00-15:00';
                      //         }

                      //         String firstDate = scheduledCardsInfo[0]["date"];

                      //         return Column(
                      //           children: [
                      //             if(i==0)...[
                      //               AddingDate(dateItem: scheduledCardsInfo[i]["date"] ),
                      //               AddingTime(timeItem: time),
                      //               MyButton(iconData: Icons.abc_outlined, buttonText: info["basicInfo"]["schoolName"], location: scheduledCardsInfo[i]["location"],data: data, uid:scheduledCardsInfo[i]["opponentUID"] ,
                      //               info: info, i: i,),
                      //             ]

                      //             else if(firstDate==scheduledCardsInfo[i]["date"])...[

                      //               AddingTime(timeItem: time),
                      //               MyButton(iconData: Icons.abc_outlined, buttonText: info["basicInfo"]["schoolName"], location: scheduledCardsInfo[i]["location"],data: data, uid:scheduledCardsInfo[i]["opponentUID"] ,
                      //                 info: info, i: i,),

                      //             ]

                      //           ],
                      //         );

                      //       }

                      //     },
                      //   ),
                      // ]
                      // ],

                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            completeSchedule()));
                              },
                              child: Card(
                                color: Colors.blue[900],
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  child: Text(
                                    myPage['iWillCheckSchedulebutton']!,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              historyOfGames()));
                                },
                                child: Container(
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        myPage['pastGamehistory']!,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        historyOfGames()));
                                          },
                                          icon: const Icon(
                                              Icons.arrow_forward_ios)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AccountSettingHome()));
                                },
                                child: Container(
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AccountSetting['accountsetting']!,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AccountSettingHome()));
                                          },
                                          icon: const Icon(
                                              Icons.arrow_forward_ios)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ContactUs()));
                                },
                                child: Container(
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        myPage['contactUs']!,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ContactUs()));
                                          },
                                          icon: const Icon(
                                              Icons.arrow_forward_ios)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: GestureDetector(
                                onTap: () {
                                  SharedPreferencesService.updateBoolValue(
                                      false);
                                  FirebaseAuth.instance.signOut().then((value) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MainScreen1()));
                                  });
                                },
                                child: Container(
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        myPage['logOut']!,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            SharedPreferencesService
                                                .updateBoolValue(false);
                                            FirebaseAuth.instance
                                                .signOut()
                                                .then((value) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const MainScreen1()));
                                            });
                                          },
                                          icon: const Icon(
                                              Icons.arrow_forward_ios)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
              // }
            }),
      ),
    );
  }
}

class AddingDate extends StatefulWidget {
  const AddingDate({Key? key, required this.dateItem}) : super(key: key);
  final String dateItem;

  @override
  State<AddingDate> createState() => _AddingDateState();
}

class _AddingDateState extends State<AddingDate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Text(
              "On ${widget.dateItem}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        Divider(
          height: 10,
          color: Colors.grey[400],
        ),
      ],
    );
  }
}

class AddingTime extends StatefulWidget {
  const AddingTime({Key? key, required this.timeItem}) : super(key: key);
  final String timeItem;

  @override
  State<AddingTime> createState() => _AddingTimeState();
}

class _AddingTimeState extends State<AddingTime> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.timeItem,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    required this.iconData,
    required this.buttonText,
    this.onTap,
    required this.location,
    required this.i,
    required this.info,
    required this.data,
    required this.uid,
  }) : super(key: key);
  final IconData iconData;
  final String buttonText;
  final String location;
  final int i;
  final Map<String, dynamic> info;
  final Map<String, dynamic> data;
  final String uid;

  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OpponentProfile(
                            which_page: 0,
                            buttonpressed: 5,
                            oid: uid,
                            data: data,
                            index: i,
                            info: info,
                            mode: "Automatic")));
                //just randomly assigned as automatic, it is of no use in case of established match as we do not have to show admit/request in this case
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                buttonText + "  ",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Container(
                                height: 8,
                                width: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                online,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            location,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
