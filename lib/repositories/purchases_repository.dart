import 'package:dio/dio.dart';
import 'package:invo/models/buyer_model.dart';
import 'package:invo/models/purchase_model.dart';
import 'package:invo/repositories/buyer_repository.dart';
import 'package:invo/services/database_service.dart';
import 'package:invo/utils/constant.dart';

class PurchasesRepository {
  final Dio _dio = Dio();
  final String _baseUrl = '${Constant.baseUrl}/${Constant.apiVersion}';

  final BuyerRepository _buyerRepository = BuyerRepository();

  Future<void> createPurchaseNewBuyer(
    BuyerModel buyer,
    PurchaseModel purchase,
  ) async {
    try {
      final idToken = await DatabaseService().getToken();
      if (idToken == null) {
        throw Exception('No ID token found');
      }

      final newBuyer = await _buyerRepository.createBuyer(buyer);

      final buyerId = newBuyer.id;

      final response = await _dio.post(
        '$_baseUrl/purchases/create',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
        ),
        data:
            PurchaseModel(
              buyerId: buyerId,
              pieces: purchase.pieces,
              amount: purchase.amount,
              paymentType: purchase.paymentType,
              paymentStatus: purchase.paymentStatus,
              purchaseDate: purchase.purchaseDate,
            ).toMap(),
      );

      if (response.statusCode == 201) {
      } else {
        throw Exception('Failed to create purchase');
      }
    } catch (e) {
      throw Exception('Failed to create purchase with new buyer: $e');
    }
  }

  Future<void> createPurchaseExistingBuyer(
    BuyerModel buyer,
    PurchaseModel purchase,
  ) async {
    try {
      final idToken = await DatabaseService().getToken();
      if (idToken == null) {
        throw Exception('No ID token found');
      }

      final buyerId = buyer.id;

      final response = await _dio.post(
        '$_baseUrl/purchases/create',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
        ),
        data:
            PurchaseModel(
              buyerId: buyerId,
              pieces: purchase.pieces,
              amount: purchase.amount,
              paymentType: purchase.paymentType,
              paymentStatus: purchase.paymentStatus,
              purchaseDate: purchase.purchaseDate,
            ).toMap(),
      );

      if (response.statusCode == 201) {
      } else {
        throw Exception('Failed to create purchase with existing buyer');
      }
    } catch (e) {
      throw Exception('Failed to create purchase with existing buyer: $e');
    }
  }

  Future<List<PurchaseModel>> getPurchasesWithBuyerName() async {
    try {
      final idToken = await DatabaseService().getToken();
      if (idToken == null) {
        throw Exception('No ID token found');
      }

      final response = await _dio.get(
        '$_baseUrl/purchases/purchaseList',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> rawData = response.data['data'];
        print(rawData);
        final List<PurchaseModel> purchases =
            rawData.map((purchase) => PurchaseModel.fromMap(purchase)).toList();
        print(purchases);
        return purchases;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
