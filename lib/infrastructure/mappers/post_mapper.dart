import 'package:mindly/domain/domain.dart';

class PostMapper {
  static Post postJsonToEntity(Map<String, dynamic> json) {
    final usuarioJson = json['usuario'] ?? {};

    return Post(
      uid: json['uid'] ?? json['_id'] ?? '',
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      imagen: json['imagen'] ?? '',
      categoria: json['categoria'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      usuario: User(
        uid: usuarioJson['_id'] ?? '',
        nombre: usuarioJson['nombre'] ?? '',
        correo: usuarioJson['correo'] ?? '',
        profesion: usuarioJson['profesion'] ?? '',
        fotoPerfil: usuarioJson['fotoPerfil'] ?? '',
        roles: usuarioJson['roles'] ?? [],
        biografia: usuarioJson['biografia'] ?? '',
        token: usuarioJson['token'] ?? '',
      ),
      createdAt: json['createdAt'] ?? '',
    );
  }
}
