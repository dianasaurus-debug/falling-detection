/// FeedbackForm is a data class which stores data fields of Feedback.
class ExcelAccelerometer {
  String interval;
  String value;
  String user;

  ExcelAccelerometer(this.user, this.interval, this.value);

  factory ExcelAccelerometer.fromJson(dynamic json) {
    return ExcelAccelerometer("${json['user']}", "${json['interval']}", "${json['value']}");
  }

  // Method to make GET parameters.
  Map toJson() => {
    'user' : user,
    'interval': interval,
    'value': value,
  };
}