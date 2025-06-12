import 'dart:convert';

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
      print(e);
      throw Exception(e);
    }
  }

  Future<List<dynamic>> getDueDetailList() async {
    try {
      final idToken = await DatabaseService().getToken();
      if (idToken == null) {
        throw throw Exception('No ID token found');
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
        print(data);
        final List<dynamic> dueList = data['data'];
        print(dueList);
        return dueList;
      }
      return [];
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
