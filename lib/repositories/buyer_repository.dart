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
        final data = response.data;
        return BuyerModel.fromMap(data['data']);
      } else {
        final error = response.data['error'] ?? 'Unknown error';
        throw Exception('Failed to create buyer $error');
      }
    } catch (e) {
      throw Exception('Failed to create buyer: $e');
    }
  }

  Future<List<BuyerModel>>? getBuyers() async {
    try {
      final idToken = await DatabaseService().getToken();
      if (idToken == null) {
        throw Exception('No ID token found');
      }

      final response = await _dio.get(
        '$_baseUrl/buyer/get-buyers',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> buyersData = data['data'];
        final List<BuyerModel> buyers =
            buyersData.map((buyer) => BuyerModel.fromMap(buyer)).toList();
        return buyers;
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch buyers: $e');
    }
  }

  Future<BuyerModel?> getBuyerBuyerId(String id) async {
    try {
      final idToken = await DatabaseService().getToken();

      final response = await _dio.get(
        '$_baseUrl/buyer/get-buyer/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final data = response.data;
        final BuyerModel buyer = BuyerModel.fromMap(data['data']);
        return buyer;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
