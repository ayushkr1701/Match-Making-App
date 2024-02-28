import 'package:ai_match_making_app/screens/Base/home_screen.dart';
import 'package:ai_match_making_app/screens/modals/info_modal.dart';
import 'package:ai_match_making_app/screens/profile/util_classes.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../reusable_widgets/reusable_widgets.dart';
import '../Base/my_page.dart';

// ignore: camel_case_types, must_be_immutable
class completeSchedule extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  completeSchedule({super.key});

  @override
  State<completeSchedule> createState() => _completeScheduleState();
}

// ignore: camel_case_types
class _completeScheduleState extends State<completeSchedule> {
  String currentID = getCurrentUID();
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    uid: currentID,
                    selectedIndex: _selectedIndex,
                  )));
    });
  }

  int _selectedIndex = 3;
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    CollectionReference scheduledCardData =
        FirebaseFirestore.instance.collection('Teams');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[300],
        title: const Text(
          'Complete Schedule',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: scheduledCardData.doc(uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            // print(data.length);
            // print("printing data :-");
            // print(data);
            List<dynamic> scheduledCardsInfo;
            // List<dynamic> scheduledCardsDate;
            // List<dynamic> newList = [];
            scheduledCardsInfo = data["matchScheduled"];
            // scheduledCardsDate= data["matchScheduledDate"];
            scheduledCardsInfo = sortMatchCards(scheduledCardsInfo);

            // scheduledCardsDate =  sortMatchCardsDate(scheduledCardsDate);
            List<dynamic> to_be_removed = [];
            DateTime today = DateTime.now();
            String hour_today = "${today.hour}";
            String today_date = "${today.day}";
            String rightnow = "${today.year}-${today.month}-${today_date}";

            List<dynamic> upcomming_matches = [];
            for (int i = 0; i < scheduledCardsInfo.length; i++) {
              String comp = formattedDate(scheduledCardsInfo[i]['date']);
              // print(comp);
              // print(rightnow);
              if (comp == rightnow) {
                // print("here");
                int time_today = int.parse(hour_today);
                if (scheduledCardsInfo[i]['timeSlot'] == 1) {
                  print(time_today);
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

            // DocumentReference documentReference = FirebaseFirestore.instance
            //     .collection('Teams')
            //     .doc(uid);//remeber to update this with uid
            // FirebaseFirestore.instance.runTransaction((transaction) async {
            //   DocumentSnapshot snapshot = await transaction.get(documentReference);
            //   if (!snapshot.exists) {
            //     throw Exception("User does not exist!");
            //   }
            //   List<dynamic>request_card = [];
            //   for(int j = 0;j<widget.data['matchRequests'].length;j++){
            //     if(j!=widget.index){
            //       request_card.add(widget.data['matchRequests'][j]);
            //     }
            //   }
            //   transaction.update(documentReference, {'matchRequests': request_card});
            // });

            if (scheduledCardsInfo.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CustomLogoWidget(
                    imagePath: "assets/images/schedule.png",
                    text: "This is where scheduled matches will be displayed",
                  ),
                ],
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Card(
                    child: Column(
                      children: [
                        for (int i = 0; i < scheduledCardsInfo.length; i++) ...[
                          StreamBuilder<DocumentSnapshot>(
                            stream: scheduledCardData
                                .doc(scheduledCardsInfo[i]["opponentUID"])
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text("Something went wrong");
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("");
                              } else {
                                Map<String, dynamic> info = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                //
                                String time;

                                if (scheduledCardsInfo[i]["timeSlot"] == 1) {
                                  time = '9:00-11:00';
                                } else if (scheduledCardsInfo[i]["timeSlot"] ==
                                    2) {
                                  time = '11:00-13:00';
                                } else {
                                  time = '13:00-15:00';
                                }

                                return Column(
                                  children: [
                                    if (i == 0) ...[          // for the first date, directly insert the date first
                                      AddingDate(
                                          dateItem: scheduledCardsInfo[i]
                                              ["date"]),
                                    ] else if (scheduledCardsInfo[i - 1]            // to add new date only when there is change in date. This will ensure all the matches for a particular day comes under that particular day.
                                            ["date"] !=
                                        scheduledCardsInfo[i]["date"]) ...[
                                      AddingDate(
                                          dateItem: scheduledCardsInfo[i]
                                              ["date"]),
                                    ],
                                    AddingTime(timeItem: time),
                                    MyButton(
                                      iconData: Icons.abc_outlined,
                                      buttonText: info["basicInfo"]
                                          ["schoolName"],
                                      location: scheduledCardsInfo[i]
                                          ["location"],
                                      data: data,
                                      uid: scheduledCardsInfo[i]["opponentUID"],
                                      info: info,
                                      i: i,
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        // selectedIconTheme: const IconThemeData(color: Colors.black),
        selectedItemColor: const Color.fromRGBO(17, 86, 149, 1),
        showUnselectedLabels: true,
        // selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedIconTheme: const IconThemeData(
          color: Colors.black38,
        ),
        unselectedItemColor: Colors.black38,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage("assets/images/match_making_navbar.png"),
              size: 24,
            ),
            label: matchMaking['matchMakingTitle']!,
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage("assets/images/request_management_navbar.png"),
              size: 24,
            ),
            label: requestManagement['title']!,
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage("assets/images/message_navbar.png"),
              size: 24,
            ),
            label: message['title']!,
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage("assets/images/my_page_navbar.png"),
              size: 24,
            ),
            label: myPage['title']!,
          ),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors, camel_case_types
class historyOfGames extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  historyOfGames({super.key});

  @override
  State<historyOfGames> createState() => _historyOfGamesState();
}

// ignore: camel_case_types
class _historyOfGamesState extends State<historyOfGames> {
  String currentID = getCurrentUID();
  int _selectedIndex = 3;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    uid: currentID,
                    selectedIndex: _selectedIndex,
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    CollectionReference scheduledCardData =
        FirebaseFirestore.instance.collection('Teams');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[300],
        title: const Text(
          'Past Game History',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: scheduledCardData.doc(uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            // print(data.length);
            // print("printing data :-");
            // print(data);
            List<dynamic> scheduledCardsInfo;
            // List<dynamic> scheduledCardsDate;
            // List<dynamic> newList = [];
            scheduledCardsInfo = data["matchHistory"];
            // scheduledCardsDate= data["matchScheduledDate"];
            scheduledCardsInfo = sortMatchCards(scheduledCardsInfo);

            // scheduledCardsDate =  sortMatchCardsDate(scheduledCardsDate);

            if (scheduledCardsInfo.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CustomLogoWidget(
                    imagePath: "assets/images/history.png",
                    text:
                        "This is where history of matches played will be displayed",
                  ),
                ],
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Card(
                    child: Column(
                      children: [
                        for (int i = 0; i < scheduledCardsInfo.length; i++) ...[
                          StreamBuilder<DocumentSnapshot>(
                            stream: scheduledCardData
                                .doc(scheduledCardsInfo[i]["opponentUID"])
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text("Something went wrong");
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("");
                              } else {
                                Map<String, dynamic> info = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                //
                                String time;

                                if (scheduledCardsInfo[i]["timeSlot"] == 1) {
                                  time = '9:00-11:00';
                                } else if (scheduledCardsInfo[i]["timeSlot"] ==
                                    2) {
                                  time = '11:00-13:00';
                                } else {
                                  time = '13:00-15:00';
                                }

                                return Column(
                                  children: [
                                    if (i == 0) ...[
                                      AddingDate(
                                          dateItem: scheduledCardsInfo[i]
                                              ["date"]),
                                    ] else if (scheduledCardsInfo[i - 1]
                                            ["date"] !=
                                        scheduledCardsInfo[i]["date"]) ...[
                                      AddingDate(
                                          dateItem: scheduledCardsInfo[i]
                                              ["date"]),
                                    ],
                                    AddingTime(timeItem: time),
                                    MyButton(
                                      iconData: Icons.abc_outlined,
                                      buttonText: info["basicInfo"]
                                          ["schoolName"],
                                      location: scheduledCardsInfo[i]
                                          ["location"],
                                      data: data,
                                      uid: scheduledCardsInfo[i]["opponentUID"],
                                      info: info,
                                      i: i,
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        // selectedIconTheme: const IconThemeData(color: Colors.black),
        selectedItemColor: const Color.fromRGBO(17, 86, 149, 1),
        showUnselectedLabels: true,
        // selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedIconTheme: const IconThemeData(
          color: Colors.black38,
        ),
        unselectedItemColor: Colors.black38,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage("assets/images/match_making_navbar.png"),
              size: 24,
            ),
            label: matchMaking['matchMakingTitle']!,
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage("assets/images/request_management_navbar.png"),
              size: 24,
            ),
            label: requestManagement['title']!,
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage("assets/images/message_navbar.png"),
              size: 24,
            ),
            label: message['title']!,
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage("assets/images/my_page_navbar.png"),
              size: 24,
            ),
            label: myPage['title']!,
          ),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
    );
  }
}

String formattedDate(String dateItem) {
  DateTime parsedDate = DateFormat('MMMM d, y').parse(dateItem);
  String output = DateFormat('y-M-d').format(parsedDate);
  return output;
}

String giveYearAndMonth(String dateItem) {
  DateTime parsedDate = DateFormat('MMMM d, y').parse(dateItem);
  String output = DateFormat('y-M').format(parsedDate);
  String day = DateFormat('d').format(parsedDate);
  if (day.length == 1) {
    day = "0" + day;
  }
  output = output + '-' + day;
  return output;
}

String giveDate(String dateItem) {
  DateTime parsedDate = DateFormat('MMMM d, y').parse(dateItem);
  String output = DateFormat('d').format(parsedDate);
  return output;
}

List<dynamic> sortMatchCards(List<dynamic> cardList) {
  final List<dynamic> cardDataSorted = [];
  final List<String> sortingPurposeStringList = [];

  for (int i = 0; i < cardList.length; i++) {
    // print(cardList[i]["date"]);
    String cardDate = formattedDate(cardList[i]["date"]);

    String timeSlot = (cardList[i]["timeSlot"]).toString();
    String identifier = i.toString();
    //
    String sortString = "$cardDate-$timeSlot-$identifier";
    // print(sortString);
    sortingPurposeStringList.add(sortString);
  }

  sortingPurposeStringList.sort((a, b) => a.compareTo(b));

  for (int i = 0; i < sortingPurposeStringList.length; i++) {
    String ind =
        (sortingPurposeStringList[i])[sortingPurposeStringList[i].length - 1];
    int index = int.parse(ind);
    cardDataSorted.add(cardList[index]);
  }

  return cardDataSorted;
}
