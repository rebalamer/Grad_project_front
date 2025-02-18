import 'dart:convert';
import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/APIs/fetchData.dart';
import 'package:grad_project/pages/admin/admin_home.dart';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:grad_project/pages/admin/setting.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../APIs/models/labUser.dart';
import '../../common/theme_helper.dart';
import '../../main.dart';
import '../select_photo_options_screen.dart';
import '../splash_screen.dart';
import 'package:http/http.dart' as http;

class edit_page extends StatefulWidget {
  const edit_page({Key? key}) : super(key: key);
  @override
  _edit_pageState createState() => new _edit_pageState();
}

class _edit_pageState extends State<edit_page> {
  final _formKey = GlobalKey<FormState>();

  List<String> Insurance = [
    'Afghanistan',
    'Turkey',
    'Germany',
    'France',
    'Italy',
    'Spain',
    'United Kingdom',
    'United States',
    'Canada',
    'Australia',
    'New Zealand',
    'India',
    'Indonesia',
    'Bangladesh',
    'Sri Lanka',
  ];

  List<String> selected_Insurance = [];

  String Beg_time = "8:00";
  String End_time = "22:00";

  Duration initialtimer = new Duration();
  fetchData _fetchData = fetchData();

  late TextEditingController LabNameControler;
  late TextEditingController usernameControler;
  late TextEditingController LocationControler;
  late TextEditingController phoneControler;
  late TextEditingController bTimeControler;
  late TextEditingController eTimeControler;

  File? _image;

  @override
  void initState() {
    LabNameControler = TextEditingController();
    usernameControler = TextEditingController();
    LocationControler = TextEditingController();
    phoneControler = TextEditingController();
    bTimeControler = TextEditingController();
    eTimeControler = TextEditingController();

    _fetchData.fetchLabUserInfo();
    currentInfo();

    // CurrentInfo();
    // LabNameControler.text = "Medicare";
    // usernameControler.text = "Medicarelab";
    // LocationControler.text = "Nablus Rafidea";
    // phoneControler.text = "0595585652";
    //جوا الفايل لازم يكون جواه الباث تاعت الصورة
    // _image = File(
    //     '/data/user/0/com.example.grad_project/cache/image_cropper_1670610381950.jpg');
    // selected_Insurance = [
    //   'Bangladesh',
    //   'Sri Lanka',
    // ];
    // Beg_time = "8:00";
    // End_time = "22:00";
    // bTimeControler.text = Beg_time;
    // eTimeControler.text = End_time;
  }

