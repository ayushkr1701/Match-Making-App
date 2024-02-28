import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import "package:cloud_firestore/cloud_firestore.dart";
import "package:ai_match_making_app/screens/profile/util_classes.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:image_cropper/image_cropper.dart';
import "package:image_picker/image_picker.dart";
import 'package:ai_match_making_app/screens/onboarding/onboarding_reusable_widgets.dart';
import 'package:ai_match_making_app/utils/constants.dart';
import 'package:ai_match_making_app/screens/onboarding/matchingcondition_onboard.dart';
import 'package:ai_match_making_app/screens/onboarding/signup_onboard.dart';

class BasicInfoSchool extends StatefulWidget {
  const BasicInfoSchool({super.key});
  @override
  BasicInfoSchoolBuilder createState() => BasicInfoSchoolBuilder();
}

class BasicInfoSchoolBuilder extends State<BasicInfoSchool> {
  String textError = "";
  TextEditingController classTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void onPressedFunction1() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SignUpOnboard()));
    }

    void onPressedFunction2() {
      if (classTextController.text.isEmpty) {
        setState(() {
          textError = "The input field can't be empty !";
        });
      } else {
        String uid = getCurrentUID();
        DocumentReference teamRef =
            FirebaseFirestore.instance.collection("Teams").doc(uid);

        Map<String, dynamic> newData = {
          "basicInfo.schoolName": classTextController.text,
        };

        try {
          teamRef.update(newData);
        } catch (error) {
          print('Error updating field: $error');
        }
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const RepName()));
      }
    }

    return onboardPage(signupOnboard['basicInfo']!, 1, 8, onPressedFunction1,
        onPressedFunction2, [
      Padding(
        padding: const EdgeInsets.only(left: 5, top: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              signupOnboard['schoolNteams']!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Card(
            child: TextField(
              controller: classTextController,
              style: const TextStyle(color: Color.fromRGBO(17, 86, 149, 1)),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                textError,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  // fontFamily: 'Arial',
                  // fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  height: 2,
                  // textAlign:
                ),
              ),
            ),
          ),
        ]),
      ),
    ]);
  }
}

class RepName extends StatefulWidget {
  const RepName({super.key});
  @override
  RepNameBuilder createState() => RepNameBuilder();
}

class RepNameBuilder extends State<RepName> {
  String textError = "";
  TextEditingController classTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void onPressedFunction1() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const BasicInfoSchool()));
    }

    void onPressedFunction2() {
      if (classTextController.text.isEmpty) {
        setState(() {
          textError = "The input field can't be empty !";
        });
      } else {
        String uid = getCurrentUID();
        DocumentReference teamRef =
            FirebaseFirestore.instance.collection("Teams").doc(uid);

        Map<String, dynamic> newData = {
          "basicInfo.representativeName": classTextController.text,
        };

        try {
          teamRef.update(newData);
        } catch (error) {
          print('Error updating field: $error');
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const TeamLevel()));
      }
    }

    return onboardPage(signupOnboard['basicInfo']!, 2, 8, onPressedFunction1,
        onPressedFunction2, [
      Padding(
        padding: const EdgeInsets.only(left: 5, top: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              signupOnboard['representativeName']!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Card(
            child: TextField(
              controller: classTextController,
              style: const TextStyle(color: Color.fromRGBO(17, 86, 149, 1)),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                textError,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  // fontFamily: 'Arial',
                  // fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  height: 2,
                  // textAlign:
                ),
              ),
            ),
          ),
        ]),
      ),
    ]);
  }
}

class TeamLevel extends StatefulWidget {
  const TeamLevel({super.key});
  @override
  TeamLevelBuilder createState() => TeamLevelBuilder();
}

class TeamLevelBuilder extends State<TeamLevel> {
  TextEditingController classTextController = TextEditingController();
  double currentSliderVal = 50;
  String sliderText = sliderLevelsJap[2];
  void handleSliderChanged(double value) {
    // Update the sliderValue when the slider changes
    currentSliderVal = value;
    sliderText = sliderLevelsJap[(currentSliderVal ~/ 25)];
    // Do any additional processing or update the UI as needed
  }

