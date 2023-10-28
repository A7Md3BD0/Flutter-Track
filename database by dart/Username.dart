class Username {
  String? id;
  String? name;

  Username(this.id, this.name);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
