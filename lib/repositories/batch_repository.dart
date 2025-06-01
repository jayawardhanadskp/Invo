import 'package:dio/dio.dart';
import 'package:invo/models/batch_model.dart';
import 'package:invo/services/database_service.dart';
import 'package:invo/utils/constant.dart';

class BatchRepository {
  final Dio _dio = Dio();
  final String _baseUrl = '${Constant.baseUrl}/${Constant.apiVersion}';

  Future<void> createBatch(
    String grams,
    String pieces,
    String quantity,
    String note,
    DateTime createAt,
  ) async {
    try {
      final idToken = await DatabaseService().getToken();
      print(idToken);
      if (idToken == null) {
        throw Exception('No ID token found');
      }

      final response = await _dio.post(
        '$_baseUrl/batch/create',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),

        data:
            BatchModel(
              createdAt: createAt, //DateTime.now(), //.toIso8601String(),
              grams: grams,
              pieces: pieces,
              note: note,
            ).toJson(),
      );

      if (response.statusCode == 200) {
        print('create batch: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error creating batch: $e');
      throw Exception('Failed to create batch: $e');
    }
  }
}
