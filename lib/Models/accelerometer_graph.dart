/// FeedbackForm is a data class which stores data fields of Feedback.
class AccelerometerGraph {
  String acc_i;
  String acc_x;
  String acc_y;
  String acc_z;

  AccelerometerGraph(this.acc_i,this.acc_x, this.acc_y, this.acc_z);

  factory AccelerometerGraph.fromJson(dynamic json) {
    return AccelerometerGraph("${json['accel_i']}","${json['acc_x']}", "${json['acc_y']}",
        "${json['acc_z']}");
  }

  // Method to make GET parameters.
  Map toJson() => {
    'acc_x': acc_x,
    'acc_y': acc_y,
    'acc_z': acc_z,
  };
}