import 'package:mindly/domain/domain.dart';

abstract class ComentRepository {
  Future<void> createComentario(String token, String postId, String comentario);
  Future<List<Comentario>> getComentarios();
  Future<void> deleteComentario(String token, String comentarioId);
}
