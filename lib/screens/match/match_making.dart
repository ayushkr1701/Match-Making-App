import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ai_match_making_app/screens/Base/home_screen.dart';
import 'package:ai_match_making_app/screens/Base/scheduled_matches_screen.dart';
import 'package:ai_match_making_app/utils/constants.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai_match_making_app/screens/modals/info_modal.dart';
import 'package:ai_match_making_app/screens/requests/request_manage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../reusable_widgets/reusable_widgets.dart';
import '../profile/util_classes.dart';
import 'matching_condtion.dart';

// making class of variables which we required in the form of list in this format from firebase
// ignore: camel_case_types

// list which we require from fire base

// top part of the scheduled match card
// ignore: camel_case_types
class head_scheduled_match_card extends StatefulWidget {
  const head_scheduled_match_card(
      {Key? key,
      required this.dateOfGame,
      required this.timeOfMatch,
      required this.weather})
      : super(key: key);
  final String dateOfGame;
  final String timeOfMatch;
  final int weather;
  @override
  // ignore: library_private_types_in_public_api
  _AddingMatchState createState() => _AddingMatchState();
}

class _AddingMatchState extends State<head_scheduled_match_card> {
  @override
  Widget build(BuildContext context) {
    return Card(
      // background: #DBEBF8;

      color: const Color(0xffdbebf8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 5, 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  matchMaking['dateAndTime']!,
                  style: const TextStyle(
                      color: Color(0xff115695),
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
                const Icon(
                  Icons.cloud_circle,
                  size: 30,
                  color: Colors.white,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "On ${widget.dateOfGame}",
                  style: const TextStyle(
                      color: Color(0xff115695),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                Card(
                  // shape: RoundedRectangleBorder(
                  //   side: const BorderSide(
                  //     color: Colors.white, //<-- SEE HERE
                  //   ),
                  //   borderRadius: BorderRadius.circular(5.0),
                  // ),
                  color: const Color(0xffdbebf8),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Text(widget.timeOfMatch,
                        style: const TextStyle(
                            color: Color(0xff115695),
                            fontSize: 15,
                            fontWeight: FontWeight.normal)),
                  ),
                ),
                const SizedBox(
                  width: 11,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class middle_scheduled_match_card extends StatefulWidget {
  const middle_scheduled_match_card({
    Key? key,
    required this.universityName,
    required this.address,
  }) : super(key: key);
  final String universityName;
  final String address;
  @override
  // ignore: library_private_types_in_public_api
  _AddingMiddleScheduledMatchState createState() =>
      _AddingMiddleScheduledMatchState();
}

class _AddingMiddleScheduledMatchState
    extends State<middle_scheduled_match_card> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff34C759),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        online,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.universityName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          widget.address,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: camel_case_types
class distance extends StatefulWidget {
  const distance({
    Key? key,
    required this.carDistance,
    required this.trainDistance,
    required this.walkDistance,
  }) : super(key: key);
  final String carDistance;
  final String trainDistance;
  final String walkDistance;
  @override
  // ignore: library_private_types_in_public_api
  _AddingDistanceState createState() => _AddingDistanceState();
}

class _AddingDistanceState extends State<distance> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        const Icon(
          Icons.directions_car,
          size: 20,
          color: Colors.black,
        ),
        Text(widget.carDistance),
        const SizedBox(
          width: 5,
        ),
        const Icon(
          Icons.directions_train,
          size: 20,
          color: Colors.black,
        ),
        Text(widget.trainDistance),
        const SizedBox(
          width: 5,
        ),
        const Icon(
          Icons.directions_walk,
          size: 20,
          color: Colors.black,
        ),
        Text(widget.walkDistance),
      ],
    );
  }
}

// ignore: camel_case_types
class imageAndScore extends StatefulWidget {
  const imageAndScore(
      {Key? key,
      required this.win,
      required this.loss,
      required this.point,
      required this.imageUrl})
      : super(key: key);
  final int win;
  final int loss;
  final int point;
  final String imageUrl;
  @override
  // ignore: library_private_types_in_public_api
  _AddingImageAndScoreState createState() => _AddingImageAndScoreState();
}

class _AddingImageAndScoreState extends State<imageAndScore> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.imageUrl == ''
              ? Image.asset(
                  'assets/dummy.jpg',
                  width: 155.0,
                  height: 155.0,
                  fit: BoxFit.contain,
                )
              : Image.network(
                  widget.imageUrl,
                  width: 155.0,
                  height: 155.0,
                  fit: BoxFit.contain,
                ),

          // SizedBox(width: 10,),
          Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Text(matchMaking['pastResults']!),
              ),
              Text(
                  "${widget.win.toString()} 勝 ${widget.loss.toString()} 敗 ${widget.point.toString()} 分",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class bottom extends StatelessWidget {
  const bottom({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[700],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Matching conditions for other team',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final int index;
  final int which_page;
  final String oid;
  final int inside_opponent_profile;
  final Map<String, dynamic> data;
  final Map<String, dynamic> info;
  final String mode;

  const Button(
      {Key? key,
      required this.oid,
      required this.inside_opponent_profile,
      required this.which_page,
      required this.index,
      required this.data,
      required this.info,
      required this.mode})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String modeButton;
    if (mode == "Automatic") {
      modeButton = "承認";//"Admit";
    } else {
      modeButton = "申し込む";//"Request";
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: SizedBox(
            width: 110,
            height: 40,
            child: PopUps(
              inside_opponent_profile: inside_opponent_profile,
              which_page: which_page,
              oid: oid,
              index: index,
              data: data,
              info: info,
              popUpWidget: PopUpsG1(
                  inside_opponent_profile: inside_opponent_profile,
                  btntxt: "Refuse",
                  which_page: which_page,
                  oid: oid,
                  index: index,
                  data: data,
                  info: info,
                  popUpItems: [
                    "April 22, 11:00 - 13:00",
                    "from nakano.refused the request for the match",
                    Icons.sentiment_very_dissatisfied,
                    "",
                    "Change matching conditions",
                    "Close"
                  ]),
              btnText: "拒否"
              // "Skip"
              ,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: SizedBox(
            width: 110,
            height: 40,
            child: PopUps(
              inside_opponent_profile: inside_opponent_profile,
              which_page: 0,
              oid: oid,
              index: index,
              data: data,
              info: info,
              popUpWidget: PopUpsG1(
                  inside_opponent_profile: inside_opponent_profile,
                  btntxt: modeButton,
                  which_page: which_page,
                  oid: oid,
                  index: index,
                  data: data,
                  info: info,
                  popUpItems: [
                    "April 22, 11:00 - 13:00",
                    "With higashiharuzaki high school.The game is over",
                    Icons.emoji_emotions,
                    "I'll send you a message, Let's say hello",
                    "Send a message",
                    "Close"
                  ]),
              btnText: modeButton,
            ),
          ),
        ),
      ],
    );
  }
}

class MatchMaking extends StatefulWidget {
  const MatchMaking({Key? key}) : super(key: key);

  @override
  State<MatchMaking> createState() => _MatchMakingState();
}

class _MatchMakingState extends State<MatchMaking> {
  List<Map<String, dynamic>> fetchedDataAll = [];
  late String matchDayTime;
  late String matchScheduleDate;
  late String matchingSetting;
  late String walkingDistance;
  late String carDistance;
  late String trainDistance;
  late String origin;
  late String destination;
  bool distancesFetched = false;
  bool cardAdded = false;

  Future<void> getDistances(String origin, String destination) async {
    String api = apiKey; // Replace with your Google Directions API key
    String walkingUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=walking&key=$api';
    String carUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=driving&key=$api';
    String trainUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=transit&key=$api';

    try {
      var walkingResponse = await http.get(Uri.parse(walkingUrl));
      var carResponse = await http.get(Uri.parse(carUrl));
      var trainResponse = await http.get(Uri.parse(trainUrl));

      if (walkingResponse.statusCode == 200) {
        // print(walkingResponse
        //     .body); // Print the complete response body for debugging

        var walkingData = json.decode(walkingResponse.body);

        if (walkingData['routes'] != null && walkingData['routes'].isNotEmpty) {
          walkingDistance =
              walkingData['routes'][0]['legs'][0]['duration']['text'];
        } else {
          // print('No routes found in the walking response.');
          walkingDistance = 'no distnace';
        }
      } else {
        print(
            'Walking API request failed with status code: $destination ${walkingResponse.statusCode}');
      }

      if (carResponse.statusCode == 200) {
        // print(
        //     carResponse.body); // Print the complete response body for debugging

        var carData = json.decode(carResponse.body);

        if (carData['routes'] != null && carData['routes'].isNotEmpty) {
          carDistance = carData['routes'][0]['legs'][0]['duration']['text'];
        } else {
          carDistance = 'no distance';
        }
      } else {
        print(
            'Car API request failed with status code: ${carResponse.statusCode}');
      }

      if (trainResponse.statusCode == 200) {
        // print(trainResponse
        //     .body); // Print the complete response body for debugging

        var trainData = json.decode(trainResponse.body);

        if (trainData['routes'] != null && trainData['routes'].isNotEmpty) {
          trainDistance = trainData['routes'][0]['legs'][0]['duration']['text'];
        } else {
          trainDistance = 'no trains';
        }
      } else {
        print(
            'Train API request failed with status code: ${trainResponse.statusCode}');
      }

      // setState(() {
      //   distancesFetched = true;
      // });
      // Rest of the code...
    } catch (e) {
      print('Error getting distances: $e');
    }
  }

  Future<void> fetchDataAll() async  {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("Teams").get();

    if (snapshot.docs.isNotEmpty) {
      List<Map<String, dynamic>> fetchedDataList =
          snapshot.docs.map((document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        data['uid'] = document.id; // Assign UID from document ID
        return data;
      }).toList();

      setState(() {
        fetchedDataAll = fetchedDataList;
      });

      User? user = FirebaseAuth.instance.currentUser;
      List<dynamic> matchCard = user?.uid != null
          ? (fetchedDataList.firstWhere(
                  (data) => data['uid'] == user!.uid)['matchCard'] ??
              [])
          : [];

// Update matchCard for existing opponents
      for (int index = 0; index < fetchedDataAll.length; index++) {
        try {
          Map<String, dynamic> data = fetchedDataAll[index];
          final matchAvailability = data['matchAvailability'];
          String street = data['basicInfo']?['schoolAddress']?['city'] ?? '';
          String prefecture =
              data['basicInfo']?['schoolAddress']?['prefecture'] ?? '';
          String pincode =
              data['basicInfo']?['schoolAddress']?['pincode'] ?? '';

          destination = '$street, $prefecture, $pincode';
          await getDistances(origin, destination);
          print('distance calculated $index');

          if (matchAvailability != null && matchAvailability.isNotEmpty) {
            String matchScheduleDate;
            String matchingSetting;
            // int? timeSlot;
            String matchDayTime;

            final latestMatchAvailability = matchAvailability.last;
            matchScheduleDate = latestMatchAvailability['date'] ?? 'DNE';
            matchingSetting = latestMatchAvailability['matchingSetting'] ?? '';

            int? timeSlot = latestMatchAvailability['timeSlot'];
            String timeSlotText =
                timeSlot != null ? timeSlot.toString() : 'DNE';

            if (timeSlotText == "1") {
              matchDayTime = "9:00-11:00";
            } else if (timeSlotText == "2") {
              matchDayTime = "11:00-13:00";
            } else if (timeSlotText == "3") {
              matchDayTime = "13:00-15:00";
            }

            // Check if opponentUID already exists in matchCard
            bool opponentExists =
                matchCard.any((card) => card['opponentUID'] == data['uid']);

            if (!opponentExists && data['uid'] != user?.uid) {
              matchCard.add({
                'date': matchScheduleDate,
                // 'distanceByCar': carDistance,
                // 'distanceByTrain': trainDistance,
                // 'distanceByWalk': walkingDistance,
                'location': "location",
                'matchingSetting': matchingSetting,
                'opponentUID': data['uid'],
                'teamLevel': data['basicInfo']['teamLevel'],
                'timeSlot': timeSlot,
              });
            } else {
              // Find the index of the existing opponent in matchCard
              int opponentIndex = matchCard
                  .indexWhere((card) => card['opponentUID'] == data['uid']);

              // Retrieve the existing opponent data
              Map<String, dynamic> existingOpponent = matchCard[opponentIndex];
              print('the function is running $index');

              // Check if any values have changed
              bool hasChanged = false;

              if (existingOpponent['date'] != matchScheduleDate) {
                existingOpponent['date'] = matchScheduleDate;
                hasChanged = true;
              }

              if (existingOpponent['matchingSetting'] != matchingSetting) {
                existingOpponent['matchingSetting'] = matchingSetting;
                hasChanged = true;
              }

              if (existingOpponent['timeSlot'] != timeSlot) {
                existingOpponent['timeSlot'] = timeSlot;
                hasChanged = true;
              }
              // if (existingOpponent['distanceByCar'] != carDistance) {
              //   existingOpponent['distanceByCar'] = carDistance;
              //   hasChanged = true;
              // }

              // if (existingOpponent['distanceByTrain'] != trainDistance) {
              //   existingOpponent['distanceByTrain'] = trainDistance;
              //   hasChanged = true;
              // }

              // if (existingOpponent['distanceByWalk'] != walkingDistance) {
              //   existingOpponent['distanceByWalk'] = walkingDistance;
              //   hasChanged = true;
              // }

              // Update the opponent data in the matchCard
              if (hasChanged) {
                matchCard[opponentIndex] = existingOpponent;
              }
            }
          } else {
            continue;
          }
        } catch (e) {
          print('Error calculating distance for index $index: $e');
          continue; // Continue to the next iteration if an error occurs
        }
      }

      // Remove matchCard for removed opponents
      matchCard.retainWhere((card) =>
          fetchedDataAll.any((data) => data['uid'] == card['opponentUID']));

      // Update the matchCard in the database
      if (user?.uid != null) {
        FirebaseFirestore.instance.collection('Teams').doc(user!.uid).update({
          'matchCard': matchCard,
        }).then((_) {
          setState(() {
            cardAdded = true;
          });
          print('Match card updated successfully');
        }).catchError((error) {
          print('Failed to update match card: $error');
        });
      }
    }

    print(fetchedDataAll);
  }

  // void fetchOrigin() async {
  //   String uid = getCurrentUID();
  //   DocumentReference teamRef =
  //       FirebaseFirestore.instance.collection("Teams").doc(uid);

  //   teamRef.get().then((snapshot) {
  //     if (snapshot.exists) {
  //       var data = snapshot.data();
  //       if (data != null && data is Map<String, dynamic>) {
  //         setState(() {
  //           String street = data['basicInfo']?['schoolAddress']?['city'] ?? '';
  //           String prefecture =
  //               data['basicInfo']?['schoolAddress']?['prefecture'] ?? '';
  //           String pincode =
  //               data['basicInfo']?['schoolAddress']?['pincode'] ?? '';

  //           origin = '$street, $prefecture, $pincode';
  //           print('origin: $origin');
  //           getDistances(origin, destination);
  //         });
  //       }
  //     }
  //   }).catchError((e) {
  //     print('Error fetching team data: $e');
  //   });
  // }

  @override
  void initState() {
    super.initState();
    walkingDistance = '0 points';
    carDistance = '0 points';
    trainDistance = '0 points';
    // origin = '';
    // destination = '';
    // fetchOrigin();
    fetchDataAll();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    CollectionReference cardData =
        FirebaseFirestore.instance.collection('Teams');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: Text(
                matchMaking['matchMakingTitle']!,
                style: const TextStyle(color: Colors.black, fontSize: 24),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SortingDialog(); // Display the Sort Dialog box
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.sort,
                    color: Colors.black,
                  )),
            ),
            Expanded(
                flex: 1,
                child: Text(
                  matchMaking['sort']!,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                )),
          ],
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: cardData.doc(uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(matchMaking['somethingWrong']!);
          }

          if (snapshot.connectionState == ConnectionState.waiting && cardAdded == false) {
            return const Center(child: CircularProgressIndicator());
          }
           else {
            // fetchDataAll();
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            List<dynamic> matchMakingCardsInfo;
            matchMakingCardsInfo = data["matchCard"];
            int sortCondition = data["sortAction"];
            // print(data["sortAction"]);
            matchMakingCardsInfo = sortMatchCardsBasedOnCondition(
                matchMakingCardsInfo, sortCondition);
            // print(matchMakingCardsInfo);
            // print(data['matchCard']);
            // updating the sorted match card array in the firebase
            if (matchMakingCardsInfo != data["matchCard"]) {
              DocumentReference documentReference =
                  FirebaseFirestore.instance.collection('Teams').doc(uid);

              FirebaseFirestore.instance.runTransaction((transaction) async {
                DocumentSnapshot snapshot =
                    await transaction.get(documentReference);
                if (!snapshot.exists) {
                  throw Exception("User does not exist!");
                }

                // print(widget.data['matchApplied']);

                // transaction.update(
                //     documentReference, {'matchCard': matchMakingCardsInfo});
              });
            }
            if (matchMakingCardsInfo.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          firebaseUIButton(
                              context, matchMaking['scheduleMatches']!, () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => completeSchedule()));
                          }),
                        ]),
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                  CustomLogoWidget(
                    imagePath: "assets/images/matchmaking.png",
                    text: matchMaking['potentialOpponentText']!,
                  ),
                  SizedBox(
                    width: 300,
                    child: Column(children: [
                      firebaseUIButton(
                          context, matchMaking['changeMakingCondn']!, () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MatchingConditionScreen()));
                      }),
                    ]),
                  ),
                ],
              );
            } else {
              // fetchDataAll();
              return Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Card(
                    child: Column(
                      children: [
                        for (int i = 0;
                            i < matchMakingCardsInfo.length;
                            i++) ...[
                          StreamBuilder<DocumentSnapshot>(
                            stream: cardData
                                .doc(matchMakingCardsInfo[i]["opponentUID"])
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text(matchMaking['somethingWrong']!);
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("");
                              } else {
                                Map<String, dynamic> info = snapshot.data!
                                    .data() as Map<String, dynamic>;

                                String time;
                                if (matchMakingCardsInfo[i]['timeSlot'] == 1) {
                                  time = '9:00-11:00';
                                } else if (matchMakingCardsInfo[i]
                                        ['timeSlot'] ==
                                    2) {
                                  time = '11:00-13:00';
                                } else {
                                  time = '13:00-15:00';
                                }
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OpponentProfile(
                                                    which_page: 0,
                                                    buttonpressed: 0,
                                                    oid: matchMakingCardsInfo[i]
                                                        ["opponentUID"],
                                                    data: data,
                                                    index: i,
                                                    info: info,
                                                    mode: matchMakingCardsInfo[
                                                            i]
                                                        ['matchingSetting'])));
                                  },
                                  child: Card(
                                    shape: const RoundedRectangleBorder(
                                        side: BorderSide(
                                      color: Colors.black,
                                    )),
                                    child: Column(
                                      children: [
                                        head_scheduled_match_card(
                                            dateOfGame: matchMakingCardsInfo[i]
                                                ['date'],
                                            timeOfMatch: time,
                                            weather: 1),
                                        middle_scheduled_match_card(
                                            universityName: info['basicInfo']
                                                ['schoolName'],
                                            address:
                                                "${info['basicInfo']['schoolAddress']['street']} , ${info['basicInfo']['schoolAddress']['city']} , ${info['basicInfo']['schoolAddress']['pincode']} "),
                                        // distance(
                                        //     carDistance: matchMakingCardsInfo[i]
                                        //             ['distanceByCar'] ??
                                        //         '',
                                        //     trainDistance:
                                        //         matchMakingCardsInfo[i]
                                        //                 ['distanceByTrain'] ??
                                        //             '',
                                        //     walkDistance:
                                        //         matchMakingCardsInfo[i]
                                        //                 ['distanceByWalk'] ??
                                        //             ''),
                                        imageAndScore(
                                            win:
                                                info['basicInfo']['win'] != null
                                                    ? info['basicInfo']['win']
                                                    : 0,
                                            loss: info['basicInfo']['loss'] !=
                                                    null
                                                ? info['basicInfo']['loss']
                                                : 0,
                                            point: info['basicInfo']['draw'] !=
                                                    null
                                                ? info['basicInfo']['draw']
                                                : 0,
                                            imageUrl: (info.containsKey(
                                                        'images') &&
                                                    info['images'] != null &&
                                                    info['images'].length != 0)
                                                ? info['images']['0']
                                                : ''),
                                        Button(
                                            inside_opponent_profile: 0,
                                            which_page: 0,
                                            oid: matchMakingCardsInfo[i]
                                                ["opponentUID"],
                                            data: data,
                                            index: i,
                                            info: info,
                                            mode: matchMakingCardsInfo[i]
                                                ['matchingSetting']),
                                      ],
                                    ),
                                  ),
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
    );
  }
}

