import "dart:io";
import "package:ai_match_making_app/screens/profile/pick_location.dart";
import "package:ai_match_making_app/utils/constants.dart";
import "package:ai_match_making_app/utils/conversion.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:image_picker/image_picker.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:path/path.dart' as path;

List<String> separate(String str) {
  String a = "";
  String b = "";
  
  int ind = -1;
  
  for (int i=0; i<str.length; i++){
      if (str[i] == ','){
          ind = i;
          break;
      }
  }
  if (ind != -1){
      if (ind == 0){
        a = str.substring(ind+1);
        b = str.substring(ind+1);
      }
      else if(ind == str.length-1){
         a = str.substring(0,ind);
         b = str.substring(0,ind);
      }
      else{
          a = str.substring(0,ind);
          b = str.substring(ind+1);
      }
      
  }
  else{
       a = str;
       b = str;
  }
  
  if(b.contains("prefecture") || a.contains("city")){
      return [b,a];
  }
  
  return [a,b];
  
}

double convert(List<String> lst, String str) {
  double val = 0;
  for (int i = 0; i < 5; i++) {
    if (lst[i] == str) {
      val = i * 25;
    }
  }
  return val;
}

int value(List<TextEditingController> tec, String str) {
  int val = 0;
  for (int i = 1; i < 11; i += 2) {
    if (tec[i].text == str) {
      val += int.parse(tec[i + 1].text);
    }
  }
  return val;
}

String getCurrentUID() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return "";
  return user.uid;
}

class ScreenUtil {
  static double? screenWidth;
  static double? screenHeight;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }
}

Content homeGroundWidget(String text, List<String> contentText,
    List<TextEditingController> contentControllers, String initValue) {
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
    ],
  );
}

class Content extends StatefulWidget {
  final String text;
  final dynamic childrens;
  const Content({Key? key, required this.text, required this.childrens})
      : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _ContentBuilder createState() => _ContentBuilder();
}

class _ContentBuilder extends State<Content> {
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

// ignore: must_be_immutable
class SliderCard extends StatefulWidget {
  final List<String> sliderLevels;
  double currentSliderVal;
  final ValueChanged<double> onSliderChanged; // Callback function

  SliderCard({
    Key? key,
    required this.sliderLevels,
    required this.currentSliderVal,
    required this.onSliderChanged,
  }) : super(key: key);

  @override
  SliderCardState createState() => SliderCardState();
}

class SliderCardState extends State<SliderCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            widget.sliderLevels[(widget.currentSliderVal ~/ 25)],
            style: const TextStyle(
              color: Color.fromRGBO(17, 86, 149, 1),
            ),
          ),
          Slider(
            value: widget.currentSliderVal,
            min: 0,
            max: 100,
            divisions: 4,
            thumbColor: const Color.fromRGBO(17, 86, 149, 1),
            activeColor: const Color.fromRGBO(17, 86, 149, 1),
            label: widget.sliderLevels[(widget.currentSliderVal ~/ 25)],
            onChanged: (double value) {
              setState(() {
                widget.currentSliderVal = value;
                widget.onSliderChanged(value); // Call the callback function
              });
            },
          ),
        ],
      ),
    );
  }
}

// TextField boxText(String text, TextEditingController textcontroller) {
//   return TextField(
//     controller: textcontroller,
//     keyboardType: TextInputType.text,
//     style: const TextStyle(color: Color.fromRGBO(17, 86, 149, 1)),
//     decoration: InputDecoration(labelText: text),
//     onSubmitted: (value) {
//       textcontroller.text = value;
//     },
//   );
// }

class boxText extends StatefulWidget {
  final TextEditingController textController;
  final String text;
  const boxText({super.key, required this.textController, required this.text});

  @override
  boxTextState createState() => boxTextState();
}

class boxTextState extends State<boxText> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textController,
      keyboardType: TextInputType.text,
      style: const TextStyle(color: Color.fromRGBO(17, 86, 149, 1)),
      decoration: InputDecoration(labelText: widget.text),
      onSubmitted: (value) {
        setState(() {
          widget.textController.text = value;
        });
      },
    );
  }
}

ListView listText(
    List<TextEditingController> listControllers, List<String> listStrings) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: listControllers.length,
    itemBuilder: (context, index) {
      return boxText(
        text: listStrings[index],
        textController: listControllers[index],
      );
    },
  );
}

