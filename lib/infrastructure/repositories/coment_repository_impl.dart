import 'package:mindly/domain/domain.dart';
import 'package:mindly/infrastructure/infrastructure.dart';

class ComentRepositoryImpl extends ComentRepository {
  final Comentdatasource comentDatasource;

  ComentRepositoryImpl({Comentdatasource? datasource})
    : comentDatasource = datasource ?? ComentDatasourceImpl();

  @override
  Future<void> createComentario(
    String token,
    String postId,
    String comentario,
  ) async {
    await comentDatasource.createComentario(token, postId, comentario);
  }

  @override
  Future<void> deleteComentario(String token, String comentarioId) async {
    await comentDatasource.deleteComentario(token, comentarioId);
  }

  @override
  Future<List<Comentario>> getComentarios() async {
    return await comentDatasource.getComentarios();
  }
}
