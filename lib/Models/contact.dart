class ContactModel {

  final String name;
  final String role;
  final String phone;
  final int id;


  ContactModel(this.id, this.name,this.role,this.phone);

  ContactModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        role = json['role'],
        phone = json['phone'];


  Map<String, dynamic> toJson() => {
    'name' : name,
    'id' : id,
    'role' : role,
    'phone' : phone,
  };
}