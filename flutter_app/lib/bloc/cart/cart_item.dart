import 'package:equatable/equatable.dart';
import '../../data/models/product.dart';

class CartItem extends Equatable {
  final String key;
  final Product product;
  final int quantity;
  final int? colorIndex;
  final String? color;
  final String? colorName;
  final String image;

  const CartItem({
    required this.key,
    required this.product,
    required this.quantity,
    this.colorIndex,
    this.color,
    this.colorName,
    required this.image,
  });

  CartItem copyWith({
    String? key,
    Product? product,
    int? quantity,
    int? colorIndex,
    String? color,
    String? colorName,
    String? image,
  }) {
    return CartItem(
      key: key ?? this.key,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      colorIndex: colorIndex ?? this.colorIndex,
      color: color ?? this.color,
      colorName: colorName ?? this.colorName,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [key, product, quantity, colorIndex, color, colorName, image];
}
