import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesState()) {
    on<ToggleFavorite>(_onToggleFavorite);
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<FavoritesState> emit) {
    final List<String> currentIds = List.from(state.ids);
    if (currentIds.contains(event.id)) {
      currentIds.remove(event.id);
    } else {
      currentIds.add(event.id);
    }
    emit(state.copyWith(ids: currentIds));
  }
}
