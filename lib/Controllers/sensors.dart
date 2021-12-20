import 'dart:ffi';

import 'package:fall_detection_v2/Models/get_excel_accelerometer.dart';
import 'package:fall_detection_v2/Utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:convert' as convert;

class SensorController {
  /// Async function which loads feedback from endpoint URL and returns List.
  Future<Map<String, List<ExcelAccelerometer>>> getAllAccelerometerValues() async {
    return await http.get(Uri.parse(EXCEL_ALL_FILES_ACCELEROMETER)).then((response) {
      var jsonFeedback = convert.jsonDecode(response.body);
      var arrSitting = jsonFeedback['sitting'] as List;
      var arrWalking = jsonFeedback['walking'] as List;
      var arrFalling = jsonFeedback['falling'] as List;
      var arrStandingUp = jsonFeedback['standing_up'] as List;
      var arrSittingDown = jsonFeedback['sitting_down'] as List;

      var allResponse = {
        'arr_sitting' : arrSitting.map((json) => ExcelAccelerometer.fromJson(json)).toList(),
        'arr_walking' : arrWalking.map((json) => ExcelAccelerometer.fromJson(json)).toList(),
        'arr_falling' : arrFalling.map((json) => ExcelAccelerometer.fromJson(json)).toList(),
        'arr_standing_up' : arrStandingUp.map((json) => ExcelAccelerometer.fromJson(json)).toList(),
        'arr_sitting_down' : arrSittingDown.map((json) => ExcelAccelerometer.fromJson(json)).toList(),
      };
      return allResponse;
    });
  }
}