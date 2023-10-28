class Product {
  String? id;
  String? name;
  String? description;

  Product(this.id, this.name, this.description);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
