part of 'wallet_cubit.dart';

@immutable
abstract class WalletState {}

class WalletInitial extends WalletState {}
class AddWalletLoadingState extends WalletState {}
class AddWalletSuccessState extends WalletState {}
class AddWalletErrorState extends WalletState {
  final String error;
  AddWalletErrorState(this.error);
}
