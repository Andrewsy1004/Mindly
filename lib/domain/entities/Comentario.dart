import 'package:mindly/domain/entities/entities.dart';

class Comentario {
  final String uid;
  final Post post;
  final User usuario;
  final String contenido;
  final String createdAt;

  Comentario({
    required this.uid,
    required this.post,
    required this.usuario,
    required this.contenido,
    required this.createdAt,
  });
}
