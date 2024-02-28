import "package:ai_match_making_app/utils/conversion.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

Scaffold onboardPage(String currentPage, int completedTasks, int totalTasks,
    dynamic onPressedFunction1,dynamic onPressedFunction2, List<Widget> pageWidgets) {
  pageWidgets.insert(0, const SizedBox(height: 15));

  return Scaffold(
    appBar: AppBar(
       automaticallyImplyLeading: false,
      toolbarHeight: 120,
      foregroundColor: Colors.black,
      actions: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      signupOnboard['basicInfo']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: currentPage == signupOnboard['basicInfo']!
                            ? const Color.fromRGBO(17, 86, 149, 1)
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      signupOnboard['matchingSettings']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: currentPage == signupOnboard['matchingSettings']!
                            ? const Color.fromRGBO(17, 86, 149, 1)
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      signupOnboard['finished']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: currentPage == signupOnboard['finished']!
                            ? const Color.fromRGBO(17, 86, 149, 1)
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(signupOnboard['everythingCan']!),
                        Text(
                          "$completedTasks/$totalTasks",
                          style: const TextStyle(
                              color: Color.fromRGBO(17, 86, 149, 1)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    indicatorTasks(completedTasks, totalTasks),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      backgroundColor: Colors.white,
    ),
    body: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: pageWidgets,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color.fromRGBO(17, 86, 149, 1)),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                ),
                onPressed: () {
                  onPressedFunction1();
                },
                child: Text(
                  signupOnboard['backBtn']!,
                  style: TextStyle(fontSize: 16,color: Color.fromRGBO(17, 86, 149, 1)),
                ),
              ),
              const SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  onPressedFunction2();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(17, 86, 149, 1),
                  padding: const EdgeInsets.fromLTRB(43, 23, 43, 23),
                ),
                child: Text(signupOnboard['nextBtn']!),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget indicatorTasks(int completedTasks, int totalTasks) {
  double progress = completedTasks / totalTasks;
  return ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(5)),
    child: LinearProgressIndicator(
      minHeight: 10,
      value: progress,
      backgroundColor: Colors.grey[300],
      valueColor:
          const AlwaysStoppedAnimation<Color>(Color.fromRGBO(17, 86, 149, 1)),
    ),
  );
}


class ButtonCard extends StatefulWidget {
  final Function(String) onOptionSelected;
  final List<List<String>> options;

  const ButtonCard({Key?key, required this.onOptionSelected, required this.options}) : super(key: key);

  @override
  _ButtonCardState createState() => _ButtonCardState();
}

class _ButtonCardState extends State<ButtonCard> {
  String ? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: widget.options.map((optionPair) {
          return Column(
            children: <Widget>[
          Row(
            children: optionPair.map((option) {
              bool isSelected = (selectedOption == option);
              return Expanded(
                child: OutlinedButton(
                  
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
                    foregroundColor: isSelected ? const Color.fromRGBO(17, 86, 149, 1) : Colors.black87,
                    backgroundColor: isSelected ? const Color.fromARGB(255, 185, 224, 243) : null,
                  ),
                  child: Text(option),
                  onPressed: () {
                    setState(() {
                      selectedOption = option;
                    });
                    widget.onOptionSelected(option);
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10,)]);
        }).toList(),
      );
  }
}


class CreateCardList extends StatelessWidget {
  final List<String> options;
  final List<TextEditingController> controllers;
  final String rightText;

  const CreateCardList({
    Key?key,
    required this.options,
    required this.controllers,
    required this.rightText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: options.map((option) {
          final controller = controllers[options.indexOf(option)];
          return MemberCard(
            option: option,
            rightText: rightText,
            textController: controller,
          );
        }).toList(),
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final String option;
  final String rightText;
  final TextEditingController textController;

  const MemberCard({
    Key?key,
    required this.option,
    required this.rightText,
    required this.textController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(option),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "0",
                      ),
                      keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(rightText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ButtonCard2 extends StatefulWidget {
  final Function(String) onOptionSelected;
  final List<List<String>> options;

  const ButtonCard2({Key?key, required this.onOptionSelected, required this.options}) : super(key: key);

  @override
  _ButtonCard2State createState() => _ButtonCard2State();
}

class _ButtonCard2State extends State<ButtonCard2> {
  String ? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.map((optionPair) {
        return Column(
            children: <Widget>[
              Row(
                children: optionPair.map((option) {
                  bool isSelected = (selectedOption == option);
                  return Expanded(
                    child: OutlinedButton(

                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
                        foregroundColor: isSelected ? const Color.fromRGBO(17, 86, 149, 1) : Colors.black87,
                        backgroundColor: isSelected ? const Color.fromARGB(255, 185, 224, 243) : null,
                      ),
                      child: Text(option),
                      onPressed: () {
                        setState(() {
                          selectedOption = option;
                        });
                        widget.onOptionSelected(option);
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10,)]);
      }).toList(),
    );
  }
}