class InputFieldWithOptions extends StatefulWidget {
  final List<String> options;
  final String labelText;
  final TextEditingController optionController;
  String? initOption;

  InputFieldWithOptions(
      {Key? key,
      required this.options,
      required this.labelText,
      required this.optionController,
      this.initOption})
      : super(key: key);
  @override
  InputFieldWithOptionsState createState() => InputFieldWithOptionsState();
}

class InputFieldWithOptionsState extends State<InputFieldWithOptions> {
  late String selectedOption;
  @override
  void initState() {
    super.initState();
    selectedOption =
        (widget.initOption == "" ? widget.options.first : widget.initOption)!;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: widget.labelText,
        // border: const OutlineInputBorder(),
      ),
      value: selectedOption,
      onChanged: (String? newValue) {
        setState(() {
          selectedOption = newValue!;
          widget.optionController.text = newValue;
        });
      },
      items: widget.options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(color: Color.fromRGBO(17, 86, 149, 1)),
          ),
        );
      }).toList(),
    );
  }
}

class ImageBox extends StatefulWidget {
  final double h;
  final double w;
  final Function(String)? onImageUploaded;

  const ImageBox(
      {Key? key, required this.h, required this.w, this.onImageUploaded})
      : super(key: key);

  @override
  ImageBoxBuilder createState() => ImageBoxBuilder();
}

class ImageBoxBuilder extends State<ImageBox> {
  File? image;
  List<String> imageUrls = [];

  Future<void> pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      final File imageFile = File(pickedFile.path);

      // Upload the image to Firebase Storage
      final firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child(pickedFile.name);
      final firebase_storage.UploadTask uploadTask =
          storageRef.putFile(imageFile);

      await uploadTask.whenComplete(() => null);

      // Get the image download URL
      final String downloadURL = await storageRef.getDownloadURL();

      User? user = FirebaseAuth.instance.currentUser;
      final imagesCollection =
          FirebaseFirestore.instance.collection("Teams").doc(user?.uid);
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await imagesCollection.get();
      final int imageIndex = snapshot.exists ? snapshot.data()!.length + 1 : 1;

      imagesCollection.update({
        'images': FieldValue.arrayUnion([downloadURL]),
      });

      setState(() {
        image = imageFile;
      });

      // Invoke the callback with the download URL
      if (widget.onImageUploaded != null) {
        widget.onImageUploaded!(downloadURL);
        setState(() {
          imageUrls.add(downloadURL);
        });
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Failed to load image'),
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.h,
      width: widget.w,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ElevatedButton(
        onPressed: pickImage,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey,
        ),
        child: image != null
            ? Image.file(
                image!,
                width: 177,
                height: 200,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.add),
      ),
    );
  }
}

Card composition(List<String> controllerOptions, List<String> controllerText,
    List<TextEditingController> compositionController, String initValue) {
  return Card(
    child: Column(children: [
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: InputFieldWithOptions(
          options: controllerOptions,
          labelText: controllerText[0],
          optionController: compositionController[0],
          initOption: initValue,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: TextField(
          controller: compositionController[1],
          style: const TextStyle(color: Color.fromRGBO(17, 86, 149, 1)),
          decoration: InputDecoration(labelText: controllerText[1]),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
          ],
        ),
      ),
    ]),
  );
}

class CheckBox extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  bool isSelected;
  final String text;

  CheckBox(
      {Key? key,
      required this.onChanged,
      required this.text,
      required this.isSelected})
      : super(key: key);

  @override
  CheckBoxState createState() => CheckBoxState();
}

class CheckBoxState extends State<CheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.isSelected,
          onChanged: (bool? newValue) {
            setState(() {
              widget.isSelected = newValue ?? false;
            });
            widget.onChanged(widget.isSelected);
          },
        ),
        Text(
          widget.text,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }
}

class TeamCompCard extends StatefulWidget {
  final String text;
  final String initText;
  final List<TextEditingController> tec;
  const TeamCompCard(
      {Key? key, required this.text, required this.tec, required this.initText})
      : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _TeamCompCardBuilder createState() => _TeamCompCardBuilder();
}

