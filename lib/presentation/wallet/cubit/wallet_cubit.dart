import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:mega_plus/presentation/wallet/models/saved_card_response_model.dart';
import 'package:mega_plus/presentation/wallet/models/top_up_response_model.dart';
import 'package:meta/meta.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletInitial());

  static WalletCubit get(context) => BlocProvider.of(context);

  List<TopUpTransactionResponseModel> transactions = [];
  void getTransactions() async {
    emit(LoadingGetTransactionsWalletState());
    try {
      var response = await DioHelper.getData(
        url: EndPoints.getTopUpTransactions,
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        transactions = data
            .map((e) => TopUpTransactionResponseModel.fromJson(e))
            .toList();
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
        query: {"amount": amount},
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
        emit(SuccessGetSavedCardsState());
      } else {
        emit(ErrorGetSavedCardsState());
      }
    } catch (e) {
      emit(ErrorGetSavedCardsState());
    }
  }
}
