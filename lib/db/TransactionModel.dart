
import 'dart:convert';

TranscationModel userFromMap(String str) => TranscationModel.fromMap(json.decode(str));

String userToMap(TranscationModel data) => json.encode(data.toMap());

class TranscationModel {
  TranscationModel({
    this.id,
    this.transcation_type,
    this.transcation_date,
    this.category,
    this.ammount,
    this.description
  });

  int id;
  String transcation_type;
  String transcation_date;
  String category;
  int ammount;
  String description;

  factory TranscationModel.fromMap(Map<String, dynamic> json) => TranscationModel(
    id: json["id"] == null ? null : json["id"],
    transcation_type: json["transcation_type"] == null ? null : json["transcation_type"],
    transcation_date: json["transcation_date"] == null ? null : json["transcation_date"],
    category: json["category"] == null ? null : json["category"],
    ammount: json["ammount"] == null ? null : json["ammount"],
    description: json["description"] == null ? null : json["description"]
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "transcation_type": transcation_type == null ? null : transcation_type,
    "transcation_date": transcation_date == null ? null : transcation_date,
    "category": category == null ? null : category,
    "ammount": ammount == null ? null : ammount,
    "description": description == null ? null : description
  };
}
