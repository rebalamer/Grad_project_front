import 'dart:typed_data';

import 'package:flutter/services.dart';

class reportModel {
  late ByteBuffer report;
  late String ownerL;
  late String identityNumber;

  reportModel(this.ownerL, this.report, this.identityNumber);

  reportModel.fromJson(Map<String, dynamic> map) {
    this.report = map['report'];
    this.identityNumber = map['identityNumber'];
    this.ownerL = map['ownerL'];
  }
}
