/// FeedbackForm is a data class which stores data fields of Feedback.
class Accelerometer {
  String acc_x;
  String acc_y;
  String acc_z;

  Accelerometer(this.acc_x, this.acc_y, this.acc_z);

  factory Accelerometer.fromJson(dynamic json) {
    return Accelerometer("${json['acc_x']}", "${json['acc_y']}",
        "${json['acc_z']}");
  }

  // Method to make GET parameters.
  Map toJson() => {
    'acc_x': acc_x,
    'acc_y': acc_y,
    'acc_z': acc_z,
  };
}