  @override
  Widget build(BuildContext context) {
    void onPressedFunction1() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const RepName()));
    }

    void onPressedFunction2() {
      String uid = getCurrentUID();
      DocumentReference teamRef =
          FirebaseFirestore.instance.collection("Teams").doc(uid);

      Map<String, dynamic> newData = {
        "basicInfo.teamLevel": (currentSliderVal ~/ 25) + 1,
      };

      try {
        teamRef.update(newData);
      } catch (error) {
        print('Error updating field: $error');
      }
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const TeamComposition()));
    }

    return onboardPage(signupOnboard['basicInfo']!, 3, 8, onPressedFunction1,
        onPressedFunction2, [
      Padding(
        padding: const EdgeInsets.all(5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              signupOnboard['myTeamLevel']!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          SliderCard(
            sliderLevels: sliderLevelsJap,
            currentSliderVal: currentSliderVal,
            onSliderChanged: handleSliderChanged,
          ),
        ]),
      ),
    ]);
  }
}

class TeamComposition extends StatefulWidget {
  const TeamComposition({super.key});
  @override
  TeamCompositionBuilder createState() => TeamCompositionBuilder();
}

class TeamCompositionBuilder extends State<TeamComposition> {
  String textError = "";
  String? selectedOption;
  void handleOptionSelected(String option) {
    // Do something with the selected option
    selectedOption = option;
  }

  @override
  Widget build(BuildContext context) {
    void onPressedFunction1() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const TeamLevel()));
    }

    void onPressedFunction2() {
      if (selectedOption == null) {
        setState(() {
          textError = "Please select an option !";
        });
      } else {
        String uid = getCurrentUID();
        DocumentReference teamRef =
            FirebaseFirestore.instance.collection("Teams").doc(uid);

        Map<String, dynamic> newData = {
          "teamComposition.type": selectedOption,
        };

        try {
          teamRef.update(newData);
        } catch (error) {
          print('Error updating field: $error');
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const TeamCompMembers()));
      }
    }

    return onboardPage(signupOnboard['basicInfo']!, 4, 8, onPressedFunction1,
        onPressedFunction2, [
      Padding(
        padding: const EdgeInsets.all(5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              signupOnboard['teamComposition']!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          ButtonCard(onOptionSelected: handleOptionSelected, options: const [
            [
              "小学生・軟式",
              "小学生・硬式",
            ],
            [
              "中学生・軟式",
              "中学生・硬式",
            ],
            [
              "高校生・軟式",
              "高校生・硬式",
            ],
            ["大学生・軟式", "大学生・硬式"],
            ["大学生・準硬式", "草野球"],
            ["社会人・軟式", "社会人・硬式"]
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                textError,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  // fontFamily: 'Arial',
                  // fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  height: 2,
                  // textAlign:
                ),
              ),
            ),
          ),
        ]),
      ),
    ]);
  }
}

class TeamCompMembers extends StatefulWidget {
  const TeamCompMembers({super.key});
  @override
  TeamCompMembersBuilder createState() => TeamCompMembersBuilder();
}

