import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/APIs/fetchData.dart';
import '../common/theme_helper.dart';
import 'admin/admin_home.dart';
import 'admin_reg.dart';
import 'home_page.dart';
import 'forgot_password_page.dart';
import 'registration_page.dart';
import 'widgets/header_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:grad_project/sharedPrefs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _headerHeight = 200;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController passwordController;
  late TextEditingController usernameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<void> LogIn() async {
    // if (usernameController.text.trim().isEmpty ||
    //     passwordController.text.trim().isEmpty) {
    //   print("Empty fields");
    //   return;
    // }

    var body1 = jsonEncode({
      'username': usernameController.text,
      'password': passwordController.text,
    });

    print(body1);

    var res = await http.post(Uri.parse(fetchData.baseURL + "/users/login"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body1);
    print(res.statusCode);
    if (res.statusCode == 200) {
      print("Successfully login");
      var body = jsonDecode(res.body);
      print(body['token']);
      sharedPrefs.saveToken(body['token']);
      if (body['username'] == "admin") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Lab_Registration()),
            (Route<dynamic> route) => false);
      } else
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false);
    } else {
      var res1 =
          await http.post(Uri.parse(fetchData.baseURL + "/labUsers/login"),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: body1);
      print(res1.statusCode);
      if (res1.statusCode == 200) {
        print("Successfully login");

        var body = jsonDecode(res1.body);
        print(body['token']);

        sharedPrefs.saveToken(body['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => admin_homepage()),
            (Route<dynamic> route) => false);
      } else {
        print("faild to login");
        if (_formKey.currentState!.validate()) {}
        // _clearValues();
      }
    }

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => loginPageClass()),
    //   );
  }

  // _clearValues() {
  //   usernameController.text = "";
  //   passwordController.text = "";
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, false, Icons.login_rounded, '',
                  false), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                      Text(
                        'Welcome to',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width,
                        ),
                        child: Image.asset(
                          'assets/images/hemog.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(
                        'Sign in into your account',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  controller: usernameController,
                                  decoration: ThemeHelper().textInputDecoration(
                                      "Username", "Enter your Username"),
                                  validator: (val) {
                                    if ((val!.isEmpty)) {
                                      return " Please enter your username ";
                                    } else if (passwordController
                                        .text.isEmpty) {
                                      return null;
                                    }
                                    return "username or password not correct";
                                  },
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  validator: (val) {
                                    if ((val!.isEmpty)) {
                                      return " Please enter a password ";
                                    } else if (usernameController
                                        .text.isEmpty) {
                                      return null;
                                    }
                                    return "username or password not correct";
                                  },
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Password', 'Enter your password'),
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 15.0),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPasswordPage()),
                                    );
                                  },
                                  child: Text(
                                    "Forgot your password?",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 25.0),
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      'Sign in',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () {
                                    LogIn();

                                    //After successful login we will redirect to profile page. Let's create profile page now
                                    // Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             admin_homepage()));
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(text: "Don\'t have an account? "),
                                  TextSpan(
                                    text: 'Sign up!',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistrationPage()));
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor),
                                  ),
                                ])),
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
