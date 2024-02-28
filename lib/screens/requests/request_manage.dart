import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai_match_making_app/screens/match/match_making.dart';
import '../../reusable_widgets/reusable_widgets.dart';
import '../modals/info_modal.dart';

class AdmitButton extends StatelessWidget {
  final int whichPage; // it is 0->match_making, 1 -> list_of_request, 2 -> establsihed_matches
  final int index;
  final int inside_opponent_profile;
  final String oid;
  final Map<String, dynamic> data;
  final Map<String, dynamic> info;

  const AdmitButton({Key? key, required this.whichPage,required this.inside_opponent_profile, required this.oid, required this.index, required this.data, required this.info}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:[
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: SizedBox(
            width: 110,
            height: 40,
            child : PopUps(
              inside_opponent_profile: inside_opponent_profile,
              which_page: whichPage,
              oid: oid,
              index: index,
              data: data,
              info: info,
              popUpWidget:  PopUpsG1(
                inside_opponent_profile: inside_opponent_profile,
                btntxt: "Refuse",
                  which_page: whichPage,
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
              btnText: "Refuse",),
          ),

        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: SizedBox(
            width: 110,
            height: 40,
            child: PopUps(
              inside_opponent_profile: inside_opponent_profile,
              which_page: whichPage,
              oid: oid,
              index: index,
              data: data,
              info: info,
              popUpWidget:  PopUpsG1(
                inside_opponent_profile: inside_opponent_profile,
                btntxt: "Admit",
                  which_page: whichPage,
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
              btnText:"Admit",
            ),
          ),
        ),
      ],
    );
  }
}
void cancel_button_functionality(Map<String, dynamic> data, Map<String, dynamic> info,int index,String oid){
  // changing the user established matched
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;
  DocumentReference documentReference = FirebaseFirestore.instance
      .collection('Teams')
      .doc(uid);
  FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot snapshot = await transaction.get(documentReference);
    if (!snapshot.exists) {
      throw Exception("User does not exist!");
    }

    // print(widget.data['matchApplied']);
    List<dynamic> applied = [];
    for(int j = 0;j<data['matchApplied'].length;j++){
      if(j!=index){
        applied.add(data['matchApplied'][j]);
      }
    }
    bool already_added = false;
    List<dynamic> match = data['matchCard'];

    for(int i = 0;i<data['matchCard'].length;i++){
      if(data['matchCard'][i]['date'] == data['matchApplied'][index]['date'] &&
          data['matchCard'][i]['timeSlot'] == data['matchApplied'][index]['timeSlot'] &&
          data['matchCard'][i]['opponentUID'] == data['matchApplied'][index]['opponentUID']
      ){
        already_added = true;
      }
    }
    Map<String, dynamic> inserting_in_match_card = {
      "date": data['matchApplied'][index]['date'],
      "timeSlot": data['matchApplied'][index]['timeSlot'],
      "distanceByCar": data['matchApplied'][index]['distanceByCar'],
      "distanceByTrain": data['matchApplied'][index]['distanceByTrain'],
      "matchingSetting": data['matchApplied'][index]['matchingSetting'],
      "opponentUID": data['matchApplied'][index]['opponentUID'],
      "teamLevel": data['matchApplied'][index]['teamLevel'],
      "location": data['matchApplied'][index]['location'],};
    if(already_added == false){
      match.add(inserting_in_match_card);
      transaction.update(documentReference, {'matchCard': match});
    }
    transaction.update(documentReference, {'matchApplied': applied});
  });

  //changing the opponent established matches
  DocumentReference opp_documentReference = FirebaseFirestore.instance
      .collection('Teams')
      .doc(oid);
  print(oid);
  FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot opp_snapshot = await transaction.get(opp_documentReference);
    if (!opp_snapshot.exists) {
      throw Exception(" here User does not exist!");
    }

    // print(widget.data['matchApplied']);
    List<dynamic> requested = [];
    for(int k = 0;k<info['matchRequests'].length;k++){
      if(info['matchRequests'][k]['opponentUID']!=uid) {
        requested.add(
            info['matchRequests'][k]);
      }
    }
    transaction.update(opp_documentReference, {'matchRequests': requested});
  });
}
class CancelApplication extends StatelessWidget {
  final int whichPage; // it is 0->match_making, 1 -> list_of_request, 2 -> establsihed_matches
  final int index;
  final int inside_opponent_profile;
  final String oid;
  final Map<String, dynamic> data;
  final Map<String, dynamic> info;

