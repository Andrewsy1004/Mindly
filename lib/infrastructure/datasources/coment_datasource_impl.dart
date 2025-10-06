import 'package:dio/dio.dart';
import 'package:mindly/domain/domain.dart';

import 'package:mindly/config/config.dart';
import 'package:mindly/infrastructure/mappers/comentario_mapper%20.dart';

class ComentDatasourceImpl extends Comentdatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));

  @override
  Future<void> createComentario(
    String token,
    String postId,
    String descripcion,
  ) {
    try {
      final response = dio.post(
        '/comentarios/crear-comentario',
        data: {'descripcion': descripcion, 'postid': postId},
        options: Options(headers: {'jsonwebtoken': token}),
      );

      return response;
    } catch (e) {
      throw Exception('Error al crear comentario: $e');
    }
  }

  @override
  Future<void> deleteComentario(String token, String comentarioId) {
    try {
      final response = dio.delete(
        '/comentarios/eliminar-comentario/$comentarioId',
        options: Options(headers: {'jsonwebtoken': token}),
      );

      return response;
    } catch (e) {
      throw Exception('Error al eliminar comentario: $e');
    }
  }

  @override
  Future<List<Comentario>> getComentarios() async {
    try {
      final response = await dio.get('/comentarios/obtener-comentarios');
      final List<dynamic> data = response.data['comentarios'];

      final comentarios = data
          .map((comentarioJson) => ComentarioMapper.fromJson(comentarioJson))
          .toList();

      return comentarios;
    } catch (e) {
      throw Exception('Error al obtener comentarios: $e');
    }
  }
}
