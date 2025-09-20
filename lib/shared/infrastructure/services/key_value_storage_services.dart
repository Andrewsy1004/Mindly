import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorageServices {
  static const String _keyToken = 'auth_token';

  // Singleton
  static final KeyValueStorageServices _instance =
      KeyValueStorageServices._internal();

  factory KeyValueStorageServices() => _instance;
  KeyValueStorageServices._internal();

  // Guardar token de autenticación
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  // Obtener token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // Verificar si el usuario está logueado
  Future<bool> isUserLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
  }
}
