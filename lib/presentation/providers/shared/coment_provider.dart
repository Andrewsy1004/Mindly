import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindly/domain/domain.dart';
import 'package:mindly/infrastructure/infrastructure.dart';
import 'package:mindly/shared/shared.dart';

final comentariosProvider =
    StateNotifierProvider<ComentariosNotifier, ComentariosState>((ref) {
      final comentDatasource = ComentDatasourceImpl();
      final keyValueStorage = KeyValueStorageServices();

      return ComentariosNotifier(
        comentDatasource: comentDatasource,
        keyValueStorageService: keyValueStorage,
      );
    });

class ComentariosNotifier extends StateNotifier<ComentariosState> {
  final ComentDatasourceImpl comentDatasource;
  final KeyValueStorageServices keyValueStorageService;

  ComentariosNotifier({
    required this.comentDatasource,
    required this.keyValueStorageService,
  }) : super(ComentariosState()) {
    cargarComentarios();
  }

  Future<void> cargarComentarios() async {
    try {
      state = state.copyWith(isLoading: true);
      final comentarios = await comentDatasource.getComentarios();
      state = state.copyWith(
        comentarios: comentarios,
        isLoading: false,
        errorMessage: '',
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> crearComentario(String postId, String comentario) async {
    final token = await keyValueStorageService.getToken();
    try {
      state = state.copyWith(isLoading: true);
      await comentDatasource.createComentario(token!, postId, comentario);

      // Recargar comentarios
      await cargarComentarios();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<void> eliminarComentario(String comentarioId) async {
    final token = await keyValueStorageService.getToken();
    try {
      state = state.copyWith(isLoading: true);
      await comentDatasource.deleteComentario(token!, comentarioId);

      // Eliminar del estado local
      final updatedComentarios = state.comentarios
          .where((c) => c.uid != comentarioId)
          .toList();

      state = state.copyWith(
        comentarios: updatedComentarios,
        isLoading: false,
        errorMessage: '',
      );

      // Cargar comentarios
      await cargarComentarios();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      rethrow;
    }
  }
}

class ComentariosState {
  final List<Comentario> comentarios;
  final bool isLoading;
  final String errorMessage;

  ComentariosState({
    this.comentarios = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  ComentariosState copyWith({
    List<Comentario>? comentarios,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ComentariosState(
      comentarios: comentarios ?? this.comentarios,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
