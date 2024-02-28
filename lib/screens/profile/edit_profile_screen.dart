// ignore_for_file: deprecated_member_use
import "package:ai_match_making_app/screens/Base/home_screen.dart";
import "package:ai_match_making_app/screens/profile/pick_location.dart";
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "dart:io";
import "package:ai_match_making_app/utils/conversion.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import "package:image_picker/image_picker.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:ai_match_making_app/screens/profile/util_classes.dart';
import "package:ai_match_making_app/screens/profile/profile_screen.dart";
import 'package:ai_match_making_app/utils/constants.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);
  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  String currentID = getCurrentUID();
  int _selectedIndex = 3;

  List<File?> _imageFiles = List.generate(5, (_) => null);
  List<String?> _uploadedImageUrls = List.generate(5, (_) => null);
  String uid = getCurrentUID();
  double? latitude;
  double? langitude;
  
  double? finallatitude;
  double? finallong;
  String? street;
  String? pincode;
  String? city;
  String? prefecture;

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

  Future<void> _pickImage(int index, double height, double width) async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final double aspectRatio = width / height;
    print(aspectRatio);

    if (pickedImage != null) {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: CropAspectRatio(
            ratioX: aspectRatio, ratioY: 1.0), // Fixed aspect ratio
        compressQuality: 100, // Image quality after cropping (0 to 100)
        maxHeight: height.toInt(), // Fixed maximum height
        maxWidth: width.toInt(), // Fixed maximum width
        cropStyle:
            CropStyle.rectangle, // Use CropStyle.circle for circular cropping
      );

      if (croppedImage != null) {
        setState(() {
          _imageFiles[index] = File(croppedImage.path);
        });
      } else {
        // Handle the case when cropping is canceled or fails
        // You can display an error message or perform any desired action
        print('Image cropping canceled or failed.');
      }
    } else {
      // Handle the case when no image is picked
      // You can display an error message or perform any desired action
      print('No image picked.');
    }
  }

  Future<void> _uploadImage(int index) async {
    if (_imageFiles[index] == null) {
      return;
    }

    final firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child(_imageFiles[index]!.path);
    final firebase_storage.UploadTask uploadTask =
        storageRef.putFile(_imageFiles[index]!);
    await uploadTask.whenComplete(() => null);

    // Get the image download URL
    final String downloadURL = await storageRef.getDownloadURL();

    User? user = FirebaseAuth.instance.currentUser;
    final imagesCollection =
        FirebaseFirestore.instance.collection("Teams").doc(user?.uid);

    final List<String?> updatedUrls = List<String?>.from(_uploadedImageUrls);
    if (_imageFiles[index] != null) {
      updatedUrls[index] = downloadURL;
      Map<String, dynamic> updateData = {
        'images.$index': updatedUrls[index],
      };
      imagesCollection.update(updateData);
    }
  }

  Future<void> convertFirstHomeGroundToLatLng() async {
    String api = apiKey; // Replace with your Google Geocoding API key
    String street = firstHomeControllers[2].text;
    String prefecture = separate(firstHomeControllers[1].text)[0];
    String city = separate(firstHomeControllers[1].text)[1];
    String pincode = firstHomeControllers[0].text;

    String address = '$street, $prefecture, $pincode';

    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$api';

    try {
      var response = await http.get(Uri.parse(url));
      var data = json.decode(response.body);

      if (data['status'] == 'OK') {
        var results = data['results'];
        var location = results[0]['geometry']['location'];
        latitude = location['lat'];
        langitude = location['lng'];
        print('latitude: $latitude');
        print('longitude: $langitude');

        // Update the latitude and longitude values in Firebase
        // String uid = getCurrentUID();
        // await FirebaseFirestore.instance.collection("Teams").doc(uid).update({
        //   'basicInfo.schoolAddress.lat': latitude,
        //   'basicInfo.schoolAddress.lang': longitude
        // });
      } else {
        print('Error: Unable to convert address to coordinates');
      }
    } catch (e) {
      print('Error converting address to coordinates: $e');
    }
  }

  double currentSliderVal = 50;
  String sliderText = sliderLevelsJap[2];
  void handleSliderChanged(double value) {
    // Update the sliderValue when the slider changes
    currentSliderVal = value;
    sliderText = sliderLevelsJap[(currentSliderVal ~/ 25)];
    // Do any additional processing or update the UI as needed
  }

  TextEditingController sliderController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  List<TextEditingController> firstHomeControllers =
      List.generate(5, (index) => TextEditingController());
  List<TextEditingController> secondHomeControllers =
      List.generate(5, (index) => TextEditingController());
  List<TextEditingController> thirdHomeControllers =
      List.generate(5, (index) => TextEditingController());
  List<TextEditingController> teamCompositionControllers =
      List.generate(13, (index) => TextEditingController());
  List<TextEditingController> basicInfoControllers =
      List.generate(3, (index) => TextEditingController());
  List<TextEditingController> schoolAddressControllers =
      List.generate(5, (index) => TextEditingController());

  Map<String, dynamic>? fetchedData;
  late List<String> selectedAddress;
  String? selectedAddress1;
  Map<String, dynamic> markerDetails = {};

  // void handleAddressSelected(String? address) {
  //   setState(() {
  //     selectedAddress = address;
  //   });
  // }

  List<String> initValues = List.generate(11, (index) => "");

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

  void updateData() async {
    if (markerDetails.isNotEmpty){
                
                firstHomeControllers[2].text = markerDetails['street'];
                firstHomeControllers[1].text = markerDetails['prefecture'];
                firstHomeControllers[0].text= markerDetails['pincode'];
              }else{
                firstHomeControllers[0].text =
        fetchedData!['homeGround']['firstHomeGround']['pincode'] ?? " ";
        firstHomeControllers[1].text = fetchedData!['homeGround']['firstHomeGround']
            ['address']['prefecture'] + "," + fetchedData!['homeGround']['firstHomeGround']
            ['address']['city']??
        " ";
    firstHomeControllers[2].text = fetchedData!['homeGround']['firstHomeGround']
            ['address']['street'] ??
        " ";
              }
    initValues[0] = fetchedData!['homeGround']['firstHomeGround']
            ['parkingAvailability']
        ? matCondParkingSlotJap[0]
        : matCondParkingSlotJap[1];
    initValues[1] = fetchedData!['homeGround']['secondHomeGround']
            ['parkingAvailability']
        ? matCondParkingSlotJap[0]
        : matCondParkingSlotJap[1];
    initValues[2] = fetchedData!['homeGround']['thirdHomeGround']
            ['parkingAvailability']
        ? matCondParkingSlotJap[0]
        : matCondParkingSlotJap[1];
    initValues[3] =
        fetchedData!['teamComposition']['type'] ?? schoolLevelOptionsJap[0];
    // initValues[4] = "one year old";
    // initValues[5] = "two year old";
    // initValues[6] = "triennial";
    // initValues[7] = "four year old";
    // initValues[8] = "five year old";
    // initValues[9] = "six year old";
    initValues[10] = fetchedData!['basicInfo']['schoolAddress']
            ['parkingAvailability']
        ? matCondParkingSlotJap[0]
        : matCondParkingSlotJap[1];

    
    
    firstHomeControllers[3].text = fetchedData!['homeGround']['firstHomeGround']
            ['parkingAvailability']
        ? matCondParkingSlotJap[0]
        : matCondParkingSlotJap[1];
    firstHomeControllers[4].text =
        fetchedData!['homeGround']['firstHomeGround']['nearestStation'] ?? " ";

    secondHomeControllers[0].text =
        fetchedData!['homeGround']['secondHomeGround']['pincode'] ?? " ";
    secondHomeControllers[1].text = fetchedData!['homeGround']
            ['secondHomeGround']['address']['prefecture'] + "," + fetchedData!['homeGround']
            ['secondHomeGround']['address']['city'] ??
        " ";
    secondHomeControllers[2].text = fetchedData!['homeGround']
            ['secondHomeGround']['address']['street'] ??
        " ";
    secondHomeControllers[3].text = fetchedData!['homeGround']
            ['secondHomeGround']['parkingAvailability']
        ? matCondParkingSlotJap[0]
        : matCondParkingSlotJap[1];
    secondHomeControllers[4].text =
        fetchedData!['homeGround']['secondHomeGround']['nearestStation'] ?? " ";

    thirdHomeControllers[0].text =
        fetchedData!['homeGround']['thirdHomeGround']['pincode'] ?? " ";
    thirdHomeControllers[1].text = fetchedData!['homeGround']['thirdHomeGround']
            ['address']['prefecture'] + "," + fetchedData!['homeGround']['thirdHomeGround']
            ['address']['city'] ??
        " ";
    thirdHomeControllers[2].text = fetchedData!['homeGround']['thirdHomeGround']
            ['address']['street'] ??
        " ";
    thirdHomeControllers[3].text = fetchedData!['homeGround']['thirdHomeGround']
            ['parkingAvailability']
        ? matCondParkingSlotJap[0]
        : matCondParkingSlotJap[1];
    thirdHomeControllers[4].text =
        fetchedData!['homeGround']['thirdHomeGround']['nearestStation'] ?? " ";

    teamCompositionControllers[0].text =
        fetchedData!['teamComposition']['type'] ?? schoolLevelOptionsJap[0];
    teamCompositionControllers[1].text = academicYearOptionsJap[0];
    teamCompositionControllers[2].text =
        fetchedData!['teamComposition']['1stGradeMembers'].toString();
    teamCompositionControllers[3].text = academicYearOptionsJap[1];
    teamCompositionControllers[4].text =
        fetchedData!['teamComposition']['2ndGradeMembers'].toString();
    teamCompositionControllers[5].text = academicYearOptionsJap[2];
    teamCompositionControllers[6].text =
        fetchedData!['teamComposition']['3rdGradeMembers'].toString();
    teamCompositionControllers[7].text = academicYearOptionsJap[3];
    teamCompositionControllers[8].text =
        fetchedData!['teamComposition']['4thGradeMembers'].toString();
    teamCompositionControllers[9].text = academicYearOptionsJap[4];
    teamCompositionControllers[10].text =
        fetchedData!['teamComposition']['5thGradeMembers'].toString();
    teamCompositionControllers[11].text = academicYearOptionsJap[5];
    teamCompositionControllers[12].text =
        fetchedData!['teamComposition']['6thGradeMembers'].toString();

    bioController.text = fetchedData!['basicInfo']['bio'] ?? " ";

    basicInfoControllers[0].text =
        fetchedData!['basicInfo']['schoolName'] ?? " ";
    basicInfoControllers[1].text =
        fetchedData!['basicInfo']['representativeName'] ?? " ";
    basicInfoControllers[2].text =
        fetchedData!['basicInfo']['totalMembers'] ?? " ";

    schoolAddressControllers[0].text =
        fetchedData!['basicInfo']['schoolAddress']['pincode'] ?? " ";
    schoolAddressControllers[1].text =
        fetchedData!['basicInfo']['schoolAddress']['prefecture'] ?? " ";
    schoolAddressControllers[2].text =
        fetchedData!['basicInfo']['schoolAddress']['city'] ?? " ";
    schoolAddressControllers[3].text = fetchedData!['basicInfo']
            ['schoolAddress']['parkingAvailability']
        ? "Set"
        : "Unset";
    schoolAddressControllers[4].text =
        fetchedData!['basicInfo']['schoolAddress']['nearestStation'] ?? " ";

    currentSliderVal =
        ((fetchedData!['basicInfo']['teamLevel'] - 1) * 25).toDouble();
    sliderText = sliderLevelsJap[(currentSliderVal ~/ 25)];
    await convertFirstHomeGroundToLatLng();
  }

  // ignore: no_leading_underscores_for_local_identifiers
