import 'package:equatable/equatable.dart';
import 'cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get totalItems => items.fold(0, (total, item) => total + item.quantity);

  double get subtotal => items.fold(0, (total, item) => total + (item.quantity * item.product.price));

  CartState copyWith({
    List<CartItem>? items,
  }) {
    return CartState(
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [items];
}