class OpponentProfile extends StatefulWidget {
  final int which_page;
  final int index;
  final int buttonpressed;
  final String oid;
  final Map<String, dynamic> data;
  final Map<String, dynamic> info;
  final String mode;
  const OpponentProfile(
      {super.key,
      required this.index,
      required this.which_page,
      required this.buttonpressed,
      required this.oid,
      required this.data,
      required this.info,
      required this.mode});
  @override
  // ignore: library_private_types_in_public_api
  _OpponentProfileState createState() => _OpponentProfileState();
}

class _OpponentProfileState extends State<OpponentProfile> {
  String currentID = getCurrentUID();
  int _selectedIndex = 3;

  late final TextEditingController bioController;
  late final List<TextEditingController> basicInfoControllers;
  late final List<TextEditingController> schoolAddressControllers;
  late final List<TextEditingController> firstHomeControllers;
  String matchScheduleDate = 'value not selected';
  String matchDayTime = 'value not selected';
  String matchLocation = 'value not selected';
  late String walkingDistance;
  late String carDistance;
  late String trainDistance;
  late String origin;
  late String destination;
  bool distancesFetched = false;
  // late String origin = '';
  // late String destination = '';
  // List imagesUrl = [];

  var firstGradeMembers;
  var secondGradeMembers;
  var thirdGradeMembers;
  var fourthGradeMembers;
  var fifthGradeMembers;
  var sixthGradeMembers;
  var species;
  late String imageUrl1;
  late String imageUrl2;
  late String imageUrl3;
  late String imageUrl4;
  late String imageUrl5;
  // String imageUrl2 = '';
  // String imageUrl3 = '';
  // String imageUrl4 = '';
  // String imageUrl5 = '';