Widget _buildImageContainer(double width, double height, int index) {
  bool hasImage = _imageFiles[index] != null ||
      (fetchedData != null &&
          fetchedData!['images'] != null &&
          fetchedData!['images']['$index'] != null);

  return Container(
    height: (height.toInt()).toDouble(),
    width: (width.toInt()).toDouble(),
    decoration: BoxDecoration(
      // color: hasImage ? Colors.transparent : Colors.grey,
      borderRadius: BorderRadius.circular(5),
      
    ),
    child: ElevatedButton(
      onPressed: () => _pickImage(index, height, width),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: hasImage ? Colors.transparent : Colors.grey,
      ),
      child: _imageFiles[index] != null
          ? Image.file(
              _imageFiles[index]!,
              width: width,
              height: height,
              fit: BoxFit.cover,
            )
          : Stack(
              children: [
                if (fetchedData != null &&
                    fetchedData!['images'] != null &&
                    fetchedData!['images']['$index'] != null)
                  Image.network(
                    fetchedData!['images']['$index'] ?? '',
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                  ),
                const Align(alignment: Alignment.center, child: Icon(Icons.add)),
              ],
            ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    String user = getCurrentUID();
    List<String> imageUrls = [];

    if (fetchedData != null) {
      updateData();
      ScreenUtil.init(context);
      return Scaffold(
        body: ListView(children: [
          Padding(
              padding: const EdgeInsets.all(3.0),
              child: _buildImageContainer(
                  MediaQuery.of(context).size.width * multiplier * 375,
                  MediaQuery.of(context).size.width * multiplier * 200,
                  0)),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildImageContainer(
                    MediaQuery.of(context).size.width * multiplier * 80,
                    MediaQuery.of(context).size.width * multiplier * 45,
                    1),
                _buildImageContainer(
                    MediaQuery.of(context).size.width * multiplier * 80,
                    MediaQuery.of(context).size.width * multiplier * 45,
                    2),
                _buildImageContainer(
                    MediaQuery.of(context).size.width * multiplier * 80,
                    MediaQuery.of(context).size.width * multiplier * 45,
                    3),
                _buildImageContainer(
                    MediaQuery.of(context).size.width * multiplier * 80,
                    MediaQuery.of(context).size.width * multiplier * 45,
                    4),
              ],
            ),
          ),
          homeGroundWidget1(context, editProfile['firstHomeGround']!,
              homeTextJapanese, firstHomeControllers, initValues[0],
              (details) {
              setState(() {
                markerDetails = details;
              });
            },),
          homeGroundWidget(
            editProfile['secondHomeGround']!,
            homeTextJapanese,
            secondHomeControllers,
            initValues[1],
          ),
          homeGroundWidget(editProfile['thirdHomeGround']!, homeTextJapanese,
              thirdHomeControllers, initValues[2]),
          Padding(
            padding: const EdgeInsets.all(5),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: Text(
                  editProfile['myTeamLevel']!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              SliderCard(
                sliderLevels: sliderLevelsJap,
                currentSliderVal: currentSliderVal,
                onSliderChanged: handleSliderChanged,
              ),
            ]),
          ),
          TeamCompCard(
              text: editProfile['teamComposition']!,
              tec: teamCompositionControllers,
              initText: initValues[3]),
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 5),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  editProfile['bio']!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  editProfile['bioWordLimit']!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Card(
                child: TextField(
                  controller: bioController,
                  maxLength: 300,
                  style: const TextStyle(color: Color.fromRGBO(17, 86, 149, 1)),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  editProfile['basicInfo']!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                listText(basicInfoControllers.sublist(0, 2), [
                  editProfile['schoolNteams']!,
                  editProfile['representativeName']!
                ]),
                TextField(
                  controller: basicInfoControllers[2],
                  style: const TextStyle(color: Color.fromRGBO(17, 86, 149, 1)),
                  decoration: InputDecoration(
                      labelText: editProfile['numberOfMembers']!),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      editProfile['settingSchoolAddress']!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    listText(schoolAddressControllers.sublist(0, 3),
                        homeTextJapanese.sublist(0, 3)),
                    InputFieldWithOptions(
                      options: matCondParkingSlotJap,
                      labelText: homeTextJapanese[3],
                      optionController: schoolAddressControllers[3],
                      initOption: initValues[10],
                    ),
                    boxText(
                        text: homeTextJapanese[4],
                        textController: schoolAddressControllers[4]),
                  ])),
          const SizedBox(
            height: 80,
          )
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
        floatingActionButton: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              // foregroundColor: Colors.black,
              backgroundColor: const Color.fromRGBO(17, 86, 149, 1),
            ),
            onPressed: () async {
              _uploadImage(1);
              _uploadImage(2);
              _uploadImage(3);
              _uploadImage(4);
              _uploadImage(0);
              print(markerDetails);
              String uid = getCurrentUID();
              String firstHomeGroundPincode = fetchedData!['homeGround']
                      ['firstHomeGround']['pincode'] ??
                  " ";
              String firstHomeGroundPrefecture = fetchedData!['homeGround']
                      ['firstHomeGround']['address']['prefecture'] ??
                  " ";
              String firstHomeGroundStreet = fetchedData!['homeGround']
                      ['firstHomeGround']['address']['street'] ??
                  " ";

              if (firstHomeGroundPincode != firstHomeControllers[0].text ||
                  firstHomeGroundPrefecture != firstHomeControllers[1].text ||
                  firstHomeGroundStreet != firstHomeControllers[2].text) {
                // Address values have changed, call convertFirstHomeGroundToLatLng()
                await convertFirstHomeGroundToLatLng();
              }

              // if (firstHomeGroundPincode != firstHomeControllers[0].text ||
              //     firstHomeGroundPrefecture != firstHomeControllers[1].text ||
              //     firstHomeGroundStreet != firstHomeControllers[2].text) {
              //   // Address values have changed, call convertFirstHomeGroundToLatLng()
              //   convertFirstHomeGroundToLatLng();
              // }
              if (markerDetails.isNotEmpty){
                
                finallatitude = markerDetails['latitude'];
                finallong = markerDetails['longitude'];
                street= markerDetails['street'];
                firstHomeControllers[2].text = markerDetails['street'];
                prefecture = markerDetails['prefecture'];
                firstHomeControllers[1].text = markerDetails['prefecture'];
                pincode= markerDetails['pincode'];
                firstHomeControllers[0].text= markerDetails['pincode'];
              }else{
                finallatitude = latitude;
                finallong = langitude;
                street= firstHomeControllers[2].text;
                prefecture = separate(firstHomeControllers[1].text)[0];
                city = separate(firstHomeControllers[1].text)[1];
                pincode= firstHomeControllers[0].text;
              }
      // if (markerDetails.isNotEmpty) 'lang': markerDetails['longitude'],
      // else 'lang': longitude,
              DocumentReference teamRef =
                  FirebaseFirestore.instance.collection("Teams").doc(uid);

              // Create a new map with the additional fields for the current team
              Map<String, dynamic> newData = {
                'basicInfo': {
                  'bio': bioController.text,
                  'matchFrequency': 'Everyday',
                  'representativeName': basicInfoControllers[1].text,
                  'schoolAddress': {
                    'city': schoolAddressControllers[2].text,
                    'nearestStation': schoolAddressControllers[4].text,
                    'parkingAvailability': schoolAddressControllers[3].text ==
                            matCondParkingSlotJap[0]
                        ? true
                        : false,
                    'pincode': schoolAddressControllers[0].text,
                    'prefecture': schoolAddressControllers[1].text,
                    'lat': finallatitude,
                    'lang': finallong,
                  },
                  'schoolName': basicInfoControllers[0].text,
                  'teamLevel': (currentSliderVal ~/ 25) + 1,
                  'totalMembers': basicInfoControllers[2].text,
                  'loss': fetchedData!['basicInfo']['loss'] ?? 0,
                  'win': fetchedData!['basicInfo']['win'] ?? 0,
                },
                'homeGround': {
                  'firstHomeGround': {
                    'address': {
                      'city': city,
                      'prefecture': prefecture,
                      'street': street,
                    },
                    'geoLocation': "",
                    'nearestStation': firstHomeControllers[4].text,
                    'parkingAvailability':
                        firstHomeControllers[3].text == matCondParkingSlotJap[0]
                            ? true
                            : false,
                    'pincode': pincode,
                    'priority': true,
                  },
                  'secondHomeGround': {
                    'address': {
                      'city': separate(secondHomeControllers[1].text)[1],
                      'prefecture': separate(secondHomeControllers[1].text)[0],
                      'street': secondHomeControllers[2].text,
                    },
                    'geoLocation': "",
                    'nearestStation': secondHomeControllers[4].text,
                    'parkingAvailability': secondHomeControllers[3].text ==
                            matCondParkingSlotJap[0]
                        ? true
                        : false,
                    'pincode': secondHomeControllers[0].text,
                    'priority': true,
                  },
                  'thirdHomeGround': {
                    'address': {
                      'city': separate(thirdHomeControllers[1].text)[1],
                      'prefecture': separate(thirdHomeControllers[1].text)[0],
                      'street': thirdHomeControllers[2].text,
                    },
                    'geoLocation': "",
                    'nearestStation': thirdHomeControllers[4].text,
                    'parkingAvailability':
                        thirdHomeControllers[3].text == matCondParkingSlotJap[0]
                            ? true
                            : false,
                    'pincode': thirdHomeControllers[0].text,
                    'priority': true,
                  },
                },
                // 'images': FieldValue.arrayUnion(imageUrls),
                'teamComposition': {
                  "1stGradeMembers": value(
                      teamCompositionControllers, academicYearOptionsJap[0]),
                  "2ndGradeMembers": value(
                      teamCompositionControllers, academicYearOptionsJap[1]),
                  "3rdGradeMembers": value(
                      teamCompositionControllers, academicYearOptionsJap[2]),
                  "4thGradeMembers": value(
                      teamCompositionControllers, academicYearOptionsJap[3]),
                  "5thGradeMembers": value(
                      teamCompositionControllers, academicYearOptionsJap[4]),
                  "6thGradeMembers": value(
                      teamCompositionControllers, academicYearOptionsJap[5]),
                  "teamGrade": "",
                  "type": teamCompositionControllers[0].text,
                }
              };

              try {
                teamRef.update(newData);
                print(imageUrls);
              } catch (error) {
                print('Error adding new data to the current team: $error');
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MyProfilePage(
                          uid: user,
                        )),
              );
            },
            child: Text(
              editProfile['saveYourProfileBtn']!,
              style: const TextStyle(
                color: Colors.white,
                // fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

Content homeGroundWidget1(
    BuildContext context,
    String text,
    List<String> contentText,
    List<TextEditingController> contentControllers,
    String initValue,
    void Function(Map<String, dynamic>) markerDetailsCallback,) {
  Map<String, dynamic> selectedAddress={};
  return Content(
    text: text,
    childrens: [
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: listText(
            contentControllers.sublist(0, 3), contentText.sublist(0, 3)),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: InputFieldWithOptions(
          options: matCondParkingSlotJap,
          labelText: contentText[3],
          optionController: contentControllers[3],
          initOption: initValue,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: boxText(
            text: contentText[4], textController: contentControllers[4]),
      ),
      Builder(
        builder: (BuildContext builderContext) {
          // var selectedAddress1;
          return GestureDetector(
            onTap: () async {
              selectedAddress = await Navigator.push(
                builderContext,
                MaterialPageRoute(builder: (context) => PickLocation()),
              );
              if (selectedAddress != null) {
                double latitude = selectedAddress['latitude'];
                double longitude = selectedAddress['longitude'];
                String address = selectedAddress['address'];
                String street = selectedAddress['street'];
                String prefecture = selectedAddress['prefecture'];
                String pincode = selectedAddress['pincode'];

                Map<String, dynamic> markerDetails = {
                  'latitude': latitude,
                  'longitude': longitude,
                  'address': address,
                  'street': street,
                  'prefecture': prefecture,
                  'pincode': pincode,
                };

                // Call the callback function with the marker details
                markerDetailsCallback(markerDetails);
 
              }


              // selectedAddress1 = selectedAddress ?? '';
              print("add: $selectedAddress");
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Text(selectedAddress.isNotEmpty ? 'findAnAdd' : 'google mapで指定する'),
                ],
              ),
            ),
          );
        },
      ),
      if ((selectedAddress.isNotEmpty))
        Container(
          padding: const EdgeInsets.only(top: 8),
          // decoration: BoxDecoration(
          //   border: Border.all(color: Colors.grey),
          //   borderRadius: BorderRadius.circular(4),
          // ),
          child: Text(selectedAddress['address']),
        ),
    ],
  );
}

class Content1 extends StatefulWidget {
  final String text;
  final dynamic childrens;
  const Content1({Key? key, required this.text, required this.childrens})
      : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _ContentBuilder1 createState() => _ContentBuilder1();
}

class _ContentBuilder1 extends State<Content> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Card(
        child: ExpansionTile(
          tilePadding: const EdgeInsets.only(left: 4),
          title: Text(
            widget.text,
            style: const TextStyle(color: Colors.black),
          ),
          trailing: _isExpanded
              ? const Icon(
                  Icons.remove,
                  color: Colors.black,
                )
              : const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
          onExpansionChanged: (bool expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          children: widget.childrens,
        ),
      ),
    );
  }
}
