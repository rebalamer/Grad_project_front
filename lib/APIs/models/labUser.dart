import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class labUserModel {
  late String location;
  late String username;
  late String password;
  late String name;
  late String bTime;
  late String eTime;
  late String phoneNumber;
  late String id;
  late List insurance;
  late BinaryCodec avatar;

  labUserModel(this.location, this.username, this.password, this.phoneNumber,
      this.name, this.id, this.bTime, this.eTime, this.insurance);

  labUserModel.fromJson(Map<String, dynamic> map) {
    this.location = map['location'];
    this.username = map['username'];
    this.password = map['password'];
    this.phoneNumber = map['phoneNumber'];
    this.name = map['name'];
    this.id = map['_id'];
    this.bTime = map['bTime'];
    this.eTime = map['eTime'];
    this.insurance = map['insurance'];
  }
}
