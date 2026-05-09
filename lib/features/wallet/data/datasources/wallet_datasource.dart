import 'package:meshwark_rider/core/constants/constants.dart';
import 'package:meshwark_rider/core/network/api_client.dart';
import 'package:meshwark_rider/features/wallet/data/models/wallet_models.dart';
import 'package:meshwark_rider/features/wallet/domain/entities/wallet_entities.dart';

abstract class WalletRemoteDataSource {
  Future<WalletModel> getWallet();
  Future<void> addFunds(double amount);
  Future<void> withdraw(double amount, String accountId);
  Future<List<PaymentMethodModel>> getPaymentMethods();
  Future<void> addPaymentMethod(PaymentMethod method);
  Future<void> setDefaultPaymentMethod(String methodId);
  Future<void> deletePaymentMethod(String methodId);
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final ApiClient apiClient;

  WalletRemoteDataSourceImpl(this.apiClient);

  @override
  Future<WalletModel> getWallet() async {
    final result = await apiClient.get(ApiConstants.walletEndPoint);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => WalletModel.fromJson(response.data['data']),
    );
  }

  @override
  Future<void> addFunds(double amount) async {
    await apiClient
        .post('${ApiConstants.walletEndPoint}/add', data: {'amount': amount});
  }

  @override
  Future<void> withdraw(double amount, String accountId) async {
    await apiClient.post('${ApiConstants.walletEndPoint}/withdraw', data: {
      'amount': amount,
      'accountId': accountId,
    });
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final result =
        await apiClient.get('${ApiConstants.walletEndPoint}/methods');
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => (response.data['data'] as List)
          .map((m) => PaymentMethodModel.fromJson(m))
          .toList(),
    );
  }

  @override
  Future<void> addPaymentMethod(PaymentMethod method) async {
    await apiClient.post('${ApiConstants.walletEndPoint}/methods', data: {
      'type': method.type,
      'token': method.id,
    });
  }

  @override
  Future<void> setDefaultPaymentMethod(String methodId) async {
    await apiClient
        .put('${ApiConstants.walletEndPoint}/methods/$methodId/default');
  }

  @override
  Future<void> deletePaymentMethod(String methodId) async {
    await apiClient.delete('${ApiConstants.walletEndPoint}/methods/$methodId');
  }
}