  String lat = '0.0';
  String lang = '0.0';

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
  void initState() {
    super.initState();
    walkingDistance = '0 points';
    carDistance = '0 points';
    trainDistance = '0 points';
    origin = '';
    destination = '';
    imageUrl1 = '';
    imageUrl2 = '';
    imageUrl3 = '';
    imageUrl4 = '';
    imageUrl5 = '';
    bioController = TextEditingController();
    basicInfoControllers = List.generate(3, (_) => TextEditingController());
    schoolAddressControllers = List.generate(5, (_) => TextEditingController());
    firstHomeControllers = List.generate(5, (_) => TextEditingController());
    fetchTeamData();
    fetchOrigin();
  }

  void fetchTeamData() async {
    // String uid = getCurrentUID();
    DocumentReference teamRef =
        FirebaseFirestore.instance.collection("Teams").doc(widget.oid);

    teamRef.get().then((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data is Map<String, dynamic>) {
          // Add null check and type check
          setState(() {
            lat = (data['basicInfo']?['schoolAddress']?['lat'])?.toString() ??
                '0.0';
            if (lat == "") lat = '0.0';
            lang = (data['basicInfo']?['schoolAddress']?['lang'])?.toString() ??
                '0.0';
            if (lang == "") lang = '0.0';
            String street = data['basicInfo']?['schoolAddress']?['city'] ?? '';
            String prefecture =
                data['basicInfo']?['schoolAddress']?['prefecture'] ?? '';
            String pincode =
                data['basicInfo']?['schoolAddress']?['pincode'] ?? '';

            destination = '$street, $prefecture, $pincode';
            print(widget.oid);
            print('destination: $destination');
            bioController.text = data['basicInfo']?['bio']
                as String; // Add explicit cast to String
            basicInfoControllers[1].text =
                data['basicInfo']?['representativeName'] ?? '';
            schoolAddressControllers[2].text =
                data['basicInfo']?['schoolAddress']?['city'] ?? '';
            schoolAddressControllers[4].text =
                data['basicInfo']?['schoolAddress']?['nearestStation'] ?? '';
            schoolAddressControllers[3].text = (data['basicInfo']
                        ?['schoolAddress']?['parkingAvailability'] ==
                    true)
                ? 'set'
                : '';
            schoolAddressControllers[0].text =
                data['basicInfo']?['schoolAddress']?['pincode'] ?? '';
            schoolAddressControllers[1].text =
                data['basicInfo']?['schoolAddress']?['prefecture'] ?? '';
            basicInfoControllers[0].text =
                data['basicInfo']?['schoolName'] ?? '';
            basicInfoControllers[2].text =
                data['basicInfo']?['totalMembers'] ?? '';
            firstHomeControllers[0].text =
                data['homeGround']['firstHomeGround']['pincode'] ?? " ";
            firstHomeControllers[1].text = data['homeGround']['firstHomeGround']
                    ['address']['prefecture'] ??
                " ";
            firstHomeControllers[2].text = data['homeGround']['firstHomeGround']
                    ['address']['street'] ??
                " ";

            // final matchAvailability = data['matchAvailability'];
            // final latestMatchAvailability = matchAvailability.last;
            // matchScheduleDate =
            //     latestMatchAvailability['date'] ?? 'Value not selected';
            // matchLocation =
            //     latestMatchAvailability['location'] ?? 'Value not selected';
            // int? timeSlot = latestMatchAvailability['timeSlot'];

            // String timeSlotText =
            //     timeSlot != null ? timeSlot.toString() : 'Value not selected';
            final matchAvailability = data['matchAvailability'];

            if (matchAvailability != null && matchAvailability.isNotEmpty) {
              final latestMatchAvailability = matchAvailability.last;
              matchScheduleDate =
                  latestMatchAvailability['date'] ?? 'Value not selected';
              matchLocation =
                  latestMatchAvailability['location'] ?? 'Value not selected';
              int? timeSlot = latestMatchAvailability['timeSlot'];

              String timeSlotText =
                  timeSlot != null ? timeSlot.toString() : 'Value not selected';
              if (timeSlotText == "1") {
                matchDayTime = "9:00-11:00";
              } else if (timeSlotText == "2") {
                matchDayTime = "11:00-13:00";
              } else if (timeSlotText == "3") {
                matchDayTime = "13:00-15:00";
              }
            } else {
              matchScheduleDate = 'Value not selected';
              matchLocation = 'Value not selected';
              // Assign a default value for timeSlot or leave it as null if needed
              int? timeSlot;
              String matchDayTime = 'Value not selected';
            }

            firstGradeMembers = data['teamComposition']?['1stGradeMembers'];
            secondGradeMembers = data['teamComposition']?['2ndGradeMembers'];
            thirdGradeMembers = data['teamComposition']?['3rdGradeMembers'];
            fourthGradeMembers = data['teamComposition']?['4thGradeMembers'];
            fifthGradeMembers = data['teamComposition']?['5thGradeMembers'];
            sixthGradeMembers = data['teamComposition']?['6thGradeMembers'];
            species = data['teamComposition']?['type'];
            // print(firstGradeMembers);

            // print(firstGradeMembers);
            if ((data['images']!).isNotEmpty &&
                (data['images']).containsKey('0')) {
              imageUrl1 = ((data['images']?['0'])) as String;
            }
            if ((data['images']!).isNotEmpty &&
                (data['images']).containsKey('1')) {
              imageUrl2 = ((data['images']?['1'])) as String;
            }
            if ((data['images']!).isNotEmpty &&
                (data['images']).containsKey('2')) {
              imageUrl3 = ((data['images']?['2'])) as String;
            }
            if ((data['images']!).isNotEmpty &&
                (data['images']).containsKey('3')) {
              imageUrl4 = ((data['images']?['3'])) as String;
            }
            if ((data['images']!).isNotEmpty &&
                (data['images']).containsKey('4')) {
              imageUrl5 = ((data['images']?['4'])) as String;
            }
            // imageUrl2 = ((data['images']?['1'])) as String;
            // imageUrl3 = ((data['images']?['2'])) as String;
            // imageUrl4 = ((data['images']?['3'])) as String;
            // imageUrl5 = ((data['images']?['4'])) as String;
          });
        }
      }
    }).catchError((e) {
      print('Error fetching team data: $e');
    });
  }

  void fetchOrigin() async {
    String uid = getCurrentUID();
    DocumentReference teamRef =
        FirebaseFirestore.instance.collection("Teams").doc(currentID);

    teamRef.get().then((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data is Map<String, dynamic>) {
          setState(() {
            String street = data['basicInfo']?['schoolAddress']?['city'] ?? '';
            String prefecture =
                data['basicInfo']?['schoolAddress']?['prefecture'] ?? '';
            String pincode =
                data['basicInfo']?['schoolAddress']?['pincode'] ?? '';

            origin = '$street, $prefecture, $pincode';
            print('$currentID');
            print('origin: $origin');
            getDistances(origin, destination);
          });
        }
      }
    }).catchError((e) {
      print('Error fetching origin: $e');
    });
  }

  Future<void> getDistances(String origin, String destination) async {
    String api = apiKey; // Replace with your Google Directions API key
    String walkingUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=walking&key=$api';
    String carUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=driving&key=$api';
    String trainUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=transit&key=$api';

    try {
      var walkingResponse = await http.get(Uri.parse(walkingUrl));
      var carResponse = await http.get(Uri.parse(carUrl));
      var trainResponse = await http.get(Uri.parse(trainUrl));

      if (walkingResponse.statusCode == 200) {
        print(walkingResponse
            .body); // Print the complete response body for debugging

        var walkingData = json.decode(walkingResponse.body);

        if (walkingData['routes'] != null && walkingData['routes'].isNotEmpty) {
          walkingDistance =
              walkingData['routes'][0]['legs'][0]['duration']['text'];
        } else {
          print('No routes found in the walking response.');
        }
      } else {
        print(
            'Walking API request failed with status code: ${walkingResponse.statusCode}');
      }

      if (carResponse.statusCode == 200) {
        print(
            carResponse.body); // Print the complete response body for debugging

        var carData = json.decode(carResponse.body);

        if (carData['routes'] != null && carData['routes'].isNotEmpty) {
          carDistance = carData['routes'][0]['legs'][0]['duration']['text'];
        } else {
          print('No routes found in the car response.');
        }
      } else {
        print(
            'Car API request failed with status code: ${carResponse.statusCode}');
      }

      if (trainResponse.statusCode == 200) {
        print(trainResponse
            .body); // Print the complete response body for debugging

        var trainData = json.decode(trainResponse.body);

        if (trainData['routes'] != null && trainData['routes'].isNotEmpty) {
          trainDistance = trainData['routes'][0]['legs'][0]['duration']['text'];
        } else {
          trainDistance = 'no trains';
        }
      } else {
        print(
            'Train API request failed with status code: ${trainResponse.statusCode}');
      }

      setState(() {
        distancesFetched = true;
      });
      // Rest of the code...
    } catch (e) {
      print('Error getting distances: $e');
    }
  }

  Widget getImageWidget(String imageUrl) {
    if (imageUrl.isEmpty) {
      // Placeholder image when imageUrl is empty
      return Image.asset('assets/dummy.jpg');
    } else {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    alignment: Alignment.center,
                    height:
                        MediaQuery.of(context).size.width * multiplier * 200,
                    width: MediaQuery.of(context).size.width * multiplier * 375,
                    color: Colors.grey,
                    child: getImageWidget(imageUrl1),
                  )
                  // : SizedBox(height: 0)
                  ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: 12,
                          left: MediaQuery.of(context).size.width *
                              multiplier *
                              8),
                      child: imageUrl2.isNotEmpty
                          ? Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.width *
                                  multiplier *
                                  45,
                              width: MediaQuery.of(context).size.width *
                                  multiplier *
                                  80,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: getImageWidget(imageUrl2),
                            )
                          : Container()),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 12,
                        left:
                            MediaQuery.of(context).size.width * multiplier * 8),
                    child: imageUrl3.isNotEmpty
                        ? Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.width *
                                multiplier *
                                45,
                            width: MediaQuery.of(context).size.width *
                                multiplier *
                                80,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: getImageWidget(imageUrl3),
                          )
                        : Container(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 12,
                        left:
                            MediaQuery.of(context).size.width * multiplier * 8),
                    child: imageUrl4.isNotEmpty
                        ? Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.width *
                                multiplier *
                                45,
                            width: MediaQuery.of(context).size.width *
                                multiplier *
                                80,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: getImageWidget(imageUrl4),
                          )
                        : Container(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 12,
                        left:
                            MediaQuery.of(context).size.width * multiplier * 8),
                    child: imageUrl5.isNotEmpty
                        ? Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.width *
                                multiplier *
                                45,
                            width: MediaQuery.of(context).size.width *
                                multiplier *
                                80,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: getImageWidget(imageUrl5),
                          )
                        : Container(),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  const SizedBox(width: 16),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8, width: 2),
                  Text(
                    online,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  basicInfoControllers[0].text,
                  style: const TextStyle(
                    // fontFamily: 'Hiragino Kaku Gothic ProN',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1.3636, // line height of 30px (22 * 1.3636)
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              !distancesFetched
                  ? Text('Loading...')
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: const Icon(Icons.directions_car),
                            ),
                            const SizedBox(width: 4),
                            Text(carDistance),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.directions_bus),
                            SizedBox(width: 4),
                            Text(trainDistance),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.directions_walk),
                            SizedBox(width: 4),
                            Text(walkingDistance),
                          ],
                        ),
                      ],
                    ),

              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context)
                          .size
                          .width, // Adjust the width to match the car icon
                      child: Text(profileScreen['distanceFromFirstHG']!),
                    ),
                  ],
                ),
              ),

              // const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: Card(
                  color: Colors.white,
                  // shape: Border.all(style: BorderStyle.solid, color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(width: 1, color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 8, right: 8, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profileScreen['trialInfo']!,
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.375, // line height of 22px (16 * 1.375)
                            letterSpacing: 0,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTrialInfo(
                                profileScreen['schedule']!, matchScheduleDate),
                            buildTrialInfo(
                                profileScreen['dayTime']!, matchDayTime),
                            buildTrialInfo(profileScreen['trialMeetingPlace']!,
                                matchLocation),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileScreen['teamComp']!,
                        style: TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.375, // line height of 22px (16 * 1.375)
                          letterSpacing: 0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child:
                            buildTrialInfo(profileScreen['Species']!, species),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildLabeledBox("1 year old : $firstGradeMembers"),
                          _buildLabeledBox("2 year old : $secondGradeMembers"),
                          _buildLabeledBox("3 year old : $thirdGradeMembers"),
                          _buildLabeledBox("4 year old : $fourthGradeMembers"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildLabeledBox("5 year old : $fifthGradeMembers"),
                          _buildLabeledBox("6 year old : $sixthGradeMembers"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileScreen['homeGroundAdd']!,
                        style: TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.375, // line height of 22px (16 * 1.375)
                          letterSpacing: 0,
                        ),
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              firstHomeControllers[2].text,
                              style: TextStyle(
                                color: Color(0xFF212121),
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                height: 15 /
                                    12, // line height = line height / font size
                                // color: const Color(0xFF424242),
                              ),
                            ),
                          ]),
                    ]),
              ),

              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  alignment: Alignment.center,
                  height: 200,
                  width: 100,
                  color: Colors.grey,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(double.parse(lat),
                          double.parse(lang)), // San Francisco, CA
                      zoom: 18,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('marker_id'),
                        position: LatLng(double.parse(lat),
                            double.parse(lang)), // San Francisco, CA
                      ),
                    },
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildTrialInfo(profileScreen['parkingAvail']!,
                        schoolAddressControllers[3].text),
                    buildTrialInfo(profileScreen['nearestStation']!,
                        schoolAddressControllers[4].text),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileScreen['oneWord']!,
                      style: TextStyle(
                        color: Color(0xFF212121),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.375, // line height of 22px (16 * 1.375)
                        letterSpacing: 0,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(
                      child: Text(
                        bioController.text,
                        maxLines: 8,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileScreen['basicInfo']!,
                        style: TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.375, // line height of 22px (16 * 1.375)
                          letterSpacing: 0,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTrialInfo(profileScreen['schoolName']!,
                              basicInfoControllers[0].text),
                          buildTrialInfo(profileScreen['repName']!,
                              basicInfoControllers[1].text),
                          buildTrialInfo(profileScreen['noOfmemb']!,
                              basicInfoControllers[2].text),
                          buildTrialInfo(
                              profileScreen['practicefreq']!, "Everyday"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 16, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileScreen['schoolAdd']!,
                        style: TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.375, // line height of 22px (16 * 1.375)
                          letterSpacing: 0,
                        ),
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              schoolAddressControllers[1].text,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ]),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTrialInfo(profileScreen['parkingAvail']!,
                              schoolAddressControllers[3].text),
                          buildTrialInfo(profileScreen['nearestStation']!,
                              schoolAddressControllers[4].text),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 80,
              )
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * 0.01,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Color(0xFF424242),
              ),
              onPressed: () {
                final FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = auth.currentUser;
                final uid = user?.uid;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            uid: uid,
                            selectedIndex: 0,
                          )),
                );
              },
            ),
          ),
        ],
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
      floatingActionButton: SizedBox(
        height: 66,
        width: 400,
        child: (widget.buttonpressed == 0 && widget.which_page == 0)
            ? Button(
                inside_opponent_profile: 1,
                which_page: 0,
                oid: widget.oid,
                index: widget.index,
                data: widget.data,
                info: widget.info,
                mode: widget.mode)
            : (widget.buttonpressed == 0 && widget.which_page == 1)
                ? AdmitButton(
                    inside_opponent_profile: 1,
                    whichPage: widget.which_page,
                    oid: widget.oid,
                    index: widget.index,
                    data: widget.data,
                    info: widget.info)
                : (widget.buttonpressed == 0 && widget.which_page == 2)
                    ? CancelApplication(
                        inside_opponent_profile: 1,
                        whichPage: 2,
                        oid: widget.oid,
                        index: widget.index,
                        data: widget.data,
                        info: widget.info)
                    : const SizedBox(),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  Widget buildTrialInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft, // Align the value to the right
              child: Text(
                label,
                style: const TextStyle(
                  // fontFamily: 'Hiragino Kaku Gothic ProN',
                  fontSize: 12,
                  height: 15 / 12, // line height = line height / font size
                  letterSpacing: 0,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight, // Align the value to the right
              child: Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  height: 15 / 12, // line height = line height / font size
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledBox(String label) {
    return Container(
      width: 74,
      height: 24,
      margin: const EdgeInsets.only(top: 0, right: 16, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1.0,
          color: Colors.grey[500]!,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF757575),
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

List<dynamic> sortMatchCardsBasedOnCondition(
    List<dynamic> cardList, int sortCondition) {
  List<dynamic> cardDataSorted = [];
  List<String> sortingPurposeStringList = [];

  if (sortCondition == 1) {
    for (int i = 0; i < cardList.length; i++) {
      //Recent Match
      String cardDate = giveYearAndMonth(cardList[i]["date"]);
      String timeSlot = (cardList[i]["timeSlot"]).toString();
      String identifier = i.toString();
      String sortString = "$cardDate-$timeSlot-$identifier";

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
  } else if (sortCondition == 2) {
    //Stronger Opponent at top

    for (int i = 0; i < cardList.length; i++) {
      String teamLevel = (cardList[i]["teamLevel"]).toString();
      String identifier = i.toString();

      String sortString = "$teamLevel-$identifier";
      sortingPurposeStringList.add(sortString);
    }
    sortingPurposeStringList.sort((a, b) => a.compareTo(b));

    for (int i = 0; i < sortingPurposeStringList.length; i++) {
      String ind =
          (sortingPurposeStringList[i])[sortingPurposeStringList[i].length - 1];
      int index = int.parse(ind);
      cardDataSorted.add(cardList[index]);
    }
    cardDataSorted = cardDataSorted.reversed.toList();

    return cardDataSorted;
  } else if (sortCondition == 3) {
    //Weaker Opponent at top

    for (int i = 0; i < cardList.length; i++) {
      String teamLevel = (cardList[i]["teamLevel"]).toString();
      String identifier = i.toString();

      String sortString = "$teamLevel-$identifier";
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
  } else if (sortCondition == 4) {
    // TODO Sorting based on minimum travel time by car
    return cardList;
  } else if (sortCondition == 5) {
    // TODO Sorting based on minimum travel time by train
    return cardList;
  } else {
    return cardList;
  }
}

void updateSortActionInFireBase(int sortCondition) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('Teams').doc(uid);
  // changing the user established matched

  FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot snapshot = await transaction.get(documentReference);
    if (!snapshot.exists) {
      throw Exception("User does not exist!");
    }

    // print(widget.data['matchApplied']);

    transaction.update(documentReference, {'sortAction': sortCondition});
  });
}
