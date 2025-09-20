import 'package:dio/dio.dart';

import 'package:mindly/domain/domain.dart';
import 'package:mindly/config/config.dart';
import 'package:mindly/infrastructure/infrastructure.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/usuarios/iniciar-sesion',
        data: {'correo': email, 'contrasena': password},
      );

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
          e.response?.data['message'] ?? 'Credenciales incorrectas',
        );
      }
      if (e.type == DioErrorType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    try {
      final response = await dio.post(
        '/usuarios/crear-usuario',
        data: {'correo': email, 'contrasena': password, 'nombre': fullName},
      );

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
}
