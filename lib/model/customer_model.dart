class Model {
  int? id;
  String? personName;
  String? email;
  String? mobileNumber;

  Model({this.id, this.personName, this.email,this.mobileNumber});

  Model fromJson(json) {
    return Model(
        id: json['id'], personName: json['name'],
        email: json['"email"'],
        mobileNumber: json['"mobileNumber"']
    );
  }
  Map<String, dynamic> toJson() {
    return {'name': personName, 'email': email, 'mobileNumber': mobileNumber};
  }

}
