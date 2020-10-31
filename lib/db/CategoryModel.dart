
import 'dart:convert';

CategoryModel userFromMap(String str) => CategoryModel.fromMap(json.decode(str));

String userToMap(CategoryModel data) => json.encode(data.toMap());

class CategoryModel {
  CategoryModel({
    this.id,
    this.category_name
  });

  int id;
  String category_name;

  factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
      id: json["id"] == null ? null : json["id"],
      category_name: json["category_name"] == null ? null : json["category_name"]
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "category_name": category_name == null ? null : category_name
  };
}
