import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryImageService {
  static const _cloudName = 'ldk7qhba';
  static const _uploadPreset = 'lost_and_found_uploads';

  Future<String> upload(File image) async {
    if (!await image.exists()) {
      throw FileSystemException('Image file does not exist', image.path);
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.https(
        'api.cloudinary.com',
        '/v1_1/$_cloudName/image/upload',
      ),
    )
      ..fields['upload_preset'] = _uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw CloudinaryUploadException(
        'Cloudinary upload failed with status ${response.statusCode}.',
      );
    }

    final data = jsonDecode(body);
    if (data is! Map<String, dynamic>) {
      throw const CloudinaryUploadException(
        'Cloudinary returned an invalid upload response.',
      );
    }

    final secureUrl = data['secure_url'];
    if (secureUrl is! String || secureUrl.isEmpty) {
      throw const CloudinaryUploadException(
        'Cloudinary upload response did not include a secure URL.',
      );
    }

    return secureUrl;
  }
}

class CloudinaryUploadException implements Exception {
  final String message;

  const CloudinaryUploadException(this.message);

  @override
  String toString() => message;
}
