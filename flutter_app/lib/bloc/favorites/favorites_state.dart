import 'package:equatable/equatable.dart';

class FavoritesState extends Equatable {
  final List<String> ids;

  const FavoritesState({this.ids = const []});

  bool has(String id) => ids.contains(id);

  FavoritesState copyWith({
    List<String>? ids,
  }) {
    return FavoritesState(
      ids: ids ?? this.ids,
    );
  }

  @override
  List<Object?> get props => [ids];
}