  const CancelApplication({Key? key, required this.whichPage,required this.inside_opponent_profile, required this.oid, required this.index, required this.data, required this.info}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    String time;
    if(data['matchApplied'][index]['timeSlot'] == 1){
      time = '9:00-11:00';
    }
    else if (data['matchApplied'][index]['timeSlot'] == 2){
      time = '11:00-13:00';
    }
    else{
      time = '13:00-15:00';
    }
    return Padding(
      padding:
      const EdgeInsets.fromLTRB(60, 0, 60, 5),
      child: GestureDetector(
        onTap: () {
          String matchSetting = data['matchApplied'][index]['matchingSetting'];
          String imageUrl = info['images'].length != 0
              ? info['images']['0']
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
                                          "${data['matchApplied'][index]['date']}"+", "+ "${time}",
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
                                        "To ${data['basicInfo']['schoolName']}\n Cancel?",
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
                                                    opacity: 0.4, // set the opacity level for the background
                                                    child:
                                                    ModalBarrier(dismissible: false, color: Colors.black),
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
                                                                          "${data['matchApplied'][index]['date']}"+", "+ "${time}",
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
                                                                        "To ${data['basicInfo']['schoolName']}\n Cancelled.",
                                                                        textAlign: TextAlign.center,
                                                                        style: const TextStyle(fontSize: 18),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 0),
                                                                  height: 75.0,
                                                                  width: 75.0,
                                                                  decoration: const BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius.all(Radius.circular(5)),
                                                                    // color: Colors.grey[800],
                                                                  ),
                                                                  child:Container(
                                                                    width: 20.0,
                                                                    height: 20.0,
                                                                    decoration: const BoxDecoration(

                                                                      image: DecorationImage(
                                                                          image: AssetImage("images/x.png"),
                                                                          scale: 2,fit: BoxFit.contain),

                                                                    ),
                                                                  ),
                                                                ),

                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 0),
                                                                  child: SizedBox(
                                                                      height: 44,
                                                                      width: 215,
                                                                      child: ElevatedButton(
                                                                        onPressed: () {
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                          foregroundColor: Colors.white,
                                                                          backgroundColor:
                                                                          const Color.fromRGBO(17, 86, 149, 1),
                                                                        ),
                                                                        child: Text(
                                                                          "Change matching condition",
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

                                                                          if (inside_opponent_profile == 1) {
                                                                            print("inside this");
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) =>
                                                                                        OpponentProfile(
                                                                                            which_page: 5,
                                                                                            buttonpressed: 1,
                                                                                            oid: oid,
                                                                                            data: data,
                                                                                            index: index,
                                                                                            info: info,
                                                                                            mode: matchSetting)));
                                                                            final snackBar = const SnackBar(
                                                                              content: Text(
                                                                                  'Match has been removed from match making'),
                                                                              duration: Duration(seconds: 3),
                                                                            );
                                                                            ScaffoldMessenger.of(context)
                                                                                .showSnackBar(snackBar);
                                                                          }
                                                                          print("outside this");
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                          foregroundColor:
                                                                          const Color.fromRGBO(17, 86, 149, 1),
                                                                          backgroundColor: Colors.white,
                                                                        ),
                                                                        child: Text("Close"),
                                                                      )),
                                                                )
                                                              ]),
                                                        ),
                                                      )),
                                                ],
                                              );
                                            },
                                          );
                                          cancel_button_functionality(
                                              data, info, index, oid);

                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                          const Color.fromRGBO(17, 86, 149, 1),
                                        ),
                                        child: Text(
                                          "Cancel it.",
                                        ),
                                      )),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  child: SizedBox(
                                      height: 44,
                                      width: 228,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // print("here");
                                          Navigator.of(context).pop();

                                          if (inside_opponent_profile == 1) {
                                            print("inside this");
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OpponentProfile(
                                                            which_page: 5,
                                                            buttonpressed: 1,
                                                            oid: oid,
                                                            data: data,
                                                            index: index,
                                                            info: info,
                                                            mode: matchSetting)));
                                          }
                                          print("outside this");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor:
                                          const Color.fromRGBO(17, 86, 149, 1),
                                          backgroundColor: Colors.white,
                                        ),
                                        child: Text("I'm not canceling it."),
                                      )),
                                )
                              ]),
                        ),
                      )),
                ],
              );
            },
          );
        },
        child: Card(
          color: Colors.blue[900],
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                30, 14, 30, 14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: const [
                    Text(
                      // 'Cancel application',
                      "申し込みをキャンセル",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class RequestManage extends StatefulWidget {
  const RequestManage({Key? key}) : super(key: key);

  @override
  State<RequestManage> createState() => _RequestManageState();
}

class _RequestManageState extends State<RequestManage> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    CollectionReference cardData = FirebaseFirestore.instance.collection('Teams');
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
                  text: requestManagement['listOfRequests']!,

                ),
                Tab(
                  text: requestManagement['listOfRegTeams']!,

                ),

              ],

            ),

            title:  Text(requestManagement['title']!,
              style: TextStyle(fontSize: 24, color: Colors.black),)

        ),

        body:  TabBarView(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: cardData.doc(uid).snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                if (snapshot.hasError) {
                  return Text(matchMaking['somethingWrong']!);
                }


                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                else{
                  Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                  // print(data.length);
                  // print("printing data :-");
                  // print(data);
                  List<dynamic> requestsCardsInfo;
                  requestsCardsInfo = data["matchRequests"];
                  if(requestsCardsInfo.isEmpty){
                    return   Center(
                      child: CustomLogoWidget(
                        imagePath: "assets/images/requestmanage.png",
                        text: requestManagement['requestsSubtitle']!,
                      ),
                    );
                  }
                  // print(Match_making_cards_info);
                  // return Text("Full Name: ${data['full_name']} ${data['last_name']}");
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Card(
                        child: Column(
                          children: [
                            for(int i = 0;i<requestsCardsInfo.length;i++)...[

                              StreamBuilder<DocumentSnapshot>(
                                stream: cardData.doc(requestsCardsInfo[i]['opponentUID']).snapshots(),
                                builder:
                                    (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text(somethingWrong);
                                  }

                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  }

                                  else{
                                    Map<String, dynamic> info = snapshot.data!.data() as Map<String, dynamic>;
                                    //
                                    // print(info);


                                    // print("printing info of the match card");
                                    // print(info['basicInfo']['schoolName']);
                                    // print(i);
                                    String time;
                                    if(requestsCardsInfo[i]['timeSlot'] == 1){
                                      time = '9:00-11:00';
                                    }
                                    else if (requestsCardsInfo[i]['timeSlot'] == 2){
                                      time = '11:00-13:00';

                                    }
                                    else{
                                      time = '13:00-15:00';
                                    }
                                    return GestureDetector(
                                      onTap: (){
                                        // print("hello");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => OpponentProfile(
                                                  which_page: 1,
                                                    buttonpressed: 0,
                                                    oid: requestsCardsInfo[i]['opponentUID'],
                                                    data: data,index: i,info: info,
                                                    mode: requestsCardsInfo[i]['matchingSetting'])));
                                      },
                                      child: Card(
                                        shape: const RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Colors.black,
                                            )
                                        ),
                                        child: Column(
                                          children : [
                                            head_scheduled_match_card(dateOfGame: requestsCardsInfo[i]['date'], timeOfMatch: time , weather: 1),
                                            middle_scheduled_match_card(universityName: info['basicInfo']['schoolName'], address:  "${info['basicInfo']['schoolAddress']['street']} , ${info['basicInfo']['schoolAddress']['city']} , ${info['basicInfo']['schoolAddress']['pincode']} "),
                                            distance(carDistance: requestsCardsInfo[i]['distanceByCar'] ?? '', trainDistance: requestsCardsInfo[i]['distanceByTrain'] ?? '', walkDistance: requestsCardsInfo[i]['distanceByWalk'] ?? ''),
                                            imageAndScore(
                                                win: info['basicInfo']['win'] != null ? info['basicInfo']['win'] : 0,
                                                loss: info['basicInfo']['loss'] != null ? info['basicInfo']['loss'] : 0,
                                                point: info['basicInfo']['draw'] != null ? info['basicInfo']['draw'] : 0,
                                                imageUrl: info['images'].length != 0 ? info['images']['0'] : ''
                                                ),
                                            AdmitButton(inside_opponent_profile: 0, whichPage:1,oid:requestsCardsInfo[i]['opponentUID'], data: data,index: i,info: info,),
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

              },
            ),
            // IncomingPage(),
            StreamBuilder<DocumentSnapshot>(
             stream: cardData.doc(uid).snapshots(),

              builder:
                  (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                if (snapshot.hasError) {
                  return  Text(somethingWrong);
;                }


                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                else{
                  Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                  // print(data.length);
                  // print("printing data :-");
                  // print(data);
                  List<dynamic> registeredCardsInfo;
                  registeredCardsInfo = data["matchApplied"];
                  // print(Match_making_cards_info);
                  // return Text("Full Name: ${data['full_name']} ${data['last_name']}");
                  if(registeredCardsInfo.isEmpty){
                    return Center(
                      child: CustomLogoWidget(
                        imagePath: "assets/images/requestmanage-2.png",
                        text: requestManagement['regTeamSubtitle']!,
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Card(
                        child: Column(
                          children: [
                            for(int i = 0;i<registeredCardsInfo.length;i++)...[

                              StreamBuilder<DocumentSnapshot>(
                                stream: cardData.doc(registeredCardsInfo[i]['opponentUID']).snapshots(),
                                builder:
                                    (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text(somethingWrong);
                                  }


                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  }

                                  else{
                                    Map<String, dynamic> info = snapshot.data!.data() as Map<String, dynamic>;
                                    //
                                    // print(info);


                                    // print("printing info of the match card");
                                    // print(info['basicInfo']['schoolName']);
                                    // print(i);
                                    String time;
                                    if(registeredCardsInfo[i]['timeSlot'] == 1){
                                      time = '9:00-11:00';
                                    }
                                    else if (registeredCardsInfo[i]['timeSlot'] == 2){
                                      time = '11:00-13:00';

                                    }
                                    else{
                                      time = '13:00-15:00';
                                    }
                                    return GestureDetector(
                                      onTap: (){
                                        // print("hello");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => OpponentProfile(
                                                    which_page: 2,
                                                    buttonpressed: 0,
                                                    oid: registeredCardsInfo[i]['opponentUID'],
                                                    data: data,index: i,info: info,
                                                    mode: info['matchAvailability'][0]['matchingSetting'])));
                                      },
                                      child: Card(
                                        shape: const RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Colors.black,
                                            )
                                        ),
                                        child: Column(
                                          children : [
                                            head_scheduled_match_card(dateOfGame: registeredCardsInfo[i]['date'], timeOfMatch: time , weather: 1),
                                            middle_scheduled_match_card(universityName: info['basicInfo']['schoolName'], address:  "${info['basicInfo']['schoolAddress']['street']} , ${info['basicInfo']['schoolAddress']['city']} , ${info['basicInfo']['schoolAddress']['pincode']} "),
                                            distance(carDistance: registeredCardsInfo[i]['distanceByCar'] ?? '', trainDistance: registeredCardsInfo[i]['distanceByTrain'] ?? '', walkDistance: registeredCardsInfo[i]['distanceByWalk'] ?? ''),
                                            imageAndScore(
                                                win: info['basicInfo']['win'] != null ? info['basicInfo']['win'] : 0,
                                                loss: info['basicInfo']['loss'] != null ? info['basicInfo']['loss'] : 0,
                                                point: info['basicInfo']['draw'] != null ? info['basicInfo']['draw'] : 0,
                                                imageUrl: info['images'].length != 0 ? info['images']['0'] : ''
                                                ),
                                            // const Button(),
                                            CancelApplication(inside_opponent_profile: 0, whichPage: 2, oid: registeredCardsInfo[i]['opponentUID'], index: i, data: data, info: info),

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

              },
            ),
            // OutgoingPage(),
          ],
        ),

      ),
    ),
    );
  }
}
