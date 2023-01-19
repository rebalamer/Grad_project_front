import 'package:flutter/material.dart';
import 'dart:io';
import '../common/theme_helper.dart';
import 'u_setting.dart';
import 'dart:convert';
import 'package:grad_project/APIs/fetchData.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import '../APIs/models/user.dart';

class u_edit_page extends StatefulWidget {
  const u_edit_page({Key? key}) : super(key: key);
  @override
  _u_edit_pageState createState() => new _u_edit_pageState();
}

class _u_edit_pageState extends State<u_edit_page> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameControler = TextEditingController();
  TextEditingController usernameControler = TextEditingController();
  TextEditingController AgeControler = TextEditingController();
  TextEditingController phoneNumberControler = TextEditingController();
  TextEditingController emailControler = TextEditingController();
  TextEditingController identityNumberControler = TextEditingController();
  fetchData _fetchData = fetchData();

  @override
  void initState() {
    _fetchData.fetchUserInfo();
    currentInfo();
  }

  Future<void> editUserInfo() async {
    var body1 = jsonEncode({
      "username": usernameControler.text,
      "name": nameControler.text,
      "identityNumber": identityNumberControler.text,
      "phoneNumber": phoneNumberControler.text,
      "email": emailControler.text,
      "age": AgeControler.text,
    });

    print(body1);

    var res = await http.patch(Uri.parse(fetchData.baseURL + "/users/me"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + prefs.get("token").toString(),
        },
        body: body1);
    print(res.statusCode);
    if (res.statusCode == 200) {
      print("Successfully Update");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Settings_Screen()),
          (Route<dynamic> route) => false);
    } else {
      print("Faild Update");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.092),
                child: Text(
                  'Edit Your Information',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.width * 0.055,
                    letterSpacing: 0.5,
                    color: Color.fromARGB(255, 15, 15, 15),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: nameControler,
                        decoration: ThemeHelper().textInputDecoration(
                            'Your Name', 'Enter Your Name'),
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: usernameControler,
                        decoration: ThemeHelper().textInputDecoration(
                            'Username', 'Enter Your Username'),
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: emailControler,
                        decoration: ThemeHelper()
                            .textInputDecoration('Email', 'Enter Your Email'),
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: identityNumberControler,
                        decoration: ThemeHelper().textInputDecoration(
                            'Identity Number', 'Enter Your Identity Number'),
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: AgeControler,
                        decoration: ThemeHelper()
                            .textInputDecoration("Age", "Enter Your Age"),
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: phoneNumberControler,
                        decoration: ThemeHelper().textInputDecoration(
                            "Mobile Number", "Enter your mobile number"),
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (!(val!.isEmpty) &&
                              !RegExp(r"^(\d+)*$").hasMatch(val)) {
                            return "Enter a valid phone number";
                          }
                          return null;
                        },
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: ThemeHelper().buttonBoxDecoration(context),
                      child: ElevatedButton(
                        style: ThemeHelper().buttonStyle(),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            editUserInfo();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> bottomSheet(
    BuildContext context,
    Widget child,
  ) {
    return showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13), topRight: Radius.circular(13))),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height / 3, child: child));
  }

  Widget currentInfo() {
    // var info = _fetchData.fetchLabUserInfo();
    return FutureBuilder(
        future: _fetchData.fetchUserInfo(),
        builder: (context, snapshot) {
          userModel info = snapshot.data as userModel;

          nameControler.text = info.name;
          usernameControler.text = info.username;
          phoneNumberControler.text = info.phoneNumber;
          AgeControler.text = info.age;
          emailControler.text = info.email;
          identityNumberControler.text = info.identityNumber;
          // int n = info.insurance.length;
          // for (int i = 0; i < n; i++) {
          //   selected_Insurance[i] = info.insurance[i];
          // }

          print(nameControler.text);
          return snapshot.data == null ? Text("Loading") : Text("");
        });
  }
}
