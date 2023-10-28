class Review {
  String? id;
  String? productId;
  String? content;

  Review(this.id, this.productId, this.content);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'content': content,
    };
  }
}
