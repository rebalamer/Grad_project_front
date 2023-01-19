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
  late String check;

  bookingModel(this.ownerL, this.ownerName, this.test, this.date, this.time,
      this.serviceLoc, this.owner, this.id, this.ownerLabName, this.check);

  bookingModel.fromJson(Map<String, dynamic> map) {
    this.ownerName = map['ownerName'];
    this.ownerLabName = map['ownerLabName'];
    this.test = map['test'];
    this.date = map['date'];
    this.serviceLoc = map['serviceLoc'];
    this.id = map['_id'];
    this.owner = map['owner'];
    this.ownerL = map['ownerL'];
    this.time = map["time"];
    this.check = map["check"];
  }
}
