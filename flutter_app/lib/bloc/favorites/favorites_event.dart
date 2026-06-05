import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class ToggleFavorite extends FavoritesEvent {
  final String id;

  const ToggleFavorite(this.id);

  @override
  List<Object?> get props => [id];
}
