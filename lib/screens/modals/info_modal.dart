import 'package:ai_match_making_app/screens/profile/util_classes.dart';
import 'package:ai_match_making_app/utils/constants.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_match_making_app/screens/match/match_making.dart';

import '../../reusable_widgets/reusable_widgets.dart';
import '../Base/home_screen.dart';

class PopUps extends StatefulWidget {
  final int which_page;
  final String oid;
  final int index;
  final int inside_opponent_profile;
  final Map<String, dynamic> data;
  final Map<String, dynamic> info;
  final Widget popUpWidget;
  final String btnText;
  const PopUps(
      {super.key,
      required this.which_page,
      required this.inside_opponent_profile,
      required this.oid,
      required this.index,
      required this.data,
      required this.info,
      required this.popUpWidget,
      required this.btnText});

  @override
  PopUpsBuilder createState() => PopUpsBuilder();
}

void action_for_request(String oid, int index, Map<String, dynamic> data,
    Map<String, dynamic> info) {
  Map<String, dynamic> need_to_add_in_request = data['matchCard'][index];
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('Teams').doc(uid);
  // Changing the users data
  FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot snapshot = await transaction.get(documentReference);
    if (!snapshot.exists) {
      throw Exception("User does not exist!");
    }
    print(data['matchApplied']);
    print(data['matchApplied'].length);

    List<dynamic> applied = data['matchApplied'];
    Map<String, dynamic> inserting_applied = {
      "opponentUID": data['matchCard'][index]['opponentUID'],
      "timeSlot": data['matchCard'][index]['timeSlot'],
      "date": data['matchCard'][index]['date'],
      "distanceByCar": data['matchCard'][index]['distanceByCar'],
      "distanceByTrain": data['matchCard'][index]['distanceByTrain'],
      "distanceByWalk": data['matchCard'][index]['distanceByWalk'],
      "matchingSetting": data['matchCard'][index]['matchingSetting'],
      "teamLevel": data['basicInfo']['teamLevel'],
      "location": data['matchCard'][index]['location'],
    };
    applied.add(inserting_applied);
    print(applied);
    transaction.update(documentReference, {'matchApplied': applied});
    List<dynamic> match_card = [];
    for (int j = 0; j < data['matchCard'].length; j++) {
      if (j != index) {
        match_card.add(data['matchCard'][j]);
      }
    }
    transaction.update(documentReference, {'matchCard': match_card});
  });

  //changing the opponents data
  DocumentReference opp_documentReference =
      FirebaseFirestore.instance.collection('Teams').doc(oid);
  FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot opp_snapshot =
        await transaction.get(opp_documentReference);
    if (!opp_snapshot.exists) {
      throw Exception("User does not exist!");
    }
    print(info['matchRequests']);
    List<dynamic> request = info['matchRequests'];
    Map<String, dynamic> adding_request = {
      "date": need_to_add_in_request['date'],
      "timeSlot": need_to_add_in_request['timeSlot'],
      "distanceByCar": need_to_add_in_request['distanceByCar'],
      "distanceByTrain": need_to_add_in_request['distanceByTrain'],
      "matchingSetting": need_to_add_in_request['matchingSetting'],
      "opponentUID": uid,
      "teamLevel": need_to_add_in_request['teamLevel'],
      "location": need_to_add_in_request['location'],
    };
    request.add(adding_request);
    transaction.update(opp_documentReference, {'matchRequests': request});
  });
}

