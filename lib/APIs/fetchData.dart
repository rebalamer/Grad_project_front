import '../main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:grad_project/APIs/models/labUser.dart';
import 'package:grad_project/APIs/models/user.dart';
import 'package:grad_project/APIs/models/booking.dart';
import 'package:grad_project/APIs/models/report.dart';

class fetchData {
  static const String baseURL = "http://192.168.1.6:3030";
  var header = {"Authorization": "Bearer " + prefs.get("token").toString()};

  Future<List<labUserModel>> fetchLabUsersList() async {
    print("Labs List ssssssssssssssssssssssssssssssssssssssssssss");
    var res = await http.get(Uri.parse(baseURL + "/labUsers"));
    var body = jsonDecode(res.body) as List<dynamic>;
    print(res.statusCode);
    // print(res.body);

    return body.map((user) => labUserModel.fromJson(user)).toList();
  }

  Future<labUserModel> fetchLabUserInfo() async {
    print("LabUser Info ssssssssssssssssssssssssssssssssssssssssssss");
    var res =
        await http.get(Uri.parse(baseURL + "/labUsers/me"), headers: header);
    var body = jsonDecode(res.body);
    print(res.statusCode);
    labUserModel myAccount = labUserModel.fromJson(body);
    return myAccount;
  }

  Future<userModel> fetchUserInfo() async {
    print("User Info ssssssssssssssssssssssssssssssssssss");
    var res = await http.get(Uri.parse(baseURL + "/users/me"), headers: header);
    var body = jsonDecode(res.body);
    print(res.statusCode);
    userModel myAccount = userModel.fromJson(body);
    return myAccount;
  }

  Future<bookingModel> fetchOneBookingInfo(String id) async {
    print("Booking Info bbbbbbbbbbbbbbbbbbbbbbbbb");
    var res =
        await http.get(Uri.parse(baseURL + "/bookings/" + id), headers: header);
    var body = jsonDecode(res.body);
    print(res.statusCode);
    bookingModel myBooking = bookingModel.fromJson(body);
    return myBooking;
  }

  Future<List<bookingModel>> fetchlabBookingList() async {
    print("Lab Bookings ssssssssssssssssssssssssssssssssssssssssssss");
    var res = await http.get(Uri.parse(baseURL + "/labUserBookings"),
        headers: header);
    print(res.statusCode);
    var body = jsonDecode(res.body) as List<dynamic>;

    return body.map((user) => bookingModel.fromJson(user)).toList();
  }

  Future<List<bookingModel>> fetchlabBookingByDate(String date) async {
    print("Lab Bookings By Date ssssssssssssssssssssssssssssssssssssssssssss");

    var res = await http.get(
      Uri.parse(baseURL + "/bookingsByDate/" + date),
      headers: header,
    );
    print(res.statusCode);
    // print(res.body);
    var body = jsonDecode(res.body) as List<dynamic>;

    return body.map((user) => bookingModel.fromJson(user)).toList();
  }

  Future<List<bookingModel>> fetchMyBookingList() async {
    print("My Booking List bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
    var res =
        await http.get(Uri.parse(baseURL + "/myBookings"), headers: header);
    print(res.statusCode);
    // print(res.body);
    var body = jsonDecode(res.body) as List<dynamic>;

    return body.map((user) => bookingModel.fromJson(user)).toList();
  }

  Future<List<userModel>> fetchAllUsersList() async {
    print("All Users List uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu");
    var res = await http.get(Uri.parse(baseURL + "/users"), headers: header);
    print(res.statusCode);
    var body = jsonDecode(res.body) as List<dynamic>;

    return body.map((user) => userModel.fromJson(user)).toList();
  }
}
