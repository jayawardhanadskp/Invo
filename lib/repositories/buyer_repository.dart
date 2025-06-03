import 'package:dio/dio.dart';
import 'package:invo/models/buyer_model.dart';
import 'package:invo/services/database_service.dart';
import 'package:invo/utils/constant.dart';

class BuyerRepository {
  final Dio _dio = Dio();
  final String _baseUrl = '${Constant.baseUrl}/${Constant.apiVersion}';

  Future<BuyerModel> createBuyer(BuyerModel buyer) async {
    try {
      final idToken = await DatabaseService().getToken();
      if (idToken == null) {
        throw Exception('No ID token found');
      }

      final response = await _dio.post(
        '$_baseUrl/buyer/create',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
        ),

        data: BuyerModel(name: buyer.name, phone: buyer.phone).toJson(),
      );

      if (response.statusCode == 201) {
        print('Buyer created successfully');
        final data = response.data;
        print(data['data']);
        return BuyerModel.fromMap(data['data']);
      } else {
        final error = response.data['error'] ?? 'Unknown error';
        print('Failed to create buyer: $error');
        throw Exception('Failed to create buyer');
      }
    } catch (e) {
      print('Error creating buyer: $e');
      throw Exception('Failed to create buyer: $e');
    }
  }
}
