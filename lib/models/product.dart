class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final dynamic ratingField = json['rating'];
    final double parsedRating;

    if (ratingField is Map<String, dynamic>) {
      parsedRating = (ratingField['rate'] as num?)?.toDouble() ?? 0;
    } else {
      parsedRating = (ratingField as num?)?.toDouble() ?? 0;
    }

    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      imageUrl: ((json['imageUrl'] ?? json['image']) as String?) ?? '',
      category: (json['category'] as String?) ?? '',
      rating: parsedRating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
    };
  }
}