class PopUpsBuilder extends State<PopUps> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          final FirebaseAuth auth = FirebaseAuth.instance;
          final User? user = auth.currentUser;
          final uid = user?.uid;

          if (widget.btnText == '申し込む'
          // 'Request'
          ) {
            print("request");

            String time;
            if (widget.data['matchCard'][widget.index]['timeSlot'] == 1) {
              time = '9:00-11:00';
            } else if (widget.data['matchCard'][widget.index]['timeSlot'] ==
                2) {
              time = '11:00-13:00';
            } else {
              time = '13:00-15:00';
            }
            String imageUrl = widget.info.containsKey('images') && widget.info['images'].length != 0
    ? widget.info['images']['0']
    : '';

            String matchSetting =
                widget.data['matchCard'][widget.index]['matchingSetting'];
            print("above show dialog");
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Stack(
                  children: <Widget>[
                    const Opacity(
                      opacity: 0.4, // set the opacity level for the background
                      child:
                          ModalBarrier(dismissible: false, color: Colors.black),
                    ),
                    Dialog(
                        child: SizedBox(
                      width: 300,
                      height: 400,
                      // color: Colors.blue,
                      child: Card(
                        child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: FittedBox(
                                  alignment: Alignment.center,
                                  child: Container(
                                      padding: const EdgeInsets.all(8),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  17, 86, 149, 1),
                                              width: 2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Text(
                                        "${widget.data['matchCard'][widget.index]['date']}" +
                                            ", " +
                                            "${time}",
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(17, 86, 149, 1)),
                                      )),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: Center(
                                  child: SizedBox(
                                    width: 300,
                                    height: 55,
                                    child: Text(
                                      // "With ${widget.info['basicInfo']['schoolName']}\n Do you want to apply for a game?",
                                      "${widget.info['basicInfo']['schoolName']}へ\n試合を申し込みますか？",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 0),
                                height: 155.0,
                                width: 155.0,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  // color: Colors.grey[800],
                                ),
                                child: imageUrl == ''
                                    ? Image.asset(
                                        'assets/dummy.jpg',
                                        width: 155.0,
                                        height: 155.0,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.network(
                                        imageUrl,
                                        width: 155.0,
                                        height: 155.0,
                                        fit: BoxFit.contain,
                                      ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 0),
                                child: SizedBox(
                                    height: 44,
                                    width: 215,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Stack(
                                              children: <Widget>[
                                                const Opacity(
                                                  opacity:
                                                      0.4, // set the opacity level for the background
                                                  child: ModalBarrier(
                                                      dismissible: false,
                                                      color: Colors.black),
                                                ),
                                                Dialog(
                                                    child: SizedBox(
                                                  width: 300,
                                                  height: 400,
                                                  // color: Colors.blue,
                                                  child: Card(
                                                    child: Column(
                                                        // mainAxisAlignment: MainAxisAlignment.center
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 16),
                                                            child: FittedBox(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Container(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                          8),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color: const Color.fromRGBO(
                                                                              17,
                                                                              86,
                                                                              149,
                                                                              1),
                                                                          width:
                                                                              2),
                                                                      borderRadius: const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              5))),
                                                                  child: Text(
                                                                    "${widget.data['matchCard'][widget.index]['date']}" +
                                                                        ", " +
                                                                        "${time}",
                                                                    style: const TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            17,
                                                                            86,
                                                                            149,
                                                                            1)),
                                                                  )),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 16),
                                                            child: Center(
                                                              child: SizedBox(
                                                                width: 300,
                                                                height: 55,
                                                                child: Text(
                                                                  // "With ${widget.info['basicInfo']['schoolName']}\n The registration for game is done",
                                                                  "${widget.info['basicInfo']['schoolName']}へ\n試合の申し込みが完了しました！",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0),
                                                            height: 75.0,
                                                            width: 75.0,
                                                            decoration:
                                                                const BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              5)),
                                                              // color: Colors.grey[800],
                                                            ),
                                                            child: Container(
                                                              width: 20.0,
                                                              height: 20.0,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/images/checkmark.png"),
                                                                    scale: 2,
                                                                    fit: BoxFit
                                                                        .contain),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 0),
                                                              child: SizedBox(
                                                                height: 78,
                                                                width: 300,
                                                                child: Text(
                                                                  // "When ${widget.info['basicInfo']['schoolName']} presses " +
                                                                  //     "the approval button." +
                                                                  //     "\n It is the establishment of the game." +
                                                                  //     "\n Just a moment, please.",
                                                                  "${widget.info['basicInfo']['schoolName']}が承認ボタンを押すと\n試合の成立です。\n今しばらくお待ちください。",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              )),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0),
                                                            child: SizedBox(
                                                                height: 44,
                                                                width: 215,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    foregroundColor:
                                                                        Colors
                                                                            .white,
                                                                    backgroundColor:
                                                                        const Color.fromRGBO(
                                                                            17,
                                                                            86,
                                                                            149,
                                                                            1),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    // "See the application list",
                                                                    "申し込み一覧を見る",
                                                                  ),
                                                                )),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 16),
                                                            child: SizedBox(
                                                                height: 44,
                                                                width: 215,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    // print("here");
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();

                                                                    if (widget
                                                                            .inside_opponent_profile ==
                                                                        1) {
                                                                      print(
                                                                          "inside this");
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => OpponentProfile(which_page: 5, buttonpressed: 1, oid: widget.oid, data: widget.data, index: widget.index, info: widget.info, mode: matchSetting)));
                                                                      final snackBar =
                                                                          const SnackBar(
                                                                        content:
                                                                            Text(
                                                                              // 'Match has been requested'
                                                                              'マッチングがリクエストされました'
                                                                              ),
                                                                        duration:
                                                                            Duration(seconds: 3),
                                                                      );
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              snackBar);
                                                                    }
                                                                    print(
                                                                        "outside this");
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    foregroundColor:
                                                                        const Color.fromRGBO(
                                                                            17,
                                                                            86,
                                                                            149,
                                                                            1),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                  child: const Text(
                                                                      // "Close"
                                                                      "閉じる"
                                                                      ),
                                                                )),
                                                          )
                                                        ]),
                                                  ),
                                                )),
                                              ],
                                            );
                                          },
                                        );
                                        action_for_request(
                                            widget.oid,
                                            widget.index,
                                            widget.data,
                                            widget.info);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color.fromRGBO(
                                            17, 86, 149, 1),
                                      ),
                                      child: const Text(
                                        // "Make an application",
                                        "申し込みをする"
                                      ),
                                    )),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: SizedBox(
                                    height: 44,
                                    width: 215,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // print("here");
                                        Navigator.of(context).pop();

                                        if (widget.inside_opponent_profile ==
                                            1) {
                                          print("inside this");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OpponentProfile(
                                                          which_page: 5,
                                                          buttonpressed: 1,
                                                          oid: widget.oid,
                                                          data: widget.data,
                                                          index: widget.index,
                                                          info: widget.info,
                                                          mode: matchSetting)));
                                        }
                                        print("outside this");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: const Color.fromRGBO(
                                            17, 86, 149, 1),
                                        backgroundColor: Colors.white,
                                      ),
                                      child: const Text(
                                        // "Cancel."
                                        "キャンセル"
                                        ),
                                    )),
                              )
                            ]),
                      ),
                    )),
                  ],
                );
              },
            );
          }

          if (widget.btnText == '承認'
          // 'Admit'
          ) {
            String time;
            String matchSetting;
            String datetime;
            if (widget.which_page == 0) {
              if (widget.data['matchCard'][widget.index]['timeSlot'] == 1) {
                time = '9:00-11:00';
              } else if (widget.data['matchCard'][widget.index]['timeSlot'] ==
                  2) {
                time = '11:00-13:00';
              } else {
                time = '13:00-15:00';
              }
              datetime = "${widget.data['matchCard'][widget.index]['date']}" +
                  ", " +
                  "${time}";
              matchSetting =
                  widget.data['matchCard'][widget.index]['matchingSetting'];
            } else {
              if (widget.data['matchRequests'][widget.index]['timeSlot'] == 1) {
                time = '9:00-11:00';
              } else if (widget.data['matchRequests'][widget.index]
                      ['timeSlot'] ==
                  2) {
                time = '11:00-13:00';
              } else {
                time = '13:00-15:00';
              }
              matchSetting =
                  widget.data['matchRequests'][widget.index]['matchingSetting'];
              datetime =
                  "${widget.data['matchRequests'][widget.index]['date']}" +
                      ", " +
                      "${time}";
            }

            String imageUrl = widget.info.containsKey('images') && widget.info['images'].length != 0
    ? widget.info['images']['0']
    : '';


            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Stack(
                  children: <Widget>[
                    const Opacity(
                      opacity: 0.4, // set the opacity level for the background
                      child:
                          ModalBarrier(dismissible: false, color: Colors.black),
                    ),
                    Dialog(
                        child: SizedBox(
                      width: 300,
                      height: 400,
                      // color: Colors.blue,
                      child: Card(
                        child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: FittedBox(
                                  alignment: Alignment.center,
                                  child: Container(
                                      padding: const EdgeInsets.all(8),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  17, 86, 149, 1),
                                              width: 2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Text(
                                        datetime,
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(17, 86, 149, 1)),
                                      )),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: Center(
                                  child: SizedBox(
                                    width: 300,
                                    height: 55,
                                    child: Text(
                                      // "With ${widget.info['basicInfo']['schoolName']}\n Do you approve the game?",
                                      "${widget.info['basicInfo']['schoolName']}との\n試合を承認しますか？",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 0),
                                height: 155.0,
                                width: 155.0,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  // color: Colors.grey[800],
                                ),
                                child: imageUrl == ''
                                    ? Image.asset(
                                        'assets/dummy.jpg',
                                        width: 155.0,
                                        height: 155.0,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.network(
                                        imageUrl,
                                        width: 155.0,
                                        height: 155.0,
                                        fit: BoxFit.contain,
                                      ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 0),
                                child: SizedBox(
                                    height: 44,
                                    width: 215,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Stack(
                                              children: <Widget>[
                                                const Opacity(
                                                  opacity:
                                                      0.4, // set the opacity level for the background
                                                  child: ModalBarrier(
                                                      dismissible: false,
                                                      color: Colors.black),
                                                ),
                                                Dialog(
                                                    child: SizedBox(
                                                  width: 300,
                                                  height: 400,
                                                  // color: Colors.blue,
                                                  child: Card(
                                                    child: Column(
                                                        // mainAxisAlignment: MainAxisAlignment.center
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 16),
                                                            child: FittedBox(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Container(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                          8),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color: const Color.fromRGBO(
                                                                              17,
                                                                              86,
                                                                              149,
                                                                              1),
                                                                          width:
                                                                              2),
                                                                      borderRadius: const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              5))),
                                                                  child: Text(
                                                                    datetime,
                                                                    style: const TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            17,
                                                                            86,
                                                                            149,
                                                                            1)),
                                                                  )),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 16),
                                                            child: Center(
                                                              child: SizedBox(
                                                                width: 300,
                                                                height: 55,
                                                                child: Text(
                                                                  // "With ${widget.info['basicInfo']['schoolName']}\n The game is over",
                                                                  "${widget.info['basicInfo']['schoolName']}との\n試合が成立しました！",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0),
                                                            height: 75.0,
                                                            width: 75.0,
                                                            decoration:
                                                                const BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              5)),
                                                              // color: Colors.grey[800],
                                                            ),
                                                            child: Container(
                                                              width: 20.0,
                                                              height: 20.0,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/images/smile.png"),
                                                                    scale: 2,
                                                                    fit: BoxFit
                                                                        .contain),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 0),
                                                              child:
                                                                  const SizedBox(
                                                                height: 78,
                                                                width: 300,
                                                                child: Text(
                                                                  // "I'll send you a message\n Let's say hello",
                                                                  "早速メッセージで\n挨拶してみましょう！",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              )),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0),
                                                            child: SizedBox(
                                                                height: 44,
                                                                width: 215,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    foregroundColor:
                                                                        Colors
                                                                            .white,
                                                                    backgroundColor:
                                                                        const Color.fromRGBO(
                                                                            17,
                                                                            86,
                                                                            149,
                                                                            1),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    // "Send a message",
                                                                    "メッセージを送る"
                                                                  ),
                                                                )),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 16),
                                                            child: SizedBox(
                                                                height: 44,
                                                                width: 215,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    // print("here");
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();

                                                                    if (widget
                                                                            .inside_opponent_profile ==
                                                                        1) {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => OpponentProfile(which_page: 5, buttonpressed: 1, oid: widget.oid, data: widget.data, index: widget.index, info: widget.info, mode: matchSetting)));
                                                                      final snackBar =
                                                                          const SnackBar(
                                                                        content:
                                                                            Text(
                                                                              // 'Match has been approved/ admitted'
                                                                              "試合は承認/許可されました"
                                                                              ),
                                                                        duration:
                                                                            Duration(seconds: 3),
                                                                      );
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              snackBar);
                                                                    }
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    foregroundColor:
                                                                        const Color.fromRGBO(
                                                                            17,
                                                                            86,
                                                                            149,
                                                                            1),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                  child: const Text(
                                                                      // "Close."
                                                                      "閉じる"
                                                                      ),
                                                                )),
                                                          )
                                                        ]),
                                                  ),
                                                )),
                                              ],
                                            );
                                          },
                                        );
                                        if (widget.which_page == 0) {
                                          DocumentReference documentReference =
                                              FirebaseFirestore.instance
                                                  .collection('Teams')
                                                  .doc(uid);
                                          // changing the user established matched
                                          FirebaseFirestore.instance
                                              .runTransaction(
                                                  (transaction) async {
                                            DocumentSnapshot snapshot =
                                                await transaction
                                                    .get(documentReference);
                                            if (!snapshot.exists) {
                                              throw Exception(
                                                  "User does not exist!");
                                            }

                                            // print(widget.data['matchApplied']);
                                            List<dynamic> scheduled =
                                                widget.data['matchScheduled'];

                                            Map<String, dynamic> input = {
                                              "opponentUID": widget
                                                      .data['matchCard']
                                                  [widget.index]['opponentUID'],
                                              "date": widget.data['matchCard']
                                                  [widget.index]['date'],
                                              "timeSlot": widget
                                                      .data['matchCard']
                                                  [widget.index]['timeSlot'],
                                                  "distanceByCar": widget.data['matchCard'][widget.index]['distanceByCar'],
      "distanceByTrain": widget.data['matchCard'][widget.index]['distanceByTrain'],
      "distanceByWalk": widget.data['matchCard'][widget.index]['distanceByWalk'],
      "matchingSetting": widget.data['matchCard'][widget.index]['matchingSetting'],
      "teamLevel": widget.data['basicInfo']['teamLevel'],
                                              "location":
                                                  widget.data['matchCard']
                                                      [widget.index]['location']
                                            };
                                            scheduled.add(input);
                                            print(scheduled);
                                            // print(applied);
                                            transaction.update(
                                                documentReference,
                                                {'matchScheduled': scheduled});
                                            List<dynamic> match_card = [];
                                            for (int j = 0;
                                                j <
                                                    widget.data['matchCard']
                                                        .length;
                                                j++) {
                                              if (j != widget.index) {
                                                match_card.add(widget
                                                    .data['matchCard'][j]);
                                              }
                                            }
                                            transaction.update(
                                                documentReference,
                                                {'matchCard': match_card});
                                          });

                                          //changing the opponent established matches
                                          DocumentReference
                                              opp_documentReference =
                                              FirebaseFirestore.instance
                                                  .collection('Teams')
                                                  .doc(widget.oid);

                                          FirebaseFirestore.instance
                                              .runTransaction(
                                                  (transaction) async {
                                            DocumentSnapshot opp_snapshot =
                                                await transaction
                                                    .get(opp_documentReference);
                                            if (!opp_snapshot.exists) {
                                              throw Exception(
                                                  "User does not exist!");
                                            }

                                            // print(widget.data['matchApplied']);
                                            List<dynamic> opp_scheduled =
                                                widget.info['matchScheduled'];

                                            Map<String, dynamic> opp_input = {
                                              "opponentUID": uid,
                                              "date": widget.data['matchCard']
                                                  [widget.index]['date'],
                                              "timeSlot": widget
                                                      .data['matchCard']
                                                  [widget.index]['timeSlot'],
                                              "location":
                                                  widget.data['matchCard']
                                                      [widget.index]['location']
                                            };
                                            opp_scheduled.add(opp_input);
                                            print(opp_scheduled);
                                            // print(applied);
                                            transaction.update(
                                                opp_documentReference, {
                                              'matchScheduled': opp_scheduled
                                            });
                                          });
                                        } else {
                                          print("doing this");
                                          DocumentReference documentReference =
                                              FirebaseFirestore.instance
                                                  .collection('Teams')
                                                  .doc(uid);
                                          // changing the user established matched
                                          FirebaseFirestore.instance
                                              .runTransaction(
                                                  (transaction) async {
                                            DocumentSnapshot snapshot =
                                                await transaction
                                                    .get(documentReference);
                                            if (!snapshot.exists) {
                                              throw Exception(
                                                  "User does not exist!");
                                            }

                                            // print(widget.data['matchApplied']);
                                            List<dynamic> scheduled =
                                                widget.data['matchScheduled'];

                                            Map<String, dynamic> input = {
                                              "opponentUID": widget
                                                      .data['matchRequests']
                                                  [widget.index]['opponentUID'],
                                              "date":
                                                  widget.data['matchRequests']
                                                      [widget.index]['date'],
                                              "timeSlot": widget
                                                      .data['matchRequests']
                                                  [widget.index]['timeSlot'],
                                              "location":
                                                  widget.data['matchRequests']
                                                      [widget.index]['location']
                                            };
                                            scheduled.add(input);
                                            print(scheduled);
                                            // print(applied);
                                            transaction.update(
                                                documentReference,
                                                {'matchScheduled': scheduled});
                                            List<dynamic> request_card = [];
                                            for (int j = 0;
                                                j <
                                                    widget.data['matchRequests']
                                                        .length;
                                                j++) {
                                              if (j != widget.index) {
                                                request_card.add(widget
                                                    .data['matchRequests'][j]);
                                              }
                                            }
                                            transaction.update(
                                                documentReference, {
                                              'matchRequests': request_card
                                            });
                                          });

                                          //changing the opponent established matches
                                          DocumentReference
                                              opp_documentReference =
                                              FirebaseFirestore.instance
                                                  .collection('Teams')
                                                  .doc(widget.oid);

                                          FirebaseFirestore.instance
                                              .runTransaction(
                                                  (transaction) async {
                                            DocumentSnapshot opp_snapshot =
                                                await transaction
                                                    .get(opp_documentReference);
                                            if (!opp_snapshot.exists) {
                                              throw Exception(
                                                  "User does not exist!");
                                            }

                                            // print(widget.data['matchApplied']);
                                            List<dynamic> opp_scheduled =
                                                widget.info['matchScheduled'];
                                            List<dynamic> applied_match = [];
                                            for (int i = 0;
                                                i <
                                                    widget.info['matchApplied']
                                                        .length;
                                                i++) {
                                              if (widget.info['matchApplied'][i]
                                                          ['date'] ==
                                                      widget.data['matchRequests']
                                                              [widget.index]
                                                          ['date'] &&
                                                  widget.info['matchApplied'][i]
                                                          ['timeSlot'] ==
                                                      widget.data['matchRequests']
                                                              [widget.index]
                                                          ['timeSlot']) {
                                                continue;
                                              } else {
                                                applied_match.add(widget
                                                    .info['matchApplied'][i]);
                                              }
                                            }
                                            Map<String, dynamic> opp_input = {
                                              "opponentUID": uid,
                                              "date":
                                                  widget.data['matchRequests']
                                                      [widget.index]['date'],
                                              "timeSlot": widget
                                                      .data['matchRequests']
                                                  [widget.index]['timeSlot'],
                                              "location":
                                                  widget.data['matchRequests']
                                                      [widget.index]['location']
                                            };
                                            opp_scheduled.add(opp_input);
                                            print(opp_scheduled);
                                            // print(applied);
                                            transaction.update(
                                                opp_documentReference, {
                                              'matchScheduled': opp_scheduled
                                            });

                                            transaction.update(
                                                opp_documentReference, {
                                              'matchApplied': applied_match
                                            });
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color.fromRGBO(
                                            17, 86, 149, 1),
                                      ),
                                      child: const Text(
                                        // "To approve",
                                        "承認する",
                                      ),
                                    )),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: SizedBox(
                                    height: 44,
                                    width: 215,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // print("here");
                                        Navigator.of(context).pop();

                                        if (widget.inside_opponent_profile ==
                                            1) {
                                          print("inside this");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OpponentProfile(
                                                          which_page: 5,
                                                          buttonpressed: 1,
                                                          oid: widget.oid,
                                                          data: widget.data,
                                                          index: widget.index,
                                                          info: widget.info,
                                                          mode: matchSetting)));
                                        }
                                        print("outside this");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: const Color.fromRGBO(
                                            17, 86, 149, 1),
                                        backgroundColor: Colors.white,
                                      ),
                                      child: const Text(
                                        // "Cancel."
                                        "キャンセル",
                                        ),
                                    )),
                              )
                            ]),
                      ),
                    )),
                  ],
                );
              },
            );
          }

          if (widget.btnText == '拒否'
          // 'Skip'
          ) {
            String matchSetting =
                widget.data['matchCard'][widget.index]['matchingSetting'];
            String time;
            if (widget.data['matchCard'][widget.index]['timeSlot'] == 1) {
              time = '9:00-11:00';
            } else if (widget.data['matchCard'][widget.index]['timeSlot'] ==
                2) {
              time = '11:00-13:00';
            } else {
              time = '13:00-15:00';
            }
            String imageUrl = widget.info.containsKey('images') && widget.info['images'].length != 0
    ? widget.info['images']['0']
    : '';

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Stack(
                  children: <Widget>[
                    const Opacity(
                      opacity: 0.4, // set the opacity level for the background
                      child:
                          ModalBarrier(dismissible: false, color: Colors.black),
                    ),
                    Dialog(
                        child: SizedBox(
                      width: 300,
                      height: 400,
                      // color: Colors.blue,
                      child: Card(
                        child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: FittedBox(
                                  alignment: Alignment.center,
                                  child: Container(
                                      padding: const EdgeInsets.all(8),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  17, 86, 149, 1),
                                              width: 2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Text(
                                        "${widget.data['matchCard'][widget.index]['date']}" +
                                            ", " +
                                            "${time}",
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(17, 86, 149, 1)),
                                      )),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: Center(
                                  child: SizedBox(
                                    width: 300,
                                    height: 55,
                                    child: Text(
                                      // "With ${widget.info['basicInfo']['schoolName']}\n Skip the game?",
                                      "${widget.info['basicInfo']['schoolName']}との\n試合をスキップしますか？",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 0),
                                height: 155.0,
                                width: 155.0,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  // color: Colors.grey[800],
                                ),
                                child: imageUrl == ''
                                    ? Image.asset(
                                        'assets/dummy.jpg',
                                        width: 155.0,
                                        height: 155.0,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.network(
                                        imageUrl,
                                        width: 155.0,
                                        height: 155.0,
                                        fit: BoxFit.contain,
                                      ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 0),
                                child: SizedBox(
                                    height: 44,
                                    width: 215,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        DocumentReference documentReference =
                                            FirebaseFirestore.instance
                                                .collection('Teams')
                                                .doc(uid);
                                        FirebaseFirestore.instance
                                            .runTransaction(
                                                (transaction) async {
                                          DocumentSnapshot snapshot =
                                              await transaction
                                                  .get(documentReference);
                                          if (!snapshot.exists) {
                                            throw Exception(
                                                "User does not exist!");
                                          }
                                          List<dynamic> match_card = [];
                                          for (int j = 0;
                                              j <
                                                  widget
                                                      .data['matchCard'].length;
                                              j++) {
                                            if (j != widget.index) {
                                              match_card.add(
                                                  widget.data['matchCard'][j]);
                                            }
                                          }
                                          transaction.update(documentReference,
                                              {'matchCard': match_card});
                                        });

                                        Navigator.of(context).pop();
                                        if (widget.inside_opponent_profile ==
                                            1) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OpponentProfile(
                                                          which_page: 5,
                                                          buttonpressed: 1,
                                                          oid: widget.oid,
                                                          data: widget.data,
                                                          index: widget.index,
                                                          info: widget.info,
                                                          mode: matchSetting)));
                                          final snackBar = const SnackBar(
                                            content:
                                                Text('Match has been skipped'),
                                            duration: Duration(seconds: 3),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color.fromRGBO(
                                            17, 86, 149, 1),
                                      ),
                                      child: const Text(
                                        // "I'm Skipping",
                                        "承認する",
                                      ),
                                    )),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: SizedBox(
                                    height: 44,
                                    width: 215,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // print("here");
                                        Navigator.of(context).pop();

                                        if (widget.inside_opponent_profile ==
                                            1) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OpponentProfile(
                                                          which_page: 5,
                                                          buttonpressed: 1,
                                                          oid: widget.oid,
                                                          data: widget.data,
                                                          index: widget.index,
                                                          info: widget.info,
                                                          mode: matchSetting)));
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: const Color.fromRGBO(
                                            17, 86, 149, 1),
                                        backgroundColor: Colors.white,
                                      ),
                                      child: const Text(
                                        // "Cancel."
                                        "キャンセル"
                                        ),
                                    )),
                              )
                            ]),
                      ),
                    )),
                  ],
                );
              },
            );
          }

          if (widget.btnText == 'Refuse') {
            String time;
            if (widget.data['matchRequests'][widget.index]['timeSlot'] == 1) {
              time = '9:00-11:00';
            } else if (widget.data['matchRequests'][widget.index]['timeSlot'] ==
                2) {
              time = '11:00-13:00';
            } else {
              time = '13:00-15:00';
            }
            String matchSetting =
                widget.data['matchRequests'][widget.index]['matchingSetting'];
            String imageUrl = widget.info.containsKey('images') && widget.info['images'].length != 0
    ? widget.info['images']['0']
    : '';

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Stack(
                  children: <Widget>[
                    const Opacity(
                      opacity: 0.4, // set the opacity level for the background
                      child:
                          ModalBarrier(dismissible: false, color: Colors.black),
                    ),
                    Dialog(
                        child: SizedBox(
                      width: 300,
                      height: 400,
                      // color: Colors.blue,
                      child: Card(
                        child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: FittedBox(
                                  alignment: Alignment.center,
                                  child: Container(
                                      padding: const EdgeInsets.all(8),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  17, 86, 149, 1),
                                              width: 2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Text(
                                        "${widget.data['matchRequests'][widget.index]['date']}" +
                                            ", " +
                                            "${time}",
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(17, 86, 149, 1)),
                                      )),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: Center(
                                  child: SizedBox(
                                    width: 300,
                                    height: 55,
                                    child: Text(
                                      "To ${widget.data['basicInfo']['schoolName']}\n you refuse the request for game",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 0),
                                height: 155.0,
                                width: 155.0,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  // color: Colors.grey[800],
                                ),
                                child: imageUrl == ''
                                    ? Image.asset(
                                        'assets/dummy.jpg',
                                        width: 155.0,
                                        height: 155.0,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.network(
                                        imageUrl,
                                        width: 155.0,
                                        height: 155.0,
                                        fit: BoxFit.contain,
                                      ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 0),
                                child: SizedBox(
                                    height: 44,
                                    width: 215,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Stack(
                                              children: <Widget>[
                                                const Opacity(
                                                  opacity:
                                                      0.4, // set the opacity level for the background
                                                  child: ModalBarrier(
                                                      dismissible: false,
                                                      color: Colors.black),
                                                ),
                                                Dialog(
                                                    child: SizedBox(
                                                  width: 300,
                                                  height: 320,
                                                  // color: Colors.blue,
                                                  child: Card(
                                                    child: Column(
                                                        // mainAxisAlignment: MainAxisAlignment.center
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 16),
                                                            child: FittedBox(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Container(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                          8),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color: const Color.fromRGBO(
                                                                              17,
                                                                              86,
                                                                              149,
                                                                              1),
                                                                          width:
                                                                              2),
                                                                      borderRadius: const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              5))),
                                                                  child: Text(
                                                                    "${widget.data['matchRequests'][widget.index]['date']}" +
                                                                        ", " +
                                                                        "${time}",
                                                                    style: const TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            17,
                                                                            86,
                                                                            149,
                                                                            1)),
                                                                  )),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 16),
                                                            child: Center(
                                                              child: SizedBox(
                                                                width: 300,
                                                                height: 55,
                                                                child: Text(
                                                                  "To ${widget.data['basicInfo']['schoolName']}\n refused the request for the match",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0),
                                                            height: 75.0,
                                                            width: 75.0,
                                                            decoration:
                                                                const BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              5)),
                                                              // color: Colors.grey[800],
                                                            ),
                                                            child: Container(
                                                              width: 20.0,
                                                              height: 20.0,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        "images/refuse.png"),
                                                                    scale: 2,
                                                                    fit: BoxFit
                                                                        .contain),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0),
                                                            child: SizedBox(
                                                                height: 44,
                                                                width: 215,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    foregroundColor:
                                                                        Colors
                                                                            .white,
                                                                    backgroundColor:
                                                                        const Color.fromRGBO(
                                                                            17,
                                                                            86,
                                                                            149,
                                                                            1),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    "Change matching condition",
                                                                  ),
                                                                )),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 16),
                                                            child: SizedBox(
                                                                height: 44,
                                                                width: 215,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    // print("here");
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();

                                                                    if (widget
                                                                            .inside_opponent_profile ==
                                                                        1) {
                                                                      print(
                                                                          "inside this");
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => OpponentProfile(which_page: 5, buttonpressed: 1, oid: widget.oid, data: widget.data, index: widget.index, info: widget.info, mode: matchSetting)));
                                                                      final snackBar =
                                                                          const SnackBar(
                                                                        content:
                                                                            Text('Match has been refused'),
                                                                        duration:
                                                                            Duration(seconds: 3),
                                                                      );
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              snackBar);
                                                                    }
                                                                    print(
                                                                        "outside this");
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    foregroundColor:
                                                                        const Color.fromRGBO(
                                                                            17,
                                                                            86,
                                                                            149,
                                                                            1),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                  child: const Text(
                                                                      "Close."),
                                                                )),
                                                          )
                                                        ]),
                                                  ),
                                                )),
                                              ],
                                            );
                                          },
                                        );
                                        DocumentReference documentReference =
                                            FirebaseFirestore.instance
                                                .collection('Teams')
                                                .doc(
                                                    uid); //remeber to update this with uid
                                        FirebaseFirestore.instance
                                            .runTransaction(
                                                (transaction) async {
                                          DocumentSnapshot snapshot =
                                              await transaction
                                                  .get(documentReference);
                                          if (!snapshot.exists) {
                                            throw Exception(
                                                "User does not exist!");
                                          }
                                          List<dynamic> request_card = [];
                                          for (int j = 0;
                                              j <
                                                  widget.data['matchRequests']
                                                      .length;
                                              j++) {
                                            if (j != widget.index) {
                                              request_card.add(widget
                                                  .data['matchRequests'][j]);
                                            }
                                          }
                                          transaction.update(documentReference,
                                              {'matchRequests': request_card});
                                        });
                                        //opponent data change
                                        DocumentReference
                                            opp_documentReference =
                                            FirebaseFirestore.instance
                                                .collection('Teams')
                                                .doc(widget
                                                    .oid); //remeber to update this with uid
                                        FirebaseFirestore.instance
                                            .runTransaction(
                                                (transaction) async {
                                          DocumentSnapshot opp_snapshot =
                                              await transaction
                                                  .get(documentReference);
                                          if (!opp_snapshot.exists) {
                                            throw Exception(
                                                "User does not exist!");
                                          }
                                          List<dynamic> applied_card = [];
                                          for (int j = 0;
                                              j <
                                                  widget.info['matchApplied']
                                                      .length;
                                              j++) {
                                            if (widget.data['matchRequests']
                                                            [widget.index]
                                                        ['date'] ==
                                                    widget.info['matchApplied']
                                                        [j]['date'] &&
                                                widget.data['matchRequests']
                                                            [widget.index]
                                                        ['timeSlot'] ==
                                                    widget.info['matchApplied']
                                                        [j]['timeSlot']) {
                                              continue;
                                            } else {
                                              applied_card.add(widget
                                                  .info['matchApplied'][j]);
                                            }
                                          }
                                          transaction.update(
                                              opp_documentReference,
                                              {'matchApplied': applied_card});
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color.fromRGBO(
                                            17, 86, 149, 1),
                                      ),
                                      child: const Text(
                                        "Cancel it.",
                                      ),
                                    )),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: SizedBox(
                                    height: 44,
                                    width: 215,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // print("here");
                                        Navigator.of(context).pop();

                                        if (widget.inside_opponent_profile ==
                                            1) {
                                          print("inside this");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OpponentProfile(
                                                          which_page: 5,
                                                          buttonpressed: 1,
                                                          oid: widget.oid,
                                                          data: widget.data,
                                                          index: widget.index,
                                                          info: widget.info,
                                                          mode: matchSetting)));
                                        }
                                        print("outside this");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: const Color.fromRGBO(
                                            17, 86, 149, 1),
                                        backgroundColor: Colors.white,
                                      ),
                                      child:
                                          const Text("I'm not canceling it."),
                                    )),
                              )
                            ]),
                      ),
                    )),
                  ],
                );
              },
            );
          }
        },
        style: (widget.btnText == '拒否' || widget.btnText == 'Refuse')
            ? ElevatedButton.styleFrom(
                foregroundColor: const Color.fromRGBO(17, 86, 149, 1),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color.fromRGBO(17, 86, 149, 1)),
              )
            : ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromRGBO(17, 86, 149, 1),
              ),
        child: Text(widget.btnText));
  }
}

