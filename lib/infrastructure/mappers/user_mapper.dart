import 'package:mindly/domain/domain.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
    nombre: json['usuario']['nombre'] ?? '',
    correo: json['usuario']['correo'] ?? '',
    roles: List<String>.from(json['usuario']['roles'] ?? []),
    profesion: json['usuario']['profesion'] ?? '',
    biografia: json['usuario']['biografia'] ?? '',
    fotoPerfil: json['usuario']['fotoPerfil'] ?? '',
    uid: json['usuario']['uid'] ?? '',
    token: json['token'] ?? '',
  );

  static User sliderUserJsonToEntity(Map<String, dynamic> json) => User(
    uid: json['id'] ?? '',
    nombre: json['nombre'] ?? '',
    correo: json['correo'] ?? '',
    profesion: json['profesion'] ?? '',
    fotoPerfil: json['fotoPerfil'] ?? '',
    roles: <String>[],
    biografia: json['biografia'] ?? '',
    token: '',
  );
}
