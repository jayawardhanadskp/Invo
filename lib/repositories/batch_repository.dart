import 'package:dio/dio.dart';
import 'package:invo/models/batch_model.dart';
import 'package:invo/models/buyer_model.dart';
import 'package:invo/services/database_service.dart';
import 'package:invo/utils/constant.dart';

class BatchRepository {
  final Dio _dio = Dio();
  final String _baseUrl = '${Constant.baseUrl}/${Constant.apiVersion}';

  Future<void> createBatch(
    String grams,
    int pieces,
    String note,
    DateTime createAt,
  ) async {
    try {
      final idToken = await DatabaseService().getToken();
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

  Future<List<BatchModel>> getBatchList() async {
    try {
      final idToken = await DatabaseService().getToken();
      if (idToken == null) {
        throw Exception('No ID token found');
      }

      final response = await _dio.get(
        '$_baseUrl/batch/batchList',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> rawList = response.data['data'];
        final List<BatchModel> batchList =
            rawList.map((batch) => BatchModel.fromMap(batch)).toList();
        return batchList;
      } else {
        throw Exception('Failed to get batch list');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
