import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:grad_project/pages/admin/admin_home.dart';
import 'package:grad_project/pages/admin/setting.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:grad_project/APIs/fetchData.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../APIs/models/booking.dart';
import 'package:http/http.dart' as http;

import '../../common/theme_helper.dart';
import '../../main.dart';

class appointment_page extends StatefulWidget {
  const appointment_page({Key? key}) : super(key: key);
  @override
  _appointment_pageState createState() => new _appointment_pageState();
}

class _appointment_pageState extends State<appointment_page> {
  //details of appointment
  String date = "";

  List<int> check = [0, 0, 0, 0];
  int _page = 0;
  double ttop = 100;
  TextEditingController dateInputt = TextEditingController();

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  fetchData _fetchData = fetchData();

  @override
  void initState() {
    // TODO: implement initState
    // _fetchData.fetchlabBookingList();
    super.initState();
  }

  Future<void> UpdateCheck(int check, String id) async {
    var body1 = jsonEncode({'check': check});

    print(body1);

    var res = await http.patch(
        Uri.parse(fetchData.baseURL + "/bookings/updateCheck/" + id),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + prefs.get("token").toString(),
        },
        body: body1);

    print(res.statusCode);
    if (res.statusCode == 200) {
      fetchLabBooking();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => appointment_page()),
      // );
      print("Successfully Update Check");
    } else {
      print("faild Update Check");
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => admin_homepage()));
          },
        ),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
              child: Text(
                'Appointments',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.width * 0.07,
                  letterSpacing: 0.5,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 40, bottom: 5, left: 25),
              child: TextField(
                  controller: dateInputt,
                  onChanged: (String date) {
                    // fetchLabBookingByDate(date);
                  },
                  //editing controller of this TextField
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.calendar_today,
                        color: Color.fromARGB(255, 9, 78, 153),
                      ),
                      //icon of text field
                      labelText: "Enter Date" //label text of field
                      ),
                  readOnly: true,
                  //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2024),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color.fromARGB(
                                    255, 136, 174, 197), // <-- SEE HERE
                                onPrimary: Colors.white, // <-- SEE HERE
                                onSurface: Color.fromARGB(
                                    255, 36, 82, 110), // <-- SEE HERE
                              ),
                              dialogBackgroundColor: Colors.white,
                            ),
                            child: Container(child: child),
                          );
                        });

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      //formatted date output using intl package =>  2021-03-16
                      setState(() {
                        dateInputt.text = formattedDate;
                        date =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {}
                  }),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(60, 10, 0, 0),
                  child: Container(
                    decoration: ThemeHelper().buttonBoxDecoration(context),
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 4, bottom: 4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Color.fromARGB(255, 255, 255, 255)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                          "Search",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: () async {},
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Container(
                    decoration: ThemeHelper().buttonBoxDecoration(context),
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 4, bottom: 4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Color.fromARGB(255, 255, 255, 255)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                          "Show All",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        dateInputt.clear();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            ),
            Center(
              child: dateInputt.text.isNotEmpty
                  ? fetchLabBookingByDate(dateInputt.text)
                  : fetchLabBooking(),
            ),
          ],
        ),
      ),
    );
  }

  Widget appointmentt(BuildContext context, String ownerName, List test,
      String date, String time, int i, int check, String id, String servLoc) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.07,
          right: MediaQuery.of(context).size.width * 0.07,
          top: MediaQuery.of(context).size.width * 0.03,
          bottom: MediaQuery.of(context).size.width * 0.03),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.22,
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
                      ownerName,
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(left: 197, top: 30),
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
                  "in" + " " + servLoc,
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 100, left: 25),
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
                padding: EdgeInsets.only(left: 230, top: 100),
                child: IconButton(
                  icon: Icon(
                    Icons.check_circle_rounded,
                    size: 40,
                    color: (check == 1)
                        ? Color.fromARGB(255, 9, 78, 153)
                        : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      if (check == 0) {
                        check = 1;

                        UpdateCheck(check, id);

                        print(check);
                      } else if (check == 1) {
                        check = 0;
                        UpdateCheck(check, id);

                        print(check);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget text_wed(BuildContext context, String s, int i) {
    if (i != 0) ttop = ttop + 25;
    if (i == 0) ttop = 120;
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

// Fetch all bookings and make card for each booking
  Widget fetchLabBooking() {
    return FutureBuilder(
      future: _fetchData.fetchlabBookingList(),
      builder: (context, snapshot) {
        var bookings = snapshot.data as List<bookingModel>;
        return snapshot.data == null
            ? Text("Loading...")
            : SizedBox(
                width: 1000,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        print(index);
                        return appointmentt(
                            context,
                            bookings[index].ownerName,
                            bookings[index].test,
                            bookings[index].date,
                            bookings[index].time,
                            index,
                            int.parse(bookings[index].check),
                            bookings[index].id,
                            bookings[index].serviceLoc);
                      },
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget fetchLabBookingByDate(String date) {
    return FutureBuilder(
      future: _fetchData.fetchlabBookingByDate(date),
      builder: (context, snapshot) {
        var bookings = snapshot.data as List<bookingModel>;
        return snapshot.data == null
            ? Text("Loading...")
            : SizedBox(
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        print(index);
                        return appointmentt(
                            context,
                            bookings[index].ownerName,
                            bookings[index].test,
                            bookings[index].date,
                            bookings[index].time,
                            index,
                            int.parse(bookings[index].check),
                            bookings[index].id,
                            bookings[index].serviceLoc);
                      },
                    ),
                  ],
                ),
              );
      },
    );
  }
}
