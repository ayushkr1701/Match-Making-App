import 'package:ai_match_making_app/screens/profile/util_classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TrialProfilePage extends StatefulWidget {
  const TrialProfilePage({Key? key}) : super(key: key);
  @override
  TrialProfilePageState createState() => TrialProfilePageState();
}


class TrialProfilePageState extends State<TrialProfilePage> {
    List<Map<String, dynamic>> fetchedDataAll =[];
      late String matchDayTime;
  late String matchScheduleDate;
  late String matchingSetting;
   @override
  void initState() {
    super.initState();
    fetchDataAll();
  }
void fetchDataAll() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("Teams").get();

  if (snapshot.docs.isNotEmpty) {
    List<Map<String, dynamic>> fetchedDataList = snapshot.docs.map((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      data['uid'] = document.id; // Assign UID from document ID
      return data;
    }).toList();

    setState(() {
      fetchedDataAll = fetchedDataList;
    });

    for (int index = 0; index < fetchedDataAll.length; index++) {
      Map<String, dynamic> data = fetchedDataAll[index];
      final matchAvailability = data['matchAvailability'];

      String matchScheduleDate;
      String matchingSetting;
      int? timeSlot;
      String matchDayTime;

      if (matchAvailability != null && matchAvailability.isNotEmpty) {
        final latestMatchAvailability = matchAvailability.last;
        matchScheduleDate = latestMatchAvailability['date'] ?? 'DNE';
        matchingSetting = latestMatchAvailability['matchingSetting'] ?? '';

        int? timeSlot = latestMatchAvailability['timeSlot'];
        String timeSlotText = timeSlot != null ? timeSlot.toString() : 'DNE';

        if (timeSlotText == "1") {
          matchDayTime = "9:00-11:00";
        } else if (timeSlotText == "2") {
          matchDayTime = "11:00-13:00";
        } else if (timeSlotText == "3") {
          matchDayTime = "13:00-15:00";
        }
      } else {
        matchScheduleDate = 'DNE';
        matchingSetting = '';
        // Assign a default value for timeSlot or leave it as null if needed
        timeSlot = null;
        matchDayTime = 'DNE';
      }

      User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('Teams').doc(user?.uid).update({
        'matchCard': FieldValue.arrayUnion([
          {
            'date': matchScheduleDate,
            'distanceByCar': 0,
            'distanceByTrain': 0,
            'location': "location",
            'matchingSetting': matchingSetting,
            'opponentUID': data['uid'],
            'teamLevel': 2,
            'timeSlot': 1
          }
        ])
      }).then((_) {
        print('Match scheduled successfully');
      }).catchError((error) {
        print('Failed to schedule match: $error');
      });
    }
  }

  print(fetchedDataAll);
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Profile Page'),
    ),
    body: ListView(
      children: [
        DataTable(
          columns: [
            DataColumn(label: Text('Serial Number')),
            DataColumn(label: Text('Name')),
          ],
          rows: fetchedDataAll.map((data) {
            String serialNumber = data['uid'];
            String name = data['basicInfo']['representativeName'];
            return DataRow(cells: [
              DataCell(Text(serialNumber)),
              DataCell(Text(name)),
            ]);
          }).toList(),
        ),
      ],
    ),
  );
}

}