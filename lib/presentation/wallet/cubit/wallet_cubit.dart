import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:mega_plus/presentation/wallet/models/charging_transaction_response_model.dart';
import 'package:mega_plus/presentation/wallet/models/saved_card_response_model.dart';
import 'package:mega_plus/presentation/wallet/models/top_up_response_model.dart';
import 'package:mega_plus/presentation/wallet/models/wallet_transaction_model.dart';
import 'package:meta/meta.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletInitial());

  static WalletCubit get(context) => BlocProvider.of(context);

  List<WalletTransactionModel> transactions = [];
  void getTransactions() async {
    emit(LoadingGetTransactionsWalletState());
    try {
      var response = await DioHelper.getData(
        url: EndPoints.getTopUpTransactions,
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"];
        List<WalletTransactionModel> allTransactions = [];

        // Parse topup transactions
        if (data["topup_transactions"] != null) {
          var topupList = data["topup_transactions"] as List;
          allTransactions.addAll(
            topupList.map(
              (e) => WalletTransactionModel.fromTopUp(
                TopUpTransactionResponseModel.fromJson(e),
              ),
            ),
          );
        }

        // Parse charging transactions
        if (data["charging_transactions"] != null) {
          var chargingList = data["charging_transactions"] as List;
          allTransactions.addAll(
            chargingList.map(
              (e) => WalletTransactionModel.fromCharging(
                ChargingTransactionResponseModel.fromJson(e),
              ),
            ),
          );
        }

        // Sort by date (most recent first) - assuming createdAt is in format that can be compared
        allTransactions.sort((a, b) {
          // Simple string comparison - you might want to parse dates properly
          return (b.createdAt ?? '').compareTo(a.createdAt ?? '');
        });

        transactions = allTransactions;
        emit(SuccessGetTransactionsWalletState());
      } else {
        emit(ErrorGetTransactionsWalletState());
      }
    } catch (e) {
      emit(ErrorGetTransactionsWalletState());
    }
  }

  String? balance;
  String? currency;
  void getWallet() async {
    emit(LoadingGetWalletState());
    try {
      var response = await DioHelper.getData(url: EndPoints.getWalletBalance);
      if (response.statusCode == 200 && response.data["success"] == true) {
        balance = response.data["data"][0]["balance"];
        currency = response.data["data"][0]["currency"];
        emit(SuccessGetWalletState());
        getTransactions();
      } else {
        emit(ErrorGetWalletState());
      }
    } catch (e) {
      emit(ErrorGetWalletState());
    }
  }

  String? payUrl;
  void getPayUrl(num amount) async {
    emit(LoadingPayWalletState());
    try {
      var response = await DioHelper.getData(
        url: EndPoints.getPayUrl,
        query: {
          "amount": amount,
          "tax_amount": 1.25,
          "tax_percentage": (amount * 1.25) / 100,
          "fixed_vat": 1.7,
        },
        // data: FormData.fromMap({"amount": amount}),
      );
      print(response.data.toString());
      if (response.statusCode == 200 && response.data["success"] == true) {
        payUrl = response.data["data"]["iframeUrl"];
        emit(SuccessPayWalletState());
      } else {
        emit(ErrorPayWalletState());
      }
    } catch (e) {
      print(e.toString());
      emit(ErrorPayWalletState());
    }
  }

  String? redirectionUrl;

  // Pay with saved card
  void payWithSavedCard(num amount, String token) async {
    emit(LoadingPayWithSavedCardState());
    try {
      var response = await DioHelper.postData(
        url: EndPoints.payWithSavedCard,
        data: {"amount": amount, "cardToken": token},
      );
      print(response.data.toString());
      if (response.statusCode == 200) {
        var data = response.data;

        // Check if 3DS redirection is required
        if (data["use_redirection"] == true) {
          redirectionUrl = data["redirection_url"];
          emit(SuccessPayWithSavedCardRedirectState());
        } else {
          // Payment completed without redirection
          emit(SuccessPayWithSavedCardState());
        }
      } else {
        emit(
          ErrorPayWithSavedCardState(
            response.data["message"] ?? "Payment failed",
          ),
        );
      }
    } catch (e) {
      print(e.toString());
      emit(ErrorPayWithSavedCardState("Payment failed. Please try again."));
    }
  }

  List<SavedCardResponseModel> savedCards = [];
  void getSavedCards() async {
    emit(LoadingGetSavedCardsState());
    try {
      var response = await DioHelper.getData(url: EndPoints.getSavedCards);
      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        savedCards = data
            .map((e) => SavedCardResponseModel.fromJson(e))
            .toList();
        print(response.data);
        emit(SuccessGetSavedCardsState());
      } else {
        emit(ErrorGetSavedCardsState());
      }
    } catch (e) {
      emit(ErrorGetSavedCardsState());
    }
  }

  void deleteCard(int id) async {
    emit(LoadingGetSavedCardsState());
    try {
      var response = await DioHelper.deleteData(
        url: "${EndPoints.deleteSavedCards}$id",
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        getSavedCards();
      } else {
        emit(ErrorDeleteSavedCardsState());
      }
    } catch (e) {
      emit(ErrorDeleteSavedCardsState());
    }
  }

  void deactivateCard(int id) async {
    emit(LoadingGetSavedCardsState());
    try {
      var response = await DioHelper.patchData(
        url: EndPoints.deactivateSavedCards(id),
        data: {},
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        getSavedCards();
      } else {
        emit(ErrorDeactivateSavedCardsState());
      }
    } catch (e) {
      emit(ErrorDeactivateSavedCardsState());
    }
  }

  void setDefaultCard(int id) async {
    emit(LoadingGetSavedCardsState());
    try {
      var response = await DioHelper.patchData(
        url: EndPoints.setDefaultSavedCards(id),
        data: {},
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        getSavedCards();
      } else {
        emit(ErrorSetDefaultSavedCardsState());
      }
    } catch (e) {
      emit(ErrorSetDefaultSavedCardsState());
    }
  }
}
