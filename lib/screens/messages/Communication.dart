import 'dart:async';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import '../../reusable_widgets/reusable_widgets.dart';
import 'message.dart';

class Communication extends StatefulWidget {
  const Communication({Key? key}) : super(key: key);

  @override
  State<Communication> createState() => _CommunicationState();
}

class _CommunicationState extends State<Communication> {
  @override
  Widget build(BuildContext context) {
    List<Message_info> list_message_block = [];
    Stream<List<Message_info>> DataFromFirebase() {
      final streamController = StreamController<List<Message_info>>.broadcast();

      Map<String, dynamic> data;
      User? us = FirebaseAuth.instance.currentUser;

      final docRef = FirebaseFirestore.instance.collection("Teams").doc(us?.uid);

      docRef.snapshots().listen((DocumentSnapshot doc) async {
        data = doc.data() as Map<String, dynamic>;
        String? mys = us?.uid;
        List<Future> futures = [];

        for (Map<String, dynamic> i in data["matchScheduled"]) {
          String r = "";
          String ig="";
          String uni="";
          String tim = "";
          String msg = "";
          String team="";
          int unseen = 0;

          team = i["opponentUID"];


          int result = team.compareTo(mys!);

          if (result < 0) {
            r = "$team@$mys";
          } else {
            r = "$mys@$team";
          }

          futures.add(
              FirebaseFirestore.instance.collection("ChatRooms")
                  .doc(r)
                  .collection("Chats")
                  .orderBy("time")
                  .get()
                  .then((dcs) {
                for (var docSnapshot in dcs.docs) {
                  Timestamp time = docSnapshot["time"];
                  String p = time.toDate().toString();
                  tim = p;

                  msg = docSnapshot["message"];
                }
              })
          );

          futures.add(
              FirebaseFirestore.instance.collection("ChatRooms")
                  .doc(r)
                  .collection("Chats")
                  .where('status', isEqualTo: false)
                  .where('from', isEqualTo: team)
                  .get()
                  .then((querySnapshot) {

                unseen = querySnapshot.docs.length;
              })
          );
          futures.add(
              FirebaseFirestore.instance.collection("Teams").doc(team).get().then((DocumentSnapshot dox) {
                Map<String, dynamic> dat = dox.data() as Map<String, dynamic>;
               uni = dat["basicInfo"]["schoolName"];

                // if ((dat['images']!).isNotEmpty &&
                //     (dat['images']).containsKey('0')) {
                //   ig = ((dat['images']?['0'])) as String;
                // }
                // else{
                //   ig="";
                // }
                if ((dat['images']!).isNotEmpty &&
                    (dat['images']).containsKey('0')) {
                  ig = ((dat['images']?['0'])) as String;
                }
                else{
                  ig="";
                }


               // print(ig);
                // ig=dat["images"][0];
                // print(ig);
                // ig="";
                // print("hello");
// ig="https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aHVtYW58ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60";


              })
          );


          Future.wait(futures).then((_) {

print("hi2");
            list_message_block.add(Message_info(
              university_name: uni,
              last_message_time: tim,
              last_message: msg,
              number_of_unseen_message: unseen.toString(),
              room: r,
              imgstr: ig,
            ));

            streamController.add(list_message_block);

          });
        }

      }, onError: (e) => print("Error getting document: $e"));

      return streamController.stream;
    }

    // Stream<List<Message_info>> message_block = DataFromFirebase();

    return Scaffold(
body: StreamBuilder<List<Message_info>>(
  stream: DataFromFirebase(),
  builder: (BuildContext context, AsyncSnapshot<List<Message_info>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return

        // const Column(
        //     mainAxisAlignment:MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children:[ Center(
        //         child: CustomLogoWidget(imagePath: "assets/images/ri_message-2-fill.png",
        //             text: "ここに試合が成立した相手との\nやりとりが表示されます。",)
        //     )
        //     ]
        // );
      const CircularProgressIndicator();

    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      List<Message_info> data = snapshot.data ?? [];
      if(data.isEmpty){
        return
          Column(
              mainAxisAlignment:MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:const [ Center(
                  child: CustomLogoWidget(imagePath: "assets/images/ri_message-2-fill.png",
                      text: "ここに試合が成立した相手との\nやりとりが表示されます。")
              )
              ]
          );
      }
      else{
        return Column(
          children: [
            for (int i = 0; i < data.length; i++)
              Message_block(
                  data[i].university_name,
                  data[i].last_message_time,
                  data[i].last_message,
                  data[i].number_of_unseen_message,
                  context,
                  data[i].room,
                  data[i].imgstr
              ),
          ],
        );
      }}
  },
),

    );
  }
}
