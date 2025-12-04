part of 'wallet_cubit.dart';

@immutable
sealed class WalletState {}

final class WalletInitial extends WalletState {}

 class LoadingGetTransactionsWalletState extends WalletState {}
 class SuccessGetTransactionsWalletState extends WalletState {}
 class ErrorGetTransactionsWalletState extends WalletState {}



 class LoadingGetWalletState extends WalletState {}
 class SuccessGetWalletState extends WalletState {}
 class ErrorGetWalletState extends WalletState {}

 class LoadingPayWalletState extends WalletState {}
 class SuccessPayWalletState extends WalletState {}
 class ErrorPayWalletState extends WalletState {}

 class LoadingGetSavedCardsState extends WalletState {}
 class SuccessGetSavedCardsState extends WalletState {}
 class ErrorGetSavedCardsState extends WalletState {}