class TeamCompMembersBuilder extends State<TeamCompMembers> {
  Map<String, dynamic>? fetchedData;
  String currentEduLevel = "Grass ball";
  List<String> currentOptions = ["Number of peoples"];
  List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());

  List<String> options(String str) {
    List<String> optionsStr = ["Number of peoples"];
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

  void update() {
    currentEduLevel = fetchedData!['teamComposition']['type'];
    currentOptions = options(currentEduLevel);
  }

  @override
  Widget build(BuildContext context) {
    void onPressedFunction1() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const TeamComposition()));
    }

    void onPressedFunction2() {
      String uid = getCurrentUID();
      DocumentReference teamRef =
          FirebaseFirestore.instance.collection("Teams").doc(uid);

      Map<String, dynamic> newData = {
        "teamComposition.1stGradeMembers":
            controllers[0].text.isEmpty ? 0 : int.parse(controllers[0].text),
        "teamComposition.2ndGradeMembers":
            controllers[1].text.isEmpty ? 0 : int.parse(controllers[1].text),
        "teamComposition.3rdGradeMembers":
            controllers[2].text.isEmpty ? 0 : int.parse(controllers[2].text),
        "teamComposition.4thGradeMembers":
            controllers[3].text.isEmpty ? 0 : int.parse(controllers[3].text),
        "teamComposition.5thGradeMembers":
            controllers[4].text.isEmpty ? 0 : int.parse(controllers[4].text),
        "teamComposition.6thGradeMembers":
            controllers[5].text.isEmpty ? 0 : int.parse(controllers[5].text),
      };

      try {
        teamRef.update(newData);
      } catch (error) {
        print('Error updating field: $error');
      }
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeGround()));
    }

    if (fetchedData != null) {
      update();
      return onboardPage(
          "Basic Information", 5, 8, onPressedFunction1, onPressedFunction2, [
        Padding(
          padding: const EdgeInsets.all(5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(5),
              child: Text(
                "Team composition (number of people per $currentEduLevel)",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            CreateCardList(
                options: currentOptions,
                controllers: controllers,
                rightText: "people"),
          ]),
        ),
      ]);
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

class HomeGround extends StatefulWidget {
  const HomeGround({super.key});
  @override
  HomeGroundBuilder createState() => HomeGroundBuilder();
}

class HomeGroundBuilder extends State<HomeGround> {
  String textError = "* required field";
  double? latitude;
  double? langitude;
  List<TextEditingController> classFirstControllers =
      List.generate(5, (index) => TextEditingController());
  List<TextEditingController> classSecondControllers =
      List.generate(5, (index) => TextEditingController());
  List<TextEditingController> classThirdControllers =
      List.generate(5, (index) => TextEditingController());

  Future<void> convertFirstHomeGroundToLatLng() async {
    String api = apiKey; // Replace with your Google Geocoding API key
    String street = classFirstControllers[2].text;
    String prefecture = classFirstControllers[1].text;
    String pincode = classFirstControllers[0].text;

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

  @override
  Widget build(BuildContext context) {
    void onPressedFunction1() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const TeamCompMembers()));
    }

    void onPressedFunction2() async {
      if (classFirstControllers[0].text.isEmpty ||
          classFirstControllers[1].text.isEmpty ||
          classFirstControllers[2].text.isEmpty ||
          classFirstControllers[4].text.isEmpty) {
        setState(() {
          textError = "Required input field can't be empty !";
        });
      } else {
        await convertFirstHomeGroundToLatLng();
        String uid = getCurrentUID();
        DocumentReference teamRef =
            FirebaseFirestore.instance.collection("Teams").doc(uid);

        Map<String, dynamic> newData = {
          'basicInfo.schoolAddress.lat': latitude,
          'basicInfo.schoolAddress.lang': langitude,
          'homeGround.firstHomeGround.address.city':
              classFirstControllers[1].text,
          'homeGround.firstHomeGround.address.prefecture':
              classFirstControllers[1].text,
          'homeGround.firstHomeGround.address.street':
              classFirstControllers[2].text,
          'homeGround.firstHomeGround.geoLocation': "",
          'homeGround.firstHomeGround.nearestStation':
              classFirstControllers[4].text,
          'homeGround.firstHomeGround.parkingAvailability':
              classFirstControllers[3].text == matCondParkingSlotJap[0]
                  ? true
                  : false,
          'homeGround.firstHomeGround.pincode': classFirstControllers[0].text,
          'homeGround.firstHomeGround.priority': true,
          'homeGround.secondHomeGround.address.city':
              classSecondControllers[1].text,
          'homeGround.secondHomeGround.address.prefecture':
              classSecondControllers[1].text,
          'homeGround.secondHomeGround.address.street':
              classSecondControllers[2].text,
          'homeGround.secondHomeGround.geoLocation': "",
          'homeGround.secondHomeGround.nearestStation':
              classSecondControllers[4].text,
          'homeGround.secondHomeGround.parkingAvailability':
              classSecondControllers[3].text == matCondParkingSlotJap[0]
                  ? true
                  : false,
          'homeGround.secondHomeGround.pincode': classSecondControllers[0].text,
          'homeGround.secondHomeGround.priority': true,
          'homeGround.thirdHomeGround.address.city':
              classThirdControllers[1].text,
          'homeGround.thirdHomeGround.address.prefecture':
              classThirdControllers[1].text,
          'homeGround.thirdHomeGround.address.street':
              classThirdControllers[2].text,
          'homeGround.thirdHomeGround.geoLocation': "",
          'homeGround.thirdHomeGround.nearestStation':
              classThirdControllers[4].text,
          'homeGround.thirdHomeGround.parkingAvailability':
              classThirdControllers[3].text == matCondParkingSlotJap[0]
                  ? true
                  : false,
          'homeGround.thirdHomeGround.pincode': classThirdControllers[0].text,
          'homeGround.thirdHomeGround.priority': true,
        };
        try {
          teamRef.update(newData);
        } catch (error) {
          print('Error updating field: $error');
        }
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const OneWord()));
      }
    }

    return onboardPage(signupOnboard['basicInfo']!, 6, 8, onPressedFunction1,
        onPressedFunction2, [
      Padding(
        padding: const EdgeInsets.only(left: 5, top: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              profileScreen['homeGroundAdd']!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  // "* the distance to the opponent is from the first home ground, the distance between the two.",
                  "※相手チームまでの距離などは「第一ホームグラウンド」からの距離で表示されます",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  // "※ if there is no home ground, school address or frequently used",
                  "※ホームグラウンドがない場合、学校住所もしくはよく使う グラウンド住所を入力して下さい。",
                  style: TextStyle(fontSize: 14),
                ),
                // Text(
                //   "Please enter the ground address.",
                //   style: TextStyle(fontSize: 14),
                // ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          homeGroundWidget(signupOnboard['firstHomeGround']!, homeTextJapanese,
              classFirstControllers, "有り"),
          homeGroundWidget(signupOnboard['secondHomeGround']!, homeTextJapanese,
              classSecondControllers, "有り"),
          homeGroundWidget(signupOnboard['thirdHomeGround']!, homeTextJapanese,
              classThirdControllers, "有り"),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              textError,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ]),
      ),
    ]);
  }
}

