import 'package:mindly/domain/domain.dart';

class Post {
  final String uid;
  final String titulo;
  final String descripcion;
  final String imagen;
  final String categoria;
  final List<String> tags;
  final User usuario;
  final bool estado = true;

  Post({
    required this.uid,
    required this.titulo,
    required this.descripcion,
    required this.imagen,
    required this.categoria,
    required this.tags,
    required this.usuario,
  });
}
