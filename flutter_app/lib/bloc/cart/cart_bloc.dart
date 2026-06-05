import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import 'cart_item.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddProductToCart>(_onAddProduct);
    on<RemoveProductFromCart>(_onRemoveProduct);
    on<UpdateProductQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
  }

  String _variantKey(String id, int? colorIndex) {
    return colorIndex == null ? id : '$id::$colorIndex';
  }

  void _onAddProduct(AddProductToCart event, Emitter<CartState> emit) {
    final List<CartItem> currentItems = List.from(state.items);
    final key = _variantKey(event.product.id, event.colorIndex);
    final existingIndex = currentItems.indexWhere((item) => item.key == key);

    if (existingIndex != -1) {
      final existingItem = currentItems[existingIndex];
      currentItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + event.quantity,
      );
    } else {
      String? color;
      String? colorName;
      String image = event.product.image;

      if (event.colorIndex != null && event.colorIndex! < event.product.colors.length) {
        color = event.product.colors[event.colorIndex!];
        if (event.product.colorNames != null && event.colorIndex! < event.product.colorNames!.length) {
          colorName = event.product.colorNames![event.colorIndex!];
        }
        if (event.product.images != null && event.colorIndex! < event.product.images!.length) {
          image = event.product.images![event.colorIndex!];
        }
      }

      currentItems.add(CartItem(
        key: key,
        product: event.product,
        quantity: event.quantity,
        colorIndex: event.colorIndex,
        color: color,
        colorName: colorName,
        image: image,
      ));
    }

    emit(state.copyWith(items: currentItems));
  }

  void _onRemoveProduct(RemoveProductFromCart event, Emitter<CartState> emit) {
    final List<CartItem> currentItems = List.from(state.items)
      ..removeWhere((item) => item.key == event.key);
    emit(state.copyWith(items: currentItems));
  }

  void _onUpdateQuantity(UpdateProductQuantity event, Emitter<CartState> emit) {
    if (event.quantity <= 0) {
      add(RemoveProductFromCart(event.key));
      return;
    }

    final List<CartItem> currentItems = List.from(state.items);
    final existingIndex = currentItems.indexWhere((item) => item.key == event.key);

    if (existingIndex != -1) {
      currentItems[existingIndex] = currentItems[existingIndex].copyWith(
        quantity: event.quantity,
      );
      emit(state.copyWith(items: currentItems));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState(items: []));
  }
}
