import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  final String name;
  final String room;
  const Chat({super.key, required this.name, required this.room});


  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  String xx= "auth_id_1@auth_id_2";


  @override
  Widget build(BuildContext context) {


    Stream<List<MessageTile>> msgsStream() {
      User? us = FirebaseAuth.instance.currentUser;

      return FirebaseFirestore.instance
          .collection("ChatRooms")
          .doc(widget.room)
          .collection("Chats")
          .orderBy("time")
          .snapshots()
          .map((querySnapshot) {
        List<MessageTile> lsst = [];
        for (var docSnapshot in querySnapshot.docs) {
          Timestamp time = docSnapshot["time"];
          String p=time.toDate().toString();
          bool sbm = false;
          if (docSnapshot["from"] == us?.uid) {
            sbm = true;
          }
if(docSnapshot['status']==false && sbm==false){
  FirebaseFirestore.instance.collection("ChatRooms").doc(widget.room).collection("Chats").doc(docSnapshot.id).set({
    'status':true
  },SetOptions(merge: true),

  );
}

          lsst.add(
            MessageTile(
              message: docSnapshot["message"],
              sendByMe: sbm,
              time: p,
            ),
          );
        }
        return lsst;
      });
    }


    final myController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        // elevation: 0,
        title:  Text(
          widget.name,
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                StreamBuilder<List<MessageTile>>(
                  stream: msgsStream(),
                  builder: (BuildContext context, AsyncSnapshot<List<MessageTile>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<MessageTile> data = snapshot.data ?? [];
                      return Column(
                        children: [
                          for (int i = 0; i < data.length; i++)
                            MessageTile(
                              message: data[i].message,
                              sendByMe: data[i].sendByMe,
                              time: data[i].time,
                            ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // IconButton(
                //   icon: const Icon(Icons.photo),
                //   onPressed: () {
                //
                //   },
                // ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: TextFormField(
                      controller: myController,
                      decoration: const InputDecoration(
                        hintText: 'You type a message',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        border: InputBorder.none,
                      ),
                      // Add functionality for text field here
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    User? us=FirebaseAuth.instance.currentUser;

                   FirebaseFirestore.instance.collection("ChatRooms").doc(widget.room).collection("Chats").doc().set({
                     'from': us?.uid,
                     'message':  myController.text,
                     'time':DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch),
                     'status':false
                   });
                myController.clear();

                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String time;

  MessageTile({
    required this.message,
    required this.sendByMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: sendByMe ? 0 : 24,
        right: sendByMe ? 24 : 0,
      ),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: sendByMe
                ? const EdgeInsets.only(left: 30)
                : const EdgeInsets.only(right: 30),
            padding: const EdgeInsets.only(
              top: 17,
              bottom: 17,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: sendByMe
                  ? const BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23),
              )
                  : const BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23),
              ),
              gradient: LinearGradient(
                colors: sendByMe
                    ? [
                  const Color.fromRGBO(17, 86, 149, 1),
                  const Color.fromRGBO(17, 86, 149, 1),
                ]
                    : [
                  Colors.black54,
                  Colors.black54,
                ],
              ),
            ),
            child: Text(
              message,
              textAlign: sendByMe ? TextAlign.end : TextAlign.start,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                // fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            margin: sendByMe
                ? const EdgeInsets.only(right: 16)
                : const EdgeInsets.only(left: 16),
            child: Text(
              time,
              style: const TextStyle(
                color: Colors.black38,
                fontSize: 12,
                // fontFamily: 'OverpassRegular',

              ),
            ),
          ),
        ],
      ),
    );
  }
}
