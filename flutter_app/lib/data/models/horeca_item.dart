class HorecaItem {
  final String id;
  final String name;
  final String category;
  final String tagline;
  final String description;
  final double price;
  final String unit;
  final String duration;
  final String warranty;
  final String image;
  final List<String> includes;

  const HorecaItem({
    required this.id,
    required this.name,
    required this.category,
    required this.tagline,
    required this.description,
    required this.price,
    required this.unit,
    required this.duration,
    required this.warranty,
    required this.image,
    required this.includes,
  });
}

class HorecaCategoryInfo {
  final String id;
  final String emoji;

  const HorecaCategoryInfo({required this.id, required this.emoji});
}

const List<HorecaCategoryInfo> horecaCategories = [
  HorecaCategoryInfo(id: "Доставка обладнання", emoji: "🚚"),
  HorecaCategoryInfo(id: "Монтаж", emoji: "🛠️"),
  HorecaCategoryInfo(id: "Сервісне обслуговування", emoji: "🔧"),
  HorecaCategoryInfo(id: "Консультації", emoji: "💬"),
];
