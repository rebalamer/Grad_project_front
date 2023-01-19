import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/pages/splash_screen.dart';
import 'package:grad_project/pages/widgets/header_widget.dart';
import '../common/theme_helper.dart';
import 'dart:convert';
import 'profile_page.dart';
import 'package:http/http.dart' as http;
import 'package:grad_project/APIs/fetchData.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  // List<String> town = [
  //   'Afghanistan',
  //   'Turkey',
  //   'Germany',
  //   'France',
  //   'Italy',
  //   'Spain',
  //   'United Kingdom',
  //   'United States',
  //   'Canada',
  //   'Australia',
  //   'New Zealand',
  //   'India',
  //   'Indonesia',
  //   'Bangladesh',
  //   'Sri Lanka',
  // ];

  late TextEditingController fullNameControler;
  late TextEditingController usernameControler;
  late TextEditingController ageControler;
  late TextEditingController phoneControler;
  late TextEditingController passwordControler;
  late TextEditingController confirmPasswordControler;
  late TextEditingController identityNumberControler;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fullNameControler = TextEditingController();
    usernameControler = TextEditingController();
    ageControler = TextEditingController();
    phoneControler = TextEditingController();
    passwordControler = TextEditingController();
    confirmPasswordControler = TextEditingController();
    identityNumberControler = TextEditingController();
  }

  Future<void> SignUp() async {
    if (_formKey.currentState!.validate()) {
      if (fullNameControler.text.trim().isEmpty ||
          usernameControler.text.trim().isEmpty ||
          ageControler.text.trim().isEmpty ||
          passwordControler.text.trim().isEmpty ||
          confirmPasswordControler.text.trim().isEmpty ||
          phoneControler.text.trim().isEmpty ||
          identityNumberControler.text.trim().isEmpty) {
        print("Empty fields");
        return;
      }
      if (passwordControler.text != confirmPasswordControler.text) {
        print("Password miss match");
        return;
      }
      var body1 = jsonEncode({
        'username': usernameControler.text,
        'name': fullNameControler.text,
        'age': ageControler.text,
        'password': passwordControler.text,
        'phoneNumber': phoneControler.text,
        'identityNumber': identityNumberControler.text,
      });

      print(body1);

      var res = await http.post(Uri.parse(fetchData.baseURL + "/users"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body1);
      print(res.statusCode);
      if (res.statusCode == 201) {
        print("Successfully signed up");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => SplashScreen(
                      title: '',
                    )),
            (Route<dynamic> route) => false);
      } else {
        print("faild to sign up");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              child: HeaderWidget(
                  150, false, Icons.person_add_alt_1_rounded, '', false),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 100),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.6,
                                ),
                                child: Image.asset(
                                  'assets/images/hemog_black.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          child: TextFormField(
                            controller: fullNameControler,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter a name";
                              }
                              return null;
                            },
                            decoration: ThemeHelper().textInputDecoration(
                                'Full name', 'Enter your full name'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: TextFormField(
                            controller: usernameControler,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter a username";
                              }
                              return null;
                            },
                            decoration: ThemeHelper().textInputDecoration(
                                'Username', 'Enter your uesrname'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: identityNumberControler,
                            validator: (val) {
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                return "Enter a valid identity number";
                              } else if (identityNumberControler.text.length !=
                                  9) {
                                return "Enter a valid identity number";
                              }
                              return null;
                            },
                            decoration: ThemeHelper().textInputDecoration(
                                'Identity number',
                                'Enter your identity number'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: ageControler,
                            decoration: ThemeHelper()
                                .textInputDecoration("Age", "Enter your age"),
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your age";
                              } else if (ageControler.text.length > 2) {
                                return "Please enter a valid age";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: phoneControler,
                            decoration: ThemeHelper().textInputDecoration(
                                "Mobile number", "Enter your mobile number"),
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                return "Enter a valid phone number";
                              } else if (val.isEmpty) {
                                return "Enter your number";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: passwordControler,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Password*", "Enter your password"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              } else if (confirmPasswordControler.text !=
                                  passwordControler.text) {
                                return "Check password must be the same";
                              } else if (confirmPasswordControler.text.length <
                                  8) {
                                return "your password is too short";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: TextFormField(
                            controller: confirmPasswordControler,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Confirm Password*",
                                "Enter your password agin"),
                            validator: (val) {
                              if (confirmPasswordControler.text !=
                                  passwordControler.text) {
                                return "Check password must be the same";
                              } else if (confirmPasswordControler.text.length <
                                  8) {
                                return "your password is too short";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 15.0),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: checkboxValue,
                                        onChanged: (value) {
                                          setState(() {
                                            checkboxValue = value!;
                                            state.didChange(value);
                                          });
                                        }),
                                    Text(
                                      "I accept all terms and conditions.",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                          validator: (value) {
                            if (!checkboxValue) {
                              return 'You need to accept terms and conditions';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Register".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              SignUp();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
