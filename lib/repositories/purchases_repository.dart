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

      if (newBuyer == null) {
        throw Exception('Failed to create buyer,');
      }

      final buyerId = newBuyer.id;
      print(buyerId);

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
        print('Purchase created successfully');
      } else {
        throw Exception('Failed to create purchase');
      }
    } catch (e) {
      print('Error creating purchase with new buyer: $e');
      throw Exception('Failed to create purchase with new buyer: $e');
    }
  }
}