class PopUpsG1 extends StatefulWidget {
  final int which_page;
  final String oid;
  final int inside_opponent_profile;
  final String btntxt;
  final int index;
  final Map<String, dynamic> data;
  final Map<String, dynamic> info;
  final List<dynamic> popUpItems;

  const PopUpsG1(
      {Key? key,
      required this.popUpItems,
      required this.inside_opponent_profile,
      required this.btntxt,
      required this.which_page,
      required this.oid,
      required this.index,
      required this.data,
      required this.info})
      : super(key: key);
  @override
  PopupBuilderG1 createState() => PopupBuilderG1();
}

class PopupBuilderG1 extends State<PopUpsG1> {
  @override
  Widget build(BuildContext context) {
    List<Widget> popUpChildrenG1 = [
      FittedBox(
        alignment: Alignment.center,
        child: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromRGBO(17, 86, 149, 1), width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Text(
              widget.popUpItems[0],
              style: const TextStyle(color: Color.fromRGBO(17, 86, 149, 1)),
            )),
      ),
      Center(
        child: SizedBox(
          width: 240,
          child: Text(
            widget.popUpItems[1],
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
      Container(
          height: 56,
          width: 56,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            // color: Colors.grey[800],
          ),
          child: Icon(
            widget.popUpItems[2],
            color: Colors.black,
            size: 50,
          )),
      Text(
        widget.popUpItems[3],
        style: const TextStyle(fontSize: 14),
      ),
      SizedBox(
          height: 44,
          width: 215,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromRGBO(17, 86, 149, 1),
            ),
            child: Text(widget.popUpItems[4]),
          )),
      SizedBox(
          height: 44,
          width: 215,
          child: ElevatedButton(
            onPressed: () {
              // print("here");
              Navigator.of(context).pop();

              if (widget.inside_opponent_profile == 1) {
                print("inside this");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OpponentProfile(
                            which_page: 5,
                            buttonpressed: 1,
                            oid: widget.oid,
                            data: widget.data,
                            index: widget.index,
                            info: widget.info,
                            mode: "Automatic")));
                if (widget.btntxt == "Refuse") {
                  final snackBar = const SnackBar(
                    content: Text('Match has been removed from match making'),
                    duration: Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                if (widget.btntxt == '承認'
                // "Admit"
                ) {
                  final snackBar = const SnackBar(
                    content: Text('Match has been stablished'),
                    duration: Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                if (widget.btntxt == '申し込む'
                // "Request"
                ) {
                  final snackBar = const SnackBar(
                    content: Text('Match has been requested'),
                    duration: Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
              print("outside this");
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromRGBO(17, 86, 149, 1),
              backgroundColor: Colors.white,
            ),
            child: Text(widget.popUpItems[5]),
          )),
    ];
    return Dialog(
        child: SizedBox(
      width: 300,
      height: 364,
      // color: Colors.blue,
      child: Card(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center
          children: List.generate(
            popUpChildrenG1.length,
            (index) => Container(
              margin: const EdgeInsets.only(top: 16),
              child: popUpChildrenG1[index], // set the padding for each child
            ),
          ),
        ),
      ),
    ));
  }
}

class PopUpsG2 extends StatefulWidget {
  final List<String> options;
  final String btnText;
  const PopUpsG2({Key? key, required this.options, required this.btnText})
      : super(key: key);
  @override
  PopupBuilderG2 createState() => PopupBuilderG2();
}

class PopupBuilderG2 extends State<PopUpsG2> {
  String? _selectedOption;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                child: Column(
                  children: [
                    Column(
                      children: widget.options.map((option) {
                        bool isSelected = _selectedOption == option;
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                option,
                                style: const TextStyle(fontSize: 18),
                              ),
                              trailing: isSelected
                                  ? const Icon(Icons.check_box_rounded)
                                  : null,
                              onTap: () {
                                setState(() {
                                  _selectedOption = option;
                                });
                              },
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 200,
          height: 50,
          left: 70,
          right: 70,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromRGBO(17, 86, 149, 1),
              backgroundColor: Colors.white,
            ),
            child: Text(widget.btnText),
          ),
        ),
      ],
    );
  }
}

class PopUpsG3 extends StatefulWidget {
  final List<dynamic> popUpItems;
  final List<TextEditingController> popUpsControllers;
  const PopUpsG3(
      {Key? key, required this.popUpItems, required this.popUpsControllers})
      : super(key: key);
  @override
  PopupBuilderG3 createState() => PopupBuilderG3();
}

class PopupBuilderG3 extends State<PopUpsG3> {
  @override
  Widget build(BuildContext context) {
    List<Widget> popUpChildrenG3 = [
      Text(
        widget.popUpItems[0],
        style: const TextStyle(fontSize: 18),
      ),
      Text(
        widget.popUpItems[1],
        style: const TextStyle(fontSize: 18),
      ),
      Text(
        widget.popUpItems[2],
        style: const TextStyle(fontSize: 14),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 50,
            child: Column(
              children: [
                TextField(
                  controller: widget.popUpsControllers[0],
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                ),
                Text(widget.popUpItems[3]),
              ],
            ),
          ),
          SizedBox(
            width: 50,
            child: Column(
              children: [
                TextField(
                  controller: widget.popUpsControllers[1],
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                ),
                Text(widget.popUpItems[4]),
              ],
            ),
          ),
        ],
      ),
      SizedBox(
          height: 44,
          width: 215,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromRGBO(17, 86, 149, 1),
              backgroundColor: Colors.white,
            ),
            child: Text(widget.popUpItems[5]),
          )),
      SizedBox(
          height: 44,
          width: 215,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromRGBO(17, 86, 149, 1),
              backgroundColor: Colors.white,
            ),
            child: Text(widget.popUpItems[6]),
          )),
    ];
    return Dialog(
        child: SizedBox(
      width: 300,
      height: 364,
      // color: Colors.blue,
      child: Card(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center
          children: List.generate(
            popUpChildrenG3.length,
            (index) => Container(
              margin: const EdgeInsets.only(top: 16),
              child: popUpChildrenG3[index], // set the padding for each child
            ),
          ),
        ),
      ),
    ));
  }
}

