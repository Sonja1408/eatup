class APIResponse {
  final List<dynamic> result; // Declaration of the list of results.

  APIResponse({required this.result}); // Constructor that expects the list.

  factory APIResponse.fromJson(Map<String, dynamic> json) { // Constructor that expects a JSON object.
    var resultList = json['result'] as List; // Extracting the results from the JSON object.
    return APIResponse(result: resultList); // Returning a new APIResponse instance with the extracted results.
  }
}
