import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/pages/home_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../APIs/fetchData.dart';

import '../APIs/models/booking.dart';
import '../main.dart';

class Edit_Booking_page extends StatefulWidget {
  String id;
  Edit_Booking_page({Key? key, required this.id}) : super(key: key);

  @override
  Booking_pageState createState() => new Booking_pageState();
}

class Booking_pageState extends State<Edit_Booking_page> {
  @override
  late TextEditingController dateInput;
  late TextEditingController timeInput;

  List<String> med_analysis = [
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

  List<String> selected_test = [];
  String selected_date = "";
  String selected_time = "";
  int selected_service =
      0; //return 1 if selected lab / return 2 if selected home
  String serviceLoc = "";

  bool select_t = false;
  Duration initialtimer = new Duration();
  int selectitem = 1;

  int serviceL = 0;
  int flag = 0;

  @override
  void initState() {
    dateInput = TextEditingController();
    timeInput = TextEditingController();
    super.initState();
  }

  fetchData _fetchData = fetchData();

  Future<void> UpdateBooking() async {
    if (timeInput.text.trim().isEmpty ||
        dateInput.text.trim().isEmpty ||
        selected_test.isEmpty ||
        selected_service == 0) {
      print("Empty fields");
      return;
    }
    print("aaa");
    if (selected_service == 1) {
      serviceLoc = "Lab";
    } else
      serviceLoc = "Home";

    var body1 = jsonEncode({
      'test': selected_test,
      'date': dateInput.text,
      'time': timeInput.text,
      'serviceLoc': serviceLoc,
    });

    print(body1);

    var res = await http.patch(
        Uri.parse(fetchData.baseURL + "/bookings/update/" + widget.id),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + prefs.get("token").toString(),
        },
        body: body1);
    print(res.statusCode);
    if (res.statusCode == 200) {
      print("Successfully Update");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      print("faild Update");
    }
    _clearValues();
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => loginPageClass()),
    //   );
  }

  _clearValues() {
    dateInput.text = "";
    timeInput.text = "";
  }

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
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
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
            //  mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.092),
                child: Text(
                  'Book Appointment',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.width * 0.055,
                    letterSpacing: 0.5,
                    color: Color.fromARGB(255, 15, 15, 15),
                  ),
                ),
              ),
              // Text(widget.id),
              Padding(
                padding: EdgeInsets.only(right: 50, top: 5),
                child: Text('Select a Medical Analysis from the list:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                      color: Color.fromARGB(255, 9, 78, 153),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(right: 40, top: 10, left: 25),
                child: DropdownSearch<String>.multiSelection(
                  mode: Mode.MENU,
                  maxHeight: 400,
                  showSearchBox: true,
                  items: med_analysis,
                  showSelectedItems: false,
                  selectedItems: selected_test,
                  //save selected list
                  onChanged: (value) {
                    selected_test = value;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 245,
                  top: 20,
                ),
                child: Text('Select Date:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                      color: Color.fromARGB(255, 9, 78, 153),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(right: 40, top: 10, left: 25),
                child: TextField(
                    controller: dateInput,
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
                          firstDate: DateTime.now(),
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
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          dateInput.text = formattedDate;
                          selected_date =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 245,
                  top: 20,
                ),
                child: Text('Select Time:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                      color: Color.fromARGB(255, 9, 78, 153),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(right: 40, top: 10, left: 25),
                child: TextField(
                    controller: timeInput,
                    //editing controller of this TextField
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.timer_sharp,
                          color: Color.fromARGB(255, 9, 78, 153),
                        ),
                        //icon of text field
                        labelText: "Enter Time" //label text of field
                        ),
                    readOnly: true,
                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      await bottomSheet(context, timePicker());
                      if (select_t) {
                        setState(() {
                          timeInput.text = selected_time;
                        });
                      }
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 125,
                  top: 20,
                ),
                child: Text('Choose the service location:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                      color: Color.fromARGB(255, 9, 78, 153),
                    )),
              ),
              Padding(
                  padding: EdgeInsets.only(right: 40, top: 25, left: 25),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.height * 0.02),
                      ),
                      CustomRadioButton('Lab', 1),
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.height * 0.02),
                      ),
                      CustomRadioButton('Home', 2),
                    ],
                  )),

              Padding(
                padding: EdgeInsets.only(right: 20, top: 60, left: 15),
                child: ElevatedButton(
                  onPressed: () {
                    UpdateBooking();
                    print(selected_test);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(Size(280, 50)),
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 159, 198, 223),
                    ),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: Text('Book',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.of(context).size.width * 0.042,
                        color: Color.fromARGB(255, 0, 0, 0),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget timePicker() {
    return CupertinoTimerPicker(
      mode: CupertinoTimerPickerMode.hm,
      minuteInterval: 15,
      initialTimerDuration: initialtimer,
      onTimerDurationChanged: (Duration changedtimer) {
        setState(() {
          select_t = true;
          initialtimer = changedtimer;
          selected_time = changedtimer.inHours.toString() +
              ':' +
              (changedtimer.inMinutes % 60).toString();
        });
      },
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

  Widget CustomRadioButton(String st, int index) {
    return Container(
      width: 100.0,
      height: 40.0,
      child: OutlinedButton(
          onPressed: () {
            setState(() {
              selected_service = index;
              print(selected_service);
            });
          },
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.009),
            child: Text(
              st,
              style: TextStyle(
                  // color: Color(0xff132137),
                  color: (selected_service == index)
                      ? Color.fromARGB(255, 9, 78, 153)
                      : Color.fromARGB(255, 148, 157, 172),
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w500),
            ),
          ),
          style: OutlinedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(
              width: MediaQuery.of(context).size.width * 0.008,
              color: (selected_service == index)
                  ? Color.fromARGB(255, 9, 78, 153)
                  : Color.fromARGB(255, 148, 157, 172),
            ),
          )),
    );
  }

  Widget currentInf() {
    // var info = _fetchData.fetchLabUserInfo();
    return FutureBuilder(
        future: _fetchData.fetchOneBookingInfo(widget.id),
        builder: (context, snapshot) {
          bookingModel info = snapshot.data as bookingModel;

          // dateInput.text = info.date;
          // timeInput.text = info.time;
          // for (int i = 0; i < info.test.length; i++) {
          //   selected_test[i] = info.test[i];
          // }
          if (info.serviceLoc == "Lab") {
            selected_service = 1;
          } else {
            selected_service = 2;
          }

          // phoneNumberControler.text = info.phoneNumber;
          // AgeControler.text = info.age;
          // emailControler.text = info.email;
          // identityNumberControler.text = info.identityNumber;
          // int n = info.insurance.length;
          // for (int i = 0; i < n; i++) {
          //   selected_Insurance[i] = info.insurance[i];
          // }

          // print(nameControler.text);

          return snapshot.data == null
              ? Text("Loading")
              : CustomRadioButton(info.serviceLoc, selected_service);
        });
  }
}
