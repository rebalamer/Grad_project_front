import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:grad_project/pages/price.dart';
import 'package:grad_project/pages/u_result.dart';
import '../APIs/models/booking.dart';
import '../APIs/models/labUser.dart';
import '../APIs/models/user.dart';
import '../pages/u_setting.dart';
import 'booking.dart';
import '../main.dart';
import 'package:grad_project/APIs/fetchData.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../APIs/fetchData.dart';
import 'edit_booking.dart';
import '../pages/map.dart';
import 'notification.dart';
import './pdf_viewer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //details of appointment

  //information about Labs
  List<String> Laboratories = [
    "Professional ",
    "Al-Najah ",
    "MedLabs",
    "Medicare",
    "Ajyal Lab"
  ];
  List<String> phone_Lab = [
    "092396420",
    "092396420",
    "092396420",
    "092396420",
    "092396420"
  ];
  List<String> Location = [
    "Nablus-R",
    "Nablus-R",
    "Nablus-R",
    "Nablus-R",
    "Nablus-R",
  ];
  int _page = 0;
  double ttop = 100;

  List<String> Lab_name = [
    "Professional",
    "Professional ",
    "Al-Najah ",
    "MedLabs",
  ];
  List<List> selected_test = [
    [
      'ggga',
      "Professional ",
    ],
    [
      'gggj',
      "Professional ",
    ],
    [
      'ggmg',
      "Professional ",
    ],
    [
      'ggbg',
      "Professional ",
    ]
  ];
  List<String> selected_date = ["0/0/0", "0/0/0", "0/0/0", "0/0/0"];
  List<String> selected_time = [
    "5:10",
    "5:10",
    "5:10",
    "5:10",
  ];
  //information about Labs
  static String idLab = "aaaaa";
  fetchData _fetchData = fetchData();

  //for notification
  List<String> date = ["17/1/2023", "17/1/2023", "17/1/2023"];
  List<String> noti_time = ["15:50", "16:05", "16:15"];

  List<String> reminder = [
    'Reminder',
    'Reminder1',
    'Reminder2',
    'Reminder3',
    'Reminder4',
    'Reminder5',
    'Reminder6',
    'Reminder7',
    'Reminder8',
    'Reminder9'
  ];

  @override
  void initState() {
    if (noti_time.isNotEmpty) {
      for (int i = 0; i < noti_time.length; i++) {
        notify.create_notification(noti_time[i], date[i], i, reminder[i]);
      }
    }
    super.initState();
  }

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  Future<void> DeleteBooking(String id) async {
    var res = await http.delete(
      Uri.parse(fetchData.baseURL + "/bookings/delete/" + id),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer " + prefs.get("token").toString(),
      },
    );
    print(res.statusCode);
    if (res.statusCode == 200) {
      print("Successfully Delete Booking");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
      );
    } else {
      print("Faild Delete Booking");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 159, 198, 223),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 159, 198, 223),
        toolbarHeight: MediaQuery.of(context).size.height * 0.09,
        elevation: 1,
        title: Container(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.065,
            child: Image.asset(
              'assets/images/hemog_black.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        height: 60.0,
        index: 2,
        items: <Widget>[
          Icon(Icons.attach_money_rounded, size: 32),
          Icon(Icons.article, size: 30),
          Icon(Icons.home, size: 30),
          Icon(Icons.location_on, size: 30),
          Icon(Icons.settings, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 159, 198, 223),
        onTap: (index) {
          setState(() {
            _page = index;
            if (index == 0) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => price_page()));
              setState(() {});
            }
            if (index == 1) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => uresult_page()));
              setState(() {});
            }
            if (index == 3) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MapSample()));
              setState(() {});
            }
            if (index == 4) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Settings_Screen()));
              setState(() {});
            }
          });
        },
      ),
      body: SingleChildScrollView(
        // scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
              child: Text(
                'Laboratories',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: MediaQuery.of(context).size.width * 0.052,
                  letterSpacing: 0.5,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: <Widget>[fetchLabUsers()]),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.06),
              child: Text(
                'Appointment Details',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: MediaQuery.of(context).size.width * 0.052,
                  letterSpacing: 0.5,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            // SingleChildScrollView(
            //   scrollDirection: Axis.vertical,
            //   child: Column(children: <Widget>[fetchMyBooking()]),
            // ),
            fetchMyBooking(),
          ],
        ),
      ),
    );
  }

  Widget appointmentt(BuildContext context, String labName, String date,
      String time, List test, int i, String id) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.07),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(1.1, 4.0),
                blurRadius: 8.0),
          ],
        ),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(15),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25, top: 30),
                    child: Text(
                      labName,
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 63, top: 30),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Color.fromARGB(255, 9, 78, 153),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              date,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(left: 197, top: 70),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timer_sharp,
                        color: Color.fromARGB(255, 9, 78, 153),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          time,
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(top: 70, left: 25),
                child: Text(
                  "Selected Test:",
                  style: TextStyle(
                      color: Color.fromARGB(255, 9, 78, 153),
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.w700),
                ),
              ),
              for (int k = 0; k < test.length; k++)
                text_wed(context, test[k], k),
              Padding(
                padding: EdgeInsets.only(top: 160, left: 200),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height * 0.032,
                      width: MediaQuery.of(context).size.width * 0.12,
                      //margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          color: Color(0xFFFB475F).withOpacity(.65)),
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 1),
                          child: IconButton(
                            alignment: Alignment.topCenter,
                            icon: Icon(
                              Icons.close,
                              size: 12,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            onPressed: () {
                              showAlertDialog(context, id);
                            },
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height * 0.032,
                      width: MediaQuery.of(context).size.width * 0.12,
                      //margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          color: Color(0xFFFB475F).withOpacity(.65)),
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 1),
                          child: IconButton(
                            alignment: Alignment.topCenter,
                            icon: Icon(
                              Icons.edit,
                              size: 12,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            onPressed: () {
                              fetchLabUsers();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Edit_Booking_page(id: id)));
                              // setState(() {});
                            },
                          )),
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

  showAlertDialog(BuildContext context, String id) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Color.fromARGB(255, 159, 198, 223),
        ),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Continue"),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Color.fromARGB(255, 159, 198, 223),
        ),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
      ),
      onPressed: () {
        DeleteBooking(id);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Appointment"),
      content: Text("Are you sure you want to delete this appointment?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget text_wed(BuildContext context, String s, int i) {
    if (i != 0) ttop = ttop + 25;
    if (i == 0) ttop = 100;

    return Padding(
      padding: EdgeInsets.only(left: 30, top: ttop),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Text(
          s,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: MediaQuery.of(context).size.width * 0.045,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget Laboratory(BuildContext context, String labname, String location,
      String phoneNumber, String id, String bTime, String eTime) {
    return Padding(
        padding:
            EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.03),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(1.1, 4.0),
                      blurRadius: 8.0),
                ],
              ),
              child: Stack(children: <Widget>[
                // Big light background
                Positioned(
                  right: 170,
                  top: 0,
                  bottom: 0,
                  left: 2,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      color: Color.fromARGB(255, 253, 250, 250),
                    ),
                    child: Image.asset(
                      'assets/images/Laboratory.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                Positioned(
                  // right: 10,
                  left: 100,
                  top: 2,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            labname,
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.007),
                          Text(
                            location,
                            style: TextStyle(
                                color: Color.fromARGB(255, 9, 78, 153),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Row(children: [
                            Text(
                              phoneNumber,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 9, 78, 153),
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                  fontWeight: FontWeight.w600),
                            ),
                            Padding(padding: EdgeInsets.only(left: 30)),
                            Container(
                              alignment: Alignment.topCenter,
                              height:
                                  MediaQuery.of(context).size.height * 0.032,
                              width: MediaQuery.of(context).size.width * 0.12,
                              //margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                  color: Color(0xFFFB475F).withOpacity(.65)),
                              child: Padding(
                                  padding: EdgeInsets.only(bottom: 1),
                                  child: IconButton(
                                    alignment: Alignment.topCenter,
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    onPressed: () {
                                      // idLab
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Booking_page(
                                                    id: id,
                                                    bTime: bTime,
                                                    eTime: eTime,
                                                  )));
                                      setState(() {});
                                    },
                                  )),
                            ),
                          ]),
                        ]),
                  ),
                ),
              ]),
            ),
          ],
        ));
  }

  // Fetch Labs and make card for each Lab
  Widget fetchLabUsers() {
    return FutureBuilder(
      future: _fetchData.fetchLabUsersList(),
      builder: (context, snapshot) {
        var labs = snapshot.data as List<labUserModel>;
        return snapshot.data == null
            ? Text("Loading...")
            // ignore: unnecessary_new
            : new SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: labs.length,
                      itemBuilder: (context, index) {
                        // if (labs[index].username == "admin") {
                        //   index = index + 1;
                        // }
                        return Laboratory(
                            context,
                            labs[index].name,
                            labs[index].location,
                            labs[index].phoneNumber,
                            labs[index].id,
                            labs[index].bTime,
                            labs[index].eTime);
                      },
                    ),
                  ],
                ),
              );
      },
    );
  }

// Fetch User booking and make card for each booking
  Widget fetchMyBooking() {
    return FutureBuilder(
      future: _fetchData.fetchMyBookingList(),
      builder: (context, snapshot) {
        var bookings = snapshot.data as List<bookingModel>;
        return snapshot.data == null
            ? Text("Loading...")
            : Container(
                width: 400,
                child: Column(
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        return appointmentt(
                            context,
                            bookings[index].ownerLabName,
                            bookings[index].date,
                            bookings[index].time,
                            bookings[index].test,
                            index,
                            bookings[index].id);
                      },
                    ),
                  ],
                ),
              );
      },
    );
  }
}
