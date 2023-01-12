import 'dart:ffi';

class bookingModel {
  late List test;
  late String date;
  late String time;
  late String ownerName;
  late String ownerLabName;
  late String serviceLoc;
  late String owner;
  late String ownerL;
  late String id;

  bookingModel(this.ownerL, this.ownerName, this.test, this.date, this.time,
      this.serviceLoc, this.owner, this.id, this.ownerLabName);

  bookingModel.fromJson(Map<String, dynamic> map) {
    this.ownerName = map['ownerName'];
    this.ownerLabName = map['ownerLabName'];
    this.test = map['test'];
    this.date = map['date'];
    this.serviceLoc = map['serviceLoc'];
    this.id = map['id'];
    this.owner = map['owner'];
    this.ownerL = map['ownerL'];
  }
}
