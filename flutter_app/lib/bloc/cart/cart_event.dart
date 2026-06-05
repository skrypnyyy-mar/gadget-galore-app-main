import 'package:equatable/equatable.dart';
import '../../data/models/product.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddProductToCart extends CartEvent {
  final Product product;
  final int quantity;
  final int? colorIndex;

  const AddProductToCart(this.product, {this.quantity = 1, this.colorIndex});

  @override
  List<Object?> get props => [product, quantity, colorIndex];
}

class RemoveProductFromCart extends CartEvent {
  final String key;

  const RemoveProductFromCart(this.key);

  @override
  List<Object?> get props => [key];
}

class UpdateProductQuantity extends CartEvent {
  final String key;
  final int quantity;

  const UpdateProductQuantity(this.key, this.quantity);

  @override
  List<Object?> get props => [key, quantity];
}

class ClearCart extends CartEvent {}
