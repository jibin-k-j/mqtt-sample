class LightModel {
  String id;
  String name;
  String productId;

  LightModel({
    required this.id,
    required this.name,
    required this.productId,
  });

  factory LightModel.fromJson(Map<String, dynamic> json) => LightModel(
    id: json["id"],
    name: json["name"],
    productId: json["productId"],
  );

  Map<String, dynamic> toJson() => {
    "id":id,
    "name": name,
    "productId": productId,
  };
}
