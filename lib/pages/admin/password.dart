import 'package:flutter/material.dart';
import 'package:grad_project/pages/admin/setting.dart';

import '../../common/theme_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:grad_project/APIs/fetchData.dart';

import '../../main.dart';

class password extends StatefulWidget {
  const password({Key? key}) : super(key: key);
  @override
  _passwordState createState() => new _passwordState();
}

class _passwordState extends State<password> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController oldpasswordControler = TextEditingController();
  TextEditingController newpasswordControler = TextEditingController();
  TextEditingController confirmPasswordControler = TextEditingController();

  String Password = "";

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   Password = oldpasswordControler.text;
  // }

  Future<void> editPassword() async {
    // if (oldpasswordControler.text.trim().isEmpty ||
    //     newpasswordControler.text.trim().isEmpty ||
    //     confirmPasswordControler.text.trim().isEmpty) {
    //   print("Empty fields");
    //   return;
    // } else if (oldpasswordControler.text != confirmPasswordControler.text) {
    //   print("Passwords not Match");
    //   return;
    // }

    var body = jsonEncode({
      'password': oldpasswordControler.text,
    });

    print(body);
    var res = await http.post(
      Uri.parse(fetchData.baseURL + "/labUsers/password"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer " + prefs.get("token").toString()
      },
      body: body,
    );
    print(res.statusCode);
    if (res.statusCode == 200) {
      print("Current pass correct");
      Password = oldpasswordControler.text;
      if (_formKey.currentState!.validate()) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Settings_Screen()),
            (Route<dynamic> route) => false);
      }
      if (newpasswordControler.text != confirmPasswordControler.text) {
        return;
      }
      var body1 = jsonEncode({
        'password': newpasswordControler.text,
      });

      print(body1);
      var res1 = await http.patch(Uri.parse(fetchData.baseURL + "/labUsers/me"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer " + prefs.get("token").toString()
          },
          body: body1);
      print(res1.statusCode);
      if (res1.statusCode == 200) {
        print("Successfully Update pass");
        if (_formKey.currentState!.validate()) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Settings_Screen()),
              (Route<dynamic> route) => false);
        }
      } else {
        print("faild to Update pass");
        if (_formKey.currentState!.validate()) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Settings_Screen()),
              (Route<dynamic> route) => false);
        }
      }
    } else {
      print("Current pass not  correct");
      if (_formKey.currentState!.validate()) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Settings_Screen()),
            (Route<dynamic> route) => false);
      }
    }
    _clearValues();
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => loginPageClass()),
    //   );
  }

  _clearValues() {
    Password = "";
    // LabNameControler.text = "";
    // usernameControler.text = "";
    // LocationControler.text = "";
    // phoneControler.text = "";
    // passwordControler.text = "";
    // bTime.text = "";
    // eTime.text = "";
    // selected_Insurance = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 159, 198, 223),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 159, 198, 223),
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          elevation: 0,
          title: Padding(
            padding: EdgeInsets.only(left: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.065,
              child: Image.asset(
                'assets/images/hemog_black.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Settings_Screen()));
            },
          ),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(1.1, 4.0),
                    blurRadius: 8.0),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.092,
                        right: MediaQuery.of(context).size.width * 0.092,
                        bottom: MediaQuery.of(context).size.width * 0.092,
                        top: MediaQuery.of(context).size.width * 0.3),
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.of(context).size.width * 0.07,
                        letterSpacing: 0.5,
                        color: Color.fromARGB(255, 15, 15, 15),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: oldpasswordControler,
                            obscureText: true,
                            decoration: ThemeHelper()
                                .textInputDecoration("Current Password*", ""),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              if (Password != oldpasswordControler.text) {
                                return "Wrong Current password ";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: newpasswordControler,
                            obscureText: true,
                            decoration: ThemeHelper()
                                .textInputDecoration("New Password*", ""),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }

                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: confirmPasswordControler,
                            obscureText: true,
                            decoration: ThemeHelper()
                                .textInputDecoration("Confirm Password*", ""),
                            validator: (val) {
                              if (confirmPasswordControler.text !=
                                  newpasswordControler.text) {
                                return "Check password must be the same for new password";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(right: 20, top: 40, left: 15),
                          child: ElevatedButton(
                            onPressed: () {
                              editPassword();
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              minimumSize:
                                  MaterialStateProperty.all(Size(280, 50)),
                              backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 159, 198, 223),
                              ),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            child: Text('Reset',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.062,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
