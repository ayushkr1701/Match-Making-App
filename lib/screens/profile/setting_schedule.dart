import 'package:ai_match_making_app/screens/Base/home_screen.dart';
import 'package:ai_match_making_app/screens/profile/pick_location.dart';
import 'package:ai_match_making_app/screens/profile/util_classes.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SettingSchedulePage extends StatefulWidget {
  const SettingSchedulePage({Key? key}) : super(key: key);

  @override
  _SettingSchedulePageState createState() => _SettingSchedulePageState();
}

class _SettingSchedulePageState extends State<SettingSchedulePage> {
  String currentID = getCurrentUID();
  int _selectedIndex = 3;

  final List<String> matchingSettings = ['Automatic', 'Manual'];
  final List<String> matchingSettingsJap = ['自動', '手動'];

  final List<String> venues = ['Either way', 'Home hope', 'Away hope'];
  final List<String> venuesJap = ['どちらでも', 'ホーム希望', 'アウェイ（遠征）希望'];
  late int time;
  final List<String> homeDesignation = [
    'First home ground',
    'Second home ground',
    'Third home ground',
    'Specify on google map'
  ];
  final List<String> homeDesignationJap = [
    '第一ホームグラウンド',
    '第二ホームグラウンド',
    '第三ホームグラウンド',
    'google mapで指定する'
  ];
  final List<String> timeSlots = [
    '9:00 ~ 11:00',
    '11:00 ~ 13:00',
    '13:00 ~ 15:00'
  ];
  late TextEditingController matchsettingsController;
  late TextEditingController venueController;
  late TextEditingController homedesignationController;
  late TextEditingController timeSlotController;
  Set<String> selectedTimeSlots = Set<String>();
  DateTime? selectedDate;
  List<Map<String, dynamic>> scheduledMatches = [];

