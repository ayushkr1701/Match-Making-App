
import 'package:ai_match_making_app/screens/match/match_making.dart';
import 'package:ai_match_making_app/screens/messages/message.dart';
import 'package:ai_match_making_app/screens/Base/my_page.dart';
import 'package:ai_match_making_app/screens/profile/util_classes.dart';
import 'package:ai_match_making_app/screens/requests/request_manage.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:ai_match_making_app/screens/Base/scheduled_matches_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../reusable_widgets/reusable_widgets.dart';

class AutoPopup extends StatefulWidget {
  final Map<String, dynamic> data;
  final Map<String, dynamic> info;
  final int index;
  final String? uid;
  AutoPopup(
      {super.key,
        required this.uid,
        required this.data,
        required this.info,
        required this.index});
  @override
  _AutoPopupState createState() => _AutoPopupState();
}

class _AutoPopupState extends State<AutoPopup> {


  bool _popupShown = false;
  @override
  void initState() {
    super.initState();
    // Wait for 3 seconds and then show the dialog
    Future.delayed(Duration.zero, ()
    {
      if (!_popupShown) {


        showDialog(
          context: context,
          builder: (BuildContext context) {
            if (widget.data['matchVerification'][widget.index]
            ['firstOneToOpen'] ==
                1 &&
                widget.data['matchVerification'][widget.index]['myScore'] ==
                    -1) {
              int? selectedValue1, selectedValue2;
              return AlertDialog(

                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.lightBlueAccent, // Border color
                            width: 2.0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(
                              6.0), // Border radius
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          // Padding around the text
                          child: Text(
                            widget.data['matchVerification'][widget
                                .index]['date'],
                            style: TextStyle(fontSize: 14.0,
                                color: Colors.lightBlueAccent), // Text style
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Center(
                      child: Text(
                        'My University Name',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Please enter the match details',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 100,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: Center(
                                child: DropdownButton<int>(
                                  value: selectedValue1,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue1 = value;
                                    });
                                  },
                                  items: List<DropdownMenuItem<int>>.generate(
                                    100,
                                        (index) =>
                                        DropdownMenuItem<int>(
                                          value: index + 1,
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 30),
                                            ),
                                          ),
                                        ),
                                  ),
                                  underline: const SizedBox.shrink(),
                                ),
                              ),
                            ),
                            const Text(
                              'Own Team',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w600),
                            ),

                          ],
                        ),
                        const SizedBox(width: 16),
                        Column(
                          children: [
                            Container(
                              width: 100,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: Center(
                                child: DropdownButton<int>(

                                  value: selectedValue2,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue2 = value;
                                    });
                                  },
                                  items: List<DropdownMenuItem<int>>.generate(
                                    100,
                                        (index) =>
                                        DropdownMenuItem<int>(
                                          value: index + 1,
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 30),
                                            ),
                                          ),
                                        ),
                                  ),
                                  underline: const SizedBox.shrink(),
                                ),
                              ),
                            ),
                            const Text(
                              'Opponent Team',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    firebaseUIButton(
                        context,
                        "Confirmation of result to the other team", () {
                      String s =
                      (selectedValue1! > selectedValue2!) ? "Win" : "Lose";

                      // Database changes with reference to user
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('Teams')
                          .doc(widget.uid); //remeber to update this with uid
                      FirebaseFirestore.instance
                          .runTransaction((transaction) async {
                        DocumentSnapshot snapshot =
                        await transaction.get(documentReference);
                        if (!snapshot.exists) {
                          throw Exception("User does not exist!");
                        }

                        List<dynamic> update_match_verification =
                        widget.data['matchVerification'];
                        update_match_verification[widget.index]['myScore'] =
                            selectedValue1;
                        update_match_verification[widget
                            .index]['opponentScore'] =
                            selectedValue2;
                        transaction.update(documentReference,
                            {'matchVerification': update_match_verification});
                      });
                      //Database changes for opponent
                      DocumentReference opp_documentReference = FirebaseFirestore
                          .instance
                          .collection('Teams')
                          .doc(widget.data['matchVerification'][widget.index]
                      ['opponentUID']);
                      FirebaseFirestore.instance
                          .runTransaction((transaction) async {
                        DocumentSnapshot opp_snapshot =
                        await transaction.get(opp_documentReference);
                        if (!opp_snapshot.exists) {
                          throw Exception("User does not exist!");
                        }
                        List<dynamic> opponent_match_verification =
                        widget.info['matchVerification'];

                        for (int i = 0;
                        i < opponent_match_verification.length;
                        i++) {
                          if (opponent_match_verification[i]['timeSlot'] ==
                              widget.data['matchVerification'][widget.index]
                              ['timeSlot'] &&
                              opponent_match_verification[i]['date'] ==
                                  widget.data['matchVerification'][widget.index]
                                  ['date']) {
                            opponent_match_verification[i]['myScore'] =
                                selectedValue2;
                            opponent_match_verification[i]['opponentScore'] =
                                selectedValue1;
                          }
                        }

                        transaction.update(opp_documentReference,
                            {'matchVerification': opponent_match_verification});
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setState) {
                                return AlertDialog(
                                  title: const Center(child: Text('Sent')),
                                  content: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: Image.asset(
                                          "assets/images/sent.png",
                                          scale: 2.1,
                                        ),
                                      ),
                                      const Center(
                                        child: Text(
                                          'By entering the game results number of wins and losses against the opposing team,You can see it in Numbers.',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const Center(
                                        child: Text(
                                          'Past Results',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const Center(
                                        child: Divider(
                                          color: Colors.black38,
                                          thickness: 1.0,
                                        ),
                                      ),
                                      const Center(
                                        child: Text(
                                          '4 wins, 2 losses and 1 point',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      firebaseUIButton(context, "Close", () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen(
                                                        uid: widget.uid, selectedIndex: 0,)));
                                      }),
                                    ],
                                  ),
                                );
                              },
                            ),
                      );
                    }),
                  ],
                ),
              );
            } else if (widget.data['matchVerification'][widget.index]
            ['firstOneToOpen'] ==
                2) {
              int? selectedValue1, selectedValue2;
              return AlertDialog(
                title:
                const Center(child: Text('Please enter the match results')),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                      child: Text(
                        'The information of the team that entered the game results first to the opposing team.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<int>(
                          value: selectedValue1,
                          onChanged: (value) {
                            setState(() {
                              selectedValue1 = value;
                            });
                          },
                          items: List<DropdownMenuItem<int>>.generate(
                            100,
                                (index) =>
                                DropdownMenuItem<int>(
                                  value: index + 1,
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ),
                          ),
                          underline: const SizedBox.shrink(),
                        ),
                        const SizedBox(width: 16),
                        DropdownButton<int>(
                          value: selectedValue2,
                          onChanged: (value) {
                            setState(() {
                              selectedValue2 = value;
                            });
                          },
                          items: List<DropdownMenuItem<int>>.generate(
                            100,
                                (index) =>
                                DropdownMenuItem<int>(
                                  value: index + 1,
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ),
                          ),
                          underline: const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    firebaseUIButton(
                        context,
                        "Confirmation of result to the other team", () {
                      String s =
                      (selectedValue1! > selectedValue2!) ? "Win" : "Lose";

                      if (selectedValue2 ==
                          widget.data['matchVerification'][widget.index]
                          ['opponentScore'] &&
                          selectedValue1 ==
                              widget.data['matchVerification'][widget.index]
                              ['myScore']) {
                        // Database changes with reference to user
                        DocumentReference documentReference = FirebaseFirestore
                            .instance
                            .collection('Teams')
                            .doc(widget.uid); //remeber to update this with uid
                        FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentSnapshot snapshot =
                          await transaction.get(documentReference);
                          if (!snapshot.exists) {
                            throw Exception("User does not exist!");
                          }
                          List<dynamic> match_history_update =
                          widget.data['matchHistory'];
                          List<dynamic> update_match_verification = [];
                          for (int i = 0; i <
                              match_history_update.length; i++) {
                            if (match_history_update[i]['timeSlot'] ==
                                widget.data['matchVerification'][widget.index]
                                ['timeSlot'] &&
                                match_history_update[i]['date'] ==
                                    widget.data['matchVerification'][widget
                                        .index]
                                    ['date']) {
                              match_history_update[i]['myScore'] =
                                  selectedValue1;
                              match_history_update[i]['opponentScore'] =
                                  selectedValue2;
                            }
                          }
                          for (int i = 0;
                          i < widget.data['matchVerification'].length;
                          i++) {
                            if (i != widget.index) {
                              update_match_verification
                                  .add(widget.data['matchVerification'][i]);
                            }
                          }
                          transaction.update(documentReference,
                              {'matchVerification': update_match_verification});
                          transaction.update(documentReference,
                              {'matchHistory': match_history_update});
                        });
                        //Database changes for opponent
                        DocumentReference opp_documentReference =
                        FirebaseFirestore.instance.collection('Teams').doc(
                            widget.data['matchVerification'][widget.index]
                            ['opponentUID']);
                        FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentSnapshot opp_snapshot =
                          await transaction.get(opp_documentReference);
                          if (!opp_snapshot.exists) {
                            throw Exception("User does not exist!");
                          }
                          List<dynamic> opponent_match_verification = [];

                          for (int i = 0;
                          i < widget.info['matchVerification'].length;
                          i++) {
                            if (widget
                                .info['matchVerification'][i]['timeSlot'] ==
                                widget.data['matchVerification'][widget.index]
                                ['timeSlot'] &&
                                widget.info['matchVerification'][i]['date'] ==
                                    widget.data['matchVerification'][widget
                                        .index]
                                    ['date']) {
                              continue;
                            } else {
                              opponent_match_verification
                                  .add(widget.info['matchVerification'][i]);
                            }
                          }
                          List<dynamic> opponent_match_history =
                          widget.info['matchHistory'];
                          Map<String, dynamic> history_update_opponent = {
                            "date": widget.data['matchVerification'][widget
                                .index]['date'],
                            "timeSlot": widget.data['matchVerification'][widget
                                .index]['timeSlot'],
                            "location": widget.data['matchVerification'][widget
                                .index]['location'],
                            "opponentUID": widget.uid,
                            "myScore": selectedValue1,
                            "opponentScore": selectedValue2,
                            "result": "",
                          };
                          opponent_match_history.add(history_update_opponent);
                          transaction.update(opp_documentReference,
                              {'matchHistory': opponent_match_history});
                          transaction.update(opp_documentReference,
                              {
                                'matchVerification': opponent_match_verification
                              });
                        });
                      } else {
                        // Database changes with reference to user
                        DocumentReference documentReference = FirebaseFirestore
                            .instance
                            .collection('Teams')
                            .doc(widget.uid); //remeber to update this with uid
                        FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentSnapshot snapshot =
                          await transaction.get(documentReference);
                          if (!snapshot.exists) {
                            throw Exception("User does not exist!");
                          }
                          List<dynamic> update_match_verification =
                          widget.data['matchVerification'];
                          update_match_verification[widget.index]['myScore'] =
                              selectedValue1;
                          update_match_verification[widget.index]
                          ['opponentScore'] = selectedValue2;
                          update_match_verification[widget.index]
                          ['firstOneToOpen'] = 1;
                          transaction.update(documentReference,
                              {'matchVerification': update_match_verification});
                        });
                        //Database changes for opponent
                        DocumentReference opp_documentReference =
                        FirebaseFirestore.instance.collection('Teams').doc(
                            widget.data['matchVerification'][widget.index]
                            ['opponentUID']);
                        FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentSnapshot opp_snapshot =
                          await transaction.get(opp_documentReference);
                          if (!opp_snapshot.exists) {
                            throw Exception("User does not exist!");
                          }
                          List<dynamic> opponent_match_verification =
                          widget.info['matchVerification'];
                          for (int i = 0;
                          i < opponent_match_verification.length;
                          i++) {
                            if (opponent_match_verification[i]['timeSlot'] ==
                                widget.data['matchVerification'][widget.index]
                                ['timeSlot'] &&
                                opponent_match_verification[i]['date'] ==
                                    widget.data['matchVerification'][widget
                                        .index]
                                    ['date']) {
                              opponent_match_verification[i]['myScore'] =
                                  selectedValue2;
                              opponent_match_verification[i]['opponentScore'] =
                                  selectedValue1;
                              opponent_match_verification[i]['firstOneToOpen'] =
                              2;
                            }
                          }

                          transaction.update(opp_documentReference,
                              {
                                'matchVerification': opponent_match_verification
                              });
                        });
                      }
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setState) {
                                return AlertDialog(
                                  title: const Center(child: Text('Sent')),
                                  content: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: Image.asset(
                                          "assets/images/sent.png",
                                          scale: 2.1,
                                        ),
                                      ),
                                      const Center(
                                        child: Text(
                                          'By entering the game results number of wins and losses against the opposing team,You can see it in Numbers.',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const Center(
                                        child: Text(
                                          'Past Results',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const Center(
                                        child: Divider(
                                          color: Colors.black38,
                                          thickness: 1.0,
                                        ),
                                      ),
                                      const Center(
                                        child: Text(
                                          '4 wins, 2 losses and 1 point',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      firebaseUIButton(context, "Close", () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen(
                                                        uid: widget.uid,selectedIndex: 0,)));
                                      }),
                                    ],
                                  ),
                                );
                              },
                            ),
                      );
                    }),
                  ],
                ),
              );
            } else {
              return SizedBox(
                width: 0,
                height: 0,
              );
            }
          },
        );
        // print("prathmesh12312");
        setState(() {
          // print("Helloworld");
          _popupShown = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class HomeScreen extends StatefulWidget {
  final String? uid;
  int selectedIndex;
  HomeScreen({Key? key, required this.uid,required this.selectedIndex}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<Widget> _pages = <Widget>[
    MatchMaking(),
    RequestManage(),
    Messages(),
    MyPage(),
  ];

  CollectionReference scheduledCardData =
      FirebaseFirestore.instance.collection('Teams');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Disable back button functionality
          return false;
        },
    child: Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: scheduledCardData.doc(widget.uid).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Text("");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              List<dynamic> scheduledCardsInfo;
              // List<dynamic> scheduledCardsDate;
              // List<dynamic> newList = [];
              scheduledCardsInfo = data["matchScheduled"];
              // scheduledCardsDate= data["matchScheduledDate"];


              // scheduledCardsDate =  sortMatchCardsDate(scheduledCardsDate);
              List<dynamic> to_be_removed = [];
              DateTime today = DateTime.now();
              String hour_today = "${today.hour}";
              String today_date = "${today.day}";
              if (today_date.length == 1) {
                today_date = "0" + today_date;
              }
              String rightnow = "${today.year}-${today.month}-${today_date}";

              List<dynamic> upcomming_matches = [];
              for (int i = 0; i < scheduledCardsInfo.length; i++) {
                DateTime parsedDate = DateFormat('MMMM d, y')
                    .parse(scheduledCardsInfo[i]['date']);
                String Date_ff = DateFormat('d').format(parsedDate);
                if (Date_ff.length == 1) {
                  Date_ff = "0" + Date_ff;
                }
                String ouput = DateFormat('y-M').format(parsedDate);
                String comp = ouput + "-" + Date_ff;

                if (comp == rightnow) {
                  int time_today = int.parse(hour_today);
                  if (scheduledCardsInfo[i]['timeSlot'] == 1) {
                    if (time_today > 11) {
                      to_be_removed.add(scheduledCardsInfo[i]);
                    } else {
                      upcomming_matches.add(scheduledCardsInfo[i]);
                    }
                  } else if (scheduledCardsInfo[i]['timeSlot'] == 2) {
                    if (time_today > 15) {
                      to_be_removed.add(scheduledCardsInfo[i]);
                    } else {
                      upcomming_matches.add(scheduledCardsInfo[i]);
                    }
                  } else {
                    if (time_today > 17) {
                      to_be_removed.add(scheduledCardsInfo[i]);
                    } else {
                      upcomming_matches.add(scheduledCardsInfo[i]);
                    }
                  }
                } else if (comp.compareTo(rightnow) == -1) {
                  to_be_removed.add(scheduledCardsInfo[i]);
                } else {
                  upcomming_matches.add(scheduledCardsInfo[i]);
                }
              }

              // Database changes with reference to user
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('Teams')
                  .doc(widget.uid); //remeber to update this with uid
              FirebaseFirestore.instance.runTransaction((transaction) async {
                DocumentSnapshot snapshot =
                    await transaction.get(documentReference);
                if (!snapshot.exists) {
                  throw Exception("User does not exist!");
                }
                List<dynamic> to_be_verified = data['matchVerification'];
                List<dynamic> added_history = data['matchHistory'];
                for (int i = 0; i < to_be_removed.length; i++) {
                  int notremove = 0;
                  for(int j= 0;j<to_be_verified.length;j++){
                    if(to_be_verified[i]['date']==to_be_removed[i]['date']
                      && to_be_verified[i]['timeSlot'] == to_be_removed[i]['timeSlot']
                    ){
                      notremove = 1;
                    }

                  }
                  if(notremove == 0){
                    Map<String, dynamic> mp = {
                      "firstOneToOpen": 1,
                      "myScore": -1,
                      "opponentScore": -1,
                      "result": "",
                      "opponentUID": to_be_removed[i]['opponentUID'],
                      "date": to_be_removed[i]['date'],
                      "timeSlot": to_be_removed[i]['timeSlot'],
                      "location": to_be_removed[i]['location']
                    };
                    to_be_verified.add(mp);
                    Map<String, dynamic> mp_history = {
                      "date": to_be_removed[i]['date'],
                      "timeSlot": to_be_removed[i]['timeSlot'],
                      "opponentScore": -1,
                      "myScore": -1,
                      "result": "",
                      "location": to_be_removed[i]['location'],
                      "opponentUID": to_be_removed[i]['opponentUID']
                    };
                    added_history.add(mp_history);

                    transaction.update(
                        documentReference, {'matchVerification': to_be_verified});
                    transaction
                        .update(documentReference, {'matchHistory': added_history});
                    transaction.update(
                        documentReference, {'matchScheduled': upcomming_matches});
                  }
                  else{
                    Map<String, dynamic> mp_history = {
                      "date": to_be_removed[i]['date'],
                      "timeSlot": to_be_removed[i]['timeSlot'],
                      "opponentScore": -1,
                      "myScore": -1,
                      "result": "",
                      "location": to_be_removed[i]['location'],
                      "opponentUID": to_be_removed[i]['opponentUID']
                    };
                    added_history.add(mp_history);
                    transaction
                        .update(documentReference, {'matchHistory': added_history});
                    transaction.update(
                        documentReference, {'matchScheduled': upcomming_matches});
                  }


                }


              });



              return Column(
                children: [
                  for (int i = 0, p = 0;
                      i < data['matchVerification'].length;
                      i++) ...[
                    if (data['matchVerification'][i]['myScore'] == -1 ||data['matchVerification'][i]['firstOneToOpen'] == 2) ...[
                      StreamBuilder<DocumentSnapshot>(
                          stream: scheduledCardData
                              .doc(data['matchVerification'][i]['opponentUID'])
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {

                            if (snapshot.hasError) {
                              return const Text("Something went wrong");
                            }

                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return const Text("Document does not exist");
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              Map<String, dynamic> info =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              if(data['matchVerification'][i]['firstOneToOpen'] ==1){
                                DocumentReference opp_documentReference =
                                FirebaseFirestore.instance
                                    .collection('Teams')
                                    .doc(data['matchVerification'][i]
                                ['opponentUID']);
                                FirebaseFirestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentSnapshot opp_snapshot =
                                  await transaction
                                      .get(opp_documentReference);
                                  if (!opp_snapshot.exists) {
                                    throw Exception("User does not exist!");
                                  }
                                  if(p==0){
                                    List<dynamic> opp_to_be_verified =
                                    info['matchVerification'];

                                    Map<String, dynamic> mp_opp = {
                                      "firstOneToOpen": 2,
                                      "myScore": -1,
                                      "opponentScore": -1,
                                      "result": "",
                                      "opponentUID": widget.uid,
                                      "date": data['matchVerification'][i]['date'],
                                      "timeSlot": data['matchVerification'][i]['timeSlot'],
                                      "location": data['matchVerification'][i]['location']
                                    };
                                    opp_to_be_verified.add(mp_opp);
                                    // print(opp_to_be_verified);
                                    if(p==0) {
                                      // print(p);

                                      transaction.update(opp_documentReference, {
                                        'matchVerification':
                                        opp_to_be_verified
                                      });
                                      // print(opp_to_be_verified);
                                      p++;
                                    }
                                    p++;

                                  }});
                              }
                              return AutoPopup(
                                  uid: widget.uid,
                                  data: data,
                                  info: info,
                                  index: i);
                            }
                          })
                    ]
                  ],
                  Expanded(
                    child: _pages.elementAt(widget.selectedIndex),
                  )
                ],
              );
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        // selectedIconTheme: const IconThemeData(color: Colors.black),
        selectedItemColor: Color.fromRGBO(17, 86, 149, 1),
        showUnselectedLabels: true,
        // selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedIconTheme: const IconThemeData(
          color: Colors.black38,
        ),
        unselectedItemColor: Colors.black38,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/match_making_navbar.png"),
              size: 24,
            ),
            label: matchMaking['matchMakingTitle']!,
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/request_management_navbar.png"),
              size: 24,
            ),
            label: requestManagement['title']!,
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/message_navbar.png"),
              size: 24,
            ),
            label: message['title']!,
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/my_page_navbar.png"),
              size: 24,
            ),
            label: myPage['title']!,
          ),
        ],
        currentIndex: widget.selectedIndex, //New
        onTap: _onItemTapped,
      ),
    ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }
}
