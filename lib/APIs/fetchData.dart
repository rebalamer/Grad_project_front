import '../main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:grad_project/APIs/models/labUser.dart';
import 'package:grad_project/APIs/models/user.dart';
import 'package:grad_project/APIs/models/booking.dart';

class fetchData {
  static const String baseURL = "http://192.168.1.103:3030";
  var header = {"Authorization": "Bearer " + prefs.get("token").toString()};

  Future<List<labUserModel>> fetchLabUsersList() async {
    print("ssssssssssssssssssssssssssssssssssssssssssss");
    var res = await http.get(Uri.parse(baseURL + "/labUsers"));
    var body = jsonDecode(res.body) as List<dynamic>;
    print(res.statusCode);
    // print(res.body);

    return body.map((user) => labUserModel.fromJson(user)).toList();
  }

  Future<labUserModel> fetchLabUserInfo() async {
    print("ssssssssssssssssssssssssssssssssssssssssssss");
    var res =
        await http.get(Uri.parse(baseURL + "/labUsers/me"), headers: header);
    var body = jsonDecode(res.body);
    print(res.statusCode);
    labUserModel myAccount = labUserModel.fromJson(body);
    return myAccount;
  }

  Future<List<bookingModel>> fetchlabBookingList() async {
    print("ssssssssssssssssssssssssssssssssssssssssssss");
    var res = await http.get(Uri.parse(baseURL + "/labUserBookings"),
        headers: header);
    print(res.statusCode);
    var body = jsonDecode(res.body) as List<dynamic>;

    return body.map((user) => bookingModel.fromJson(user)).toList();
  }

  Future<List<bookingModel>> fetchMyBookingList() async {
    print("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
    var res =
        await http.get(Uri.parse(baseURL + "/myBookings"), headers: header);
    print(res.statusCode);
    var body = jsonDecode(res.body) as List<dynamic>;

    return body.map((user) => bookingModel.fromJson(user)).toList();
  }

  Future<List<userModel>> fetchAllUsersList() async {
    print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu");
    var res = await http.get(Uri.parse(baseURL + "/users"), headers: header);
    print(res.statusCode);
    var body = jsonDecode(res.body) as List<dynamic>;

    return body.map((user) => userModel.fromJson(user)).toList();
  }
}
