class DetectedObject {
  final String item;

  DetectedObject({required this.item});

  factory DetectedObject.fromJson(Map<String, dynamic> json) {
    return DetectedObject(
      item: json['item'],
    );
  }
}