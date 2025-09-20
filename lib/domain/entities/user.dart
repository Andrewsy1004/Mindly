class User {
  final String nombre;
  final String correo;
  final List<String> roles;
  final String profesion;
  final String biografia;
  final String fotoPerfil;
  final String uid;
  final String token;

  User({
    required this.nombre,
    required this.correo,
    required this.roles,
    required this.profesion,
    required this.biografia,
    required this.fotoPerfil,
    required this.uid,
    required this.token,
  });
}