class _TeamCompCardBuilder extends State<TeamCompCard> {
  bool _isExpanded = false;
  List<Widget> children = [];
  String? _dropdownValue;
  int? limit;
  List<String> optionsStr = [];
  @override
  void initState() {
    super.initState();
    _dropdownValue = widget.initText;
    limit = change(widget.initText);
    options(widget.initText);
    optionsStr = [...optionsStr];
    for (int i = 0; i < limit!; i++) {
      children.add(ChildWidget(
        acadController: widget.tec[2 * i + 1],
        numController: widget.tec[2 * i + 2],
        options: optionsStr,
        academicYear: optionsStr.isNotEmpty
            ? optionsStr[0]
            : '', // Set the initial academic year as the first available option
      ));
    }
// Initialize _dropdownValue with the provided academicYear
  }

  void options(String str) {
    if (str.startsWith("小学生")) {
      optionsStr = academicYearOptionsJap;
    } else if (str.startsWith("中学生") || str.startsWith("高校生")) {
      optionsStr = academicYearOptionsJap.sublist(0, 3);
    } else if (str.startsWith("大学生")) {
      optionsStr = academicYearOptionsJap.sublist(0, 4);
    } else {
      optionsStr = [];
    }
  }

  int change(String str) {
    int val = 0;
    if (str.startsWith("小学生")) {
      val = 6;
    } else if (str.startsWith("中学生") || str.startsWith("高校生")) {
      val = 3;
    } else if (str.startsWith("大学生")) {
      val = 4;
    }
    return val;
  }

  void onDropdownValueChanged(String data) {
    widget.tec[0].text = data;
  }

  void _addChildWidget() {
    setState(() {
      int len = children.length;

      // Create a list of already selected academic years
      List<String> selectedAcademicYears = [];
      for (int i = 0; i < len; i++) {
        selectedAcademicYears.add(widget.tec[2 * i + 1].text);
      }

      // Generate options list based on selected academic years
      List<String> updatedOptions = [];
      for (String option in optionsStr) {
        if (!selectedAcademicYears.contains(option)) {
          updatedOptions.add(option);
        }
      }

      children.add(ChildWidget(
        acadController: widget.tec[2 * len + 1],
        numController: widget.tec[2 * len + 2],
        options: updatedOptions,
        academicYear: updatedOptions.isNotEmpty
            ? updatedOptions[0]
            : '', // Set the initial academic year as the first available option
      ));
    });
  }

  void _clearChildren() {
    setState(() {
      children.clear();
    });
  }

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
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "School level"),
                value: _dropdownValue,
                onChanged: (newValue) {
                  setState(() {
                    _dropdownValue = newValue;
                    onDropdownValueChanged.call(newValue!);
                    options(newValue);
                    _clearChildren();
                    optionsStr = [...optionsStr];
                    limit = change(newValue);
                    for (int i = 1; i < widget.tec.length; i++) {
                      widget.tec[i].clear();
                    }
                  });
                },
                items: schoolLevelOptionsJap
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                          color: Color.fromRGBO(17, 86, 149, 1)),
                    ),
                  );
                }).toList(),
              ),
            ),
            Column(
              children: children,
            ),
            if (_isExpanded && children.length < limit!)
              IconButton(
                icon: const Icon(Icons.add_circle),
                onPressed: () {
                  _addChildWidget();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class ChildWidget extends StatefulWidget {
  final List<String> options;
  final TextEditingController acadController;
  final TextEditingController numController;
  final String academicYear;
  const ChildWidget({
    Key? key,
    required this.options,
    required this.numController,
    required this.acadController,
    required this.academicYear,
  }) : super(key: key);

  @override
  _ChildWidgetState createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget> {
  String? _dropdownValue;
  @override
  void initState() {
    super.initState();

    _dropdownValue = widget.acadController.text.isNotEmpty
        ? widget.acadController.text
        : null;

    if (_dropdownValue != null) {
      widget.acadController.text = _dropdownValue!;
    }
// Initialize _dropdownValue with the provided academicYear
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: compositionTextJap[0]),
              value: _dropdownValue,
              onChanged: (newValue) {
                setState(() {
                  _dropdownValue = newValue;
                  widget.acadController.text = newValue!;
                });
              },
              items:
                  widget.options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style:
                        const TextStyle(color: Color.fromRGBO(17, 86, 149, 1)),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextField(
              controller: widget.numController,
              style: const TextStyle(color: Color.fromRGBO(17, 86, 149, 1)),
              decoration: InputDecoration(
                labelText: compositionTextJap[1],
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
