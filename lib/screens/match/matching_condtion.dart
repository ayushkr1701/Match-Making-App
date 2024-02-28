import 'package:ai_match_making_app/screens/Base/home_screen.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ai_match_making_app/utils/constants.dart';
import 'package:ai_match_making_app/screens/profile/util_classes.dart';

class MatchingConditionScreen extends StatefulWidget {
  const MatchingConditionScreen({Key? key}) : super(key: key);
  @override
  MatchingConditionBuilder createState() => MatchingConditionBuilder();
}

class MatchingConditionBuilder extends State<MatchingConditionScreen> {
  String currentID = getCurrentUID();
  int _selectedIndex = 3;
  Map<String, dynamic>? fetchedData;
  List<TextEditingController> aboutOppositeTeamControllers =
      List.generate(6, (index) => TextEditingController());
  List<String> initValues = List.generate(6, (index) => "");
  String travelSlider = matCondTravelSliderLevelsJap[2];
  String trolleySlider = matCondTrolleySliderLevelsJap[2];
  double travelSliderVal = 50;
  double trolleySliderVal = 50;
  bool _selectedValCar = false;
  bool _selectedValTrain = false;
  bool _selectedValWalk = false;
  void _handleValueChanged1(bool newValue) {
    _selectedValCar = newValue;
  }
  void _handleValueChanged2(bool newValue) {
    _selectedValTrain = newValue;
  }
  void _handleValueChanged3(bool newValue) {
    _selectedValWalk = newValue;
  }
  
  void handleSliderChanged1(double value) {
    // Update the sliderValue when the slider changes
    travelSliderVal = value;
    travelSlider = matCondTravelSliderLevelsJap[(travelSliderVal ~/ 25)];
    // Do any additional processing or update the UI as needed
  }

