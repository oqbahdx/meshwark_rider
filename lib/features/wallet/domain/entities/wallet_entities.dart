class Wallet {
  final String id;
  final double balance;
  final double pendingBalance;
  final List<WalletTransaction> transactions;

  const Wallet({
    required this.id,
    required this.balance,
    required this.pendingBalance,
    required this.transactions,
  });
}

class WalletTransaction {
  final String id;
  final double amount;
  final String type;
  final String status;
  final DateTime createdAt;
  final String? tripId;

  const WalletTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.createdAt,
    this.tripId,
  });
}

class PaymentMethod {
  final String id;
  final String type;
  final String last4;
  final String? expiryMonth;
  final String? expiryYear;
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.last4,
    this.expiryMonth,
    this.expiryYear,
    this.isDefault = false,
  });
}
