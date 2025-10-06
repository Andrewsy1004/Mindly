import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:mindly/config/config.dart';

class CloudinaryHelper {
  static final Dio _dio = Dio();

  static Future<String> fileUpload(Uint8List file) async {
    if (file.isEmpty) {
      throw Exception('No tenemos ningún archivo a subir');
    }

    final cloudUrl = Environment.apiCloudinary;

    final formData = FormData();
    formData.fields.add(MapEntry('upload_preset', 'reactJournal'));
    formData.files.add(
      MapEntry('file', MultipartFile.fromBytes(file, filename: 'upload.png')),
    );

    try {
      final resp = await _dio.post(cloudUrl, data: formData);

      if (resp.statusCode != 200) {
        throw Exception('No se pudo subir imagen');
      }

      final cloudResp = resp.data;
      return cloudResp['secure_url'];
    } catch (error) {
      print('ERROR: $error');
      throw Exception(error.toString());
    }
  }
}