  Future<void> editLabInfo() async {
    print("iam here");
    if (LabNameControler.text.trim().isEmpty ||
        usernameControler.text.trim().isEmpty ||
        LocationControler.text.trim().isEmpty ||
        phoneControler.text.trim().isEmpty ||
        bTimeControler.text.trim().isEmpty ||
        eTimeControler.text.trim().isEmpty ||
        selected_Insurance.isEmpty) {
      print("Empty fields");
      return;
    }

    var body1 = jsonEncode({
      "username": usernameControler.text,
      "bTime": bTimeControler.text,
      "eTime": eTimeControler.text,
      "phoneNumber": phoneControler.text,
      "name": LabNameControler.text,
      "location": LocationControler.text,
      "insurance": selected_Insurance,
    });

    print(body1);

    var res = await http.patch(Uri.parse(fetchData.baseURL + "/labUsers/me"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + prefs.get("token").toString(),
        },
        body: body1);
    print(res.statusCode);
    if (res.statusCode == 200) {
      print("Successfully Update");
      var res1 = await http
          .post(Uri.parse(fetchData.baseURL + "/labUsers/me/avatar"), headers: {
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer " + prefs.get("token").toString(),
      }, body: {
        "avatar": _image
      });
      print(res.statusCode);
      if (res.statusCode == 200) {
        print("Successfully Update avatar");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Settings_Screen()),
            (Route<dynamic> route) => false);
      } else {
        print("faild Update avatar");
      }
    } else {
      print("faild Update");
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
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 28.0, right: 28, bottom: 15),
                      child: Center(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            _showSelectPhotoOptions(context);
                          },
                          child: Center(
                            child: Container(
                                height: 150.0,
                                width: 150.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade200,
                                ),
                                child: Center(
                                  child: _image == null
                                      ? Icon(
                                          Icons.person_add_alt_1_rounded,
                                          color: Colors.black,
                                          size: 40.0,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: FileImage(_image!),
                                          radius: 150.0,
                                        ),
                                )),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: LabNameControler,
                        decoration:
                            ThemeHelper().textInputDecoration('Lab Name', ''),
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
                        decoration:
                            ThemeHelper().textInputDecoration('User Name', ''),
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: LocationControler,
                        decoration:
                            ThemeHelper().textInputDecoration("Location", ""),
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: phoneControler,
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
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 25, right: 30),
                      child: TextField(
                          controller: bTimeControler,
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.timer_sharp,
                                color: Color.fromARGB(255, 0, 78, 153),
                              ),
                              labelText:
                                  "Enter Beginning Time" //label text of field
                              ),
                          readOnly: true,
                          onTap: () async {
                            await bottomSheet(context, timePicker1());
                            setState(() {
                              bTimeControler.text = Beg_time;
                            });
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 25, right: 30),
                      child: TextField(
                          controller: eTimeControler,
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.timer_sharp,
                                color: Color.fromARGB(255, 0, 78, 153),
                              ),
                              labelText: "Enter End Time" //label text of field
                              ),
                          readOnly: true,
                          onTap: () async {
                            await bottomSheet(context, timePicker2());
                            setState(() {
                              eTimeControler.text = End_time;
                            });
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 30, top: 5, left: 30),
                      child: DropdownSearch<String>.multiSelection(
                        mode: Mode.MENU,
                        maxHeight: 400,
                        showSearchBox: true,

                        dropdownSearchDecoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: " Insurance",
                          hintText: "Select Insurance",
                        ),
                        items: Insurance,
                        showSelectedItems: false,
                        selectedItems: selected_Insurance,
                        //save selected list
                        onChanged: (value) {
                          selected_Insurance = value;
                        },
                      ),
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
                          editLabInfo();
                          print(LabNameControler.text);
                          print(usernameControler.text);
                          print(LocationControler.text);
                          print(phoneControler.text);
                          print(bTimeControler.text);
                          print(eTimeControler.text);
                          print(_image);
                          print(selected_Insurance);
                          if (_formKey.currentState!.validate()) {}
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

  Widget timePicker1() {
    return CupertinoTimerPicker(
      mode: CupertinoTimerPickerMode.hm,
      minuteInterval: 15,
      initialTimerDuration: initialtimer,
      onTimerDurationChanged: (Duration changedtimer) {
        setState(() {
          initialtimer = changedtimer;
          Beg_time = changedtimer.inHours.toString() +
              ':' +
              (changedtimer.inMinutes % 60).toString();
        });
      },
    );
  }

  Widget timePicker2() {
    return CupertinoTimerPicker(
      mode: CupertinoTimerPickerMode.hm,
      minuteInterval: 15,
      initialTimerDuration: initialtimer,
      onTimerDurationChanged: (Duration changedtimer) {
        setState(() {
          initialtimer = changedtimer;
          End_time = changedtimer.inHours.toString() +
              ':' +
              (changedtimer.inMinutes % 60).toString();
        });
      },
    );
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImage,
              ),
            );
          }),
    );
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  Future _pickImage(ImageSource source) async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      print("helloooooo");
      img = await _cropImage(imageFile: img);

      setState(() {
        _image = img;
        //  Navigator.of(context).pop();
      });
    } on Exception catch (e) {
      print(e);
      //Navigator.of(context).pop();
    }
  }

  Widget currentInfo() {
    // var info = _fetchData.fetchLabUserInfo();
    return FutureBuilder(
        future: _fetchData.fetchLabUserInfo(),
        builder: (context, snapshot) {
          labUserModel info = snapshot.data as labUserModel;

          LabNameControler.text = info.name;
          usernameControler.text = info.username;
          LocationControler.text = info.location;
          phoneControler.text = info.phoneNumber;
          bTimeControler.text = info.bTime;
          eTimeControler.text = info.eTime;
          // int n = info.insurance.length;
          // for (int i = 0; i < n; i++) {
          //   selected_Insurance[i] = info.insurance[i];
          // }

          print(LabNameControler.text);
          return snapshot.data == null ? Text("Loading") : Text("");
        });
  }
}
