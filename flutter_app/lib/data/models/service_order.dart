class ServiceOrder {
  final String id;
  final String name;
  final String description;
  final String status;

  ServiceOrder({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
  });

  factory ServiceOrder.fromJson(Map<String, dynamic> json) {
    return ServiceOrder(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Обробляється',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'status': status,
  };
}
