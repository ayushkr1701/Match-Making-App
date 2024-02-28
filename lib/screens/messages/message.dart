// ignore_for_file: unused_import

import 'dart:async';

import 'package:ai_match_making_app/screens/messages/Communication.dart';
import 'package:ai_match_making_app/screens/messages/chat.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../reusable_widgets/reusable_widgets.dart';
import '../match/match_making.dart';



class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {


  @override
  Widget build(BuildContext context) {

    // Stream<List<Message_info>> list_message_block = DataFromFirebase().asBroadcastStream();


    CollectionReference _cardData = FirebaseFirestore.instance.collection('Teams');
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    return WillPopScope(
      onWillPop: () async {
        // Disable back button functionality
        return false;
      },


    child: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            tabs: [
              Tab(
                text: message['establishedMatch']!,
              ),
              Tab(
                text: message['communication']!,
              ),
            ],

          ),
          title: Text(
            message['title']!,
            style: TextStyle(
                fontSize: 24, color: Colors.black),
          ),


        ),


        body: TabBarView(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: _cardData.doc(uid).snapshots(),

              builder:
                  (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                if (snapshot.hasError) {
                  return Text(somethingWrong);
                }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                else{
                  Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

                  List<dynamic> scheduledCardsInfo;
                  scheduledCardsInfo = data["matchScheduled"];

                  if(scheduledCardsInfo.isEmpty){
                    return  Center(
                      child: CustomLogoWidget(
                        imagePath: "assets/images/message.png",
                        text: message['communicationSubtitle']!,
                      ),
                    );
                  }
                  // print(Match_making_cards_info);
                  // return Text("Full Name: ${data['full_name']} ${data['last_name']}");
                  else {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: Card(
                          child: Column(
                            children: [
                              for(int i = 0; i <
                                  scheduledCardsInfo.length; i++)...[

                                StreamBuilder<DocumentSnapshot>(
                                  stream: _cardData.doc(
                                      scheduledCardsInfo[i]['opponentUID'])
                                      .snapshots(),
                                  builder:
                                      (BuildContext context, AsyncSnapshot<
                                      DocumentSnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return Text(somethingWrong);
                                    }

                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const Center(child: CircularProgressIndicator());
                                        }

                                   else {
                                      Map<String, dynamic> info = snapshot.data!
                                          .data() as Map<String, dynamic>;

                                      String time;
                                      if (scheduledCardsInfo[i]['timeSlot'] ==
                                          1) {
                                        time = '9:00-11:00';
                                      }
                                      else
                                      if (scheduledCardsInfo[i]['timeSlot'] ==
                                          2) {
                                        time = '11:00-13:00';
                                      }
                                      else {
                                        time = '13:00-15:00';
                                      }
                                      return GestureDetector(
                                        onTap: () {

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => OpponentProfile(
                                                      which_page: 3,
                                                      buttonpressed: 0,
                                                      oid: scheduledCardsInfo[i]['opponentUID'],
                                                      data: data,index: i,info: info,
                                                      mode: 'Automatic')));


                                        },
                                        child: Card(
                                          shape: const RoundedRectangleBorder(
                                              // side: BorderSide(
                                              //   color: Colors.black,
                                              // )
                                          ),
                                          child: Column(
                                            children: [
                                              head_scheduled_match_card(
                                                  dateOfGame: scheduledCardsInfo[i]['date'] ,
                                                  timeOfMatch: time,
                                                  weather: 1),
                                              middle_scheduled_match_card(
                                                  universityName: info['basicInfo']['schoolName'],
                                                  address: "${info['basicInfo']['schoolAddress']['street']} , ${info['basicInfo']['schoolAddress']['city']} , ${info['basicInfo']['schoolAddress']['pincode']} "),
                                              distance(carDistance: scheduledCardsInfo[i]['distanceByCar'] ?? '',
                                                  trainDistance: scheduledCardsInfo[i]['distanceByTrain'] ?? '',
                                                  walkDistance: scheduledCardsInfo[i]['distanceByWalk'] ?? ''),
                                            imageAndScore(
                                                win: info['basicInfo']['win'] != null ? info['basicInfo']['win'] : 0,
                                                loss: info['basicInfo']['loss'] != null ? info['basicInfo']['loss'] : 0,
                                                point: info['basicInfo']['draw'] != null ? info['basicInfo']['draw'] : 0,
                                                imageUrl: info['images'].length != 0 ? info['images']['0'] : ''
                                                ),
                                              // const Button(),
                                              Padding(
                                                padding:
                                                const EdgeInsets.fromLTRB(
                                                    60, 0, 60, 5),
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: Card(
                                                    color: Colors.blue[900],
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          45, 15, 45, 15),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              Text(
                                                                message['sendMessage']!,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 16),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    return const Text("");
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

                return const Center(child: CircularProgressIndicator());
              },
            ),

            Communication(),

            // OutgoingPage(),
          ],
        ),

      ),
    ),
    );
  }
}


class Message_info extends StatefulWidget {
  const Message_info({Key? key, required this.university_name, required this.last_message_time, required this.last_message, required this.number_of_unseen_message,  required this.room, required this.imgstr}) : super(key: key);
  final String university_name;
  final String last_message_time;
  final String last_message;
  final String number_of_unseen_message;
  final String room;
  final String imgstr;
  @override
  State<Message_info> createState() => _Message_infoState();
}

class _Message_infoState extends State<Message_info> {
  @override
  Widget build(BuildContext context) {
    return Message_block(widget.university_name, widget.last_message_time, widget.last_message, widget.number_of_unseen_message, context, widget.room, widget.imgstr);
  }
}

Widget Message_block(String universityName, String lastMessageTime,
    String lastMessage, String numberOfUnseenMessage, BuildContext context, String room, String imgstr) {
  String textReq = "";
  int tt = 40;
  if(lastMessage.length<40) tt = lastMessage.length;
  for(int i =0;i<tt;i++)
    textReq += lastMessage[i];
  lastMessage = textReq;
// print("hi");
// print(imgstr);

  return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
      onTap: () {
        Navigator.push(context,MaterialPageRoute(builder: (context) => Chat(name: universityName, room: room,)));

      },

    child: Card(

    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,

            child: getImageWidget(imgstr),

            // Image.network(
            //   imgstr,
            //   // fit: BoxFit.cover,
            //   errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            //     return Image.asset('dummy2.png');
            //   },
            // ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              flex: 5,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          universityName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          lastMessageTime,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(lastMessage,),



                      if(numberOfUnseenMessage!="0")
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.black,
                          child: Text(numberOfUnseenMessage,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white),),
                        ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    ),
  ),
  ),
  );
}

Widget getImageWidget(String imageUrl) {
  if (imageUrl.isEmpty || imageUrl == '') {
    // Placeholder image when imageUrl is empty
    return Image.asset('assets/dummy2.png');
  } else {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
    );
  }
}

