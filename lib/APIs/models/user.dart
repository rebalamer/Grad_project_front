class userModel {
  late String username;
  late String password;
  late String name;
  late String age;
  late String phoneNumber;
  late String id;
  late String email;
  late String identityNumber;

  userModel(this.age, this.username, this.password, this.phoneNumber, this.name,
      this.id, this.email, this.identityNumber);

  userModel.fromJson(Map<String, dynamic> map) {
    this.age = map['age'];
    this.username = map['username'];
    this.identityNumber = map['identityNumber'];
    this.password = map['password'];
    this.phoneNumber = map['phoneNumber'];
    this.name = map['name'];
    this.id = map['id'];
    this.email = map['email'];
  }
}