class OneWord extends StatefulWidget {
  const OneWord({super.key});
  @override
  OneWordBuilder createState() => OneWordBuilder();
}

class OneWordBuilder extends State<OneWord> {
  String textError = "";
  TextEditingController classController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void onPressedFunction1() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeGround()));
    }

    void onPressedFunction2() {
      if (classController.text.length < 10) {
        setState(() {
          textError = " Input text is less than 10 words !";
        });
      } else {
        String uid = getCurrentUID();
        DocumentReference teamRef =
            FirebaseFirestore.instance.collection("Teams").doc(uid);

        Map<String, dynamic> newData = {
          "basicInfo.bio": classController.text,
        };

        try {
          teamRef.update(newData);
        } catch (error) {
          print('Error updating field: $error');
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ImagePage()));
      }
    }

    return onboardPage(signupOnboard['basicInfo']!, 7, 8, onPressedFunction1,
        onPressedFunction2, [
      Padding(
        padding: const EdgeInsets.only(left: 5, top: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              signupOnboard['oneWord']!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              signupOnboard['10to300']!,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Card(
            child: TextField(
              controller: classController,
              maxLength: 300,
              maxLines: null,
              style: const TextStyle(color: Color.fromRGBO(17, 86, 149, 1)),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                textError,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  // fontFamily: 'Arial',
                  // fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  height: 2,
                  // textAlign:
                ),
              ),
            ),
          ),
        ]),
      ),
    ]);
  }
}

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});
  @override
  ImagePageBuilder createState() => ImagePageBuilder();
}

class ImagePageBuilder extends State<ImagePage> {
  TextEditingController classController = TextEditingController();
  List<File?> _imageFiles = List.generate(5, (_) => null);
  List<String?> _uploadedImageUrls = List.generate(5, (_) => null);
  String textError = "";
  String uid = getCurrentUID();

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

  Map<String, dynamic>? fetchedData;
  @override
  void initState() {
    super.initState();
    fetchData();
    print('done');
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
                  const Align(
                      alignment: Alignment.center, child: Icon(Icons.add)),
                ],
              ),
      ),
    );
  }

  bool _isImageSelected() {
    return _imageFiles.any((file) => file != null);
  }

  @override
  Widget build(BuildContext context) {
    void onPressedFunction1() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const OneWord()));
    }

    void onPressedFunction2() {
      if (!_isImageSelected()) {
        // No image selected, show an error message or perform desired action
        setState(() {
          textError = "Please select an Image!";
        });
        return;
      }
      String uid = getCurrentUID();
      DocumentReference teamRef =
          FirebaseFirestore.instance.collection("Teams").doc(uid);

      // Map<String, dynamic> newData = {
      //   "images": []
      // };
      _uploadImage(0);
      // try {
      //   teamRef.update(newData);
      // } catch (error) {
      //   print('Error updating field: $error');
      // }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MatchingConditionOnboard()));
    }

    return onboardPage(signupOnboard['basicInfo']!, 8, 8, onPressedFunction1,
        onPressedFunction2, [
      Padding(
        padding: const EdgeInsets.only(left: 5, top: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              signupOnboard['pictureOfteam']!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(3.0),
              child: _buildImageContainer(
                  MediaQuery.of(context).size.width * multiplier * 375,
                  MediaQuery.of(context).size.width * multiplier * 200,
                  0)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                textError,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  // fontFamily: 'Arial',
                  // fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  height: 2,
                  // textAlign:
                ),
              ),
            ),
          ),

          // ImageBox widget here
        ]),
      ),
    ]);
  }
}
