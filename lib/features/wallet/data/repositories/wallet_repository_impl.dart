import 'package:dartz/dartz.dart';
import 'package:meshwark_rider/core/errors/failures.dart';
import 'package:meshwark_rider/features/wallet/data/datasources/wallet_datasource.dart';
import 'package:meshwark_rider/features/wallet/domain/entities/wallet_entities.dart';
import 'package:meshwark_rider/features/wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Wallet>> getWallet() async {
    try {
      final wallet = await remoteDataSource.getWallet();
      return Right(wallet);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addFunds(double amount) async {
    try {
      await remoteDataSource.addFunds(amount);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> withdraw(
      double amount, String accountId) async {
    try {
      await remoteDataSource.withdraw(amount, accountId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods() async {
    try {
      final methods = await remoteDataSource.getPaymentMethods();
      return Right(methods);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addPaymentMethod(PaymentMethod method) async {
    try {
      await remoteDataSource.addPaymentMethod(method);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultPaymentMethod(String methodId) async {
    try {
      await remoteDataSource.setDefaultPaymentMethod(methodId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePaymentMethod(String methodId) async {
    try {
      await remoteDataSource.deletePaymentMethod(methodId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
