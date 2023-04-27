import 'package:eatup/models/detected_object.dart';

class APIResponse {
  final List<DetectedObject> result;

  APIResponse({required this.result});

  factory APIResponse.fromJson(Map<String, dynamic> json) {
    var resultList = json['result'] as List;
    List<DetectedObject> results = resultList
        .map((resultJson) => DetectedObject.fromJson(resultJson))
        .toList();
    return APIResponse(result: results);
  }
}