import 'package:dio/dio.dart';
import 'package:invo/services/database_service.dart';
import 'package:invo/utils/constant.dart';

class DueRepository {
  final Dio _dio = Dio();
  final String _baseUrl = '${Constant.baseUrl}/${Constant.apiVersion}';

  Future<int> getAllDues() async {
    try {
      final idToken = await DatabaseService().getToken();
      if (idToken == null) {
        throw throw Exception('No ID token found');
      }

      final response = await _dio.get(
        '$_baseUrl/due/dueCount',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final int dueCount = data['data'];
        return dueCount;
      }
      return 0;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<dynamic>> getDueDetailList() async {
    try {
      final idToken = await DatabaseService().getToken();
      if (idToken == null) {
        throw Exception('No ID token found');
      }

      final response = await _dio.get(
        '$_baseUrl/due/dueList',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> dueList = data['data'];
        return dueList;
      }
      return [];
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> payDue(String buyerId, int amount) async {
    try {
      final idToken = await DatabaseService().getToken();
      if (idToken == null) {
        throw Exception('No ID token found');
      }

      final response = await _dio.post(
        '$_baseUrl/due/payDue',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
        ),
        data: {'buyerId': buyerId, 'paymentAmount': amount},
      );

      if (response.statusCode == 201) {
        return response.data['message'];
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
