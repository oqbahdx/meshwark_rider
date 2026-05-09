library wallet_bloc;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshwark_rider/features/wallet/domain/repositories/wallet_repository.dart';

abstract class WalletState extends Equatable {
  const WalletState();
  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoadingState extends WalletState {}

class WalletLoaded extends WalletState {
  final double balance;
  final double pendingBalance;
  const WalletLoaded({required this.balance, required this.pendingBalance});
  @override
  List<Object?> get props => [balance, pendingBalance];
}

class WalletErrorState extends WalletState {
  final String message;
  const WalletErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class WalletAddFundsSuccessState extends WalletState {}

class WalletWithdrawSuccessState extends WalletState {}

abstract class WalletEvent extends Equatable {
  const WalletEvent();
  @override
  List<Object?> get props => [];
}

class LoadWallet extends WalletEvent {}

class AddFundsEvent extends WalletEvent {
  final double amount;
  const AddFundsEvent(this.amount);
  @override
  List<Object?> get props => [amount];
}

class WithdrawFundsEvent extends WalletEvent {
  final double amount;
  final String accountId;
  const WithdrawFundsEvent({required this.amount, required this.accountId});
  @override
  List<Object?> get props => [amount, accountId];
}

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository walletRepository;

  WalletBloc({required this.walletRepository}) : super(WalletInitial()) {
    on<LoadWallet>(_onLoadWallet);
    on<AddFundsEvent>(_onAddFunds);
    on<WithdrawFundsEvent>(_onWithdrawFunds);
  }

  Future<void> _onLoadWallet(
      LoadWallet event, Emitter<WalletState> emit) async {
    emit(WalletLoadingState());
    final result = await walletRepository.getWallet();
    result.fold(
      (failure) => emit(WalletErrorState(failure.message)),
      (wallet) => emit(WalletLoaded(
        balance: wallet.balance,
        pendingBalance: wallet.pendingBalance,
      )),
    );
  }

  Future<void> _onAddFunds(
      AddFundsEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoadingState());
    final result = await walletRepository.addFunds(event.amount);
    result.fold(
      (failure) => emit(WalletErrorState(failure.message)),
      (_) => emit(WalletAddFundsSuccessState()),
    );
  }

  Future<void> _onWithdrawFunds(
      WithdrawFundsEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoadingState());
    final result =
        await walletRepository.withdraw(event.amount, event.accountId);
    result.fold(
      (failure) => emit(WalletErrorState(failure.message)),
      (_) => emit(WalletWithdrawSuccessState()),
    );
  }
}