class PopUpsContactPage extends StatefulWidget {
  const PopUpsContactPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _PopupCPBuilder createState() => _PopupCPBuilder();
}

class _PopupCPBuilder extends State<PopUpsContactPage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    List<Widget> popUpChildren = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            contactUsPopUp['title']!,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Icon(Icons.check_circle)
        ],
      ),
      SizedBox(
        width: 275,
        child: Column(
          children: [
            Center(
              child: Text(
                contactUsPopUp['heading']!,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                contactUsPopUp['description']!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
      SizedBox(
          height: 49,
          width: 228,
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                            uid: getCurrentUID(), selectedIndex: 3)));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromRGBO(17, 86, 149, 1),
              ),
              child: Text(
                contactUsPopUp['backbtn']!,
                style: const TextStyle(fontSize: 14),
              ))),
    ];
    return Dialog(
        child: SizedBox(
      width: ScreenUtil.screenWidth! * multiplier * 300,
      height: ScreenUtil.screenWidth! * multiplier * 228,
      // color: Colors.blue,
      child: Card(
        child: Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 8, 10, 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                popUpChildren.length,
                (index) => Column(
                  children: [
                    popUpChildren[index],
                    const SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

class SortingDialog extends StatefulWidget {
  const SortingDialog({super.key});

  @override
  _SortingDialogState createState() => _SortingDialogState();
}

class _SortingDialogState extends State<SortingDialog> {
  int sortAction = 1;
  List<bool> isContainerClicked = [false, false, false, false, false];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            // overflow: Overflow.visible,
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            sortAction = 1; // Most recent match at top
                            setState(() {
                              isContainerClicked[0] = !isContainerClicked[
                                  0]; // Toggle the clicked state
                              for (int i = 0; i < 5; i++) {
                                if (i != 0) {
                                  if (isContainerClicked[i] == true) {
                                    isContainerClicked[i] =
                                        !isContainerClicked[i];
                                  }
                                }
                              }
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Most recent match',
                                style: TextStyle(
                                    color: isContainerClicked[0]
                                        ? Colors.blue
                                        : Colors.black),
                              ),
                              isContainerClicked[0]
                                  ? const Icon(Icons.check)
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 5,
                        ),
                        TextButton(
                          onPressed: () {
                            sortAction = 2; // A stronger opponent
                            setState(() {
                              isContainerClicked[1] = !isContainerClicked[
                                  1]; // Toggle the clicked state
                              for (int i = 0; i < 5; i++) {
                                if (i != 1) {
                                  if (isContainerClicked[i] == true) {
                                    isContainerClicked[i] =
                                        !isContainerClicked[i];
                                  }
                                }
                              }
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'A stronger opponent',
                                style: TextStyle(
                                    color: isContainerClicked[1]
                                        ? Colors.blue
                                        : Colors.black),
                              ),
                              isContainerClicked[1]
                                  ? const Icon(Icons.check)
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 5,
                        ),
                        TextButton(
                          onPressed: () {
                            sortAction = 3; // A weaker opponent
                            setState(() {
                              isContainerClicked[2] = !isContainerClicked[
                                  2]; // Toggle the clicked state
                              for (int i = 0; i < 5; i++) {
                                if (i != 2) {
                                  if (isContainerClicked[i] == true) {
                                    isContainerClicked[i] =
                                        !isContainerClicked[i];
                                  }
                                }
                              }
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'A weaker opponent',
                                style: TextStyle(
                                    color: isContainerClicked[2]
                                        ? Colors.blue
                                        : Colors.black),
                              ),
                              isContainerClicked[2]
                                  ? const Icon(Icons.check)
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 5,
                        ),
                        TextButton(
                          onPressed: () {
                            sortAction = 4; // Minimum travel time (by car)
                            setState(() {
                              isContainerClicked[3] = !isContainerClicked[
                                  3]; // Toggle the clicked state
                              for (int i = 0; i < 5; i++) {
                                if (i != 3) {
                                  if (isContainerClicked[i] == true) {
                                    isContainerClicked[i] =
                                        !isContainerClicked[i];
                                  }
                                }
                              }
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Minimum travel time (by car)',
                                style: TextStyle(
                                    color: isContainerClicked[3]
                                        ? Colors.blue
                                        : Colors.black),
                              ),
                              isContainerClicked[3]
                                  ? const Icon(Icons.check)
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 5,
                        ),
                        TextButton(
                          onPressed: () {
                            sortAction = 5; // Minimum travel time (by train)
                            setState(() {
                              isContainerClicked[4] = !isContainerClicked[
                                  4]; // Toggle the clicked state
                              for (int i = 0; i < 5; i++) {
                                if (i != 4) {
                                  if (isContainerClicked[i] == true) {
                                    isContainerClicked[i] =
                                        !isContainerClicked[i];
                                  }
                                }
                              }
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Minimum travel time (by train)',
                                style: TextStyle(
                                    color: isContainerClicked[4]
                                        ? Colors.blue
                                        : Colors.black),
                              ),
                              isContainerClicked[4]
                                  ? const Icon(Icons.check)
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          print(sortAction);

                          updateSortActionInFireBase(sortAction);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF115695),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.cached),
                            SizedBox(width: 8),
                            Text("Update"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

void testingUI(BuildContext context) {
  int? selectedValue1, selectedValue2;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(child: Text('Please enter the match results')),
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
                    // setState(() {
                    //   selectedValue1 = value;
                    // });
                  },
                  items: List<DropdownMenuItem<int>>.generate(
                    100,
                    (index) => DropdownMenuItem<int>(
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
                    // setState(() {
                    //   selectedValue2 = value;
                    // });
                  },
                  items: List<DropdownMenuItem<int>>.generate(
                    100,
                    (index) => DropdownMenuItem<int>(
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
                context, "Confirmation of result to the other team", () {
              // String s =
              // (selectedValue1! > selectedValue2!) ? "Win" : "Lose";

              showDialog(
                context: context,
                builder: (BuildContext context) => StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return AlertDialog(
                      title: const Center(child: Text('Sent')),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    builder: (context) => HomeScreen(
                                          uid: "auth_id",
                                          selectedIndex: 0,
                                        )));
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
    },
  );
}
