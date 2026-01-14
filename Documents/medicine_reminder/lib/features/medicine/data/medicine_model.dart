class MedicineModel {
  final int id;
  final String name;
  final String dose;
  final int hour;
  final int minute;

  MedicineModel({
    required this.id,
    required this.name,
    required this.dose,
    required this.hour,
    required this.minute,
  });

  String get timeLabel {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "dose": dose,
      "hour": hour,
      "minute": minute,
    };
  }

  factory MedicineModel.fromMap(Map map) {
    return MedicineModel(
      id: map["id"],
      name: map["name"],
      dose: map["dose"],
      hour: map["hour"],
      minute: map["minute"],
    );
  }
}
