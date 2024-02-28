// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:ai_match_making_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:ai_match_making_app/screens/Base/home_screen.dart';
import 'package:ai_match_making_app/screens/Base/my_page.dart';
import 'package:ai_match_making_app/screens/profile/edit_profile_screen.dart';
import 'package:ai_match_making_app/screens/profile/util_classes.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyProfilePage extends StatefulWidget {
  final String uid;
  const MyProfilePage({Key? key, required this.uid}) : super(key: key);
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  Map<String,dynamic>?fetchedData;
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
    String uid = widget.uid;
    DocumentReference teamRef =
        FirebaseFirestore.instance.collection("Teams").doc(uid);

    teamRef.get().then((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data is Map<String, dynamic>) {
          fetchedData = data;
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
            // print('destination: $destination');
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
        FirebaseFirestore.instance.collection("Teams").doc(uid);

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
            // print('origin: $origin');
            getDistances(origin, destination);
          });
        }
      }
    }).catchError((e) {
      print('Error fetching team data: $e');
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
        // print(walkingResponse
        //     .body); // Print the complete response body for debugging

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
        // print(
        //     carResponse.body); // Print the complete response body for debugging

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
    // if (!distancesFetched) {
    //   return Center(child: CircularProgressIndicator());
    // } else {
    if (fetchedData != null){
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
                    color: Colors.transparent,
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
                                color: Colors.transparent,
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
                              color: Colors.transparent,
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
                              color: Colors.transparent,
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
                              color: Colors.transparent,
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
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  basicInfoControllers[0].text,
                  style: TextStyle(
                    color: Color(0xFF212121),
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
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Color(0xFF424242),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            uid: widget.uid,
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
        selectedItemColor: Color.fromRGBO(17, 86, 149, 1),
        showUnselectedLabels: true,
        // selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedIconTheme: const IconThemeData(
          color: Colors.black38,
        ),
        unselectedItemColor: Colors.black38,
        items: <BottomNavigationBarItem>[
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
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
      floatingActionButton: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color.fromRGBO(17, 86, 149, 1),
            width: 2,
          ),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(17, 86, 149, 1),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const EditProfilePage()),
            );
          },
          child: Text(
            profileScreen['editProfileBtn']!,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );}
    else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
  }}

  Widget buildTrialInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft, // Align the value to the right
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF212121),
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
      width: MediaQuery.of(context).size.width * 0.2,
      height: 24,
      margin: const EdgeInsets.only(top: 0, right: 10, bottom: 8),
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