  void handleSliderChanged2(double value) {
    // Update the sliderValue when the slider changes
    trolleySliderVal = value;
    trolleySlider = matCondTrolleySliderLevelsJap[(trolleySliderVal ~/ 25)];
    // Do any additional processing or update the UI as needed
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomeScreen(uid: currentID,selectedIndex: _selectedIndex,)));
    });
  }
  List<String> options(String str) {
    List<String> optionsStr = [];
    if (str.startsWith("小学生")) {
      optionsStr = academicYearOptionsJap;
    } else if (str.startsWith("中学生") || str.startsWith("高校生")) {
      optionsStr = academicYearOptionsJap.sublist(0, 3);
    } else if (str.startsWith("大学生")) {
      optionsStr = academicYearOptionsJap.sublist(0, 4);
    }
    return optionsStr;
  }

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

  void updateData() {
    String teamCompType = fetchedData!['teamComposition']['type'];
    String teamCompYear = fetchedData!['matchingConditions']['teamGrade'] ?? "";
    if ((teamCompType.startsWith("小学生")&& (teamCompYear == academicYearOptionsJap[4] || teamCompYear == academicYearOptionsJap[5])) || (teamCompType.startsWith("大学生") && (teamCompYear == academicYearOptionsJap[3]))){
        initValues[1] = academicYearOptionsJap[0];
    }
    else{
      initValues[1] = fetchedData!['matchingConditions']['teamGrade'] ??
        academicYearOptionsJap[0];
    }
    
    initValues[2] = fetchedData!['matchingConditions']
            ['prefecturePreference'] ??
        matCondPrefecturesJap[0];
    initValues[3] =
        fetchedData!['matchingConditions']['cityPreference'] ?? matCondUrbanJap[0];
    initValues[4] = fetchedData!['matchingConditions']['useExpressway']
        ? "利用する" //I use it"
        : "利用しない";
    initValues[5] = fetchedData!['matchingConditions']['parkingAvailability']
        ? "有り"//"There"
        : "なし";//"Without";
    aboutOppositeTeamControllers[1].text = fetchedData!['matchingConditions']
            ['teamGrade'] ??
        academicYearOptionsJap[0];
    aboutOppositeTeamControllers[2].text = fetchedData!['matchingConditions']
            ['prefecturePreference'] ??
        matCondPrefecturesJap[0];
    aboutOppositeTeamControllers[3].text =
        fetchedData!['matchingConditions']['cityPreference'] ?? matCondUrbanJap[0];
    aboutOppositeTeamControllers[4].text = fetchedData!['matchingConditions']
            ['useExpressway']
        ? "利用する"//"I use it"
        : "利用しない";//"I don't use it";
    aboutOppositeTeamControllers[5].text = fetchedData!['matchingConditions']
            ['parkingAvailability']
        ? "有り"//"There"
        : "なし";//"Without";

    travelSlider = fetchedData!['matchingConditions']['maximumDistance'] ??
        matCondTravelSliderLevelsJap[2];
    travelSliderVal = convert(matCondTravelSliderLevelsJap, travelSlider);
    trolleySlider = fetchedData!['matchingConditions']['stationDistance'] ??
        matCondTrolleySliderLevelsJap[2];
    trolleySliderVal = convert(matCondTrolleySliderLevelsJap, trolleySlider);

    _selectedValCar = fetchedData!['matchingConditions']['useCar'];
    _selectedValTrain = fetchedData!['matchingConditions']['useMetro'];
    _selectedValWalk = fetchedData!['matchingConditions']['useWalk'];
  }

  int getDistance(myGeoLocation, opponentGelLocation){
    // TODO Create mechanism to get distance from geolocation
    return 0;
  }

  Future<List<Map<String, dynamic>>> getMatchedOpponentsDetails () async {
    // This function will provide the list of opponents based on matching conditions.

    List<Map<String, dynamic>> matchCard = [];
    // TODO Write function to search for opponent based on matching condition
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Teams").get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (QueryDocumentSnapshot document in documents) {
      if(document.id == getCurrentUID()) continue;
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

      String cityPreference = aboutOppositeTeamControllers[3].text; // CityPreference
      String prefecturePreference = aboutOppositeTeamControllers[2].text; // PrefecturePreference
      if (cityPreference == "Same"){
        if (data!["basicInfo"]["schoolAddress"]["city"] != fetchedData!["basicInfo"]["schoolAddress"]["city"]){
          continue;
        }
        if (data["basicInfo"]["schoolAddress"]["prefecture"] != fetchedData!["basicInfo"]["schoolAddress"]["prefecture"]){
          continue;
        }
      }
      if (prefecturePreference == "Same" && cityPreference == "Different"){
        if (data!["basicInfo"]["schoolAddress"]["city"] == fetchedData!["basicInfo"]["schoolAddress"]["city"]){
          continue;
        }
        if (data["basicInfo"]["schoolAddress"]["prefecture"] != fetchedData!["basicInfo"]["schoolAddress"]["prefecture"]){
          continue;
        }
      }
      if (prefecturePreference == "Different"){
        if (data!["basicInfo"]["schoolAddress"]["prefecture"] == fetchedData!["basicInfo"]["schoolAddress"]["prefecture"]){
          continue;
        }
      }

      try {
        String parkingAvailability = aboutOppositeTeamControllers[5].text; // ParkingAvailability
        if (parkingAvailability == "有り"){//"There"
          if (!data!["homeGround"]["firstHomeGround"]["parkingAvailability"]){
            continue;
          }
        }
      } catch (e){}
      try{
        if (travelSlider != "Not specified"){
          int maxDistance = int.parse(travelSlider.split(" ")[1]);
          if (maxDistance > getDistance(
              data!["homeGround"]["firstHomeGround"]["geoLocation"],
              fetchedData!["basicInfo"]["geoLocation"]
          )){
            continue;
          }
        }
      } catch (e){}
      try{
        if (trolleySlider != "Not specified"){
          int maxDistance = int.parse(trolleySlider.split(" ")[1]);
          if (maxDistance > data!["homeGround"]["firstHomeGround"]["nearestStationDistance"]){
            continue;
          }
        }
      } catch (e){}

      for(int i = 0; i<data!['matchAvailability'].length;i++){
        for(int j = 0; j < fetchedData!['matchAvailability'].length;j++){
          if(data['matchAvailability'][i]['timeSlot']==fetchedData!['matchAvailability'][j]['timeSlot']&&
              data['matchAvailability'][i]['date']==fetchedData!['matchAvailability'][j]['date']){
            Map<String, dynamic> addingMatchCard = {
              "date": data['matchAvailability'][i]['date'],
              "timeSlot": data['matchAvailability'][i]['timeSlot'],
              "distanceByCar": 0,
              "distanceByTrain": 0,
              "matchingSetting":  data['matchAvailability'][i]['matchingSetting'],
              "opponentUID": document.id,
              "teamLevel": data["basicInfo"]["teamLevel"],
              "location": "Match Location",
            };
            matchCard.add(addingMatchCard);
          }
        }
      }
    }

    return matchCard;
  }

  Future<void> updateMatchingConditions () async {
        String uid = getCurrentUID();
        DocumentReference teamRef =
            FirebaseFirestore.instance.collection("Teams").doc(uid);

        // Create a new map with the additional fields for the current team
        Map<String, dynamic> newData = {
            "matchingConditions": {
                "cityPreference": aboutOppositeTeamControllers[3].text,
                "matchAgainst": "",
                "maximumDistance": travelSlider,
                "parkingAvailability":
                    aboutOppositeTeamControllers[5].text == "有り"//"There"
                        ? true
                        : false,
                "prefecturePreference":
                    aboutOppositeTeamControllers[2].text,
                "stationDistance": trolleySlider,
                "teamGrade": aboutOppositeTeamControllers[1].text,
                "teamType" : fetchedData!['teamComposition']['type'],
                "useCar":
                    _selectedValCar,
                "useMetro":
                    _selectedValTrain,
                "useWalk":
                    _selectedValWalk,
                "useExpressway":
                    aboutOppositeTeamControllers[4].text == "利用する"//"I use it"
                        ? true
                        : false,
            }
        };

        try {
          teamRef.update(newData);
          print('New data added to the current team successfully');

          // Get data of matchCard
          dynamic myMatchCard = fetchedData!["matchCard"];

          // Remove data of My Team from all opponents matchCard
          for (int i=0; i<myMatchCard.length; i++){
            DocumentReference opponentRef = FirebaseFirestore.instance.collection("Teams").doc(myMatchCard[i]["opponentUID"]);
            try{
              opponentRef.update({
                "matchCard": FieldValue.arrayRemove([uid])
              });
            } catch (e){}
          }

          // Remove all data from matchCard of user
          teamRef.update({
            "matchCard": []
          });

          List<Map<String, dynamic>>newMatchCard = await getMatchedOpponentsDetails();

          // Update the matchCard variable of My Team
          teamRef.update({
            "matchCard": newMatchCard
          });

          // TODO Add my team uid in opponent matchCard
          // for (int i=0; i<newMatchCard.length; i++){
          //     DocumentReference opponentRef = FirebaseFirestore.instance.collection("Teams").doc(newMatchCard[i]);
          //     opponentRef.update({
          //         "matchCard": FieldValue.arrayUnion([uid])
          //     });
          // }
        } catch (error) {
          print('Error adding new data to the current team: $error');
        }
        Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (fetchedData != null) {
      updateData();
      return Scaffold(
        appBar: AppBar(
        title: Text(
          matchingCondition['title']!,
          style: const TextStyle(
            color: Colors.black, // Set the text color to black
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(matchingCondition['aboutOppTeam']!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              InputFieldWithOptions(
                options: options(fetchedData!['teamComposition']['type']??"").isEmpty ? [] : options(fetchedData!['teamComposition']['type']??""),
                labelText: matchingCondition['academicYear']!,
                optionController: aboutOppositeTeamControllers[1],
                initOption: initValues[1],
              ),
            ]),
          ),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      matchingCondition['entireMovement']!,
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Row(
                    children: [
                      CheckBox(onChanged: _handleValueChanged1, text: matchingCondition['car']!, isSelected: _selectedValCar),
                      CheckBox(onChanged: _handleValueChanged2, text: matchingCondition['train']!, isSelected: _selectedValTrain,),
                      CheckBox(onChanged: _handleValueChanged3, text: matchingCondition['walk']!, isSelected: _selectedValWalk,),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 4),
                      child: Text(
                        matchingCondition['maxTravelTime']!,
                        style: const TextStyle(fontSize: 16),
                      )),
                  SliderCard(
                      sliderLevels: matCondTravelSliderLevelsJap,
                      currentSliderVal: travelSliderVal,
                      onSliderChanged: handleSliderChanged1),
                  InputFieldWithOptions(
                    options: matCondPrefecturesJap,
                    labelText: matchingCondition['prefectures']!,
                    optionController: aboutOppositeTeamControllers[2],
                    initOption: initValues[2],
                  ),
                  InputFieldWithOptions(
                    options: matCondUrbanJap,
                    labelText: matchingCondition['urbanVillage']!,
                    optionController: aboutOppositeTeamControllers[3],
                    initOption: initValues[3],
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
               Text(matchingCondition['aboutCar']!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              InputFieldWithOptions(
                options: matCondCarSpecifyJap,
                labelText: matchingCondition['expressway']!,
                optionController: aboutOppositeTeamControllers[4],
                initOption: initValues[4],
              ),
              InputFieldWithOptions(
                options: matCondParkingSlotJap,
                labelText: matchingCondition['parkingAvailability']!,
                optionController: aboutOppositeTeamControllers[5],
                initOption: initValues[5],
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    matchingCondition['aboutTrain']!,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: Text(
                      matchingCondition['walkFromTheStation']!,
                      style: const TextStyle(fontSize: 16),
                    )),
                SliderCard(
                  sliderLevels: matCondTrolleySliderLevelsJap,
                  currentSliderVal: trolleySliderVal,
                  onSliderChanged: handleSliderChanged2,
                )
              ],
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              width: 220,
              height: 65,
              child: ElevatedButton(
                onPressed: updateMatchingConditions,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(17, 86, 149, 1),
                ),
                child: Text(
                  matchingCondition['finishedBtn']!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ]),
        bottomNavigationBar: BottomNavigationBar(
        // selectedIconTheme: const IconThemeData(color: Colors.black),
        selectedItemColor: const Color.fromRGBO(17, 86, 149, 1),
        showUnselectedLabels: true,
        // selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedIconTheme: const IconThemeData(
          color: Colors.black38,
        ),
        unselectedItemColor: Colors.black38,
        items:  <BottomNavigationBarItem>[
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
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
