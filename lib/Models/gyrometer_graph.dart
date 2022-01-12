/// FeedbackForm is a data class which stores data fields of Feedback.
class GyroGraph {
  String gyro_i;
  String gyro_x;
  String gyro_y;
  String gyro_z;

  GyroGraph(this.gyro_i,this.gyro_x, this.gyro_y, this.gyro_z);

  factory GyroGraph.fromJson(dynamic json) {
    return GyroGraph("${json['gyro_i']}","${json['gyro_x']}", "${json['gyro_y']}",
        "${json['gyro_z']}");
  }

  // Method to make GET parameters.
  Map toJson() => {
    'gyro_x': gyro_x,
    'gyro_y': gyro_y,
    'gyro_z': gyro_z,
  };
}