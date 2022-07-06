class User {
  final String name;
  final String tb;
  final String bb;
  final String usia;
  final String gender;
  final String email;
  final String alamat;
  final int id;
  final String phone;


  User(this.id, this.name, this.alamat, this.tb,this.bb,this.usia,this.gender,this.email, this.phone);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        bb = json['bb'].toString(),
        gender = json['gender'],
        alamat = json['alamat'],
        tb = json['tb'].toString(),
        email = json['email'],
        phone = json['phone'],
        usia = json['usia'].toString();

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