  var selectedAddress;
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
    matchsettingsController = TextEditingController();
    venueController = TextEditingController();
    homedesignationController = TextEditingController();
    timeSlotController = TextEditingController();
    fetchData();
  }

  @override
  void dispose() {
    matchsettingsController.dispose();
    venueController.dispose();
    homedesignationController.dispose();
    timeSlotController.dispose();
    super.dispose();
  }

  // Fetch scheduled matches from Firestore
  void fetchData() async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('Teams')
        .doc(user?.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        List<dynamic>? matchAvailabilityList = doc.data()?['matchAvailability'];
        if (matchAvailabilityList != null) {
          setState(() {
            scheduledMatches =
                List<Map<String, dynamic>>.from(matchAvailabilityList);
          });
        }
      }
    }).catchError((error) {
      print('Failed to fetch scheduled matches: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          settingSchedule['title']!,
          style: const TextStyle(
            color: Colors.black, // Set the text color to black
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Card(
        margin: const EdgeInsets.all(16),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Existing scheduled matches cards

            // New match scheduling section
            Row(
              children: [
                Expanded(
                  child: buildDatePickerInput(),
                ),
              ],
            ),

            const SizedBox(height: 16),
            buildTimeSlotSelection(),
            buildInputFieldWithOptions(
              options: matchingSettingsJap,
              labelText: settingSchedule['matchingSettings']!,
              optionController: matchsettingsController,
            ),
            const SizedBox(height: 16),
            buildInputFieldWithOptions(
              options: venuesJap,
              labelText: settingSchedule['trialMeetingPlace']!,
              optionController: venueController,
            ),
            if ((venueController.text == 'どちらでも') ||
                (venueController.text == 'ホーム希望'))
              Container(
                padding: const EdgeInsets.only(top: 16),
                child: buildInputFieldWithOptions(
                  options: homeDesignationJap,
                  labelText: settingSchedule['homeDesignation']!,
                  optionController: homedesignationController,
                ),
              ),

            // const SizedBox(height: 16),
            // buildInputFieldWithOptions(
            //   options: homeDesignation,
            //   labelText: settingSchedule['homeDesignation']!,
            //   optionController: homedesignationController,
            // ),
            if ((homedesignationController.text == 'google mapで指定する') &&
                (selectedAddress != null))
              Container(
                padding: const EdgeInsets.only(top: 8),
                // decoration: BoxDecoration(
                //   border: Border.all(color: Colors.grey),
                //   borderRadius: BorderRadius.circular(4),
                // ),
                child: Text(selectedAddress),
              ),

            const SizedBox(height: 16),

            if (homedesignationController.text == 'google mapで指定する')
              GestureDetector(
                onTap: () async {
                  final selectedAddress = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PickLocation()),
                  );

                  setState(() {
                    this.selectedAddress = selectedAddress['address'] ?? '';
                  });
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
                      Text(selectedAddress != null
                          ? settingSchedule['findAnAdd']!
                          : settingSchedule['changeTheAdd']!),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: 50,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  fetchData();
                  String selectedSetting = matchsettingsController.text;
                  String selectedVenue = venueController.text;
                  String selectedHomedesignation =
                      homedesignationController.text;
                  Set<String> selectedTimeSlot = selectedTimeSlots;

                  String selectedDateFormatted = selectedDate != null
                      ? DateFormat.yMMMMd().format(selectedDate!)
                      : '';

                  if (selectedSetting.isEmpty ||
                      selectedVenue.isEmpty ||
                      (selectedVenue != 'アウェイ（遠征）希望' &&
                          selectedHomedesignation.isEmpty) ||
                      (selectedHomedesignation == 'google mapで指定する' &&
                          (selectedAddress == null)) ||
                      selectedTimeSlot.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(settingSchedule['emptyFields']!),
                          content: Text(settingSchedule['pleaseFill']!),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(settingSchedule['ok']!),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }

                  List<int> timeSlots = [];

                  for (String slot in selectedTimeSlot) {
                    if (slot == '9:00 ~ 11:00') {
                      timeSlots.add(1);
                    } else if (slot == '11:00 ~ 13:00') {
                      timeSlots.add(2);
                    } else if (slot == '13:00 ~ 15:00') {
                      timeSlots.add(3);
                    } else {
                      timeSlots.add(0);
                    }
                  }

                  // Update matchScheduled field in Firestore
                  User? user = FirebaseAuth.instance.currentUser;
                  FirebaseFirestore.instance
                      .collection('Teams')
                      .doc(user?.uid)
                      .update({
                    'matchAvailability': FieldValue.arrayUnion(
                      timeSlots.map((time) {
                        return {
                          'matchingSetting': selectedSetting,
                          'timeSlot': time,
                          'location': selectedVenue,
                          'date': selectedDateFormatted,
                        };
                      }).toList(),
                    ),
                  }).then((_) {
                    print('Match scheduled successfully');
                  }).catchError((error) {
                    print('Failed to schedule match: $error');
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const SettingSchedulePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF115695),
                  // Change the color to your desired color
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cached),
                    const SizedBox(width: 8),
                    Text(settingSchedule['updateBtn']!),
                  ],
                ),
              ),
            ),

            for (int i = 0; i < scheduledMatches.length; i++)
              buildScheduledMatchCard(scheduledMatches[i], i),
          ],
        ),
      ),

      // ListView.builder(
      //   itemCount: scheduledMatches.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     return buildScheduledMatchCard(scheduledMatches[index]);
      //   },
      // );
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
    );
  }

  Widget buildInputFieldWithOptions({
    required List<String> options,
    required String labelText,
    required TextEditingController optionController,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
           
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600,
          fontSize: 12,
          height: 15 / 12, // Line height divided by font size
          color: Color(0xFF757575),
        ),
      ),
      value: optionController.text.isEmpty ? null : optionController.text,
      onChanged: (String? newValue) {
        setState(() {
          optionController.text = newValue!;
        });
      },
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF115695),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildTimeSlotSelection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 31),
          child: Text(
            settingSchedule['timeZone']!,
            style: const TextStyle(
               
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              height: 15 / 12, // Line height divided by font size
              color: Color(0xFF757575),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: timeSlots.map((String timeSlot) {
            bool isSelected = selectedTimeSlots.contains(timeSlot);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedTimeSlots.remove(timeSlot);
                  } else {
                    selectedTimeSlots.add(timeSlot);
                  }
                });
              },
              child: Container(
                width: 62,
                height: 61,
                margin: const EdgeInsets.only(right: 14),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF115695) : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF115695)
                        : Color(0xFF757575),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    timeSlot,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Color(0xFF757575),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      height: 1.25, // line height equivalent to 125%
                       
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildDatePickerInput() {
    return InkWell(
      onTap: () {
        _showDatePicker();
      },
      child: TextFormField(
        decoration: InputDecoration(
          labelText: settingSchedule['selectDate']!,
          labelStyle: const TextStyle(
             
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
            fontSize: 12,
            height: 15 / 12, // Line height divided by font size
            color: Color(0xFF757575),
          ),
          suffixIcon: const Icon(
            Icons.arrow_drop_down_outlined,
            color: Colors.black54,
          ),
          suffixIconConstraints: const BoxConstraints(
            minHeight: 24,
            minWidth: 24,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF115695)),
          ),
        ),
        controller: TextEditingController(
          text: selectedDate != null
              ? DateFormat.yMMMMd().format(selectedDate!)
              : '',
        ),
        style: const TextStyle(
          color: Color(0xFF115695),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a date';
          }
          return null;
        },
        enabled: false,
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget buildScheduledMatchCard(Map<String, dynamic> match, int index) {
    String timeSlotText = '';

    // Set the timeSlotText based on the value of match['timeSlot']
    if (match['timeSlot'] == 1) {
      timeSlotText = '9:00-11:00';
    } else if (match['timeSlot'] == 2) {
      timeSlotText = '11:00-13:00';
    } else if (match['timeSlot'] == 3) {
      timeSlotText = '13:00-15:00';
    } else {
      timeSlotText = '';
    }
    return Card(
      color: Colors.white,
      // shape: Border.all(style: BorderStyle.solid, color: Colors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(width: 1, color: Colors.black),
      ),
      margin: const EdgeInsets.only(top: 16, bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${settingSchedule['matchSettingType']!} ${index + 1}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            buildTrialInfo(settingSchedule['matchingSettings']!,
                '${match['matchingSetting']}'),
            buildTrialInfo(settingSchedule['timeZone']!, timeSlotText),
            buildTrialInfo(
                profileScreen['trialMeetingPlace']!, ' ${match['location']}'),
            buildTrialInfo(profileScreen['schedule']!, ' ${match['date']}'),
            const SizedBox(height: 8),
            SizedBox(
              width: 300,
              height: 49,
              child: ElevatedButton(
                onPressed: () {
                  // Remove the match from the scheduledMatches list
                  setState(() {
                    scheduledMatches.removeAt(index);
                  });

                  // Update matchScheduled field in Firestore
                  User? user = FirebaseAuth.instance.currentUser;
                  FirebaseFirestore.instance
                      .collection('Teams')
                      .doc(user?.uid)
                      .update({
                    'matchAvailability': scheduledMatches,
                  }).then((_) {
                    print('Match deleted successfully');
                  }).catchError((error) {
                    print('Failed to delete match: $error');
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF115695),
                  // minimumSize: Size(231, 49),
                ),
                child: Text(settingSchedule['deleteBtn']!),
              ),
            )
          ],
        ),
      ),
    );
  }
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
