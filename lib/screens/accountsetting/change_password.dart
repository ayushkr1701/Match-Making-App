import 'package:ai_match_making_app/screens/Base/my_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai_match_making_app/utils/conversion.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _reEnterPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  User? _user;
  bool _passwordsMatch = true;
  bool _passwordLengthValid = true;
  bool _incorrectPassword = false;
  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _reEnterPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    String currentPassword = _currentPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String reEnteredPassword = _reEnterPasswordController.text.trim();
    if (newPassword != reEnteredPassword) {
      setState(() {
        _passwordsMatch = false;
        _passwordLengthValid = true;
        _incorrectPassword = false;
      });
      return;
    }
    if (newPassword.length < 6) {
      setState(() {
        _passwordsMatch = true;
        _passwordLengthValid = false;
        _incorrectPassword = false;
      });
      return;
    }
    if (_user != null) {
      try {

        final credentials = EmailAuthProvider.credential(
          email: _user!.email!,
          password: _currentPasswordController.text.trim(),
        );

        final authResult = await _user!.reauthenticateWithCredential(credentials);
        if (authResult.user != null) {
          await _user!.updatePassword(_newPasswordController.text.trim());
          setState(() {
            _passwordsMatch = true;
            _passwordLengthValid = true;
            _incorrectPassword = false;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AccountSetting['passwordchanged']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.black,
                      size: 16,
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AccountSetting['passworddialogbox']!,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MyPage()),
                                  );
                                },
                                child: Card(
                                  color: Colors.blue[900],
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                                    child: Text(
                                      AccountSetting['backtomypage']!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      } catch (error) {
        setState(() {
          _passwordsMatch = true;
          _passwordLengthValid = true;
          _incorrectPassword = true;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(error.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AccountSetting['password']!,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              AccountSetting['currentpassword']!,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Colors.black45,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: AccountSetting['enterpassword']!,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              AccountSetting['newpassword']!,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Colors.black45,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: AccountSetting['enterpassword']!,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              AccountSetting['reenterpassword']!,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Colors.black45,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _reEnterPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: AccountSetting['enterpassword']!,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          if (!_passwordsMatch)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(
                registerPage['pswdDontMatch']!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          if (!_passwordLengthValid)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(
                registerPage['pswdMoreThanSix']!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          if (_incorrectPassword)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(
                AccountSetting['currentpasswordincorrect']!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          const SizedBox(height: 30),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: _changePassword,
                      child: Card(
                        color: Colors.blue[900],
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(85, 15, 85, 15),
                          child: Text(
                              AccountSetting['change']!,
                            style: const TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
