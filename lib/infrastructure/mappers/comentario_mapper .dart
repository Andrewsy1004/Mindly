import 'package:mindly/domain/domain.dart';

class ComentarioMapper {
  static Comentario fromJson(Map<String, dynamic> json) {
    return Comentario(
      uid: json['uid'] ?? '',
      contenido: json['descripcion'] ?? '',
      createdAt: json['createdAt'] ?? '',
      post: Post(
        uid: json['post']?['_id'] ?? '',
        titulo: json['post']?['titulo'] ?? '',
        descripcion: '',
        imagen: '',
        categoria: '',
        tags: const [],
        usuario: User(
          nombre: '',
          correo: '',
          roles: const [],
          profesion: '',
          biografia: '',
          fotoPerfil: '',
          uid: '',
          token: '',
        ),
        createdAt: '',
      ),
      usuario: User(
        nombre: json['usuario']?['nombre'] ?? '',
        correo: json['usuario']?['correo'] ?? '',
        roles: const [],
        profesion: json['usuario']?['profesion'] ?? '',
        biografia: '',
        fotoPerfil: json['usuario']?['fotoPerfil'] ?? '',
        uid: json['usuario']?['_id'] ?? '',
        token: '',
      ),
    );
  }
}
