class History {

  final String title;
  final String description;
  final String latitude;
  final String longitude;
  final int id;


  History(this.id, this.title,this.description,this.latitude, this.longitude);

  History.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        id = json['id'],
        description = json['description'],
        longitude = json['longitude'],
        latitude = json['latitude'];


  Map<String, dynamic> toJson() => {
    'title' : title,
    'id' : id,
    'description' : description,
    'latitude' : latitude,
    'longitude' : longitude,

  };
}