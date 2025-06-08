import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';


part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletInitial());
  String publicKey = "pk_sbox_kphzjesonz5ofslucb2pxvmzayl";
  String secretKey = "sk_sbox_bagh7iuewbqbe4yccyav3rnkmie";
  initPayment() async {

    print("payment init");
  }
  Future<void> generateToken(
      {required String number,
        required String expiryMonth,
        required String cardNameHolder,
        required String expiryYear,
        required String cvv}) async {
    try {
      emit(AddWalletLoadingState());

      emit(AddWalletSuccessState());
      if (kDebugMode) {

      }
    } catch (ex) {
      emit(AddWalletErrorState(ex.toString()));
      print("error : $ex");
    }
  }
}
