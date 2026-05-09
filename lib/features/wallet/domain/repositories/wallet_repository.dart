import 'package:dartz/dartz.dart';
import 'package:meshwark_rider/core/errors/failures.dart';
import 'package:meshwark_rider/features/wallet/domain/entities/wallet_entities.dart';

abstract class WalletRepository {
  Future<Either<Failure, Wallet>> getWallet();
  Future<Either<Failure, void>> addFunds(double amount);
  Future<Either<Failure, void>> withdraw(double amount, String accountId);
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods();
  Future<Either<Failure, void>> addPaymentMethod(PaymentMethod method);
  Future<Either<Failure, void>> setDefaultPaymentMethod(String methodId);
  Future<Either<Failure, void>> deletePaymentMethod(String methodId);
}
