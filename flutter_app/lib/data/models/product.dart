class Product {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final double price;
  final String category;
  final String image;
  final double rating;
  final int reviews;
  final int? stock;
  final List<String> colors;
  final List<String>? colorNames;
  final List<String>? images;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      tagline: json['tagline'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      image: json['image'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'] as int,
      colors: List<String>.from(json['colors'] ?? []),
      colorNames: json['colorNames'] != null ? List<String>.from(json['colorNames']) : null,
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      stock: json['stock'] != null ? json['stock'] as int : null,
    );
  }

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.colors,
    this.colorNames,
    this.images,
    this.stock,
  });
}

const List<String> productCategories = [
  "Всі",
  "Смартфони",
  "Ноутбуки",
  "Аудіо",
  "Аксесуари",
  "Планшети",
  "Кавомашини",
  "Печі",
  "Холодильники",
  "Міксери",
  "Посудомийки",
  "Плити",
];
