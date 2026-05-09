import 'package:meshwark_rider/features/wallet/domain/entities/wallet_entities.dart';

class WalletModel extends Wallet {
  const WalletModel({
    required super.id,
    required super.balance,
    required super.pendingBalance,
    required super.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      pendingBalance: (json['pendingBalance'] as num?)?.toDouble() ?? 0.0,
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((t) => WalletTransactionModel.fromJson(t))
              .toList() ??
          [],
    );
  }
}

class WalletTransactionModel extends WalletTransaction {
  const WalletTransactionModel({
    required super.id,
    required super.amount,
    required super.type,
    required super.status,
    required super.createdAt,
    super.tripId,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      tripId: json['tripId'],
    );
  }
}

class PaymentMethodModel extends PaymentMethod {
  const PaymentMethodModel({
    required super.id,
    required super.type,
    required super.last4,
    super.expiryMonth,
    super.expiryYear,
    super.isDefault,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      last4: json['last4'] ?? '',
      expiryMonth: json['expiryMonth'],
      expiryYear: json['expiryYear'],
      isDefault: json['isDefault'] ?? false,
    );
  }
}
