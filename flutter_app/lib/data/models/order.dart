class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'price': price,
  };
}

class Order {
  final String id;
  final String status;
  final double total;
  final String createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.status,
    required this.total,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List<dynamic>? ?? [];
    return Order(
      id: json['id']?.toString() ?? '',
      status: json['status'] ?? 'PENDING',
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] ?? '',
      items: itemsList.map((item) => OrderItem.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'total': total,
    'createdAt': createdAt,
    'items': items.map((item) => item.toJson()).toList(),
  };
}
