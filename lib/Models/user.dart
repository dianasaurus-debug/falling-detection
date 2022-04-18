class User {
  final String name;
  final String tb;
  final String bb;
  final String usia;
  final String gender;
  final String email;
  final int id;
  final String phone;


  User(this.id, this.name,this.tb,this.bb,this.usia,this.gender,this.email, this.phone);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        bb = json['bb'],
        gender = json['gender'],
        tb = json['tb'],
        email = json['email'],
        phone = json['phone'],
        usia = json['usia'];

  Map<String, dynamic> toJson() => {
    'name' : name,
    'id' : id,
    'bb' : bb,
    'gender' : gender,
    'tb' : tb,
    'email' : email,
    'phone' : phone,
    'usia' : usia
  };
}